#include "rwmake.ch"

User Function ST_BXA_IND
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "CONSUMO/BAIXA DE MADEIRA INDUSTRIALIZADA/USINADA"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_BIND(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_BIND(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_BIND(4)' , 0, 4},;
{ "Excluir"         ,'U_ST_BIND(5)' , 0, 5},;
{ "Gerar Req.Mod(2)",'U_ST_PR05()' , 0, 4},;
{ "Legenda"         ,'U_ST_LG08()' , 0, 1}}


dbSelectArea("Z14")
dbSetOrder(1)

// Cores padroes do semaforo
aCores := { { 'Z14_STATUS == "A"','BR_VERDE'},;  // Verde - Pedido Aberto
{ 'Z14_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Fechado ou Encerrado

mBrowse( 6,1,22,75,"Z14",,"Z14_STATUS",,,,aCores)

Return

User Function ST_LG08()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Pedido Aberto"},;
{"DISABLE"   ,"Fechado/Encerrado"     }})
Return


User Function ST_BIND(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z14")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z14_STATUS == "F"
		MsgBox ("Romaneio Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z14")
	IF !RECLOCK("Z14",.F.)
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
Else
	cOpcao := "VISUALIZAR"
	nOpcE := 2
	nOpcG := 2
Endif


RegToMemory("Z14",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z15")

While !Eof().And.(x3_arquivo=="Z15")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z15_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z15_CONTR"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z15_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z15")
	dbSetOrder(1)
	dbSeek(xFilial("Z15")+M->Z14_CONTR)
	
	While !eof() .and. Z15->Z15_FILIAL == xFilial("Z15") .And. Z15->Z15_CONTR == M->Z14_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z15_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z14")

cTitulo        := "MANUTENCAO DE ROMANEIO DE CONSUMO DE MADEIRA INDUSTRIALIZADA/USINADA"
cAliasEnchoice := "Z14"
cAliasGetD     := "Z15"
cLinOk         := 'ExecBlock("Vld07",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z14_CONTR"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {"Z14_STATUS","Z14_TPENTR","Z14_DOC","Z14_SERIE","Z14_DTDOC","Z14_CLIENT","Z14_LOJA","Z14_OBSERV","Z14_CONTAT","Z14_CC"}
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_LOTE"   })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_ITPED"  })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_CERT"   })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_OBS"    })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_BAIXA"  })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z15_ACTOT"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_07GRInc()
			dbSelectArea("Z14")
			ConfirmSX8()
		Elseif _nOpcao == 4
			U_ST_07GrAlt()
		Elseif _nOpcao == 5
			U_ST_07GrExc()
		Endif
		
		Exit
	Else
		if  _nOpcao == 3
			dbSelectArea("Z14")
			RollBackSx8()
		Endif
		Exit
	Endif
	
EndDo

dbSelectArea("Z14")
if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

Return


/***********************************/
/***********************************/
User Function ST_07GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z15")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z15",.T.)
			Z15->Z15_FILIAL  := xFilial("Z15")
			Z15->Z15_CONTR   := M->Z14_CONTR
			Z15->Z15_SEQ     := STRZERO(nNUmIT,4)
			Z15->Z15_LOTE    := aCols[nIt,_nPosLOTE]
			Z15->Z15_PEDIDO  := aCols[nIt,_nPosPEDIDO]
			Z15->Z15_ITPED   := aCols[nIt,_nPosITPED]
			Z15->Z15_CERT    := aCols[nIt,_nPosCERT]
			Z15->Z15_PECAS   := aCols[nIt,_nPosPECAS]
			Z15->Z15_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z15->Z15_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z15->Z15_DESCM   := aCols[nIt,_nPosDESCM]
			Z15->Z15_PRECO   := aCols[nIt,_nPosPRECO]
			Z15->Z15_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z15->Z15_OBS     := aCols[nIt,_nPosOBS]
			Z15->Z15_BAIXA   := aCols[nIt,_nPosBAIXA]
			Z15->Z15_ACPEC   := aCols[nIt,_nPosACPEC]
			Z15->Z15_ACVOL   := aCols[nIt,_nPosACVOL]
			Z15->Z15_ACTOT   := aCols[nIt,_nPosACTOT]
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z14")
if RecLock("Z14",.T.)
	Z14->Z14_FILIAL   := xFilial("Z14")
	Z14->Z14_STATUS   := M->Z14_STATUS
	Z14->Z14_CONTR    := M->Z14_CONTR
	Z14->Z14_DATA     := M->Z14_DATA
	Z14->Z14_DESTIN   := M->Z14_DESTIN
	Z14->Z14_TPENTR   := M->Z14_TPENTR
	Z14->Z14_CC       := M->Z14_CC
	Z14->Z14_DESCC    := M->Z14_DESCC
	Z14->Z14_DOC      := M->Z14_DOC
	Z14->Z14_SERIE    := M->Z14_SERIE
	Z14->Z14_DTDOC    := M->Z14_DTDOC
	Z14->Z14_CLIENT   := M->Z14_CLIENT
	Z14->Z14_LOJA     := M->Z14_LOJA
	Z14->Z14_NOME     := M->Z14_NOME
	Z14->Z14_OBSERV   := M->Z14_OBSERV
	Z14->Z14_CONTAT   := M->Z14_CONTAT
	MsUnLock()
Endif
dbSelectArea("Z14")
Return


/***********************************/
/***********************************/
User Function ST_07GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z15")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z15")
	dbSetOrder(1)
	if dbseek(xfilial("Z15")+M->Z14_CONTR+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z15",.F.)
			If !aCols[nIt,_nPosDel]
				Z15->Z15_LOTE    := aCols[nIt,_nPosLOTE]
				Z15->Z15_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z15->Z15_ITPED   := aCols[nIt,_nPosITPED]
				Z15->Z15_CERT    := aCols[nIt,_nPosCERT]
				Z15->Z15_PECAS   := aCols[nIt,_nPosPECAS]
				Z15->Z15_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z15->Z15_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z15->Z15_DESCM   := aCols[nIt,_nPosDESCM]
				Z15->Z15_PRECO   := aCols[nIt,_nPosPRECO]
				Z15->Z15_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z15->Z15_OBS     := aCols[nIt,_nPosOBS]
				Z15->Z15_BAIXA   := aCols[nIt,_nPosBAIXA]
				Z15->Z15_ACPEC   := aCols[nIt,_nPosACPEC]
				Z15->Z15_ACVOL   := aCols[nIt,_nPosACVOL]
				Z15->Z15_ACTOT   := aCols[nIt,_nPosACTOT]
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z15",.t.)
				Z15->Z15_FILIAL  := xFilial("Z15")
				Z15->Z15_CONTR   := M->Z14_CONTR
				Z15->Z15_SEQ     := "9999"
				Z15->Z15_LOTE    := aCols[nIt,_nPosLOTE]
				Z15->Z15_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z15->Z15_ITPED   := aCols[nIt,_nPosITPED]
				Z15->Z15_CERT    := aCols[nIt,_nPosCERT]
				Z15->Z15_PECAS   := aCols[nIt,_nPosPECAS]
				Z15->Z15_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z15->Z15_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z15->Z15_DESCM   := aCols[nIt,_nPosDESCM]
				Z15->Z15_PRECO   := aCols[nIt,_nPosPRECO]
				Z15->Z15_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z15->Z15_OBS     := aCols[nIt,_nPosOBS]
				Z15->Z15_BAIXA   := aCols[nIt,_nPosBAIXA]
				Z15->Z15_ACPEC   := aCols[nIt,_nPosACPEC]
				Z15->Z15_ACVOL   := aCols[nIt,_nPosACVOL]
				Z15->Z15_ACTOT   := aCols[nIt,_nPosACTOT]
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z15")
dbSetOrder(2)
if dbseek(xfilial("Z15")+M->Z14_CONTR,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z15_CONTR == M->Z14_CONTR
		_nNumSeq ++
		IF RecLock("Z15",.F.)
			Z15->Z15_SEQ := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z14")
Z14->Z14_STATUS   := M->Z14_STATUS
Z14->Z14_CONTR    := M->Z14_CONTR
Z14->Z14_DATA     := M->Z14_DATA
Z14->Z14_DESTIN   := M->Z14_DESTIN
Z14->Z14_TPENTR   := M->Z14_TPENTR
Z14->Z14_CC       := M->Z14_CC
Z14->Z14_DESCC    := M->Z14_DESCC
Z14->Z14_DOC      := M->Z14_DOC
Z14->Z14_SERIE    := M->Z14_SERIE
Z14->Z14_DTDOC    := M->Z14_DTDOC
Z14->Z14_CLIENT   := M->Z14_CLIENT
Z14->Z14_LOJA     := M->Z14_LOJA
Z14->Z14_NOME     := M->Z14_NOME
Z14->Z14_OBSERV   := M->Z14_OBSERV
Z14->Z14_CONTAT   := M->Z14_CONTAT
Return


/***********************************/
/***********************************/
User Function ST_07GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z15")
dbSetOrder(1)
if dbSeek(xFilial("Z15")+M->Z14_CONTR)
	WHILE Z15_FILIAL == xFilial("Z15") .AND. Z15_CONTR=M->Z14_CONTR
		If RecLock("Z15",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z14")
dbDelete()
Return


User Function Vld07()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
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
If !aCols[n,_nPosDel]
	IF ACOLS[N,_NPOSBAIXA]=="LB"
		Alert("Pacote ainda nao esta liberado no estoque, verifique!")
		_lRet := .F.
	ELSEIF ACOLS[N,_NPOSBAIXA]=="BX"
		Alert("Pacote ja baixado, verifique!")
		_lRet := .F.
	ENDIF
EndIf
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00


User Function ST_IPESQ(nLote,nTipo)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
cAlias:=Alias()
dbSelectArea("Z13")
dbSetOrder(3)
_Pecas:=0
_Volume:=0
_Total:=0
if dbSeek(xFilial("Z13")+nLote,.T.)
	Do WHILE xFilial("Z13")==Z13_FILIAL .AND. Z13_LOTE == nLote
		_Pecas:=_Pecas+Z13_PECAS
		_Volume:=_Volume+Z13_VOLUME
		_Total:=_Total+Z13_TOTAL
		DBSKIP()
	ENDDO
Endif
If nTipo=1
	_Ret:=_Pecas
ElseIf nTipo=2
	_Ret:=_Volume
Else
	_Ret:=_Total
Endif
dbSelectArea(cAlias)
Return(_Ret)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00


// GERAR MOV. INTERNOS
User Function ST_PR05()

Private cPerg := "Z14"
Private oGeraTxt
Private cString := "Z14"

ValidPerg()

dbSelectArea("Z14")
dbSetOrder(1)

Pergunte(cPerg,.T.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Requisição (Mod. 02)")
@ 02,10 TO 070,185
@ 10,018 Say " Este programa ira gerar a requisição de baixa do romaneio de  "
@ 18,018 Say " consumo de Pacotes/Lotes.                                     "
@ 26,018 Say "                                                               "

@ 75,98 BMPBUTTON TYPE 01 ACTION OkGeraREQ()
@ 75,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 75,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

Static Function OkGeraREQ
dbSelectArea("Z14")
dbSetOrder(1)
dbSeek(xFilial("Z14")+MV_PAR01)
IF FOUND()
	dbSelectArea("Z14")
	IF Z14_STATUS="F"
		MSGBOX("Requisicao ja foi Gerada!!!")
	ELSEIF ALLTRIM(Z14_TPENTR)<>"R"
		MSGBOX("Tipo do Romaneio nao e Requisicao!")
	ELSEIF ALLTRIM(Z14_CC)=""
		MSGBOX("Informe o Centro de Custo para Baixa!")
	ELSEIF POSICIONE("SF5",1,xFilial("SF5")+MV_PAR04,"F5_TIPO")<>"R"
		MSGBOX("Tipo de movimentacao incompativel!!! "+MV_PAR04)
	ELSE
		dbSelectArea("Z15")
		dbSetOrder(1)
		DbSeek(xFilial("Z15")+MV_PAR01)
		While !eof() .AND. xFilial("Z15")=Z15_FILIAL .AND. Z15_CONTR==MV_PAR01
			
			dbSelectArea("Z13")
			dbSetOrder(3)
			DbSeek(xFilial("Z13")+Z15->Z15_LOTE)
			While !eof() .AND. xFilial("Z13")=Z13_FILIAL .AND. Z13_LOTE==Z15->Z15_LOTE
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+Z13->Z13_PROD)
				
				dbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+Z13->Z13_PROD)
				
				dbSelectArea("SX6")
				DbSetOrder(1)
				DbSeek("  "+"MV_DOCSEQ")
				
				dbSelectArea("SD3")
				If RecLock("SD3",.T.)
					Replace D3_FILIAL With xFILIAL("SD3")
					Replace D3_TM With MV_PAR04
					Replace D3_COD With Z13->Z13_PROD
					Replace D3_UM With SB1->B1_UM
					Replace D3_CF With "RE0"
					Replace D3_QUANT With IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					Replace D3_LOCAL With Z13->Z13_LOCAL
					Replace D3_DOC With GETMV("MV_DOCSEQ")
					Replace D3_GRUPO With SB1->B1_GRUPO
					Replace D3_EMISSAO With Z14->Z14_DATA
					Replace D3_CUSTO1 With SB2->B2_CM1*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					Replace D3_CUSTO2 With SB2->B2_CM2*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					Replace D3_CUSTO3 With SB2->B2_CM3*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					Replace D3_CUSTO4 With SB2->B2_CM4*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					Replace D3_CUSTO5 With SB2->B2_CM5*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					Replace D3_CC With Z14->Z14_CC
					Replace D3_SEGUM With SB1->B1_SEGUM
					Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z13->Z13_VOLUME,IIF(MV_PAR03=2,1,Z13->Z13_PECAS))
					Replace D3_TIPO With SB1->B1_TIPO
					Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
					Replace D3_CHAVE WITH "E0"
					MsUnLock()
				EndIf
				dbSelectArea("SB2")
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU-IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM-IIF(MV_PAR03=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					REPLACE B2_VATU1 WITH B2_VATU1-(B2_CM1*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS)))
					REPLACE B2_VATU2 WITH B2_VATU1-(B2_CM2*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS)))
					REPLACE B2_VATU3 WITH B2_VATU1-(B2_CM3*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS)))
					REPLACE B2_VATU4 WITH B2_VATU1-(B2_CM4*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS)))
					REPLACE B2_VATU5 WITH B2_VATU1-(B2_CM5*IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS)))
					MsUnLock("SB2")
				EndIf
				
				dbSelectArea("Z13")
				If RecLock("Z13",.F.)
					REPLACE Z13_BAIXA  WITH "BX"
					REPLACE Z13_DOCBX  WITH Z14->Z14_CONTR
					REPLACE Z13_DTBX   WITH Z14->Z14_DATA
					REPLACE Z13_CCBX   WITH Z14->Z14_CC
					REPLACE Z13_DESTBX WITH Z14->Z14_DESTIN
					MsUnLock("Z13")
				EndIf
				dbskip()
			enddo
			dbSelectArea("Z15")
			dbskip()
		enddo
		
		dbSelectArea("Z14")
		If RecLock("Z14",.F.)
			REPLACE Z14_DOCREQ WITH GETMV("MV_DOCSEQ")
			REPLACE Z14_STATUS WITH "F"
			MsUnLock("Z14")
		EndIf
		
		MSGBOX("Requisicao Mod.2 gerada com sucesso!!!" + GETMV("MV_DOCSEQ"))
		
		dbSelectArea("SX6")
		If RecLock("SX6",.F.)
			REPLACE X6_CONTEUD WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
			REPLACE X6_CONTENG WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
			REPLACE X6_CONTSPA WITH STRZERO(VAL(SX6->X6_CONTEUD)+1,6)
			MsUnLock("SX6")
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
aAdd(aRegs,{cPerg,"04","TM para Baixa?","TM para Baixa?","TM para Baixa?","mv_ch4","C",3,0,0,"G","EXISTCPO('SF5')","","","","","","","","","","","","","","","","","","","","","","","","","","SF5",""})

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
