#include "rwmake.ch"

User Function ST_PKT(_nOpcao)

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
	If Z16_STATUS <> "A" .and. Z16_STATUS <> "E"
		MsgBox ("Packing List de Pacotes nao pode ser Alterado!","ATENCAO","STOP")
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
dbSeek("Z18")

While !Eof().And.(x3_arquivo=="Z18")
	
	If Upper(AllTrim(X3_CAMPO)) = "Z18_FILIAL" .OR. Upper(AllTrim(X3_CAMPO)) = "Z18_CONTR"
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
		aCols[1,_ni] := If(AllTrim(Upper(aHeader[_ni,2]))=="Z18_SEQ",StrZero(_nI,4),CriaVar(aHeader[_ni,2]))
	Next
	
Else
	
	If M->Z16_STATUS="A"
		U_ST_Z18PKT(M->Z16_CONTR) //Cria a lista para Status = "A"
	EndIf
	
	dbSelectArea("Z18")
	dbSetOrder(1)
	dbSeek(xFilial("Z18")+M->Z16_CONTR)
	
	While !eof() .and. Z18->Z18_FILIAL == xFilial("Z18") .And. Z18->Z18_CONTR == M->Z16_CONTR
		
		AADD(aCols,Array(nUsado+1))
		
		For _ni:=1 to nUsado
			
			If Upper(AllTrim(aHeader[_ni,10])) != "V" // Campo Real
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			Else // Campo Virtual
				cCpo := AllTrim(Upper(aHeader[_nI,2]))
				Do Case
					Case cCpo == "Z18_SEQ"
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
	
	_nPosItem := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_SEQ"})
	
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	
	aCols[1,_nPosItem] := "0001"
	aCols[1,nUsado+1]  := .T. // Define como deletado
	
Endif

dbSelectArea("Z16")

cTitulo        := "GERACAO DE PACKING LIST E SELECAO DE PACOTES"
cAliasEnchoice := "Z16"
cAliasGetD     := "Z18"
cLinOk         := 'ExecBlock("Vld09",.F.,.F.)'
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

_nPosITEM   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_LOTE"   })
_nPosPROD   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_PROD"   })
_nPosDESCP  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_DESCP"  })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_LOCAL"  })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_ITPED"  })
_nPosPERFIL := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_PERFIL" })
_nPosTIPO   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_TIPO"   })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_CERT"   })
_nPosEMB    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_EMB"    })
_nPosQUAL   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_QUAL"   })
_nPosSECAGE := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_SECAGE" })
_nPosUMIDAD := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_UMIDAD" })
_nPosCOD    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_COD"    })
_nPosESPECI := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_ESPECI" })
_nPosESPESS := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_ESPESS" })
_nPosLARGUR := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_LARGUR" })
_nPosCOMPR  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_COMPR"  })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_OBS"    })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z18_ACTOT"  })
_nPosDel    := Len(aHeader) +1

n := 1

While .T.
	
	_lRet := Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,,999,aAltEnchoice)
	
	If _lRet
		if  _nOpcao == 3
			U_ST_09GRInc()
		Elseif _nOpcao == 4
			U_ST_09GrAlt()
		Elseif _nOpcao == 5
			U_ST_09GrExc()
		Endif
		
		Exit
	Else
		Exit
	Endif
	
EndDo

if _nOpcao == 4 .or. _nOpcao == 5
	msunlock()
ENdif

dbSelectArea("Z16")

If Z16_STATUS="A"
	
	dbSelectArea("Z18")
	dbSetOrder(2)
	if dbSeek(xFilial("Z18")+Z16->Z16_CONTR)
		WHILE Z18_FILIAL == xFilial("Z18") .AND. Z18_CONTR=Z16->Z16_CONTR
			If RecLock("Z18",.F.)
				dbDelete()
				MsUnLock()
			Endif
			DBSKIP()
		ENDDO
	Endif
	
EndIf

dbSelectArea("Z16")

Return


/***********************************/
/***********************************/
User Function ST_09GRInc()
/***********************************/
/***********************************/
Return


/***********************************/
/***********************************/
User Function ST_09GrAlt()
/***********************************/
/***********************************/
dbSelectArea("Z18")
For nIt := 1 To Len(aCols)
	dbSelectArea("Z18")
	dbSetOrder(1)
	if dbseek(xfilial("Z18")+M->Z16_CONTR+aCols[nIt,_nPosITEM],.F.)
		IF RecLock("Z18",.F.)
			If !aCols[nIt,_nPosDel]
				Z18->Z18_LOTE    := aCols[nIt,_nPosLOTE]
				Z18->Z18_PROD    := aCols[nIt,_nPosPROD]
				Z18->Z18_DESCP   := aCols[nIt,_nPosDESCP]
				Z18->Z18_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z18->Z18_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z18->Z18_ITPED   := aCols[nIt,_nPosITPED]
				Z18->Z18_TIPO    := aCols[nIt,_nPosTIPO]
				Z18->Z18_PERFIL  := aCols[nIt,_nPosPERFIL]
				Z18->Z18_CERT    := aCols[nIt,_nPosCERT]
				Z18->Z18_EMB     := aCols[nIt,_nPosEMB]
				Z18->Z18_QUAL    := aCols[nIt,_nPosQUAL]
				Z18->Z18_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z18->Z18_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z18->Z18_COD     := aCols[nIt,_nPosCOD]
				Z18->Z18_ESPECI  := aCols[nIt,_nPosESPECI]
				Z18->Z18_ESPESS  := aCols[nIt,_nPosESPESS]
				Z18->Z18_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z18->Z18_COMPR   := aCols[nIt,_nPosCOMPR]
				Z18->Z18_PECAS   := aCols[nIt,_nPosPECAS]
				Z18->Z18_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z18->Z18_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z18->Z18_DESCM   := aCols[nIt,_nPosDESCM]
				Z18->Z18_PRECO   := aCols[nIt,_nPosPRECO]
				Z18->Z18_TOTAL   := aCols[nIt,_nPosTOTAL]
			Z18->Z18_ACPEC   := aCols[nIt,_nPosACPEC]
			Z18->Z18_ACVOL   := aCols[nIt,_nPosACVOL]
			Z18->Z18_ACTOT   := aCols[nIt,_nPosACTOT]
				Z18->Z18_OBS     := aCols[nIt,_nPosOBS]
			Else
				delete
			Endif
			MsUnLock()
		Endif
	Else
		If !aCols[nIt,_nPosDel]
			IF RecLock("Z18",.t.)
				Z18->Z18_FILIAL  := xFilial("Z18")
				Z18->Z18_CONTR   := M->Z12_CONTR
				Z18->Z18_SEQ     := "9999"
				Z18->Z18_LOTE    := aCols[nIt,_nPosLOTE]
				Z18->Z18_PROD    := aCols[nIt,_nPosPROD]
				Z18->Z18_DESCP   := aCols[nIt,_nPosDESCP]
				Z18->Z18_LOCAL   := aCols[nIt,_nPosLOCAL]
				Z18->Z18_PEDIDO  := aCols[nIt,_nPosPEDIDO]
				Z18->Z18_ITPED   := aCols[nIt,_nPosITPED]
				Z18->Z18_PERFIL  := aCols[nIt,_nPosPERFIL]
				Z18->Z18_TIPO    := aCols[nIt,_nPosTIPO]
				Z18->Z18_CERT    := aCols[nIt,_nPosCERT]
				Z18->Z18_EMB     := aCols[nIt,_nPosEMB]
				Z18->Z18_QUAL    := aCols[nIt,_nPosQUAL]
				Z18->Z18_SECAGE  := aCols[nIt,_nPosSECAGE]
				Z18->Z18_UMIDAD  := aCols[nIt,_nPosUMIDAD]
				Z18->Z18_COD     := aCols[nIt,_nPosCOD]
				Z18->Z18_ESPECI  := aCols[nIt,_nPosESPECI]
				Z18->Z18_ESPESS  := aCols[nIt,_nPosESPESS]
				Z18->Z18_LARGUR  := aCols[nIt,_nPosLARGUR]
				Z18->Z18_COMPR   := aCols[nIt,_nPosCOMPR]
				Z18->Z18_PECAS   := aCols[nIt,_nPosPECAS]
				Z18->Z18_VOLUME  := aCols[nIt,_nPosVOLUME]
				Z18->Z18_TPMOED  := aCols[nIt,_nPosTPMOED]
				Z18->Z18_DESCM   := aCols[nIt,_nPosDESCM]
				Z18->Z18_PRECO   := aCols[nIt,_nPosPRECO]
				Z18->Z18_TOTAL   := aCols[nIt,_nPosTOTAL]
				Z18->Z18_OBS     := aCols[nIt,_nPosOBS]
			Z18->Z18_ACPEC   := aCols[nIt,_nPosACPEC]
			Z18->Z18_ACVOL   := aCols[nIt,_nPosACVOL]
			Z18->Z18_ACTOT   := aCols[nIt,_nPosACTOT]
				MsUnLock()
			Endif
		Endif
	Endif
Next
dbSelectArea("Z18")
dbSetOrder(2)
if dbseek(xfilial("Z18")+M->Z16_CONTR,.F.)
	_nNumSeq := 0
	Do While ! eof() .and. Z18_CONTR == M->Z16_CONTR
		_nNumSeq ++
		IF RecLock("Z18",.F.)
			Z18->Z18_SEQ := STRZERO(_nNumSeq,4)
			msunlock()
		Endif
		dbskip()
	Enddo
EndIf
dbSelectArea("Z16")
Z16->Z16_STATUS   := "E"
Z16->Z16_DATA     := M->Z16_DATA
Z16->Z16_PEDIDO   := M->Z16_PEDIDO
Z16->Z16_CLIENT   := M->Z16_CLIENT
Z16->Z16_LOJA     := M->Z16_LOJA
Z16->Z16_NOME     := M->Z16_NOME
Z16->Z16_OBSERV   := M->Z16_OBSERV
Return


/***********************************/
/***********************************/
User Function ST_09GrExc()
/***********************************/
/***********************************/
Return


User Function Vld09()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
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


User Function ST_Z18PKT(_cContr)
dbSelectArea("Z17")
dbSetOrder(4)
If dbseek(xfilial("Z17")+_cContr,.T.)
	_nNumSeq := 0
	While !eof() .and. Z17_FILIAL == xFilial("Z17") .And. Z17_CONTR == _cContr
		If Z17_TIPO="S"
			dbSelectArea("Z06")
			dbSetOrder(3)
			If dbseek(xfilial("Z06")+Z17->Z17_LOTE,.F.)
				While !eof() .and. Z06->Z06_FILIAL == xFilial("Z06") .And. Z06->Z06_LOTE == Z17->Z17_LOTE
					IF RecLock("Z18",.t.)
						_nNumSeq ++
						Z18->Z18_FILIAL  := xFilial("Z18")
						Z18->Z18_CONTR   := _cContr
						Z18->Z18_SEQ     := STRZERO(_nNumSeq,4)
						Z18->Z18_TPCT    := Z17->Z17_TIPO
						Z18->Z18_LOTE    := Z06->Z06_LOTE
						Z18->Z18_PROD    := Z06->Z06_PROD
						Z18->Z18_DESCP   := POSICIONE("SB1",1,xFilial("SB1")+Z06->Z06_PROD,"B1_DESC")
						Z18->Z18_LOCAL   := Z06->Z06_LOCAL
						Z18->Z18_PEDIDO  := Z17->Z17_PEDIDO
						Z18->Z18_ITPED   := Z17->Z17_ITPED
						Z18->Z18_PERFIL  := "MAD. SERRADA"
						Z18->Z18_TIPO    := Z06->Z06_TIPO
						Z18->Z18_CERT    := Z06->Z06_CERT
						Z18->Z18_EMB     := Z06->Z06_EMB
						Z18->Z18_QUAL    := Z06->Z06_QUAL
						Z18->Z18_SECAGE  := Z06->Z06_SECAGE
						Z18->Z18_UMIDAD  := Z06->Z06_UMIDAD
						Z18->Z18_COD     := Z06->Z06_COD
						Z18->Z18_ESPECI  := Z06->Z06_ESPECI
						Z18->Z18_ESPESS  := Z06->Z06_ESPESS
						Z18->Z18_LARGUR  := Z06->Z06_LARGUR
						Z18->Z18_COMPR   := Z06->Z06_COMPR
						Z18->Z18_PECAS   := Z06->Z06_PECAS
						Z18->Z18_VOLUME  := Z06->Z06_VOLUME
						Z18->Z18_TPMOED  := Z17->Z17_TPMOED
						Z18->Z18_DESCM   := Z17->Z17_DESCM
						Z18->Z18_PRECO   := Z17->Z17_PRECO
						Z18->Z18_TOTAL   := Z17->Z17_PRECO*Z06->Z06_VOLUME
						Z18->Z18_OBS     := Z17->Z17_OBS
						MsUnLock()
					Endif
					dbSelectArea("Z06")
					dbSkip()
				EndDo
			EndIf
		Else
			dbSelectArea("Z13")
			dbSetOrder(3)
			If dbseek(xfilial("Z13")+Z17->Z17_LOTE,.F.)
				While !eof() .and. Z13->Z13_FILIAL == xFilial("Z13") .And. Z13->Z13_LOTE == Z17->Z17_LOTE
					IF RecLock("Z18",.t.)
						_nNumSeq ++
						Z18->Z18_FILIAL  := xFilial("Z18")
						Z18->Z18_CONTR   := _cContr
						Z18->Z18_SEQ     := STRZERO(_nNumSeq,4)
						Z18->Z18_TPCT    := Z17->Z17_TIPO
						Z18->Z18_LOTE    := Z13->Z13_LOTE
						Z18->Z18_PROD    := Z13->Z13_PROD
						Z18->Z18_DESCP   := POSICIONE("SB1",1,xFilial("SB1")+Z13->Z13_PROD,"B1_DESC")
						Z18->Z18_LOCAL   := Z13->Z13_LOCAL
						Z18->Z18_PEDIDO  := Z17->Z17_PEDIDO
						Z18->Z18_ITPED   := Z17->Z17_ITPED
						Z18->Z18_PERFIL  := Z13->Z13_PERFIL
						Z18->Z18_TIPO    := Z13->Z13_TIPO
						Z18->Z18_CERT    := Z13->Z13_CERT
						Z18->Z18_EMB     := Z13->Z13_EMB
						Z18->Z18_QUAL    := Z13->Z13_QUAL
						Z18->Z18_SECAGE  := Z13->Z13_SECAGE
						Z18->Z18_UMIDAD  := Z13->Z13_UMIDAD
						Z18->Z18_COD     := Z13->Z13_COD
						Z18->Z18_ESPECI  := Z13->Z13_ESPECI
						Z18->Z18_ESPESS  := Z13->Z13_ESPESS
						Z18->Z18_LARGUR  := Z13->Z13_LARGUR
						Z18->Z18_COMPR   := Z13->Z13_COMPR
						Z18->Z18_PECAS   := Z13->Z13_PECAS
						Z18->Z18_VOLUME  := Z13->Z13_VOLUME
						Z18->Z18_TPMOED  := Z17->Z17_TPMOED
						Z18->Z18_DESCM   := Z17->Z17_DESCM
						Z18->Z18_PRECO   := Z17->Z17_PRECO
						Z18->Z18_TOTAL   := Z17->Z17_PRECO*Z13->Z13_VOLUME
						Z18->Z18_OBS     := Z13->Z13_OBS
						MsUnLock()
					Endif
					dbSelectArea("Z13")
					dbSkip()
				EndDo
			EndIf
		Endif
		dbSelectArea("Z17")
		dbSkip()
	EndDo
EndIf
Return

