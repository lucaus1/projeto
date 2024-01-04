#include "rwmake.ch"

User Function ST_CAD_PED
SetPrvt("CCADASTRO,AROTINA,")
cCadastro := "CADASTRO DE PEDIDOS"

aRotina   := { { "Pesquisar"       ,"AxPesqui" , 0, 1},;
{ "Visualizar"      ,'U_ST_PED(2)' , 0, 2},;
{ "Incluir"         ,'U_ST_PED(3)' , 0, 3},;
{ "Alterar"         ,'U_ST_PED(4)' , 0, 4},;
{ "Excluir"         ,'U_ST_PED(5)' , 0, 5},;
{ "Legenda"         ,'U_ST_LG01()' , 0, 1}}

dbSelectArea("Z03")
dbSetOrder(2)

// Cores padroes do semaforo
aCores := { { 'Z03_STATUS == "A"','BR_VERDE'},;  // Verde - Pedido Aberto
{ 'Z03_STATUS == "L"','BR_AMARELO'},;    // Amarelo - Liberado para Producao
{ 'Z03_STATUS == "P"','BR_AZUL'},;    // Azul - Atendido Parcialmente
{ 'Z03_STATUS == "F"','BR_VERMELHO'}}     // Vermelho - Fechado ou Encerrado

mBrowse( 6,1,22,75,"Z03",,"Z03_STATUS",,,,aCores)

Return

User Function ST_LG01()
BRWLEGENDA(cCadastro,"Legenda",;
{{"ENABLE"    ,"Pedido Aberto"},;
{"BR_AMARELO","Liberado para Producao"},;
{"BR_AZUL","Atendido Parcialmente"  },;
{"DISABLE"   ,"Fechado/Encerrado"     }})
Return


User Function ST_PED(_nOpcao)

SetPrvt("COPCAO,NOPCE,NOPCG,NUSADO,AHEADER,ACOLS")
SetPrvt("N,_NI,CCPO,_NPOSITEM,CTITULO,CALIASENCHOICE")
SetPrvt("CALIASGETD,CLINOK,CTUDOK,CFIELDOK,ACPOENCHOICE,_LRET")

dbSelectArea("Z03")

if _nOpcao <> 3
	If EOF()
		Help("",1,"ARQVAZIO")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	If Z03_STATUS == "F"
		MsgBox ("Pedido Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
		Return
	Endif
Endif

if _nOpcao == 4 .or. _nOpcao == 5
	dbSelectArea("Z03")
	IF !RECLOCK("Z03",.F.)
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


RegToMemory("Z03",(cOpcao == "INCLUIR"))

nUsado  := 0
aHeader := {}

dbSelectArea("SX3")
dbSeek("Z04")

While !Eof().And.(x3_arquivo=="Z04")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z04_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z04_PEDIDO"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z04_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z04")
	dbSetOrder(2)
	dbSeek(xFilial("Z04")+M->Z03_PEDIDO)
	
	While !eof() .and. Z04->Z04_FILIAL == xFilial("Z04") .And. Z04->Z04_PEDIDO == M->Z03_PEDIDO
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z04_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z03")

cTitulo        := "CADASTRO DE PEDIDOS"
cAliasEnchoice := "Z03"
cAliasGetD     := "Z04"
cLinOk         := 'ExecBlock("Vld01",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z03_PEDIDO"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {"Z03_STATUS","Z03_DTEMB","Z03_DESTIN"}
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_SEQ"    })
_nPosPROD   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_PROD"   })
_nPosDESCP  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_DESCP"  })
_nPosPERFIL := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_PERFIL" })
_nPosTIPO   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_TIPO"   })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_CERT"   })
_nPosEMB    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_EMB"    })
_nPosQUAL   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_QUAL"   })
_nPosSECAGE := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_SECAGE" })
_nPosUMIDAD := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_UMIDAD" })
_nPosCOD    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_COD"    })
_nPosESPECI := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_ESPECI" })
_nPosESPESS := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_ESPESS" })
_nPosLARGUR := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_LARGUR" })
_nPosCMPR1  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_COMPR1" })
_nPosCMPR2  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_COMPR2" })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_PRECO"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_OBS"    })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z04_BAIXA"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_01GRInc()
		Elseif _nOpcao == 4
			U_ST_01GrAlt()
		Elseif _nOpcao == 5
			U_ST_01GrExc()
		Endif
		
		Exit
	Else
		Exit
	Endif
	
EndDo

if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

dbSelectArea("Z03")

Return


/***********************************/
/***********************************/
User Function ST_01GRInc()
/***********************************/
/***********************************/
nNumIt := 0
For nIt := 1 To Len(aCols)
	If !aCols[nIt,_nPosDel]
		dbSelectArea("Z04")
		dbSetOrder(1)
		nNumIt ++
		if RecLock("Z04",.T.)
			Z04->Z04_FILIAL  := xFilial("Z04")
			Z04->Z04_PEDIDO  := M->Z03_PEDIDO
			Z04->Z04_SEQ     := STRZERO(nNUmIT,4)
			Z04->Z04_PROD    := aCols[nIt,_nPosPROD]
			Z04->Z04_DESCP   := aCols[nIt,_nPosDESCP]
			Z04->Z04_PERFIL  := aCols[nIt,_nPosPERFIL]
			Z04->Z04_TIPO    := aCols[nIt,_nPosTIPO]
			Z04->Z04_CERT    := aCols[nIt,_nPosCERT]
			Z04->Z04_EMB     := aCols[nIt,_nPosEMB]
			Z04->Z04_QUAL    := aCols[nIt,_nPosQUAL]
			Z04->Z04_SECAGE  := aCols[nIt,_nPosSECAGE]
			Z04->Z04_UMIDAD  := aCols[nIt,_nPosUMIDAD]
			Z04->Z04_COD     := aCols[nIt,_nPosCOD]
			Z04->Z04_ESPECI  := aCols[nIt,_nPosESPECI]
			Z04->Z04_ESPESS  := aCols[nIt,_nPosESPESS]
			Z04->Z04_LARGUR  := aCols[nIt,_nPosLARGUR]
			Z04->Z04_COMPR1  := aCols[nIt,_nPosCMPR1]
			Z04->Z04_COMPR2  := aCols[nIt,_nPosCMPR2]
			Z04->Z04_VOLUME  := aCols[nIt,_nPosVOLUME]
			Z04->Z04_TPMOED  := aCols[nIt,_nPosTPMOED]
			Z04->Z04_DESCM   := aCols[nIt,_nPosDESCM]
			Z04->Z04_PRECO   := aCols[nIt,_nPosPRECO]
			Z04->Z04_OBS     := aCols[nIt,_nPosOBS]
			Z04->Z04_BAIXA   := aCols[nIt,_nPosBAIXA]
			MsUnLock()
		Endif
	Endif
Next
dbSelectArea("Z03")
if RecLock("Z03",.T.)
	Z03->Z03_FILIAL   := xFilial("Z03")
	Z03->Z03_STATUS   := M->Z03_STATUS
	Z03->Z03_PEDIDO   := M->Z03_PEDIDO
	Z03->Z03_CLIENT   := M->Z03_CLIENT
	Z03->Z03_LOJA     := M->Z03_LOJA
	Z03->Z03_NOME     := M->Z03_NOME
	Z03->Z03_DATA     := M->Z03_DATA
	Z03->Z03_DTEMB    := M->Z03_DTEMB
	Z03->Z03_DESTIN   := M->Z03_DESTIN
	Z03->Z03_TPFRET   := M->Z03_TPFRET
	Z03->Z03_CONTAT   := M->Z03_CONTAT
	MsUnLock()
Endif
dbSelectArea("Z03")
Return


/***********************************/
/***********************************/
User Function ST_01GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z04")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z04")
	dbSetOrder(2)
	if dbseek(xfilial("Z04")+M->Z03_PEDIDO+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z04",.F.)
			If !aCols[nIt,_nPosDel]
				Z04->Z04_PROD    := aCols[nIt,_nPosPROD]
				Z04->Z04_DESCP   := aCols[nIt,_nPosDESCP]
				Z04->Z04_PERFIL  := aCols[nIt,_nPosPERFIL]
				Z04->Z04_TIPO    := aCols[nIt,_nPosTIPO]
				Z04->Z04_CERT    := aCols[nIt,_nPosCERT]
				Z04->Z04_EMB     := aCols[nIt,_nPosEMB]
				Z04->Z04_QUAL    := aCols[nIt,_nPosQUAL]
				Z04->Z04_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z04->Z04_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z04->Z04_COD     := aCols[nIt,_nPosCOD]
				Z04->Z04_ESPECI  := aCols[nIt,_nPosESPECI]
				Z04->Z04_ESPESS  := aCols[nIt,_nPosESPESS]
				Z04->Z04_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z04->Z04_COMPR1  := aCols[nIt,_nPosCMPR1]
				Z04->Z04_COMPR2  := aCols[nIt,_nPosCMPR2]
				Z04->Z04_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z04->Z04_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z04->Z04_DESCM   := aCols[nIt,_nPosDESCM]
				Z04->Z04_PRECO   := aCols[nIt,_nPosPRECO]
				Z04->Z04_OBS     := aCols[nIt,_nPosOBS]
				Z04->Z04_BAIXA   := aCols[nIt,_nPosBAIXA]
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z04",.t.)
				Z04->Z04_FILIAL  := xFilial("Z04")
				Z04->Z04_PEDIDO  := M->Z03_PEDIDO
				Z04->Z04_SEQ     := "9999" 
				Z04->Z04_PROD    := aCols[nIt,_nPosPROD]
				Z04->Z04_DESCP   := aCols[nIt,_nPosDESCP]
				Z04->Z04_PERFIL  := aCols[nIt,_nPosPERFIL]
				Z04->Z04_TIPO    := aCols[nIt,_nPosTIPO]
				Z04->Z04_CERT    := aCols[nIt,_nPosCERT]
				Z04->Z04_EMB     := aCols[nIt,_nPosEMB]
				Z04->Z04_QUAL    := aCols[nIt,_nPosQUAL]
				Z04->Z04_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z04->Z04_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z04->Z04_COD     := aCols[nIt,_nPosCOD]
				Z04->Z04_ESPECI  := aCols[nIt,_nPosESPECI]
				Z04->Z04_ESPESS  := aCols[nIt,_nPosESPESS]
				Z04->Z04_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z04->Z04_COMPR1  := aCols[nIt,_nPosCMPR1]
				Z04->Z04_COMPR2  := aCols[nIt,_nPosCMPR2]
				Z04->Z04_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z04->Z04_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z04->Z04_DESCM   := aCols[nIt,_nPosDESCM]
				Z04->Z04_PRECO   := aCols[nIt,_nPosPRECO]
				Z04->Z04_OBS     := aCols[nIt,_nPosOBS]
				Z04->Z04_BAIXA   := aCols[nIt,_nPosBAIXA]
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z04")
dbSetOrder(1)
if dbseek(xfilial("Z04")+M->Z03_PEDIDO,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z04_PEDIDO == M->Z03_PEDIDO
		_nNumSeq ++
		IF RecLock("Z04",.F.)
			Z04->Z04_SEQ := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z03")
Z03->Z03_STATUS   := M->Z03_STATUS
Z03->Z03_CLIENT   := M->Z03_CLIENT
Z03->Z03_LOJA     := M->Z03_LOJA
Z03->Z03_NOME     := M->Z03_NOME
Z03->Z03_DATA     := M->Z03_DATA
Z03->Z03_DTEMB    := M->Z03_DTEMB
Z03->Z03_DESTIN   := M->Z03_DESTIN
Z03->Z03_TPFRET   := M->Z03_TPFRET
Z03->Z03_CONTAT   := M->Z03_CONTAT
Return


/***********************************/
/***********************************/
User Function ST_01GrExc()
/***********************************/
/***********************************/
dbSelectArea("Z04")
dbSetOrder(1)
if dbSeek(xFilial("Z04")+M->Z03_PEDIDO)
	WHILE Z04_FILIAL == xFilial("Z04") .AND. Z04_PEDIDO=M->Z03_PEDIDO
		If RecLock("Z04",.F.)
			dbDelete()
			MsUnLock()
		Endif
		DBSKIP()
	ENDDO
Endif
dbSelectArea("Z03")
dbDelete()
Return


User Function Vld01()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
SetPrvt("_LRET,ACOLS,nP,VEZ,")
_lRet := .T.
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00


