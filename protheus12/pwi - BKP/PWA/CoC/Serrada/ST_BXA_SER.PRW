#include "rwmake.ch"

User Function ST_BXA_SER
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "CONSUMO/BAIXA DE MADEIRA SERRADA"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_BSER(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_BSER(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_BSER(4)' , 0, 4},;
{ "Excluir"         ,'U_ST_BSER(5)' , 0, 5},;
{ "Gerar Req.Mod(2)",'U_ST_PR02()' , 0, 4},;
{ "Legenda"         ,'U_ST_LG04()' , 0, 1}}


dbSelectArea("Z07")
dbSetOrder(1)

// Cores padroes do semaforo
aCores := { { 'Z07_STATUS == "A"','BR_VERDE'},;  // Verde - Pedido Aberto
{ 'Z07_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Fechado ou Encerrado

mBrowse( 6,1,22,75,"Z07",,"Z07_STATUS",,,,aCores)

Return

User Function ST_LG04()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Pedido Aberto"},;
{"DISABLE"   ,"Fechado/Encerrado"     }})
Return


User Function ST_BSER(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z07")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z07_STATUS == "F"
		MsgBox ("Romaneio Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z07")
	IF !RECLOCK("Z07",.F.)
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


RegToMemory("Z07",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z08")

While !Eof().And.(x3_arquivo=="Z08")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z08_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z08_CONTR"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z08_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z08")
	dbSetOrder(1)
	dbSeek(xFilial("Z08")+M->Z07_CONTR)
	
	While !eof() .and. Z08->Z08_FILIAL == xFilial("Z08") .And. Z08->Z08_CONTR == M->Z07_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z08_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z07")

cTitulo        := "MANUTENCAO DE ROMANEIO DE CONSUMO DE MADEIRA SERRADA"
cAliasEnchoice := "Z07"
cAliasGetD     := "Z08"
cLinOk         := 'ExecBlock("Vld03",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z07_CONTR"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {"Z07_STATUS","Z07_TPENTR","Z07_DOC","Z07_SERIE","Z07_DTDOC","Z07_CLIENT","Z07_LOJA","Z07_OBSERV","Z07_CONTAT","Z07_CC"}
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_LOTE"   })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_ITPED"  })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_CERT"   })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_OBS"    })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_BAIXA"  })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z08_ACTOT"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_03GRInc()
			dbSelectArea("Z07")
			ConfirmSX8()
		Elseif _nOpcao == 4
			U_ST_03GrAlt()
		Elseif _nOpcao == 5
			U_ST_03GrExc()
		Endif
		
		Exit
	Else
		if  _nOpcao == 3
			dbSelectArea("Z07")
			RollBackSx8()
		Endif
		Exit
	Endif
	
EndDo

dbSelectArea("Z07")
if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif
Return


/***********************************/
/***********************************/
User Function ST_03GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z08")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z08",.T.)
			Z08->Z08_FILIAL  := xFilial("Z08")
			Z08->Z08_CONTR   := M->Z07_CONTR
			Z08->Z08_SEQ     := STRZERO(nNUmIT,4)
			Z08->Z08_LOTE    := aCols[nIt,_nPosLOTE]
			Z08->Z08_PEDIDO  := aCols[nIt,_nPosPEDIDO]
			Z08->Z08_ITPED   := aCols[nIt,_nPosITPED]
			Z08->Z08_CERT    := aCols[nIt,_nPosCERT]
			Z08->Z08_PECAS   := aCols[nIt,_nPosPECAS]
			Z08->Z08_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z08->Z08_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z08->Z08_DESCM   := aCols[nIt,_nPosDESCM]
			Z08->Z08_PRECO   := aCols[nIt,_nPosPRECO]
			Z08->Z08_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z08->Z08_OBS     := aCols[nIt,_nPosOBS]
			Z08->Z08_BAIXA   := aCols[nIt,_nPosBAIXA]
			Z08->Z08_ACPEC   := aCols[nIt,_nPosACPEC]
			Z08->Z08_ACVOL   := aCols[nIt,_nPosACVOL]
			Z08->Z08_ACTOT   := aCols[nIt,_nPosACTOT]
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z07")
if RecLock("Z07",.T.)
	Z07->Z07_FILIAL   := xFilial("Z07")
	Z07->Z07_STATUS   := M->Z07_STATUS
	Z07->Z07_CONTR    := M->Z07_CONTR
	Z07->Z07_DATA     := M->Z07_DATA
	Z07->Z07_DESTIN   := M->Z07_DESTIN
	Z07->Z07_TPENTR   := M->Z07_TPENTR
	Z07->Z07_CC       := M->Z07_CC
	Z07->Z07_DESCC    := M->Z07_DESCC
	Z07->Z07_DOC      := M->Z07_DOC
	Z07->Z07_SERIE    := M->Z07_SERIE
	Z07->Z07_DTDOC    := M->Z07_DTDOC
	Z07->Z07_CLIENT   := M->Z07_CLIENT
	Z07->Z07_LOJA     := M->Z07_LOJA
	Z07->Z07_NOME     := M->Z07_NOME
	Z07->Z07_OBSERV   := M->Z07_OBSERV
	Z07->Z07_CONTAT   := M->Z07_CONTAT
	MsUnLock()
Endif
dbSelectArea("Z07")
Return


/***********************************/
/***********************************/
User Function ST_03GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z08")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z08")
	dbSetOrder(1)
	if dbseek(xfilial("Z08")+M->Z07_CONTR+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z08",.F.)
			If !aCols[nIt,_nPosDel]
				Z08->Z08_LOTE    := aCols[nIt,_nPosLOTE]
				Z08->Z08_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z08->Z08_ITPED   := aCols[nIt,_nPosITPED]
				Z08->Z08_CERT    := aCols[nIt,_nPosCERT]
				Z08->Z08_PECAS   := aCols[nIt,_nPosPECAS]
				Z08->Z08_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z08->Z08_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z08->Z08_DESCM   := aCols[nIt,_nPosDESCM]
				Z08->Z08_PRECO   := aCols[nIt,_nPosPRECO]
				Z08->Z08_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z08->Z08_OBS     := aCols[nIt,_nPosOBS]
				Z08->Z08_BAIXA   := aCols[nIt,_nPosBAIXA]
				Z08->Z08_ACPEC   := aCols[nIt,_nPosACPEC]
				Z08->Z08_ACVOL   := aCols[nIt,_nPosACVOL]
				Z08->Z08_ACTOT   := aCols[nIt,_nPosACTOT]
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z08",.t.)
				Z08->Z08_FILIAL  := xFilial("Z08")
				Z08->Z08_CONTR   := M->Z07_CONTR
				Z08->Z08_SEQ     := "9999"
				Z08->Z08_LOTE    := aCols[nIt,_nPosLOTE]
				Z08->Z08_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z08->Z08_ITPED   := aCols[nIt,_nPosITPED]
				Z08->Z08_CERT    := aCols[nIt,_nPosCERT]
				Z08->Z08_PECAS   := aCols[nIt,_nPosPECAS]
				Z08->Z08_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z08->Z08_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z08->Z08_DESCM   := aCols[nIt,_nPosDESCM]
				Z08->Z08_PRECO   := aCols[nIt,_nPosPRECO]
				Z08->Z08_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z08->Z08_OBS     := aCols[nIt,_nPosOBS]
				Z08->Z08_BAIXA   := aCols[nIt,_nPosBAIXA]
				Z08->Z08_ACPEC   := aCols[nIt,_nPosACPEC]
				Z08->Z08_ACVOL   := aCols[nIt,_nPosACVOL]
				Z08->Z08_ACTOT   := aCols[nIt,_nPosACTOT]
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z08")
dbSetOrder(2)
if dbseek(xfilial("Z08")+M->Z07_CONTR,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z08_CONTR == M->Z07_CONTR
		_nNumSeq ++
		IF RecLock("Z08",.F.)
			Z08->Z08_SEQ := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z07")
Z07->Z07_STATUS   := M->Z07_STATUS
Z07->Z07_CONTR    := M->Z07_CONTR
Z07->Z07_DATA     := M->Z07_DATA
Z07->Z07_DESTIN   := M->Z07_DESTIN
Z07->Z07_TPENTR   := M->Z07_TPENTR
Z07->Z07_CC       := M->Z07_CC
Z07->Z07_DESCC    := M->Z07_DESCC
Z07->Z07_DOC      := M->Z07_DOC
Z07->Z07_SERIE    := M->Z07_SERIE
Z07->Z07_DTDOC    := M->Z07_DTDOC
Z07->Z07_CLIENT   := M->Z07_CLIENT
Z07->Z07_LOJA     := M->Z07_LOJA
Z07->Z07_NOME     := M->Z07_NOME
Z07->Z07_OBSERV   := M->Z07_OBSERV
Z07->Z07_CONTAT   := M->Z07_CONTAT
Return


/***********************************/
/***********************************/
User Function ST_03GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z08")
dbSetOrder(1)
if dbSeek(xFilial("Z08")+M->Z07_CONTR)
	WHILE Z08_FILIAL == xFilial("Z08") .AND. Z08_CONTR=M->Z07_CONTR
		If RecLock("Z08",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z07")
dbDelete()
Return


User Function Vld03()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
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


User Function ST_PESQ(nLote,nTipo)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
cAlias:=Alias()
dbSelectArea("Z06")
dbSetOrder(3)
_Pecas:=0
_Volume:=0
_Total:=0
if dbSeek(xFilial("Z06")+nLote,.T.)
	Do WHILE xFilial("Z06")==Z06_FILIAL .AND. Z06_LOTE == nLote
		_Pecas:=_Pecas+Z06_PECAS
		_Volume:=_Volume+Z06_VOLUME
		_Total:=_Total+Z06_TOTAL
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


// GERAR PRE-NOTA FISCAL
User Function ST_PR02()

Private cPerg := "Z07"
Private oGeraTxt
Private cString := "Z07"

ValidPerg()

dbSelectArea("Z07")
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
dbSelectArea("Z07")
dbSetOrder(1)
dbSeek(xFilial("Z07")+MV_PAR01)
IF FOUND()
	dbSelectArea("Z07")
	IF Z07_STATUS="F"
		MSGBOX("Requisicao ja foi Gerada!!!")
	ELSEIF ALLTRIM(Z07_TPENTR)<>"R"
		MSGBOX("Tipo do Romaneio nao e Requisicao!")
	ELSEIF ALLTRIM(Z07_CC)=""
		MSGBOX("Informe o Centro de Custo para Baixa!")
	ELSEIF POSICIONE("SF5",1,xFilial("SF5")+MV_PAR04,"F5_TIPO")<>"R"
		MSGBOX("Tipo de movimentacao incompativel!!! "+MV_PAR04)
	ELSE
		dbSelectArea("Z08")
		dbSetOrder(1)
		DbSeek(xFilial("Z08")+MV_PAR01)
		While !eof() .AND. xFilial("Z08")=Z08_FILIAL .AND. Z08_CONTR==MV_PAR01
			
			dbSelectArea("Z06")
			dbSetOrder(3)
			DbSeek(xFilial("Z06")+Z08->Z08_LOTE)
			While !eof() .AND. xFilial("Z06")=Z06_FILIAL .AND. Z06_LOTE==Z08->Z08_LOTE
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+Z06->Z06_PROD)
				
				dbSelectArea("SB2")
				DbSetOrder(1)
				DbSeek(xFilial("SB2")+Z06->Z06_PROD)
				
				dbSelectArea("SX6")
				DbSetOrder(1)
				DbSeek("  "+"MV_DOCSEQ")
				
				dbSelectArea("SD3")
				If RecLock("SD3",.T.)
					Replace D3_FILIAL With xFILIAL("SD3")
					Replace D3_TM With MV_PAR04
					Replace D3_COD With Z06->Z06_PROD
					Replace D3_UM With SB1->B1_UM
					Replace D3_CF With "RE0"
					Replace D3_QUANT With IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_LOCAL With Z06->Z06_LOCAL
					Replace D3_DOC With GETMV("MV_DOCSEQ")
					Replace D3_GRUPO With SB1->B1_GRUPO
					Replace D3_EMISSAO With Z07->Z07_DATA
					Replace D3_CUSTO1 With SB2->B2_CM1*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_CUSTO2 With SB2->B2_CM2*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_CUSTO3 With SB2->B2_CM3*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_CUSTO4 With SB2->B2_CM4*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_CUSTO5 With SB2->B2_CM5*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					Replace D3_CC With Z07->Z07_CC
					Replace D3_SEGUM With SB1->B1_SEGUM
					Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
					Replace D3_TIPO With SB1->B1_TIPO
					Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
					Replace D3_CHAVE WITH "E0"
					MsUnLock()
				EndIf
				dbSelectArea("SB2")
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU-IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM-IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					REPLACE B2_VATU1 WITH B2_VATU1-(B2_CM1*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS)))
					REPLACE B2_VATU2 WITH B2_VATU1-(B2_CM2*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS)))
					REPLACE B2_VATU3 WITH B2_VATU1-(B2_CM3*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS)))
					REPLACE B2_VATU4 WITH B2_VATU1-(B2_CM4*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS)))
					REPLACE B2_VATU5 WITH B2_VATU1-(B2_CM5*IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS)))
					MsUnLock("SB2")
				EndIf
				
				dbSelectArea("Z06")
				If RecLock("Z06",.F.)
					REPLACE Z06_BAIXA  WITH "BX"
					REPLACE Z06_DOCBX  WITH Z07->Z07_CONTR
					REPLACE Z06_DTBX   WITH Z07->Z07_DATA
					REPLACE Z06_CCBX   WITH Z07->Z07_CC
					REPLACE Z06_DESTBX WITH Z07->Z07_DESTIN
					MsUnLock("Z06")
				EndIf
				dbskip()
			enddo
			dbSelectArea("Z08")
			dbskip()
		enddo
		
		dbSelectArea("Z07")
		If RecLock("Z07",.F.)
			REPLACE Z07_DOCREQ WITH GETMV("MV_DOCSEQ")
			REPLACE Z07_STATUS WITH "F"
			MsUnLock("Z07")
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
