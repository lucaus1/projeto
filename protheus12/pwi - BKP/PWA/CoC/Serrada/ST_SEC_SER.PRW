#include "rwmake.ch"

User Function ST_SEC_SER
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "SECAGEM DE MADEIRA SERRADA"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_CSER(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_CSER(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_CSER(4)' , 0, 4},;
{ "Excluir"         ,'U_ST_CSER(5)' , 0, 5},;
{ "Inicia/Termina"  ,'U_ST_PR03()' , 0, 4},;
{ "Legenda"         ,'U_ST_LG05()' , 0, 1}}


dbSelectArea("Z09")
dbSetOrder(1)

// Cores padroes do semaforo
aCores := { { 'Z09_STATUS == "A"','BR_VERDE'},;  // Verde - Pedido Aberto
{ 'Z09_STATUS == "P"','BR_AMARELO'},;     // Amarelo - Em processo de Estufagem
{ 'Z09_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Encerrado

mBrowse( 6,1,22,75,"Z09",,"Z09_STATUS",,,,aCores)

Return

User Function ST_LG05()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Romaneio Aberto"},;
{"BR_AMARELO","Em processo..."},;
{"DISABLE"   ,"Encerrado"     }})
Return


User Function ST_CSER(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z09")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z09_STATUS == "F"
		MsgBox ("Romaneio Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z09")
	IF !RECLOCK("Z09",.F.)
		return
	Endif
ENdif

if _nOpcao == 2
	cOpcao := "VISUALIZAR"
	nOpcE := 2
	nOpcG := 2
Elseif _nOpcao == 3
	cOpcao := "INCLUIR"
	nOpcE := 3
	nOpcG := 3
Elseif _nOpcao == 4
	cOpcao := "ALTERAR"
	nOpcE  := 4
	nOpcG  := 4
	If Z09_STATUS=="P"
		nOpcG  := 2
	Endif
Else
	cOpcao := "VISUALIZAR"
	nOpcE := 2
	nOpcG := 2
Endif


RegToMemory("Z09",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z10")

While !Eof().And.(x3_arquivo=="Z10")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z10_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z10_CONTR"
		dbSkip()
		Loop
	Endif
	
	If X3USO(x3_usado) .And. cNivel >= x3_nivel
		nUsado:=nUsado+1
		Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
		x3_tamanho, x3_decimal,X3_VALID,;
		x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
	
	dbSkip()
	
End

aCols:={}

If _nOpcao == 3
	
	aCols := {Array(nUsado+1)}
	aCols[1,nUsado+1] :=.F.
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z10_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z10")
	dbSetOrder(1)
	dbSeek(xFilial("Z10")+M->Z09_CONTR)
	
	While !eof() .and. Z10->Z10_FILIAL == xFilial("Z10") .And. Z10->Z10_CONTR == M->Z09_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z10_SEQ"
						//aCols[Len(aCols),_ni] := StrZero(Len(aCols),3)
					OtherWise
						aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,4])
				EndCase
			Endif
		Next
		
		aCols[Len(aCols),nUsado+1] := .F.
		
		dbSkip()
	End
Endif

If Len(aCols)<=0
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z09")

cTitulo        := "MANUTENCAO DE ROMANEIO DE SECAGEM DE MADEIRA SERRADA"
cAliasEnchoice := "Z09"
cAliasGetD     := "Z10"
cLinOk         := 'ExecBlock("Vld04",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z10_CONTR"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	IF M->Z09_STATUS=="P"
		aAltEnchoice  := {"Z09_OBSERV","Z09_ROMANE","Z09_CC","Z09_DTSAI","Z09_SECAGE","Z09_UMIDAD","Z09_LOCDST"}
	ELSE
		aAltEnchoice  := {"Z09_STATUS","Z09_OBSERV","Z09_ROMANE","Z09_CC","Z09_DTENT","Z09_DTSAI","Z09_ESTUFA","Z09_SECAGE","Z09_UMIDAD","Z09_LOCDST"}
	ENDIF
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_LOTE"   })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_ITPED"  })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_CERT"   })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_LOCAL"  })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_OBS"    })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_BAIXA"  })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z10_ACTOT"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_04GRInc()
			dbSelectArea("Z09")
			ConfirmSX8()
		Elseif _nOpcao == 4
			U_ST_04GrAlt()
		Elseif _nOpcao == 5
			U_ST_04GrExc()
		Endif
		
		Exit
	Else
		if  _nOpcao == 3
			dbSelectArea("Z09")
			RollBackSx8()
		Endif
		Exit
	Endif
	
EndDo

dbSelectArea("Z09")
if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

Return


/***********************************/
/***********************************/
User Function ST_04GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z10")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z10",.T.)
			Z10->Z10_FILIAL  := xFilial("Z10")
			Z10->Z10_CONTR   := M->Z09_CONTR
			Z10->Z10_SEQ     := STRZERO(nNUmIT,4)
			Z10->Z10_LOTE    := aCols[nIt,_nPosLOTE]
			Z10->Z10_PEDIDO  := aCols[nIt,_nPosPEDIDO]
			Z10->Z10_ITPED   := aCols[nIt,_nPosITPED]
			Z10->Z10_CERT    := aCols[nIt,_nPosCERT]
			Z10->Z10_LOCAL   := aCols[nIt,_nPosLOCAL]
			Z10->Z10_PECAS   := aCols[nIt,_nPosPECAS]
			Z10->Z10_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z10->Z10_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z10->Z10_DESCM   := aCols[nIt,_nPosDESCM]
			Z10->Z10_PRECO   := aCols[nIt,_nPosPRECO]
			Z10->Z10_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z10->Z10_OBS     := aCols[nIt,_nPosOBS]
			Z10->Z10_BAIXA   := aCols[nIt,_nPosBAIXA]
			Z10->Z10_ACPEC   := aCols[nIt,_nPosACPEC]
			Z10->Z10_ACVOL   := aCols[nIt,_nPosACVOL]
			Z10->Z10_ACTOT   := aCols[nIt,_nPosACTOT]
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z09")
if RecLock("Z09",.T.)
	Z09->Z09_FILIAL   := xFilial("Z09")
	Z09->Z09_STATUS   := M->Z09_STATUS
	Z09->Z09_CONTR    := M->Z09_CONTR
	Z09->Z09_DTENT    := M->Z09_DTENT
	Z09->Z09_DTSAI    := M->Z09_DTSAI
	Z09->Z09_ESTUFA   := M->Z09_ESTUFA
	Z09->Z09_LOCEST   := M->Z09_LOCEST
	Z09->Z09_LOCDST   := M->Z09_LOCDST
	Z09->Z09_SECAGE   := M->Z09_SECAGE
	Z09->Z09_UMIDAD   := M->Z09_UMIDAD
	Z09->Z09_CC       := M->Z09_CC
	Z09->Z09_DESCC    := M->Z09_DESCC
	Z09->Z09_OBSERV   := M->Z09_OBSERV
	Z09->Z09_ROMANE   := M->Z09_ROMANE
	Z09->Z09_DOCREQ   := M->Z09_DOCREQ
	MsUnLock()
Endif
dbSelectArea("Z09")
Return


/***********************************/
/***********************************/
User Function ST_04GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z10")
IF M->Z09_STATUS<>"P"
	For nIt := 1 To Len(aCols)
		dbSelectArea("Z10")
		dbSetOrder(1)
		if dbseek(xfilial("Z10")+M->Z09_CONTR+aCols[nIt,_nPosITEM],.F.)
			IF RecLock("Z10",.F.)
				If !aCols[nIt,_nPosDel]
					Z10->Z10_LOTE    := aCols[nIt,_nPosLOTE]
					Z10->Z10_PEDIDO  := aCols[nIt,_nPosPEDIDO]
					Z10->Z10_ITPED   := aCols[nIt,_nPosITPED]
					Z10->Z10_CERT    := aCols[nIt,_nPosCERT]
					Z10->Z10_LOCAL   := aCols[nIt,_nPosLOCAL]
					Z10->Z10_PECAS   := aCols[nIt,_nPosPECAS]
					Z10->Z10_VOLUME  := aCols[nIt,_nPosVOLUME]
					Z10->Z10_TPMOED  := aCols[nIt,_nPosTPMOED]
					Z10->Z10_DESCM   := aCols[nIt,_nPosDESCM]
					Z10->Z10_PRECO   := aCols[nIt,_nPosPRECO]
					Z10->Z10_TOTAL   := aCols[nIt,_nPosTOTAL]
					Z10->Z10_OBS     := aCols[nIt,_nPosOBS]
					Z10->Z10_BAIXA   := aCols[nIt,_nPosBAIXA]
					Z10->Z10_ACPEC   := aCols[nIt,_nPosACPEC]
					Z10->Z10_ACVOL   := aCols[nIt,_nPosACVOL]
					Z10->Z10_ACTOT   := aCols[nIt,_nPosACTOT]
				Else
					delete
				Endif
				MsUnLock()
			Endif
		Else
			If !aCols[nIt,_nPosDel]
				IF RecLock("Z10",.t.)
					Z10->Z10_FILIAL  := xFilial("Z10")
					Z10->Z10_CONTR   := M->Z09_CONTR
					Z10->Z10_SEQ     := "9999"
					Z10->Z10_LOTE    := aCols[nIt,_nPosLOTE]
					Z10->Z10_PEDIDO  := aCols[nIt,_nPosPEDIDO]
					Z10->Z10_ITPED   := aCols[nIt,_nPosITPED]
					Z10->Z10_CERT    := aCols[nIt,_nPosCERT]
					Z10->Z10_LOCAL   := aCols[nIt,_nPosLOCAL]
					Z10->Z10_PECAS   := aCols[nIt,_nPosPECAS]
					Z10->Z10_VOLUME  := aCols[nIt,_nPosVOLUME]
					Z10->Z10_TPMOED  := aCols[nIt,_nPosTPMOED]
					Z10->Z10_DESCM   := aCols[nIt,_nPosDESCM]
					Z10->Z10_PRECO   := aCols[nIt,_nPosPRECO]
					Z10->Z10_TOTAL   := aCols[nIt,_nPosTOTAL]
					Z10->Z10_OBS     := aCols[nIt,_nPosOBS]
					Z10->Z10_BAIXA   := aCols[nIt,_nPosBAIXA]
					Z10->Z10_ACPEC   := aCols[nIt,_nPosACPEC]
					Z10->Z10_ACVOL   := aCols[nIt,_nPosACVOL]
					Z10->Z10_ACTOT   := aCols[nIt,_nPosACTOT]
					MsUnLock()
				Endif
			Endif
		Endif
	Next
	dbSelectArea("Z10")
	dbSetOrder(2)
	if dbseek(xfilial("Z10")+M->Z09_CONTR,.F.)
		_nNumSeq := 0
		Do While ! eof() .and. Z10_CONTR == M->Z09_CONTR
			_nNumSeq ++
			IF RecLock("Z10",.F.)
				Z10->Z10_SEQ := STRZERO(_nNumSeq,4)
				msunlock()
			Endif
			dbskip()
		Enddo
	EndIf
ENDIF
dbSelectArea("Z09")
Z09->Z09_STATUS   := M->Z09_STATUS
Z09->Z09_CONTR    := M->Z09_CONTR
Z09->Z09_DTENT    := M->Z09_DTENT
Z09->Z09_DTSAI    := M->Z09_DTSAI
Z09->Z09_ESTUFA   := M->Z09_ESTUFA
Z09->Z09_LOCEST   := M->Z09_LOCEST
Z09->Z09_LOCDST   := M->Z09_LOCDST
Z09->Z09_SECAGE   := M->Z09_SECAGE
Z09->Z09_UMIDAD   := M->Z09_UMIDAD
Z09->Z09_CC       := M->Z09_CC
Z09->Z09_DESCC    := M->Z09_DESCC
Z09->Z09_OBSERV   := M->Z09_OBSERV
Z09->Z09_ROMANE   := M->Z09_ROMANE
Z09->Z09_DOCREQ   := M->Z09_DOCREQ
Return


/***********************************/
/***********************************/
User Function ST_04GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z10")
dbSetOrder(1)
if dbSeek(xFilial("Z10")+M->Z09_CONTR)
	WHILE Z10_FILIAL == xFilial("Z10") .AND. Z10_CONTR=M->Z09_CONTR
		If RecLock("Z10",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z09")
dbDelete()
Return


User Function Vld04()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
SetPrvt("_LRET,ACOLS,nP,VEZ,")
nAcPec := 0
nAcVol := 0
nAcTot := 0
For nIt := 1 To Len(aCols)
	nAcPEC := nAcPEC + IIf(!aCols[nIt,_nPosDel],ACOLS[nIt,_nPosPECAS],0)
	ACOLS[nIt,_nPosACPEC]:=nAcPEC
	nAcVOL := nAcVOL + IIf(!aCols[nIt,_nPosDel],ACOLS[nIt,_nPosVOLUME],0)
	ACOLS[nIt,_nPosACVOL]:=nAcVOL
	nAcTOT := nAcTOT + IIf(!aCols[nIt,_nPosDel],ACOLS[nIt,_nPosTOTAL],0)
	ACOLS[nIt,_nPosACTOT]:=nAcTOT
Next
_lRet := .T.
If Z09->Z09_STATUS=="P"
	If aCols[n,_nPosDel]
		Alert("Pacote nao pode ser deletado, Estufagem em andamento!")
		_lRet := .F.
	EndIf
Else
	If !aCols[n,_nPosDel]
		IF ACOLS[N,_NPOSBAIXA]=="LB"
			Alert("Pacote ainda nao esta liberado no estoque, verifique!")
			_lRet := .F.
		ELSEIF ACOLS[N,_NPOSBAIXA]=="EF"
			Alert("Pacote ja esta sendo estufado, verifique!")
			_lRet := .F.
		ELSEIF ACOLS[N,_NPOSBAIXA]=="BX"
			Alert("Pacote ja baixado, verifique!")
			_lRet := .F.
		ENDIF
	EndIf
Endif
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00


// Fecha romaneio e atualiza cadastro de Pacotes/lotes
User Function ST_PR03()

Private cPerg := "Z10"
Private oGeraTxt
Private cString := "Z10"

ValidPerg()

dbSelectArea("Z09")
dbSetOrder(1)

Pergunte(cPerg,.T.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Iniciar/Concluir Estufagem...")
@ 02,10 TO 070,185
@ 10,018 Say " Este programa ira gerar a atualizacao dos estoques            "
@ 18,018 Say " de Pacotes/Lotes e dar inicio ao Processo de Estufagem        "
@ 26,018 Say "                                                               "

@ 75,98 BMPBUTTON TYPE 01 ACTION OkGeraREQ()
@ 75,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 75,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

Static Function OkGeraREQ
dbSelectArea("Z09")
dbSetOrder(1)
dbSeek(xFilial("Z09")+MV_PAR01)
IF FOUND()
	IF Z09_STATUS="F"
		MSGBOX("Processo ja esta finalizado/fechado!!!")
	ELSEIF Z09_STATUS="A" //Iniciar Estufagem...
		dbSelectArea("Z10")
		dbSetOrder(1)
		DbSeek(xFilial("Z10")+MV_PAR01)
		While !eof() .AND. xFilial("Z10")=Z10_FILIAL .AND. Z10_CONTR==MV_PAR01
			
			dbSelectArea("Z06")
			dbSetOrder(3)
			DbSeek(xFilial("Z06")+Z10->Z10_LOTE)
			While !eof() .AND. xFilial("Z06")=Z06_FILIAL .AND. Z06_LOTE==Z10->Z10_LOTE
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+Z06->Z06_PROD)
				
				dbSelectArea("SX6")
				DbSetOrder(1)
				DbSeek("  "+"MV_DOCSEQ")
				
				dbSelectArea("SD3")
				If RecLock("SD3",.T.)
					Replace D3_FILIAL With xFILIAL("SD3")
					Replace D3_TM With "999"
					Replace D3_COD With Z06->Z06_PROD
					Replace D3_UM With SB1->B1_UM
					Replace D3_CF With "RE4"
					Replace D3_QUANT With IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_LOCAL With Z06->Z06_LOCAL
					Replace D3_DOC With GETMV("MV_DOCSEQ")
					Replace D3_GRUPO With SB1->B1_GRUPO
					Replace D3_EMISSAO With Z09->Z09_DTENT
					Replace D3_CUSTO1 With Z06->Z06_TOTAL
					Replace D3_CUSTO2 With Z06->Z06_TOTAL
					Replace D3_CUSTO3 With Z06->Z06_TOTAL
					Replace D3_CUSTO4 With Z06->Z06_TOTAL
					Replace D3_CUSTO5 With Z06->Z06_TOTAL
					Replace D3_SEGUM With SB1->B1_SEGUM
					Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
					Replace D3_TIPO With SB1->B1_TIPO
					Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
					Replace D3_CHAVE WITH "E0"
					MsUnLock()
				EndIf
				
				dbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+Z06->Z06_PROD+Z06->Z06_LOCAL)
				If Found()
					If RecLock("SB2",.F.)
						REPLACE B2_QATU WITH B2_QATU-IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
						REPLACE B2_QTSEGUM WITH B2_QTSEGUM-IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
						REPLACE B2_VATU1 WITH B2_VATU1-Z06->Z06_TOTAL
						REPLACE B2_VATU2 WITH B2_VATU2-Z06->Z06_TOTAL
						REPLACE B2_VATU3 WITH B2_VATU3-Z06->Z06_TOTAL
						REPLACE B2_VATU4 WITH B2_VATU4-Z06->Z06_TOTAL
						REPLACE B2_VATU5 WITH B2_VATU5-Z06->Z06_TOTAL
						MsUnLock("SB2")
					EndIf
				EndIf
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+Z06->Z06_PROD)
				
				If RecLock("SD3",.T.)
					Replace D3_FILIAL With xFILIAL("SD3")
					Replace D3_TM With "499"
					Replace D3_COD With Z06->Z06_PROD
					Replace D3_UM With SB1->B1_UM
					Replace D3_CF With "DE4"
					Replace D3_QUANT With IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_LOCAL With Z09->Z09_LOCEST
					Replace D3_DOC With GETMV("MV_DOCSEQ")
					Replace D3_GRUPO With SB1->B1_GRUPO
					Replace D3_EMISSAO With Z09->Z09_DTENT
					Replace D3_CUSTO1 With Z06->Z06_TOTAL
					Replace D3_CUSTO2 With Z06->Z06_TOTAL
					Replace D3_CUSTO3 With Z06->Z06_TOTAL
					Replace D3_CUSTO4 With Z06->Z06_TOTAL
					Replace D3_CUSTO5 With Z06->Z06_TOTAL
					Replace D3_SEGUM With SB1->B1_SEGUM
					Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
					Replace D3_TIPO With SB1->B1_TIPO
					Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
					Replace D3_CHAVE WITH "E9"
					MsUnLock()
				EndIf
				dbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+Z06->Z06_PROD+Z09->Z09_LOCEST)
				If Found()
					If RecLock("SB2",.F.)
						REPLACE B2_QATU WITH B2_QATU-IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
						REPLACE B2_QTSEGUM WITH B2_QTSEGUM-IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
						REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
						REPLACE B2_VATU2 WITH B2_VATU2+Z06->Z06_TOTAL
						REPLACE B2_VATU3 WITH B2_VATU3+Z06->Z06_TOTAL
						REPLACE B2_VATU4 WITH B2_VATU4+Z06->Z06_TOTAL
						REPLACE B2_VATU5 WITH B2_VATU5+Z06->Z06_TOTAL
						MsUnLock("SB2")
					EndIf
				Else
					If RecLock("SB2",.T.)
						Replace B2_FILIAL WITH xFilial("SB2")
						Replace B2_COD WITH Z06->Z06_PROD
						Replace B2_LOCAL WITH Z09->Z09_LOCEST
						REPLACE B2_QATU WITH B2_QATU-IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
						REPLACE B2_QTSEGUM WITH B2_QTSEGUM-IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
						REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
						REPLACE B2_VATU2 WITH B2_VATU2+Z06->Z06_TOTAL
						REPLACE B2_VATU3 WITH B2_VATU3+Z06->Z06_TOTAL
						REPLACE B2_VATU4 WITH B2_VATU4+Z06->Z06_TOTAL
						REPLACE B2_VATU5 WITH B2_VATU5+Z06->Z06_TOTAL
						MsUnLock("SB2")
					EndIf
				EndIf
				dbSelectArea("SX6")
				If RecLock("SX6",.F.)
					REPLACE X6_CONTEUD WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
					REPLACE X6_CONTENG WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
					REPLACE X6_CONTSPA WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
					MsUnLock("SX6")
				EndIf
				
				dbSelectArea("Z06")
				If RecLock("Z06",.F.)
					REPLACE Z06_LOCAL  WITH Z09->Z09_LOCEST
					REPLACE Z06_BAIXA  WITH "EF"
					MsUnLock("Z06")
				EndIf
				dbskip()
			enddo
			
			dbSelectArea("Z10")
			dbskip()
		enddo
		
		dbSelectArea("Z09")
		If RecLock("Z09",.F.)
			REPLACE Z09_STATUS WITH "P"
			MsUnLock("Z09")
		EndIf
	ELSE		//Finalizar Estufagem...
		dbSelectArea("Z10")
		dbSetOrder(1)
		DbSeek(xFilial("Z10")+MV_PAR01)
		While !eof() .AND. xFilial("Z10")=Z10_FILIAL .AND. Z10_CONTR==MV_PAR01
			
			dbSelectArea("Z06")
			dbSetOrder(3)
			DbSeek(xFilial("Z06")+Z10->Z10_LOTE)
			While !eof() .AND. xFilial("Z06")=Z06_FILIAL .AND. Z06_LOTE==Z10->Z10_LOTE
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+Z06->Z06_PROD)
				
				dbSelectArea("SX6")
				DbSetOrder(1)
				DbSeek("  "+"MV_DOCSEQ")
				
				dbSelectArea("SD3")
				If RecLock("SD3",.T.)
					Replace D3_FILIAL With xFILIAL("SD3")
					Replace D3_TM With "999"
					Replace D3_COD With Z06->Z06_PROD
					Replace D3_UM With SB1->B1_UM
					Replace D3_CF With "RE4"
					Replace D3_QUANT With IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_LOCAL With Z06->Z06_LOCAL
					Replace D3_DOC With GETMV("MV_DOCSEQ")
					Replace D3_GRUPO With SB1->B1_GRUPO
					Replace D3_EMISSAO With Z09->Z09_DTENT
					Replace D3_CUSTO1 With Z06->Z06_TOTAL
					Replace D3_CUSTO2 With Z06->Z06_TOTAL
					Replace D3_CUSTO3 With Z06->Z06_TOTAL
					Replace D3_CUSTO4 With Z06->Z06_TOTAL
					Replace D3_CUSTO5 With Z06->Z06_TOTAL
					Replace D3_SEGUM With SB1->B1_SEGUM
					Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
					Replace D3_TIPO With SB1->B1_TIPO
					Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
					Replace D3_CHAVE WITH "E0"
					MsUnLock()
				EndIf
				
				dbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+Z06->Z06_PROD+Z06->Z06_LOCAL)
				If Found()
					If RecLock("SB2",.F.)
						REPLACE B2_QATU WITH B2_QATU-IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
						REPLACE B2_QTSEGUM WITH B2_QTSEGUM-IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
						REPLACE B2_VATU1 WITH B2_VATU1-Z06->Z06_TOTAL
						REPLACE B2_VATU2 WITH B2_VATU2-Z06->Z06_TOTAL
						REPLACE B2_VATU3 WITH B2_VATU3-Z06->Z06_TOTAL
						REPLACE B2_VATU4 WITH B2_VATU4-Z06->Z06_TOTAL
						REPLACE B2_VATU5 WITH B2_VATU5-Z06->Z06_TOTAL
						MsUnLock("SB2")
					EndIf
				EndIf
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+Z06->Z06_PROD)
				
				If RecLock("SD3",.T.)
					Replace D3_FILIAL With xFILIAL("SD3")
					Replace D3_TM With "499"
					Replace D3_COD With Z06->Z06_PROD
					Replace D3_UM With SB1->B1_UM
					Replace D3_CF With "DE4"
					Replace D3_QUANT With IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_LOCAL With Z09->Z09_LOCDST
					Replace D3_DOC With GETMV("MV_DOCSEQ")
					Replace D3_GRUPO With SB1->B1_GRUPO
					Replace D3_EMISSAO With Z09->Z09_DTENT
					Replace D3_CUSTO1 With Z06->Z06_TOTAL
					Replace D3_CUSTO2 With Z06->Z06_TOTAL
					Replace D3_CUSTO3 With Z06->Z06_TOTAL
					Replace D3_CUSTO4 With Z06->Z06_TOTAL
					Replace D3_CUSTO5 With Z06->Z06_TOTAL
					Replace D3_SEGUM With SB1->B1_SEGUM
					Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
					Replace D3_TIPO With SB1->B1_TIPO
					Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
					Replace D3_CHAVE WITH "E9"
					MsUnLock()
				EndIf
				dbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+Z06->Z06_PROD+Z09->Z09_LOCDST)
				If Found()
					If RecLock("SB2",.F.)
						REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
						REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
						REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
						REPLACE B2_VATU2 WITH B2_VATU2+Z06->Z06_TOTAL
						REPLACE B2_VATU3 WITH B2_VATU3+Z06->Z06_TOTAL
						REPLACE B2_VATU4 WITH B2_VATU4+Z06->Z06_TOTAL
						REPLACE B2_VATU5 WITH B2_VATU5+Z06->Z06_TOTAL
						MsUnLock("SB2")
					EndIf
				Else
					If RecLock("SB2",.T.)
						Replace B2_FILIAL WITH xFilial("SB2")
						Replace B2_COD WITH Z06->Z06_PROD
						Replace B2_LOCAL WITH Z09->Z09_LOCDST
						REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
						REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
						REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
						REPLACE B2_VATU2 WITH B2_VATU2+Z06->Z06_TOTAL
						REPLACE B2_VATU3 WITH B2_VATU3+Z06->Z06_TOTAL
						REPLACE B2_VATU4 WITH B2_VATU4+Z06->Z06_TOTAL
						REPLACE B2_VATU5 WITH B2_VATU5+Z06->Z06_TOTAL
						MsUnLock("SB2")
					EndIf
				EndIf
				dbSelectArea("SX6")
				If RecLock("SX6",.F.)
					REPLACE X6_CONTEUD WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
					REPLACE X6_CONTENG WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
					REPLACE X6_CONTSPA WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
					MsUnLock("SX6")
				EndIf
				
				dbSelectArea("Z06")
				If RecLock("Z06",.F.)
					REPLACE Z06_LOCAL  WITH Z09->Z09_LOCDST
					REPLACE Z06_BAIXA  WITH "ES"
					REPLACE Z06_SECAGE WITH Z09->Z09_SECAGE
					REPLACE Z06_UMIDAD WITH Z09->Z09_UMIDAD
					REPLACE Z06_DOCSC  WITH Z09->Z09_CONTR
					REPLACE Z06_DTSEC  WITH Z09->Z09_DTENT
					MsUnLock("Z06")
				EndIf
				dbskip()
			enddo
			
			dbSelectArea("Z10")
			dbskip()
		enddo
		
		dbSelectArea("Z09")
		If RecLock("Z09",.F.)
			REPLACE Z09_STATUS WITH "F"
			MsUnLock("Z09")
		EndIf

	ENDIF
ELSE
	MSGBOX("Romaneio não encontrado, verifique os parâmetros!!!")
ENDIF

Close(oGeraTxt)

Return


// Cria SX1
Static Function ValidPerg()
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Num. Controle?","Num. Controle?","Num. Controle?","mv_ch1","C",9,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","1a. U. Medida?","1a. U. Medida?","1a. U. Medida?","mv_ch2","C",1,0,0,"C","","mv_par02","Volume","Volume","Volume","","","Pacotes","Pacotes","Pacotes","","","Pecas","Pecas","Pecas","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","2a. U. Medida?","2a. U. Medida?","2a. U. Medida?","mv_ch3","C",1,0,0,"C","","mv_par03","Volume","Volume","Volume","","","Pacotes","Pacotes","Pacotes","","","Pecas","Pecas","Pecas","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If ! DBSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(39, Len(aRegs[i])) //fCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

DBSkip()

do while x1_grupo == cPerg
	RecLock("SX1", .F.)
	DBDelete()
	DBSkip()
Enddo

DBSelectArea(_sAlias)

Return
