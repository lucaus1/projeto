#include "rwmake.ch"

User Function ST_CAD_KLT
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "MANUTENCAO DE PACKING LIST"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_PLT(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_PLT(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_PLT(4)' , 0, 4},;
{ "PACKING LIST..." ,'U_ST_PKT(4)' , 0, 4},;
{ "Visual. PL"      ,'U_ST_PKT(2)' , 0, 2},;
{ "GERAR PEDIDO..." ,'U_ST_PR06()' , 0, 4},;
{ "Excluir"         ,'U_ST_PLT(5)' , 0, 5},;
{ "Legenda"         ,'U_ST_LG09()' , 0, 1}}

dbSelectArea("Z16")
dbSetOrder(2)

// Cores padroes do semaforo
aCores := { { 'Z16_STATUS == "A"','BR_VERDE'},;  // Verde - Packing List Aberto
{ 'Z16_STATUS == "L"','BR_AMARELO'},;    // Amarelo - Apenas Lista de Selecao
{ 'Z16_STATUS == "E"','BR_AZUL'},;    // Azul - Packing List em Edicao
{ 'Z16_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Gerado Pedido de Faturamento

mBrowse( 6,1,22,75,"Z16",,"Z16_STATUS",,,,aCores)

Return

User Function ST_LG09()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Packing List Aberto"},;
{"BR_AMARELO","Apenas Gerada Lista de Selecao"},;
{"BR_AZUL","Packing List em Edicao"  },;
{"DISABLE"   ,"Fechado/Encerrado"     }})
Return


User Function ST_PLT(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z16")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z16_STATUS == "E"
		vOpc:=MsgBox ("Packing List ja foi gerado!!! Deseja reabrir?","ATENCAO","YesNo")
		If vOpc==.T.
			dbSelectArea("Z18")
			dbSetOrder(1)
			if dbSeek(xFilial("Z18")+Z16->Z16_CONTR)
				WHILE Z18_FILIAL == xFilial("Z18") .AND. Z18_CONTR=Z16->Z16_CONTR
					If RecLock("Z18",.F.)
						dbDelete()
						MsUnLock()
					Endif
					DBSKIP()
				ENDDO
			Endif
			dbSelectArea("Z16")
			
			IF RECLOCK("Z16",.F.)
				Z16->Z16_STATUS := "A"
				MsUnLock()
			Endif
		Else
			Return
		EndIf
	Endif
	If Z16_STATUS <> "A"
		MsgBox ("Pedido/Selecao de Pacotes nao pode ser Alterado!","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z16")
	IF !RECLOCK("Z16",.F.)
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


RegToMemory("Z16",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z17")

While !Eof().And.(x3_arquivo=="Z17")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z17_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z17_CONTR"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z17_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z17")
	dbSetOrder(1)
	dbSeek(xFilial("Z17")+M->Z16_CONTR)
	
	While !eof() .and. Z17->Z17_FILIAL == xFilial("Z17") .And. Z17->Z17_CONTR == M->Z16_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z17_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z16")

cTitulo        := "CADASTRO DE PACKING LIST E SELECAO DE PACOTES"
cAliasEnchoice := "Z16"
cAliasGetD     := "Z17"
cLinOk         := 'ExecBlock("Vld08",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z16_PEDIDO"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {"Z16_STATUS","Z16_DATA","Z16_OBSERV"}
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_SEQ"    })
_nPosTIPO   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_TIPO"   })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_LOTE"   })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_ITPED"  })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_CERT"   })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_TOTAL"  })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_BAIXA"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_OBS"    })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z17_ACTOT"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_08GRInc()
			dbSelectArea("Z16")
			ConfirmSX8()
		Elseif _nOpcao == 4
			U_ST_08GrAlt()
		Elseif _nOpcao == 5
			U_ST_08GrExc()
		Endif
		
		Exit
	Else
		if  _nOpcao == 3
			dbSelectArea("Z16")
			RollBackSx8()
		Endif
		Exit
	Endif
	
EndDo

dbSelectArea("Z16")
if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

Return


/***********************************/
/***********************************/
User Function ST_08GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z17")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z17",.T.)
			Z17->Z17_FILIAL  := xFilial("Z17")
			Z17->Z17_CONTR   := M->Z16_CONTR
			Z17->Z17_SEQ     := STRZERO(nNUmIT,4)
			Z17->Z17_TIPO    := aCols[nIt,_nPosTIPO]
			Z17->Z17_LOTE    := aCols[nIt,_nPosLOTE]
			Z17->Z17_PEDIDO  := aCols[nIt,_nPosPEDIDO]
			Z17->Z17_ITPED   := aCols[nIt,_nPosITPED]
			Z17->Z17_CERT    := aCols[nIt,_nPosCERT]
			Z17->Z17_PECAS   := aCols[nIt,_nPosPECAS]
			Z17->Z17_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z17->Z17_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z17->Z17_DESCM   := aCols[nIt,_nPosDESCM]
			Z17->Z17_PRECO   := aCols[nIt,_nPosPRECO]
			Z17->Z17_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z17->Z17_BAIXA   := aCols[nIt,_nPosBAIXA]
			Z17->Z17_OBS     := aCols[nIt,_nPosOBS]
			Z17->Z17_ACPEC   := aCols[nIt,_nPosACPEC]
			Z17->Z17_ACVOL   := aCols[nIt,_nPosACVOL]
			Z17->Z17_ACTOT   := aCols[nIt,_nPosACTOT]
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z16")
if RecLock("Z16",.T.)
	Z16->Z16_FILIAL   := xFilial("Z03")
	Z16->Z16_STATUS   := M->Z16_STATUS
	Z16->Z16_CONTR    := M->Z16_CONTR
	Z16->Z16_DATA     := M->Z16_DATA
	Z16->Z16_PEDIDO   := M->Z16_PEDIDO
	Z16->Z16_CLIENT   := M->Z16_CLIENT
	Z16->Z16_LOJA     := M->Z16_LOJA
	Z16->Z16_NOME     := M->Z16_NOME
	Z16->Z16_OBSERV   := M->Z16_OBSERV
	MsUnLock()
Endif
dbSelectArea("Z16")
Return


/***********************************/
/***********************************/
User Function ST_08GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z17")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z17")
	dbSetOrder(1)
	if dbseek(xfilial("Z17")+M->Z16_CONTR+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z17",.F.)
			If !aCols[nIt,_nPosDel]
				Z17->Z17_TIPO    := aCols[nIt,_nPosTIPO]
				Z17->Z17_LOTE    := aCols[nIt,_nPosLOTE]
				Z17->Z17_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z17->Z17_ITPED   := aCols[nIt,_nPosITPED]
				Z17->Z17_CERT    := aCols[nIt,_nPosCERT]
				Z17->Z17_PECAS   := aCols[nIt,_nPosPECAS]
				Z17->Z17_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z17->Z17_BAIXA   := aCols[nIt,_nPosBAIXA]
				Z17->Z17_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z17->Z17_DESCM   := aCols[nIt,_nPosDESCM]
				Z17->Z17_PRECO   := aCols[nIt,_nPosPRECO]
				Z17->Z17_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z17->Z17_OBS     := aCols[nIt,_nPosOBS]
				Z17->Z17_ACPEC   := aCols[nIt,_nPosACPEC]
				Z17->Z17_ACVOL   := aCols[nIt,_nPosACVOL]
				Z17->Z17_ACTOT   := aCols[nIt,_nPosACTOT]
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z17",.t.)
				Z17->Z17_FILIAL  := xFilial("Z17")
				Z17->Z17_CONTR   := M->Z16_CONTR
				Z17->Z17_SEQ     := "9999"
				Z17->Z17_TIPO    := aCols[nIt,_nPosTIPO]
				Z17->Z17_LOTE    := aCols[nIt,_nPosLOTE]
				Z17->Z17_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z17->Z17_ITPED   := aCols[nIt,_nPosITPED]
				Z17->Z17_CERT    := aCols[nIt,_nPosCERT]
				Z17->Z17_PECAS   := aCols[nIt,_nPosPECAS]
				Z17->Z17_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z17->Z17_BAIXA   := aCols[nIt,_nPosBAIXA]
				Z17->Z17_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z17->Z17_DESCM   := aCols[nIt,_nPosDESCM]
				Z17->Z17_PRECO   := aCols[nIt,_nPosPRECO]
				Z17->Z17_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z17->Z17_OBS     := aCols[nIt,_nPosOBS]
				Z17->Z17_ACPEC   := aCols[nIt,_nPosACPEC]
				Z17->Z17_ACVOL   := aCols[nIt,_nPosACVOL]
				Z17->Z17_ACTOT   := aCols[nIt,_nPosACTOT]
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z17")
dbSetOrder(2)
if dbseek(xfilial("Z17")+M->Z16_CONTR,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z17_CONTR == M->Z16_CONTR
		_nNumSeq ++
		IF RecLock("Z17",.F.)
			Z17->Z17_SEQ := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z16")
Z16->Z16_STATUS   := M->Z16_STATUS
Z16->Z16_DATA     := M->Z16_DATA
Z16->Z16_PEDIDO   := M->Z16_PEDIDO
Z16->Z16_CLIENT   := M->Z16_CLIENT
Z16->Z16_LOJA     := M->Z16_LOJA
Z16->Z16_NOME     := M->Z16_NOME
Z16->Z16_OBSERV   := M->Z16_OBSERV
Return


/***********************************/
/***********************************/
User Function ST_08GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z17")
dbSetOrder(2)
if dbSeek(xFilial("Z17")+M->Z16_CONTR)
	WHILE Z17_FILIAL == xFilial("Z17") .AND. Z17_CONTR=M->Z16_CONTR
		If RecLock("Z17",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z16")
dbDelete()
Return


User Function Vld08()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
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
	IF ACOLS[N,_NPOSPEDIDO]<>M->Z16_PEDIDO
		Alert("Atencao, numero do Pedido diferente do cabecalho!!!")
//		_lRet := .F.
	ENDIF
	IF ALLTRIM(ACOLS[N,_NPOSITPED])==""
		Alert("Informe sequencia do Item no Pedido!")
		_lRet := .F.
	ENDIF
	IF ACOLS[N,_NPOSBAIXA]=="LB"
		Alert("Pacote ainda nao esta liberado no estoque, verifique!")
		_lRet := .F.
	ELSEIF ACOLS[N,_NPOSBAIXA]=="BX"
		Alert("Pacote ja baixado, verifique!")
		_lRet := .F.
	ENDIF
EndIf
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
