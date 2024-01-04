#include "rwmake.ch"

User Function ST_CAD_SER
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "PRODUCAO DE MADEIRA SERRADA"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_SER(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_SER(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_SER(4)' , 0, 4},;
{ "Excluir"         ,'U_ST_SER(5)' , 0, 5},;
{ "Fechar Romaneio" ,'U_ST_PR01()' , 0, 4},;
{ "Legenda"         ,'U_ST_LG02()' , 0, 1}}

dbSelectArea("Z05")
dbSetOrder(1)

// Cores padroes do semaforo
aCores := { { 'Z05_STATUS == "A"','BR_VERDE'},;  // Verde - Pedido Aberto
{ 'Z05_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Fechado ou Encerrado

mBrowse( 6,1,22,75,"Z05",,"Z05_STATUS",,,,aCores)

Return

User Function ST_LG02()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Pedido Aberto"},;
{"DISABLE"   ,"Fechado/Encerrado"     }})
Return


User Function ST_SER(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z05")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z05_STATUS == "F"
		MsgBox ("Romaneio Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z05")
	IF !RECLOCK("Z05",.F.)
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


RegToMemory("Z05",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z06")

While !Eof().And.(x3_arquivo=="Z06")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z06_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_CONTR" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_BAIXA" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_DOCBX" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_DTBX" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_CCBX" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_DESTBX" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_DOCSC" .OR. Upper(AllTrim(X3_CAMPO)) = "Z06_DTSEC"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z06_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z06")
	dbSetOrder(1)
	dbSeek(xFilial("Z06")+M->Z05_CONTR)
	
	While !eof() .and. Z06->Z06_FILIAL == xFilial("Z06") .And. Z06->Z06_CONTR == M->Z05_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z06_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z05")

cTitulo        := "MANUTENCAO DE ROMANEIO DE PRODUCAO DE MADEIRA SERRADA"
cAliasEnchoice := "Z05"
cAliasGetD     := "Z06"
cLinOk         := 'ExecBlock("Vld02",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z05_CONTR"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {"Z05_STATUS","Z05_TPENTR","Z05_DOC","Z05_SERIE","Z05_DTDOC","Z05_FORNEC","Z05_LOJA","Z05_OBSERV","Z05_CONTAT","Z05_CC"}
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_LOTE"   })
_nPosPROD   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_PROD"   })
_nPosDESCP  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_DESCP"  })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_LOCAL"  })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_ITPED"  })
_nPosTIPO   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_TIPO"   })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_CERT"   })
_nPosEMB    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_EMB"    })
_nPosQUAL   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_QUAL"   })
_nPosSECAGE := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_SECAGE" })
_nPosUMIDAD := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_UMIDAD" })
_nPosCOD    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_COD"    })
_nPosESPECI := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_ESPECI" })
_nPosESPESS := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_ESPESS" })
_nPosLARGUR := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_LARGUR" })
_nPosCOMPR  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_COMPR"  })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_OBS"    })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z06_ACTOT"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_02GRInc()
			dbSelectArea("Z05")
			ConfirmSX8()
		Elseif _nOpcao == 4
			U_ST_02GrAlt()
		Elseif _nOpcao == 5
			U_ST_02GrExc()
		Endif
		
		Exit
	Else
		if  _nOpcao == 3
			dbSelectArea("Z05")
			RollBackSx8()
		Endif
		Exit
	Endif
	
EndDo

dbSelectArea("Z05")
if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

Return


/***********************************/
/***********************************/
User Function ST_02GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z06")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z06",.T.)
			Z06->Z06_FILIAL  := xFilial("Z06")
			Z06->Z06_CONTR   := M->Z05_CONTR
			Z06->Z06_SEQ     := STRZERO(nNUmIT,4)
			Z06->Z06_LOTE    := aCols[nIt,_nPosLOTE]
			Z06->Z06_PROD    := aCols[nIt,_nPosPROD]
			Z06->Z06_DESCP   := aCols[nIt,_nPosDESCP]
			Z06->Z06_LOCAL   := aCols[nIt,_nPosLOCAL]
			Z06->Z06_PEDIDO  := aCols[nIt,_nPosPEDIDO]
			Z06->Z06_ITPED   := aCols[nIt,_nPosITPED]
			Z06->Z06_TIPO    := aCols[nIt,_nPosTIPO]
			Z06->Z06_CERT    := aCols[nIt,_nPosCERT]
			Z06->Z06_EMB     := aCols[nIt,_nPosEMB]
			Z06->Z06_QUAL    := aCols[nIt,_nPosQUAL]
			Z06->Z06_SECAGE  := aCols[nIt,_nPosSECAGE]
			Z06->Z06_UMIDAD  := aCols[nIt,_nPosUMIDAD]
			Z06->Z06_COD     := aCols[nIt,_nPosCOD]
			Z06->Z06_ESPECI  := aCols[nIt,_nPosESPECI]
			Z06->Z06_ESPESS  := aCols[nIt,_nPosESPESS]
			Z06->Z06_LARGUR  := aCols[nIt,_nPosLARGUR]
			Z06->Z06_COMPR   := aCols[nIt,_nPosCOMPR]
			Z06->Z06_PECAS   := aCols[nIt,_nPosPECAS]
			Z06->Z06_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z06->Z06_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z06->Z06_DESCM   := aCols[nIt,_nPosDESCM]
			Z06->Z06_PRECO   := aCols[nIt,_nPosPRECO]
			Z06->Z06_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z06->Z06_OBS     := aCols[nIt,_nPosOBS]
			Z06->Z06_ACPEC   := aCols[nIt,_nPosACPEC]
			Z06->Z06_ACVOL   := aCols[nIt,_nPosACVOL]
			Z06->Z06_ACTOT   := aCols[nIt,_nPosACTOT]
			Z06->Z06_BAIXA   := "LB"
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z05")
if RecLock("Z05",.T.)
	Z05->Z05_FILIAL   := xFilial("Z05")
	Z05->Z05_STATUS   := M->Z05_STATUS
	Z05->Z05_CONTR    := M->Z05_CONTR
	Z05->Z05_DATA     := M->Z05_DATA
	Z05->Z05_TPENTR   := M->Z05_TPENTR
	Z05->Z05_DOC      := M->Z05_DOC
	Z05->Z05_SERIE    := M->Z05_SERIE
	Z05->Z05_DTDOC    := M->Z05_DTDOC
	Z05->Z05_FORNEC   := M->Z05_FORNEC
	Z05->Z05_LOJA     := M->Z05_LOJA
	Z05->Z05_NOME     := M->Z05_NOME
	Z05->Z05_OBSERV   := M->Z05_OBSERV
	Z05->Z05_CONTAT   := M->Z05_CONTAT
	Z05->Z05_CC       := M->Z05_CC
	Z05->Z05_DESCC    := M->Z05_DESCC
	Z05->Z05_DOCREQ   := M->Z05_DOCREQ
	MsUnLock()
Endif
dbSelectArea("Z05")
Return


/***********************************/
/***********************************/
User Function ST_02GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z06")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z06")
	dbSetOrder(1)
	if dbseek(xfilial("Z06")+M->Z05_CONTR+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z06",.F.)
			If !aCols[nIt,_nPosDel]
				Z06->Z06_LOTE    := aCols[nIt,_nPosLOTE]
				Z06->Z06_PROD    := aCols[nIt,_nPosPROD]
				Z06->Z06_DESCP   := aCols[nIt,_nPosDESCP]
				Z06->Z06_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z06->Z06_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z06->Z06_ITPED   := aCols[nIt,_nPosITPED]
				Z06->Z06_TIPO    := aCols[nIt,_nPosTIPO]
				Z06->Z06_CERT    := aCols[nIt,_nPosCERT]
				Z06->Z06_EMB     := aCols[nIt,_nPosEMB]
				Z06->Z06_QUAL    := aCols[nIt,_nPosQUAL]
				Z06->Z06_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z06->Z06_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z06->Z06_COD     := aCols[nIt,_nPosCOD]
				Z06->Z06_ESPECI  := aCols[nIt,_nPosESPECI]
				Z06->Z06_ESPESS  := aCols[nIt,_nPosESPESS]
				Z06->Z06_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z06->Z06_COMPR   := aCols[nIt,_nPosCOMPR]
				Z06->Z06_PECAS   := aCols[nIt,_nPosPECAS]
				Z06->Z06_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z06->Z06_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z06->Z06_DESCM   := aCols[nIt,_nPosDESCM]
				Z06->Z06_PRECO   := aCols[nIt,_nPosPRECO]
				Z06->Z06_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z06->Z06_OBS     := aCols[nIt,_nPosOBS]
				Z06->Z06_ACPEC   := aCols[nIt,_nPosACPEC]
				Z06->Z06_ACVOL   := aCols[nIt,_nPosACVOL]
				Z06->Z06_ACTOT   := aCols[nIt,_nPosACTOT]
				Z06->Z06_BAIXA   := "LB"
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z06",.t.)
				Z06->Z06_FILIAL  := xFilial("Z06")
				Z06->Z06_CONTR   := M->Z05_CONTR
				Z06->Z06_SEQ     := "9999"
				Z06->Z06_LOTE    := aCols[nIt,_nPosLOTE]
				Z06->Z06_PROD    := aCols[nIt,_nPosPROD]
				Z06->Z06_DESCP   := aCols[nIt,_nPosDESCP]
				Z06->Z06_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z06->Z06_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z06->Z06_ITPED   := aCols[nIt,_nPosITPED]
				Z06->Z06_TIPO    := aCols[nIt,_nPosTIPO]
				Z06->Z06_CERT    := aCols[nIt,_nPosCERT]
				Z06->Z06_EMB     := aCols[nIt,_nPosEMB]
				Z06->Z06_QUAL    := aCols[nIt,_nPosQUAL]
				Z06->Z06_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z06->Z06_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z06->Z06_COD     := aCols[nIt,_nPosCOD]
				Z06->Z06_ESPECI  := aCols[nIt,_nPosESPECI]
				Z06->Z06_ESPESS  := aCols[nIt,_nPosESPESS]
				Z06->Z06_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z06->Z06_COMPR   := aCols[nIt,_nPosCOMPR]
				Z06->Z06_PECAS   := aCols[nIt,_nPosPECAS]
				Z06->Z06_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z06->Z06_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z06->Z06_DESCM   := aCols[nIt,_nPosDESCM]
				Z06->Z06_PRECO   := aCols[nIt,_nPosPRECO]
				Z06->Z06_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z06->Z06_ACPEC   := aCols[nIt,_nPosACPEC]
				Z06->Z06_ACVOL   := aCols[nIt,_nPosACVOL]
				Z06->Z06_ACTOT   := aCols[nIt,_nPosACTOT]
				Z06->Z06_OBS     := aCols[nIt,_nPosOBS]
				Z06->Z06_BAIXA   := "LB"
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z06")
dbSetOrder(2)
if dbseek(xfilial("Z06")+M->Z05_CONTR,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z06_CONTR == M->Z05_CONTR
		_nNumSeq ++
		IF RecLock("Z06",.F.)
			Z06->Z06_SEQ := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z05")
Z05->Z05_STATUS   := M->Z05_STATUS
Z05->Z05_CONTR    := M->Z05_CONTR
Z05->Z05_DATA     := M->Z05_DATA
Z05->Z05_TPENTR   := M->Z05_TPENTR
Z05->Z05_DOC      := M->Z05_DOC
Z05->Z05_SERIE    := M->Z05_SERIE
Z05->Z05_DTDOC    := M->Z05_DTDOC
Z05->Z05_FORNEC   := M->Z05_FORNEC
Z05->Z05_LOJA     := M->Z05_LOJA
Z05->Z05_NOME     := M->Z05_NOME
Z05->Z05_OBSERV   := M->Z05_OBSERV
Z05->Z05_CONTAT   := M->Z05_CONTAT
Z05->Z05_CC       := M->Z05_CC
Z05->Z05_DESCC    := M->Z05_DESCC
Z05->Z05_DOCREQ   := M->Z05_DOCREQ
Return


/***********************************/
/***********************************/
User Function ST_02GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z06")
dbSetOrder(1)
if dbSeek(xFilial("Z06")+M->Z05_CONTR)
	WHILE Z06_FILIAL == xFilial("Z06") .AND. Z06_CONTR=M->Z05_CONTR
		If RecLock("Z06",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z05")
dbDelete()
Return


User Function Vld02()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
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


// GERAR PRE-NOTA FISCAL
User Function ST_PR01()

Private cPerg := "Z05"
Private oGeraTxt
Private cString := "Z05"

ValidPerg()

dbSelectArea("Z05")
dbSetOrder(1)

Pergunte(cPerg,.T.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Pré-Nota de Entrada")
@ 02,10 TO 070,185
@ 10,018 Say " Este programa ira gerar a pré-nota de entrada do romaneio de  "
@ 18,018 Say " entrada de Madeira Serrada, devendo apenas ser  realizada  a  "
@ 26,018 Say " classificação na rotina de Notas Fiscais.                     "

@ 75,98 BMPBUTTON TYPE 01 ACTION OkGeraNF()
@ 75,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 75,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

// Gera NF
Static Function OkGeraNF

dbSelectArea("Z05")
dbSetOrder(1)
dbSeek(xFilial("Z05")+MV_PAR01)
IF FOUND()
	IF Z05_TPENTR<>"N"
		MSGBOX("Este Romaneio vai gerar Movimento Interno Mod.03!")
		
		U_ST_INT_SER(Z05->Z05_CONTR)
		
		Return
	EndIf
	IF Z05_STATUS=="F"
		MSGBOX("Este Romaneio ja foi fechado! Verifique...")
		Return
	EndIf
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+Z05->Z05_FORNEC+Z05->Z05_LOJA)
	IF !FOUND()
		MSGBOX("Verifique o Código do Fornecedor!!!")
		return
	ENDIF
	dbSelectArea("SF1")
	dbSetOrder(1)
	dbSeek(xFilial("SF1")+Z05->Z05_DOC+Z05->Z05_SERIE+Z05->Z05_FORNEC+Z05->Z05_LOJA)
	IF FOUND()
		vOpc:=MSGBOX("Nota Fiscal ja Existe! Deseja Classificar Produtos?","Fechar Romaneio...","YesNo")
		If vOpc
			
			U_ST_CLA_SER(Z05->Z05_CONTR)
			
		EndIf
	Else
		vOpc:=MSGBOX("Nota Fiscal nao encontrada! Deseja Gerar Pre-Nota?","Fechar Romaneio...","YesNo")
		If vOpc
			dbSelectArea("Z06")
			dbSetOrder(4)
			dbSeek(xFilial("Z06")+Z05->Z05_CONTR)
			_Item:=0
			_Volume:=0
			_Quant:=0
			_Vltotal:=0
			IF FOUND()
				_Produto:=Z06_PROD
				_Local:=Z06_LOCAL
			ELSE
				_Produto:=""
				_Local:=""
			ENDIF
			do While !EOF() .AND. Z06_FILIAL=xFilial("Z05") .AND. Z06_CONTR=Z05->Z05_CONTR
				IF _Produto<>Z06_PROD .OR. _Local<>Z06_LOCAL
					
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
						Replace D1_FORNECE With Z05->Z05_FORNEC
						Replace D1_LOJA With Z05->Z05_LOJA
						Replace D1_LOCAL With _Local
						Replace D1_DOC With Z05->Z05_DOC
						Replace D1_SERIE With Z05->Z05_SERIE
						Replace D1_EMISSAO With Z05->Z05_DTDOC
						Replace D1_DTDIGIT With Z05->Z05_DATA //DATE()
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
					_Produto:=Z06->Z06_PROD
					_Local:=Z06->Z06_LOCAL
				ENDIF
				dbSelectArea("Z06")
				If RecLock("Z06",.F.)
					REPLACE Z06_BAIXA WITH "ES"
					MsUnLock("Z06")
				End If
				_Volume:=_Volume+Z06_VOLUME
				_Vltotal:=_Vltotal+Z06_TOTAL
				_Quant:=_Quant+Z06_PECAS
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
					Replace D1_FORNECE With Z05->Z05_FORNEC
					Replace D1_LOJA With Z05->Z05_LOJA
					Replace D1_LOCAL With _Local
					Replace D1_DOC With Z05->Z05_DOC
					Replace D1_SERIE With Z05->Z05_SERIE
					Replace D1_EMISSAO With Z05->Z05_DTDOC
					Replace D1_DTDIGIT With Z05->Z05_DATA //DATE()
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
				Replace F1_DOC With Z05->Z05_DOC
				Replace F1_SERIE With Z05->Z05_SERIE
				Replace F1_FORNECE With Z05->Z05_FORNEC
				Replace F1_LOJA With Z05->Z05_LOJA
				Replace F1_EMISSAO With Z05->Z05_DTDOC
				Replace F1_EST With POSICIONE("SA2",1,xFilial("SA2")+Z05->Z05_FORNEC+Z05->Z05_LOJA,"A2_EST") //"PA"
				Replace F1_TIPO With "N"
				Replace F1_DTDIGIT With Z05->Z05_DATA //dDataBase()
				Replace F1_ESPECIE With "NF"
				MsUnLock()
			End If
			
			dbSelectArea("Z05")
			If RecLock("Z05",.F.)
				REPLACE Z05_STATUS WITH "F"
				MsUnLock("Z05")
			End If
			MSGBOX("Pre-Nota gerada com sucesso, verifique na rotina correspondente!!!")
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
