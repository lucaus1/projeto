#include "rwmake.ch"

User Function ST_CAD_IND
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "PRODUCAO DE MADEIRA INDUSTRIALIZADA/USINAGEM"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_IND(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_IND(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_IND(4)' , 0, 4},;
{ "Excluir"         ,'U_ST_IND(5)' , 0, 5},;
{ "Fechar Romaneio" ,'U_ST_PR04()' , 0, 4},;
{ "Legenda"         ,'U_ST_LG06()' , 0, 1}}


dbSelectArea("Z12")
dbSetOrder(1)

// Cores padroes do semaforo
aCores := { { 'Z12_STATUS == "A"','BR_VERDE'},;  // Verde - Pedido Aberto
{ 'Z12_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Fechado ou Encerrado

mBrowse( 6,1,22,75,"Z12",,"Z12_STATUS",,,,aCores)

Return

User Function ST_LG06()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Pedido Aberto"},;
{"DISABLE"   ,"Fechado/Encerrado"     }})
Return


User Function ST_IND(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z12")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z12_STATUS == "F"
		MsgBox ("Romaneio Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z12")
	IF !RECLOCK("Z12",.F.)
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


RegToMemory("Z12",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z13")

While !Eof().And.(x3_arquivo=="Z13")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z13_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z13_CONTR" .OR. Upper(AllTrim(X3_CAMPO)) = "Z13_BAIXA" .OR. Upper(AllTrim(X3_CAMPO)) = "Z13_DOCBX" .OR. Upper(AllTrim(X3_CAMPO)) = "Z13_DTBX" .OR. Upper(AllTrim(X3_CAMPO)) = "Z13_CCBX" .OR. Upper(AllTrim(X3_CAMPO)) = "Z13_DESTBX"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z13_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z13")
	dbSetOrder(1)
	dbSeek(xFilial("Z13")+M->Z12_CONTR)
	
	While !eof() .and. Z13->Z13_FILIAL == xFilial("Z13") .And. Z13->Z13_CONTR == M->Z12_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z13_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z12")

cTitulo        := "MANUTENCAO DE ROMANEIO DE PRODUCAO DE MADEIRA INDUSTRIALIZADA/USINADA"
cAliasEnchoice := "Z12"
cAliasGetD     := "Z13"
cLinOk         := 'ExecBlock("Vld06",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z12_CONTR"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {"Z12_STATUS","Z12_TPENTR","Z12_DOC","Z12_SERIE","Z12_DTDOC","Z12_FORNEC","Z12_LOJA","Z12_OBSERV","Z12_CONTAT","Z12_CC"}
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_LOTE"   })
_nPosPROD   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_PROD"   })
_nPosDESCP  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_DESCP"  })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_LOCAL"  })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_ITPED"  })
_nPosPERFIL := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_PERFIL" })
_nPosTIPO   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_TIPO"   })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_CERT"   })
_nPosEMB    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_EMB"    })
_nPosQUAL   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_QUAL"   })
_nPosSECAGE := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_SECAGE" })
_nPosUMIDAD := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_UMIDAD" })
_nPosCOD    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_COD"    })
_nPosESPECI := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_ESPECI" })
_nPosESPESS := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_ESPESS" })
_nPosLARGUR := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_LARGUR" })
_nPosCOMPR  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_COMPR"  })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_OBS"    })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z13_ACTOT"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_06GRInc()
			dbSelectArea("Z12")
			ConfirmSX8()
		Elseif _nOpcao == 4
			U_ST_06GrAlt()
		Elseif _nOpcao == 5
			U_ST_06GrExc()
		Endif
		
		Exit
	Else
		if  _nOpcao == 3
			dbSelectArea("Z12")
			RollBackSx8()
		Endif
		Exit
	Endif
	
EndDo

dbSelectArea("Z12")

if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

Return


/***********************************/
/***********************************/
User Function ST_06GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z13")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z13",.T.)
			Z13->Z13_FILIAL  := xFilial("Z13")
			Z13->Z13_CONTR   := M->Z12_CONTR
			Z13->Z13_SEQ     := STRZERO(nNUmIT,4)
			Z13->Z13_LOTE    := aCols[nIt,_nPosLOTE]
			Z13->Z13_PROD    := aCols[nIt,_nPosPROD]
			Z13->Z13_DESCP    := aCols[nIt,_nPosDESCP]
			Z13->Z13_LOCAL   := aCols[nIt,_nPosLOCAL]
			Z13->Z13_PEDIDO  := aCols[nIt,_nPosPEDIDO]
			Z13->Z13_ITPED   := aCols[nIt,_nPosITPED]
			Z13->Z13_PERFIL  := aCols[nIt,_nPosPERFIL]
			Z13->Z13_TIPO    := aCols[nIt,_nPosTIPO]
			Z13->Z13_CERT    := aCols[nIt,_nPosCERT]
			Z13->Z13_EMB     := aCols[nIt,_nPosEMB]
			Z13->Z13_QUAL    := aCols[nIt,_nPosQUAL]
			Z13->Z13_SECAGE  := aCols[nIt,_nPosSECAGE]
			Z13->Z13_UMIDAD  := aCols[nIt,_nPosUMIDAD]
			Z13->Z13_COD     := aCols[nIt,_nPosCOD]
			Z13->Z13_ESPECI  := aCols[nIt,_nPosESPECI]
			Z13->Z13_ESPESS  := aCols[nIt,_nPosESPESS]
			Z13->Z13_LARGUR  := aCols[nIt,_nPosLARGUR]
			Z13->Z13_COMPR   := aCols[nIt,_nPosCOMPR]
			Z13->Z13_PECAS   := aCols[nIt,_nPosPECAS]
			Z13->Z13_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z13->Z13_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z13->Z13_DESCM   := aCols[nIt,_nPosDESCM]
			Z13->Z13_PRECO   := aCols[nIt,_nPosPRECO]
			Z13->Z13_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z13->Z13_OBS     := aCols[nIt,_nPosOBS]
			Z13->Z13_ACPEC   := aCols[nIt,_nPosACPEC]
			Z13->Z13_ACVOL   := aCols[nIt,_nPosACVOL]
			Z13->Z13_ACTOT   := aCols[nIt,_nPosACTOT]
			Z13->Z13_BAIXA   := "LB"
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z12")
if RecLock("Z12",.T.)
	Z12->Z12_FILIAL   := xFilial("Z12")
	Z12->Z12_STATUS   := M->Z12_STATUS
	Z12->Z12_CONTR    := M->Z12_CONTR
	Z12->Z12_DATA     := M->Z12_DATA
	Z12->Z12_TPENTR   := M->Z12_TPENTR
	Z12->Z12_CC       := M->Z12_CC
	Z12->Z12_DESCC    := M->Z12_DESCC
	Z12->Z12_DOC      := M->Z12_DOC
	Z12->Z12_SERIE    := M->Z12_SERIE
	Z12->Z12_DTDOC    := M->Z12_DTDOC
	Z12->Z12_FORNEC   := M->Z12_FORNEC
	Z12->Z12_LOJA     := M->Z12_LOJA
	Z12->Z12_NOME     := M->Z12_NOME
	Z12->Z12_OBSERV   := M->Z12_OBSERV
	Z12->Z12_CONTAT   := M->Z12_CONTAT
	MsUnLock()
Endif
dbSelectArea("Z12")
Return


/***********************************/
/***********************************/
User Function ST_06GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z13")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z13")
	dbSetOrder(1)
	if dbseek(xfilial("Z13")+M->Z12_CONTR+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z13",.F.)
			If !aCols[nIt,_nPosDel]
				Z13->Z13_LOTE    := aCols[nIt,_nPosLOTE]
				Z13->Z13_PROD    := aCols[nIt,_nPosPROD]
				Z13->Z13_DESCP    := aCols[nIt,_nPosDESCP]
				Z13->Z13_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z13->Z13_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z13->Z13_ITPED   := aCols[nIt,_nPosITPED]
				Z13->Z13_TIPO    := aCols[nIt,_nPosTIPO]
				Z13->Z13_PERFIL  := aCols[nIt,_nPosPERFIL]
				Z13->Z13_CERT    := aCols[nIt,_nPosCERT]
				Z13->Z13_EMB     := aCols[nIt,_nPosEMB]
				Z13->Z13_QUAL    := aCols[nIt,_nPosQUAL]
				Z13->Z13_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z13->Z13_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z13->Z13_COD     := aCols[nIt,_nPosCOD]
				Z13->Z13_ESPECI  := aCols[nIt,_nPosESPECI]
				Z13->Z13_ESPESS  := aCols[nIt,_nPosESPESS]
				Z13->Z13_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z13->Z13_COMPR   := aCols[nIt,_nPosCOMPR]
				Z13->Z13_PECAS   := aCols[nIt,_nPosPECAS]
				Z13->Z13_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z13->Z13_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z13->Z13_DESCM   := aCols[nIt,_nPosDESCM]
				Z13->Z13_PRECO   := aCols[nIt,_nPosPRECO]
				Z13->Z13_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z13->Z13_OBS     := aCols[nIt,_nPosOBS]
				Z13->Z13_ACPEC   := aCols[nIt,_nPosACPEC]
				Z13->Z13_ACVOL   := aCols[nIt,_nPosACVOL]
				Z13->Z13_ACTOT   := aCols[nIt,_nPosACTOT]
				Z13->Z13_BAIXA   := "LB"
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z13",.t.)
				Z13->Z13_FILIAL  := xFilial("Z13")
				Z13->Z13_CONTR   := M->Z12_CONTR
				Z13->Z13_SEQ     := "9999"
				Z13->Z13_LOTE    := aCols[nIt,_nPosLOTE]
				Z13->Z13_PROD    := aCols[nIt,_nPosPROD]
				Z13->Z13_DESCP    := aCols[nIt,_nPosDESCP]
				Z13->Z13_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z13->Z13_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z13->Z13_ITPED   := aCols[nIt,_nPosITPED]
				Z13->Z13_PERFIL  := aCols[nIt,_nPosPERFIL]
				Z13->Z13_TIPO    := aCols[nIt,_nPosTIPO]
				Z13->Z13_CERT    := aCols[nIt,_nPosCERT]
				Z13->Z13_EMB     := aCols[nIt,_nPosEMB]
				Z13->Z13_QUAL    := aCols[nIt,_nPosQUAL]
				Z13->Z13_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z13->Z13_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z13->Z13_COD     := aCols[nIt,_nPosCOD]
				Z13->Z13_ESPECI  := aCols[nIt,_nPosESPECI]
				Z13->Z13_ESPESS  := aCols[nIt,_nPosESPESS]
				Z13->Z13_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z13->Z13_COMPR   := aCols[nIt,_nPosCOMPR]
				Z13->Z13_PECAS   := aCols[nIt,_nPosPECAS]
				Z13->Z13_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z13->Z13_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z13->Z13_DESCM   := aCols[nIt,_nPosDESCM]
				Z13->Z13_PRECO   := aCols[nIt,_nPosPRECO]
				Z13->Z13_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z13->Z13_OBS     := aCols[nIt,_nPosOBS]
				Z13->Z13_ACPEC   := aCols[nIt,_nPosACPEC]
				Z13->Z13_ACVOL   := aCols[nIt,_nPosACVOL]
				Z13->Z13_ACTOT   := aCols[nIt,_nPosACTOT]
				Z13->Z13_BAIXA   := "LB"
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z13")
dbSetOrder(2)
if dbseek(xfilial("Z13")+M->Z12_CONTR,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z13_CONTR == M->Z12_CONTR
		_nNumSeq ++
		IF RecLock("Z13",.F.)
			Z13->Z13_SEQ := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z12")
Z12->Z12_STATUS   := M->Z12_STATUS
Z12->Z12_CONTR    := M->Z12_CONTR
Z12->Z12_DATA     := M->Z12_DATA
Z12->Z12_TPENTR   := M->Z12_TPENTR
Z12->Z12_CC       := M->Z12_CC
Z12->Z12_DESCC    := M->Z12_DESCC
Z12->Z12_DOC      := M->Z12_DOC
Z12->Z12_SERIE    := M->Z12_SERIE
Z12->Z12_DTDOC    := M->Z12_DTDOC
Z12->Z12_FORNEC   := M->Z12_FORNEC
Z12->Z12_LOJA     := M->Z12_LOJA
Z12->Z12_NOME     := M->Z12_NOME
Z12->Z12_OBSERV   := M->Z12_OBSERV
Z12->Z12_CONTAT   := M->Z12_CONTAT
Return


/***********************************/
/***********************************/
User Function ST_06GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z13")
dbSetOrder(1)
if dbSeek(xFilial("Z13")+M->Z12_CONTR)
	WHILE Z13_FILIAL == xFilial("Z13") .AND. Z13_CONTR=M->Z12_CONTR
		If RecLock("Z13",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z12")
dbDelete()
Return


User Function Vld06()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
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
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00



// GERAR MOV. INTERNOS - PRODUCAO
User Function ST_PR04()

Private cPerg := "Z12"
Private oGeraTxt
Private cString := "Z12"

ValidPerg()

dbSelectArea("Z12")
dbSetOrder(1)

Pergunte(cPerg,.T.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Mov. Interno (Mod. 02)")
@ 02,10 TO 070,185
@ 10,018 Say " Este programa ira gerar Mov. Interno de Producao do romaneio  "
@ 18,018 Say " de Pacotes/Lotes de Madeira Industrializada/Usinada           "
@ 26,018 Say "                                                               "

@ 75,98 BMPBUTTON TYPE 01 ACTION SelClas()
@ 75,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 75,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return


Static Function SelClas()
dbSelectArea("Z12")
dbSetOrder(1)
dbSeek(xFilial("Z12")+MV_PAR01)
IF FOUND()
	IF ALLTRIM(Z12_TPENTR)=="P"
		OkGeraREQ()
	Else
		OkGerINF()
	Endif
Endif
Close(oGeraTxt)
Return


// Gera NF
Static Function OkGerINF
dbSelectArea("Z12")
dbSetOrder(1)
dbSeek(xFilial("Z12")+MV_PAR01)
IF FOUND()
	IF Z12_STATUS=="F"
		MSGBOX("Este Romaneio ja foi fechado! Verifique...")
		Return
	EndIf
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+Z12->Z12_FORNEC+Z12->Z12_LOJA)
	IF !FOUND()
		MSGBOX("Verifique o Código do Fornecedor!!!")
		return
	ENDIF
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+Z12->Z12_DOC+Z12->Z12_SERIE+Z12->Z12_FORNEC+Z12->Z12_LOJA)
	IF FOUND()
		vOpc:=MSGBOX("Nota Fiscal ja Existe! Deseja Classificar Produtos?","Fechar Romaneio...","YesNo")
		If vOpc
			
			U_ST_CLA_IND(Z12->Z12_CONTR)
			
		EndIf
	Else
		vOpc:=MSGBOX("Nota Fiscal nao encontrada! Deseja Gerar Pre-Nota?","Fechar Romaneio...","YesNo")
		If vOpc
			dbSelectArea("Z13")
			dbSetOrder(4)
			dbSeek(xFilial("Z13")+Z12->Z12_CONTR)
			_Item:=0
			_Volume:=0
			_Quant:=0
			_Vltotal:=0
			IF FOUND()
				_Produto:=Z13_PROD
				_Local:=Z13_LOCAL
			ELSE
				_Produto:=""
				_Local:=""
			ENDIF
			do While !EOF() .AND. Z13_FILIAL=xFilial("Z12") .AND. Z13_CONTR=Z12->Z12_CONTR
				IF _Produto<>Z13_PROD .OR. _Local<>Z13_LOCAL
					
					dbSelectArea("SB1")
					DbSetOrder(1)
					DbSeek(xFilial("SB1")+_Produto)
					
					dbSelectArea("SD1")
					If RecLock("SD1",.T.)
						Replace D1_FILIAL With xFILIAL("SD1")
						Replace D1_COD With _Produto
						Replace D1_UM With SB1->B1_UM
						Replace D1_SEGUM With SB1->B1_SEGUM
						Replace D1_QUANT With IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
						Replace D1_VUNIT With round(_Vltotal/IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant)),2)
						Replace D1_TOTAL With round(_Vltotal/IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant)),2)*IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
						Replace D1_FORNECE With Z12->Z12_FORNEC
						Replace D1_LOJA With Z12->Z12_LOJA
						Replace D1_LOCAL With _Local
						Replace D1_DOC With Z12->Z12_DOC
						Replace D1_SERIE With Z12->Z12_SERIE
						Replace D1_EMISSAO With Z12->Z12_DTDOC
						Replace D1_DTDIGIT With Z12->Z12_DATA //DATE()
						Replace D1_GRUPO With SB1->B1_GRUPO
						Replace D1_TIPO With "N"
						Replace D1_TP With SB1->B1_TIPO
						Replace D1_QTSEGUM With IIF(MV_PAR03=1,_Volume,IIF(MV_PAR03=2,_Item,_Quant))
						Replace D1_ITEM With strzero(_Item+1,4)
						MsUnLock()
					End If
					_Item:=_Item+1
					_Volume:=0
					_Quant:=0
					_Vltotal:=0
					_Produto:=Z13->Z13_PROD
					_Local:=Z13->Z13_LOCAL
				ENDIF
				dbSelectArea("Z13")
				If RecLock("Z13",.F.)
					REPLACE Z13_BAIXA WITH "ES"
					MsUnLock("Z13")
				End If
				_Volume:=_Volume+Z13_VOLUME
				_Vltotal:=_Vltotal+Z13_TOTAL
				_Quant:=_Quant+Z13_PECAS
				dbskip()
			enddo
			
			IF _Quant>0
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+_Produto)
				
				dbSelectArea("SD1")
				If RecLock("SD1",.T.)
					Replace D1_FILIAL With xFILIAL("SD1")
					Replace D1_COD With _Produto
					Replace D1_UM With SB1->B1_UM
					Replace D1_SEGUM With SB1->B1_SEGUM
					Replace D1_QUANT With IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
					Replace D1_VUNIT With round(_Vltotal/IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant)),2)
					Replace D1_TOTAL With round(_Vltotal/IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant)),2)*IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
					Replace D1_FORNECE With Z12->Z12_FORNEC
					Replace D1_LOJA With Z12->Z12_LOJA
					Replace D1_LOCAL With _Local
					Replace D1_DOC With Z12->Z12_DOC
					Replace D1_SERIE With Z12->Z12_SERIE
					Replace D1_EMISSAO With Z12->Z12_DTDOC
					Replace D1_DTDIGIT With Z12->Z12_DATA //DATE()
					Replace D1_GRUPO With SB1->B1_GRUPO
					Replace D1_TIPO With "N"
					Replace D1_TP With SB1->B1_TIPO
					Replace D1_QTSEGUM With IIF(MV_PAR03=1,_Volume,IIF(MV_PAR03=2,_Item,_Quant))
					Replace D1_ITEM With strzero(_Item+1,4)
					MsUnLock()
				End If
			ENDIF
			
			dbSelectArea("SF1")
			If RecLock("SF1",.T.)
				Replace F1_FILIAL With xFILIAL("SF1")
				Replace F1_DOC With Z12->Z12_DOC
				Replace F1_SERIE With Z12->Z12_SERIE
				Replace F1_FORNECE With Z12->Z12_FORNEC
				Replace F1_LOJA With Z12->Z12_LOJA
				Replace F1_EMISSAO With Z12->Z12_DTDOC
				Replace F1_EST With POSICIONE("SA2",1,xFilial("SA2")+Z12->Z12_FORNEC+Z12->Z12_LOJA,"A2_EST") //"PA"
				Replace F1_TIPO With "N"
				Replace F1_DTDIGIT With Z12->Z12_DATA //dDataBase()
				Replace F1_ESPECIE With "NF"
				MsUnLock()
			End If
			
			dbSelectArea("Z12")
			If RecLock("Z12",.F.)
				REPLACE Z12_STATUS WITH "F"
				MsUnLock("Z12")
			End If
			MSGBOX("Pre-Nota gerada com sucesso, verifique na rotina correspondente!!!")
		EndIf
	ENDIF
ELSE
	MSGBOX("Romaneio não encontrado, verifique os parâmetros!!!")
ENDIF
Return


Static Function OkGeraREQ
dbSelectArea("Z12")
dbSetOrder(1)
dbSeek(xFilial("Z12")+MV_PAR01)
IF FOUND()
	dbSelectArea("Z12")
	IF Z12_STATUS="F"
		MSGBOX("Movimentacao ja foi Gerada!!!")
	ELSEIF ALLTRIM(Z12_TPENTR)<>"P"
		MSGBOX("Tipo do Documento nao e Romaneio!")
	ELSEIF ALLTRIM(Z12_CC)=""
		MSGBOX("Informe o Centro de Custo para Producao!")
	ELSEIF POSICIONE("SF5",1,xFilial("SF5")+MV_PAR04,"F5_TIPO")=="R"
		MSGBOX("Tipo de movimentacao incompativel!!! "+MV_PAR04)
	ELSE
		dbSelectArea("Z13")
		dbSetOrder(1)
		DbSeek(xFilial("Z13")+MV_PAR01)
		While !eof() .AND. xFilial("Z13")=Z13_FILIAL .AND. Z13_CONTR==MV_PAR01
			
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Z13->Z13_PROD)
			
			dbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  "+"MV_DOCSEQ")
			
			dbSelectArea("SD3")
			If RecLock("SD3",.T.)
				Replace D3_FILIAL With xFILIAL("SD3")
				Replace D3_TM With MV_PAR04
				Replace D3_COD With Z13->Z13_PROD
				Replace D3_UM With SB1->B1_UM
				Replace D3_CF With "PR0"
				Replace D3_QUANT With IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
				Replace D3_LOCAL With Z13->Z13_LOCAL
				Replace D3_DOC With GETMV("MV_DOCSEQ")
				Replace D3_GRUPO With SB1->B1_GRUPO
				Replace D3_EMISSAO With Z12->Z12_DATA
				Replace D3_CUSTO1 With Z13->Z13_TOTAL
				Replace D3_CUSTO2 With Z13->Z13_TOTAL
				Replace D3_CUSTO3 With Z13->Z13_TOTAL
				Replace D3_CUSTO4 With Z13->Z13_TOTAL
				Replace D3_CUSTO5 With Z13->Z13_TOTAL
				Replace D3_CC With Z12->Z12_CC
				Replace D3_SEGUM With SB1->B1_SEGUM
				Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z13->Z13_VOLUME,IIF(MV_PAR03=2,1,Z13->Z13_PECAS))
				Replace D3_TIPO With SB1->B1_TIPO
				Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
				Replace D3_CHAVE WITH "R0"
				MsUnLock()
			EndIf
			
			dbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+Z13->Z13_PROD)
			If Found()
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					REPLACE B2_VATU1 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU1+Z13->Z13_TOTAL
					MsUnLock("SB2")
				EndIf
			Else
				If RecLock("SB2",.T.)
					Replace B2_FILIAL WITH xFilial("SB2")
					Replace B2_COD WITH Z13->Z13_PROD
					Replace B2_LOCAL WITH Z13->Z13_LOCAL
					REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z13->Z13_VOLUME,IIF(MV_PAR02=2,1,Z13->Z13_PECAS))
					REPLACE B2_VATU1 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU1+Z13->Z13_TOTAL
					MsUnLock("SB2")
				EndIf
			EndIf
			
			dbSelectArea("Z13")
			If RecLock("Z13",.F.)
				REPLACE Z13_BAIXA  WITH "ES"
				MsUnLock("Z13")
			EndIf
			dbskip()
		enddo
		
		dbSelectArea("Z12")
		If RecLock("Z12",.F.)
			REPLACE Z12_DOCREQ WITH GETMV("MV_DOCSEQ")
			REPLACE Z12_STATUS WITH "F"
			MsUnLock("Z12")
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
