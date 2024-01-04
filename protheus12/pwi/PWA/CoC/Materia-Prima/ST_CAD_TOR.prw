#include "rwmake.ch"
#include 'topconn.ch'

User Function ST_CAD_TOR
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "ENTRADA DE TORAS"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_TOR(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_TOR(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_TOR(4)' , 0, 4},;
{ "Excluir"         ,'U_ST_TOR(5)' , 0, 5},;
{ "Fechar Romaneio" ,'U_ST_PR10()' , 0, 4},;
{ "Legenda"         ,'U_ST_LG16()' , 0, 1}}

dbSelectArea("Z28")
dbSetOrder(1)

// Cores padroes do semaforo
aCores := { { 'Z38_STATUS == "A"','BR_VERDE'},;  // Verde - Pedido Aberto
{ 'Z38_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Fechado ou Encerrado

mBrowse( 6,1,22,75,"Z38",,"Z38_STATUS",,,,aCores)

Return

User Function ST_LG16()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Romaneio Aberto"},;
{"DISABLE"   ,"Fechado/Encerrado"     }})
Return


User Function ST_TOR(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z38")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z28_STATUS == "F"
		MsgBox ("Romaneio Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z38")
	IF !RECLOCK("Z38",.F.)
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


RegToMemory("Z38",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z39")

While !Eof().And.(x3_arquivo=="Z39")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z39_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z39_CONTR"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z39_ITEM",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z39")
	dbSetOrder(1)
	dbSeek(xFilial("Z39")+M->Z38_CONTR)
	
	While !eof() .and. Z39->Z39_FILIAL == xFilial("Z39") .And. Z39->Z39_CONTR == M->Z38_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z39_ITEM"
						//aCols[Len(aCols),_ni] := StrZero(Len(aCols),3)
					OtherWise
						//aCols[Len(aCols),_ni] := CriaVar(aHeader[_ni,4])
				EndCase
			Endif
		Next
		
		aCols[Len(aCols),nUsado+1] := .F.
		
		dbSkip()
	End
Endif

If Len(aCols)<=0
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_ITEM"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z38")

cTitulo        := "ENTRADA DE TORAS NO PATIO"
cAliasEnchoice := "Z38"
cAliasGetD     := "Z39"
cLinOk         := 'ExecBlock("Vld19",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z38_CONTR"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {"Z38_DATA","Z38_CONTAT","Z38_CC","Z38_OBSERV"} //AQUI
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_ITEM"   })
_nPosPLAQ   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_PLAQ"   })
_nPosRASTRO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_RASTRO" })
_nPosSESP   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_SESP"   })
_nPosEESP   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_EESP"   })
_nPosDESP   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_DESP"   })
_nPosPROD   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_PROD"   })
_nPosDESCP  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_DESCP"  })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_LOCAL"  })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_CERT"   })
_nPosQUAL   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_QUAL"   })
_nPosPF1    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_PF1"    })
_nPosPF2    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_PF2"    })
_nPosPG1    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_PG1"    })
_nPosPG2    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_PG2"    })
_nPosOCO    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_OCO"    })
_nPosCOMPR  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_COMPR"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_OBS"    })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z39_BAIXA"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
//			U_ST_17GRInc()
			dbSelectArea("Z38")
			ConfirmSX8()
		Elseif _nOpcao == 4
//			U_ST_17GrAlt()
		Elseif _nOpcao == 5
//			U_ST_17GrExc()
		Endif
		
		Exit
	Else
		if  _nOpcao == 3
			dbSelectArea("Z38")
			RollBackSx8()
		Endif
		Exit
	Endif
	
EndDo
dbSelectArea("Z38")
if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif
Return


/***********************************/
/***********************************/
User Function ST_17GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z29")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z29",.T.)
			Z29->Z29_FILIAL  := xFilial("Z29")
			Z29->Z29_CONTR   := M->Z28_CONTR
			Z29->Z29_ITEM    := STRZERO(nNUmIT,4)
			Z29->Z29_PLAQ    := aCols[nIt,_nPosPLAQ]
			Z29->Z29_RASTRO  := aCols[nIt,_nPosRASTRO]
			Z29->Z29_SESP    := aCols[nIt,_nPosSESP]
			Z29->Z29_EESP    := aCols[nIt,_nPosEESP]
			Z29->Z29_DESP    := aCols[nIt,_nPosDESP]
			Z29->Z29_PROD    := aCols[nIt,_nPosPROD]
			Z29->Z29_DESCP   := aCols[nIt,_nPosDESCP]
			Z29->Z29_LOCAL   := aCols[nIt,_nPosLOCAL]
			Z29->Z29_CERT    := aCols[nIt,_nPosCERT]
			Z29->Z29_QUAL    := aCols[nIt,_nPosQUAL]
			Z29->Z29_PF1     := aCols[nIt,_nPosPF1]
			Z29->Z29_PF2     := aCols[nIt,_nPosPF2]
			Z29->Z29_PG1     := aCols[nIt,_nPosPG1]
			Z29->Z29_PG2     := aCols[nIt,_nPosPG2]
			Z29->Z29_OCO     := aCols[nIt,_nPosOCO]
			Z29->Z29_COMPR   := aCols[nIt,_nPosCOMPR]
			Z29->Z29_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z29->Z29_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z29->Z29_DESCM   := aCols[nIt,_nPosDESCM]
			Z29->Z29_PRECO   := aCols[nIt,_nPosPRECO]
			Z29->Z29_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z29->Z29_OBS     := aCols[nIt,_nPosOBS]
			Z29->Z29_BAIXA   := "LB"
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z28")
if RecLock("Z28",.T.)
	Z28->Z28_FILIAL   := xFilial("Z28")
	Z28->Z28_STATUS   := M->Z28_STATUS
	Z28->Z28_CONTR    := M->Z28_CONTR
	Z28->Z28_DTMED    := M->Z28_DTMED  //aqui
	Z28->Z28_MEDIC    := M->Z28_MEDIC
	Z28->Z28_PATIO    := M->Z28_PATIO
	Z28->Z28_OBSERV   := M->Z28_OBSERV
	Z28->Z28_CONTAT   := M->Z28_CONTAT
	Z28->Z28_CC       := M->Z28_CC
	Z28->Z28_DESCC    := M->Z28_DESCC
	Z28->Z28_DOCREQ   := M->Z28_DOCREQ
	MsUnLock()
Endif
dbSelectArea("Z28")
Return


/***********************************/
/***********************************/
User Function ST_17GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z29")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z29")
	dbSetOrder(2)
	if dbseek(xfilial("Z29")+M->Z28_CONTR+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z29",.F.)
			If !aCols[nIt,_nPosDel]
				Z29->Z29_PLAQ    := aCols[nIt,_nPosPLAQ]
				Z29->Z29_RASTRO  := aCols[nIt,_nPosRASTRO]
				Z29->Z29_SESP    := aCols[nIt,_nPosSESP]
				Z29->Z29_EESP    := aCols[nIt,_nPosEESP]
				Z29->Z29_DESP    := aCols[nIt,_nPosDESP]
				Z29->Z29_PROD    := aCols[nIt,_nPosPROD]
				Z29->Z29_DESCP   := aCols[nIt,_nPosDESCP]
				Z29->Z29_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z29->Z29_CERT    := aCols[nIt,_nPosCERT]
				Z29->Z29_QUAL    := aCols[nIt,_nPosQUAL]
				Z29->Z29_PF1     := aCols[nIt,_nPosPF1]
				Z29->Z29_PF2     := aCols[nIt,_nPosPF2]
				Z29->Z29_PG1     := aCols[nIt,_nPosPG1]
				Z29->Z29_PG2     := aCols[nIt,_nPosPG2]
				Z29->Z29_OCO     := aCols[nIt,_nPosOCO]
				Z29->Z29_COMPR   := aCols[nIt,_nPosCOMPR]
				Z29->Z29_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z29->Z29_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z29->Z29_DESCM   := aCols[nIt,_nPosDESCM]
				Z29->Z29_PRECO   := aCols[nIt,_nPosPRECO]
				Z29->Z29_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z29->Z29_OBS     := aCols[nIt,_nPosOBS]
				Z29->Z29_BAIXA   := aCols[nIt,_nPosBAIXA]
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z29",.T.)
				Z29->Z29_FILIAL  := xFilial("Z29")
				Z29->Z29_CONTR   := M->Z28_CONTR
				Z29->Z29_ITEM    := "9999"
				Z29->Z29_PLAQ    := aCols[nIt,_nPosPLAQ]
				Z29->Z29_RASTRO  := aCols[nIt,_nPosRASTRO]
				Z29->Z29_SESP    := aCols[nIt,_nPosSESP]
				Z29->Z29_EESP    := aCols[nIt,_nPosEESP]
				Z29->Z29_DESP    := aCols[nIt,_nPosDESP]
				Z29->Z29_PROD    := aCols[nIt,_nPosPROD]
				Z29->Z29_DESCP   := aCols[nIt,_nPosDESCP]
				Z29->Z29_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z29->Z29_CERT    := aCols[nIt,_nPosCERT]
				Z29->Z29_QUAL    := aCols[nIt,_nPosQUAL]
				Z29->Z29_PF1     := aCols[nIt,_nPosPF1]
				Z29->Z29_PF2     := aCols[nIt,_nPosPF2]
				Z29->Z29_PG1     := aCols[nIt,_nPosPG1]
				Z29->Z29_PG2     := aCols[nIt,_nPosPG2]
				Z29->Z29_OCO     := aCols[nIt,_nPosOCO]
				Z29->Z29_COMPR   := aCols[nIt,_nPosCOMPR]
				Z29->Z29_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z29->Z29_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z29->Z29_DESCM   := aCols[nIt,_nPosDESCM]
				Z29->Z29_PRECO   := aCols[nIt,_nPosPRECO]
				Z29->Z29_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z29->Z29_OBS     := aCols[nIt,_nPosOBS]
				Z29->Z29_BAIXA   := aCols[nIt,_nPosBAIXA]
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z29")
dbSetOrder(1)
if dbseek(xfilial("Z29")+M->Z28_CONTR,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z29_CONTR == M->Z28_CONTR
		_nNumSeq ++
		IF RecLock("Z29",.F.)
			Z29->Z29_ITEM := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z28")
Z28->Z28_DTMED    := M->Z28_DTMED  //aqui
Z28->Z28_MEDIC    := M->Z28_MEDIC
Z28->Z28_PATIO    := M->Z28_PATIO
Z28->Z28_OBSERV   := M->Z28_OBSERV
Z28->Z28_CONTAT   := M->Z28_CONTAT
Z28->Z28_CC       := M->Z28_CC
Z28->Z28_DESCC    := M->Z28_DESCC
Z28->Z28_DOCREQ   := M->Z28_DOCREQ
Return


/***********************************/
/***********************************/
User Function ST_17GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z29")
dbSetOrder(1)
if dbSeek(xFilial("Z29")+M->Z28_CONTR)
	WHILE Z29_FILIAL == xFilial("Z29") .AND. Z29_CONTR=M->Z28_CONTR
		If RecLock("Z29",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z28")
dbDelete()
Return


User Function Vld19()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
SetPrvt("_LRET,ACOLS,nP,VEZ,")
_lRet := .T.
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00


// GERAR MOV. INTERNOS - PRODUCAO
User Function ST_PR10()

Private cPerg := "Z28"
Private oGeraTxt
Private cString := "Z28"

ValidPerg()

dbSelectArea("Z28")
dbSetOrder(1)

Pergunte(cPerg,.T.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Mov. Interno (Mod. 02)")
@ 02,10 TO 070,185
@ 10,018 Say " Este programa ira gerar Mov. Interno de Producao do romaneio  "
@ 18,018 Say " de Toras Exploradas/Medidas                                   "
@ 26,018 Say "                                                               "

@ 75,98 BMPBUTTON TYPE 01 ACTION OkGeraREQ()
@ 75,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 75,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

Static Function OkGeraREQ
dbSelectArea("Z28")
dbSetOrder(1)
dbSeek(xFilial("Z28")+MV_PAR01)
IF FOUND()
	dbSelectArea("Z28")
	IF Z28_STATUS="F"
		MSGBOX("Movimentacao ja foi Gerada!!!")
	ELSEIF ALLTRIM(Z28_CC)=""
		MSGBOX("Informe o Centro de Custo para Producao!")
	ELSEIF POSICIONE("SF5",1,xFilial("SF5")+MV_PAR04,"F5_TIPO")=="R"
		MSGBOX("Tipo de movimentacao incompativel!!! "+MV_PAR04)
	ELSE
		dbSelectArea("Z29")
		dbSetOrder(1)
		DbSeek(xFilial("Z29")+MV_PAR01)
		While !eof() .AND. xFilial("Z29")=Z29_FILIAL .AND. Z29_CONTR==MV_PAR01
			
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Z29->Z29_PROD)
			
			dbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  "+"MV_DOCSEQ")
			
			dbSelectArea("SD3")
			If RecLock("SD3",.T.)
				Replace D3_FILIAL With xFILIAL("SD3")
				Replace D3_TM With MV_PAR04
				Replace D3_COD With Z29->Z29_PROD
				Replace D3_UM With SB1->B1_UM
				Replace D3_CF With "PR0"
				Replace D3_QUANT With IIF(MV_PAR02=1,Z29->Z29_VOLUME,1)
				Replace D3_LOCAL With Z29->Z29_LOCAL
				Replace D3_DOC With GETMV("MV_DOCSEQ")
				Replace D3_GRUPO With SB1->B1_GRUPO
				Replace D3_EMISSAO With Z28->Z28_DTMED
				Replace D3_CUSTO1 With Z29->Z29_TOTAL
				Replace D3_CUSTO2 With Z29->Z29_TOTAL
				Replace D3_CUSTO3 With Z29->Z29_TOTAL
				Replace D3_CUSTO4 With Z29->Z29_TOTAL
				Replace D3_CUSTO5 With Z29->Z29_TOTAL
				Replace D3_CC With Z28->Z28_CC
				Replace D3_SEGUM With SB1->B1_SEGUM
				Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z29->Z29_VOLUME,1)
				Replace D3_TIPO With SB1->B1_TIPO
				Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
				Replace D3_CHAVE WITH "R0"
				MsUnLock()
			EndIf
			
			dbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+Z29->Z29_PROD)
			If Found()
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z29->Z29_VOLUME,1)
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z29->Z29_VOLUME,1)
					REPLACE B2_VATU1 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU1+Z29->Z29_TOTAL
					MsUnLock("SB2")
				EndIf
			Else
				If RecLock("SB2",.T.)
					Replace B2_FILIAL WITH xFilial("SB2")
					Replace B2_COD WITH Z29->Z29_PROD
					Replace B2_LOCAL WITH Z29->Z29_LOCAL
					REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z29->Z29_VOLUME,1)
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z29->Z29_VOLUME,1)
					REPLACE B2_VATU1 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU1+Z29->Z29_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU1+Z29->Z29_TOTAL
					MsUnLock("SB2")
				EndIf
			EndIf
			
			dbSelectArea("Z29")
			If RecLock("Z29",.F.)
				REPLACE Z29_BAIXA  WITH "ES"
				MsUnLock("Z29")
			EndIf
			dbskip()
		enddo
		
		dbSelectArea("Z28")
		If RecLock("Z28",.F.)
			REPLACE Z28_DOCREQ WITH GETMV("MV_DOCSEQ")
			REPLACE Z28_STATUS WITH "F"
			MsUnLock("Z28")
		EndIf
		
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
aAdd(aRegs,{cPerg,"02","1a. U. Medida?","1a. U. Medida?","1a. U. Medida?","mv_ch2","C",1,0,0,"C","","mv_par02","Volume","Volume","Volume","","","Toras","Toras","Toras","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","2a. U. Medida?","2a. U. Medida?","2a. U. Medida?","mv_ch3","C",1,0,0,"C","","mv_par03","Volume","Volume","Volume","","","Toras","Toras","Toras","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","TM para Producao?","TM para Producao?","TM para Producao?","mv_ch4","C",3,0,0,"G","EXISTCPO('SF5')","","","","","","","","","","","","","","","","","","","","","","","","","","SF5",""})

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
