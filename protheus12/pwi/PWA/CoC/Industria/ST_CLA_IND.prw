#include "rwmake.ch"

User Function ST_CLA_IND(_Contr)

dbSelectArea("Z13")
dbSetOrder(4)
dbSeek(xFilial("Z13")+_Contr)
_Seq:=0
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
do While !EOF() .AND. Z13_FILIAL=xFilial("Z13") .AND. Z13_CONTR=_Contr
	IF _Produto<>Z13_PROD .OR. _Local<>Z13_LOCAL
		_Seq:=_Seq+1
		dbSelectArea("Z35")
		If RecLock("Z35",.T.)
			REPLACE Z35_FILIAL WITH xFilial("Z35")
			REPLACE Z35_CONTR WITH _Contr
			REPLACE Z35_SEQ WITH STRZERO(_Seq,3)
			REPLACE Z35_PROD WITH _Produto
			REPLACE Z35_DESCP WITH POSICIONE("SB1",1,xFilial("SB1")+_Produto,"B1_DESC")
			REPLACE Z35_LOCAL WITH _Local
			REPLACE Z35_ITENS WITH _Item
			REPLACE Z35_PECAS WITH _Quant
			REPLACE Z35_VOLUME WITH _Volume
			REPLACE Z35_TOTAL WITH _Vltotal
			MsUnLock("Z35")
		End If
		_Item:=0
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
	_Item:=_Item+1
	_Volume:=_Volume+Z13_VOLUME
	_Vltotal:=_Vltotal+Z13_TOTAL
	_Quant:=_Quant+Z13_PECAS
	dbskip()
enddo
IF _Quant>0
	_Seq:=_Seq+1
	dbSelectArea("Z35")
	If RecLock("Z35",.T.)
		REPLACE Z35_FILIAL WITH xFilial("Z35")
		REPLACE Z35_CONTR WITH _Contr
		REPLACE Z35_SEQ WITH STRZERO(_Seq,3)
		REPLACE Z35_PROD WITH _Produto
		REPLACE Z35_DESCP WITH POSICIONE("SB1",1,xFilial("SB1")+_Produto,"B1_DESC")
		REPLACE Z35_LOCAL WITH _Local
		REPLACE Z35_ITENS WITH _Item
		REPLACE Z35_PECAS WITH _Quant
		REPLACE Z35_VOLUME WITH _Volume
		REPLACE Z35_TOTAL WITH _Vltotal
		MsUnLock("Z35")
	End If
ENDIF

U_ST_DIND(4)

dbSelectArea("Z12")

Return


User Function ST_DIND(_nOpcao)

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
	//	If Z05_STATUS == "F"
	//		MsgBox ("Romaneio Fechado/Encerrado, e nao pode ser Alterado","ATENCAO","STOP")
	//		Return
	//	Endif
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
dbSeek("Z35")

While !Eof().And.(x3_arquivo=="Z35")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z35_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z35_CONTR"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z35_SEQ",StrZero(_nI,3),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	dbSelectArea("Z35")
	dbSetOrder(1)
	dbSeek(xFilial("Z35")+M->Z12_CONTR)
	
	While !eof() .and. Z35->Z35_FILIAL == xFilial("Z35") .And. Z35->Z35_CONTR == M->Z12_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z35_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z12")

cTitulo        := "RELACIONAMENTO NF X ROMANEIO - CLASSIFICACAO PRODUTOS"
cAliasEnchoice := "Z12"
cAliasGetD     := "Z35"
cLinOk         := 'ExecBlock("Vld16",.F.,.F.)'
cTudOk         := "AllwaysTrue()"
cFieldOk       := "AllwaysTrue()"
aCpoEnchoice   := {"Z12_CONTR"}

if _nOpcao == 2
	aAltEnchoice   := {}
Elseif _nOpcao == 3
	aAltEnchoice   := NIL
Elseif _nOpcao == 4
	aAltEnchoice   := {}
Else
	aAltEnchoice   := {}
Endif

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_SEQ"    })
_nPosPROD   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_PROD"   })
_nPosDESCP  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_DESCP"  })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_LOCAL"  })
_nPosITENS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_ITENS"  })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_VOLUME" })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_TOTAL"  })
_nPosPRODNF := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_PRODNF" })
_nPosDESCNF := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_DESCNF" })
_nPosITNF   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_ITNF"   })
_nPosLOCNF  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z35_LOCNF"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			//			U_ST_16GRInc()
		Elseif _nOpcao == 4
			
			U_ST_16GrAlt()
			
			dbSelectArea("Z12")
			If RecLock("Z12",.F.)
				REPLACE Z12_STATUS WITH "F"
				MsUnLock("Z12")
			End If
			MSGBOX("Classificacao gerada com sucesso!!!")
		Elseif _nOpcao == 5
			//			U_ST_02GrExc()
		Endif
		
		Exit
	Else
		
		dbSelectArea("Z35")
		dbSetOrder(1)
		if dbSeek(xFilial("Z35")+M->Z12_CONTR)
			WHILE Z35_FILIAL == xFilial("Z35") .AND. Z35_CONTR=M->Z12_CONTR
				If RecLock("Z35",.F.)
					dbDelete()
					MsUnLock()
				Endif
				DBSKIP()
			ENDDO
		Endif
		dbSelectArea("Z12")
		
		Exit
	Endif
	
EndDo

if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

dbSelectArea("Z12")

Return


User Function Vld16()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
SetPrvt("_LRET,ACOLS,nP,VEZ,")
_lRet := .T.
If aCols[n,_nPosDel]
	Alert("Nao permitido exclusao de itens a ser classificados!!!")
	_lRet := .F.
EndIf
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00


/***********************************/
/***********************************/
User Function ST_16GrAlt()
/***********************************/
/***********************************/
For nIt := 1 To Len(aCols)
	dbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+aCols[nIt,_nPosPRODNF])
	
	dbSelectArea("SX6")
	DbSetOrder(1)
	DbSeek("  "+"MV_DOCSEQ")
	
	dbSelectArea("SD3")
	If RecLock("SD3",.T.)
		Replace D3_FILIAL With xFILIAL("SD3")
		Replace D3_TM With "999"
		Replace D3_COD With aCols[nIt,_nPosPRODNF]
		Replace D3_UM With SB1->B1_UM
		Replace D3_CF With "RE4"
		Replace D3_QUANT With IIF(MV_PAR02=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR02=2,1,aCols[nIt,_nPosPECAS]))
		Replace D3_LOCAL With aCols[nIt,_nPosLOCNF]
		Replace D3_DOC With GETMV("MV_DOCSEQ")
		Replace D3_GRUPO With SB1->B1_GRUPO
		Replace D3_EMISSAO With M->Z12_DATA
		Replace D3_CUSTO1 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO2 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO3 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO4 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO5 With aCols[nIt,_nPosTOTAL]
		Replace D3_SEGUM With SB1->B1_SEGUM
		Replace D3_QTSEGUM With IIF(MV_PAR03=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR03=2,1,aCols[nIt,_nPosPECAS]))
		Replace D3_TIPO With SB1->B1_TIPO
		Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
		Replace D3_CHAVE WITH "E0"
		MsUnLock()
	EndIf
	
	dbSelectArea("SB2")
	DbSetOrder(1)
	DbSeek(xFilial("SB2")+aCols[nIt,_nPosPRODNF]+aCols[nIt,_nPosLOCNF])
	If Found()
		If RecLock("SB2",.F.)
			REPLACE B2_QATU WITH B2_QATU-IIF(MV_PAR02=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR02=2,1,aCols[nIt,_nPosPECAS]))
			REPLACE B2_QTSEGUM WITH B2_QTSEGUM-IIF(MV_PAR03=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR03=2,1,aCols[nIt,_nPosPECAS]))
			REPLACE B2_VATU1 WITH B2_VATU1-(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU2 WITH B2_VATU2-(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU3 WITH B2_VATU3-(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU4 WITH B2_VATU4-(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU5 WITH B2_VATU5-(aCols[nIt,_nPosTOTAL])
			MsUnLock("SB2")
		EndIf
	EndIf
	
	dbSelectArea("SB1")
	DbSetOrder(1)
	DbSeek(xFilial("SB1")+aCols[nIt,_nPosPRODNF])
	
	If RecLock("SD3",.T.)
		Replace D3_FILIAL With xFILIAL("SD3")
		Replace D3_TM With "499"
		Replace D3_COD With aCols[nIt,_nPosPROD]
		Replace D3_UM With SB1->B1_UM
		Replace D3_CF With "DE4"
		Replace D3_QUANT With IIF(MV_PAR02=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR02=2,1,aCols[nIt,_nPosPECAS]))
		Replace D3_LOCAL With aCols[nIt,_nPosLOCAL]
		Replace D3_DOC With GETMV("MV_DOCSEQ")
		Replace D3_GRUPO With SB1->B1_GRUPO
		Replace D3_EMISSAO With M->Z12_DATA
		Replace D3_CUSTO1 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO2 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO3 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO4 With aCols[nIt,_nPosTOTAL]
		Replace D3_CUSTO5 With aCols[nIt,_nPosTOTAL]
		Replace D3_SEGUM With SB1->B1_SEGUM
		Replace D3_QTSEGUM With IIF(MV_PAR03=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR03=2,1,aCols[nIt,_nPosVOLUME]))
		Replace D3_TIPO With SB1->B1_TIPO
		Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
		Replace D3_CHAVE WITH "E9"
		MsUnLock()
	EndIf
	dbSelectArea("SB2")
	DbSetOrder(1)
	DbSeek(xFilial("SB2")+aCols[nIt,_nPosPROD]+aCols[nIt,_nPosLOCAL])
	If Found()
		If RecLock("SB2",.F.)
			REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR02=2,1,aCols[nIt,_nPosPECAS]))
			REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR03=2,1,aCols[nIt,_nPosPECAS]))
			REPLACE B2_VATU1 WITH B2_VATU1+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU2 WITH B2_VATU2+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU3 WITH B2_VATU3+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU4 WITH B2_VATU4+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU5 WITH B2_VATU5+(aCols[nIt,_nPosTOTAL])
			MsUnLock("SB2")
		EndIf
	Else
		If RecLock("SB2",.T.)
			Replace B2_FILIAL WITH xFilial("SB2")
			Replace B2_COD WITH aCols[nIt,_nPosPROD]
			Replace B2_LOCAL WITH aCols[nIt,_nPosLOCAL]
			REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR02=2,1,aCols[nIt,_nPosPECAS]))
			REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,aCols[nIt,_nPosVOLUME],IIF(MV_PAR03=2,1,aCols[nIt,_nPosPECAS]))
			REPLACE B2_VATU1 WITH B2_VATU1+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU2 WITH B2_VATU2+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU3 WITH B2_VATU3+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU4 WITH B2_VATU4+(aCols[nIt,_nPosTOTAL])
			REPLACE B2_VATU5 WITH B2_VATU5+(aCols[nIt,_nPosTOTAL])
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
	
Next
Return

