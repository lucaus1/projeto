#INCLUDE "rwmake.ch"

User Function ST_CTR_IND()

Private cCadastro := "Controle de Pacotes - INDUSTRIA"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
                    {"Visualizar","AxVisual",0,2} ,;
					{"Alterar",'ExecBlock("ST_IND_CON",.F.,.F.)',0,4} ,;
					{"Transferir...",'U_ST_TRF_IM(4)',0,4} ,;
					{"Legenda",'U_ST_LG07()' , 0, 1}}

//					{"Relatorio",'ExecBlock("RelPctSer",.F.,.F.)',0,4} ,;
//					{"Excluir","AxVisual",0,4} ,;


Private aCampos := { {"ROMANEIO","Z13_CONTR","@!"} ,;
					{"ITEM","Z13_SEQ","@!"},;
					{"LOTE","Z13_LOTE","@!"},;
					{"PRODUTO","Z13_PROD","@!"},;
					{"DESCRICAO","Z13_DESCP","@!"},;
					{"PEDIDO","Z13_PEDIDO","@!"},;
					{"IT.PED","Z13_ITPED","@!"},;
					{"PERFIL","Z13_PERFIL","@!"},;
					{"TIPO","Z13_TIPO","@!"},;
					{"CERT.","Z13_CERT","@!"},;
					{"EMBALADA","Z13_EMB","@!"},;
					{"QUAL.","Z13_QUAL","@!"},;
					{"SECAGEM","Z13_SECAGE","@!"},;
					{"UMIDADE","Z13_UMIDAD","@!"},;
					{"COD.ESP.","Z13_COD","@!"},;
					{"ESPECIE","Z13_ESPECI","@!"},;
					{"ESPESSURA","Z13_ESPESS","@!"},;
					{"LARGURA","Z13_LARGUR","@!"},;
					{"COMPRIMENTO","Z13_COMPR","@!"},;
					{"PECAS","Z13_PECAS","@!"},;
					{"VOLUME","Z13_VOLUME","@!"},;
					{"TP.MOEDA","Z13_TPMOED","@!"},;
					{"PRECO","Z13_PRECO","@!"},;
					{"TOTAL","Z13_TOTAL","@!"},;
					{"OBS","Z13_OBS","@!"},;
					{"BAIXA","Z13_BAIXA","@!"}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "Z13"
dbSelectArea("Z13")
dbSetOrder(1)

dbSelectArea(cString)
aCores := { { 'Z13_BAIXA == "LB"','BR_AMARELO'},;                           // Amarelo - a Ser Liberado
		    { 'Z13_BAIXA == "ES" .AND. Z13_SECAGE == "A"','BR_VERDE'},;     // Verde - Estoque AD
		    { 'Z13_BAIXA == "ES" .AND. Z13_SECAGE == "K"','BR_AZUL'},;      // Azul - Estoque KD
		    { 'Z13_BAIXA == "BX"','BR_VERMELHO'}}                           // Vermelho - Baixado

mBrowse( 6,1,22,75,cString,,"Z13_BAIXA",,,,aCores)

Return


User Function ST_LG07()
BRWLEGENDA(cCadastro,"Legenda - Controle de Pacotes",;
{{"BR_VERMELHO","Pacote ja Baixado/Consumida"},;
{"BR_AMARELO","Pacote Necessita Liberacao"},;
{"BR_VERDE","Pacote em Estoque - AD"},;
{"BR_AZUL","Pacote em Estoque - Secagem KD" }})
Return
                                           

User Function ST_IND_CON()
SetPrvt("NOPCA,CCOD,AAC,CSAVCUR5,CSAVSCR5,CSAVROW5")
SetPrvt("CSAVCOL5,CSAVCOR5,LNIVEL,NUSADO,ACAMPOS,CALIAS")
SetPrvt("NREG,NOPC,")
nOpcA := { "Abandona","Confirma" }
cCod := { "Abandona","Confirma" }
aAC := { "Abandona","Confirma" }
while .T.
	nOpcA:=0
	lNivel := 0
	nUsado  := 0
	aCampos := {"Z13_CONTR"}
	aCampAl := {"Z13_PEDIDO","Z13_ITPED","Z13_PERFIL","Z13_TIPO","Z13_CERT","Z13_EMB","Z13_UMIDAD","Z13_TPMOED","Z13_PRECO","Z13_TOTAL","Z13_OBS"}
	cAlias := Alias()
	nReg   := Recno()
	nOpc   := 4
	DBSELECTAREA("Z13")
	nOpcA:=AxAltera("Z13", nReg, nOpc, aCampos, aCampAl)
	dbSelectArea(cAlias)
	Exit
EndDo
dbSelectArea(cAlias)
Return NIL



User Function ST_Trf_IM(nOpcx)

cAlias	:= ALIAS()

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("Z37")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "Z37")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND. X3_CAMPO<>"Z37_FILIAL" .AND. X3_CAMPO<>"Z37_DATA"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo),x3_campo,x3_picture,x3_tamanho,x3_decimal,X3_VALID,x3_usado,x3_tipo, x3_arquivo, x3_context })
	Endif
	dbSkip()
End

aCols:={}

_Data:=date()
_mTotal := 0

/*
dbSelectArea("Z37")
dbSetOrder(1)
dbSeek(xFilial("Z37"),.F.)
While !eof() .AND. xFilial("Z37")=Z37_FILIAL
	
	_mTotal ++
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		If Upper(AllTrim(aHeader[_ni,10])) != "V"                        // Campo Real
			aCols[len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Else                                                             // Campo Virtual
			cCpo := AllTrim(Upper(aHeader[_nI,2]))
			Do Case
				Case cCpo == "Z37_FILIAL"
				OtherWise
					aCols[len(aCols),_ni] := CriaVar(aHeader[_ni,4])
			EndCase
		Endif
	Next
	aCols[len(aCols),nUsado+1]:=.F.
	dbSkip()
End
*/

_nPosSEQ    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_LOTE"   })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_ITPED"  })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_CERT"   })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_LOCAL"  })
_nPosLOCDST := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_LOCDST" })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_OBS"    })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_BAIXA"  })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z37_ACTOT"  })
_nPosDel     := Len(aHeader)+1

If Len(aCols)<=0
	AADD(aCols,Array(nUsado+1))
	For _ni:=1 to nUsado
		aCols[1,_ni] := CriaVar(aHeader[_ni,2])
	Next _ni
	aCols[1,_nPosSEQ] := "0001"
	aCols[1,nUsado+1]  := .F. // Define como deletado
Endif

cTitulo:="Transferencia de Armazem por Lotes..."

aC:={}
AADD(aC,{"_Data" ,{15,10}  ,"Data para Transf.:" ,,,,.T.})

aR:={}
AADD(aR,{"_mTotal" ,{118,10}  ,"Total de Lotes Informados:" ,"@E 9,999,999",,,.F.})

aCGD:={40,5,110,315}

cLinhaOk := 'ExecBlock("Vld18",.F.,.F.)'
cTudoOk  := "AllwaysTrue()"

_lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk)

IF _lRet
	If nOpcx==3
		
	ElseIf nOpcx==4
		U_ST_GrvITR()
	ElseIf nOpcx==5
		
	EndIf
EndIf

dbSelectArea(cAlias)
Return


User Function ST_GrvITR()
For _cont := 1 To Len(aCols)
	dbSelectArea("Z37")
	dbSetOrder(1)
	If !aCols[_cont,_nPosDel]
		IF RecLock("Z37",.T.)
			Z37_FILIAL  := xFilial("Z37")
			Z37_DATA    := _Data
			Z37_SEQ     := aCols[_cont,_nPosSEQ]
			Z37_LOTE    := aCols[_cont,_nPosLOTE]
			Z37_PEDIDO  := aCols[_cont,_nPosPEDIDO]
			Z37_ITPED   := aCols[_cont,_nPosITPED]
			Z37_CERT    := aCols[_cont,_nPosCERT]
			Z37_LOCAL   := aCols[_cont,_nPosLOCAL]
			Z37_LOCDST  := aCols[_cont,_nPosLOCDST]
			Z37_PECAS   := aCols[_cont,_nPosPECAS]
			Z37_VOLUME  := aCols[_cont,_nPosVOLUME]
			Z37_TPMOED  := aCols[_cont,_nPosTPMOED]
			Z37_DESCM   := aCols[_cont,_nPosDESCM]
			Z37_PRECO   := aCols[_cont,_nPosPRECO]
			Z37_TOTAL   := aCols[_cont,_nPosTOTAL]
			Z37_OBS     := aCols[_cont,_nPosOBS]
			Z37_BAIXA   := aCols[_cont,_nPosBAIXA]
			Z37_ACPEC   := aCols[_cont,_nPosACPEC]
			Z37_ACVOL   := aCols[_cont,_nPosACVOL]
			Z37_ACTOT   := aCols[_cont,_nPosACTOT]
			MsUnLock()
		Endif
		
		dbSelectArea("Z13")
		dbSetOrder(3)
		DbSeek(xFilial("Z13")+Z37->Z37_LOTE)
		While !eof() .AND. xFilial("Z13")=Z13_FILIAL .AND. Z13_LOTE==Z37->Z37_LOTE
			
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Z13->Z13_PROD)
			
			dbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  "+"MV_DOCSEQ")
			
			dbSelectArea("SD3")
			If RecLock("SD3",.T.)
				Replace D3_FILIAL With xFILIAL("SD3")
				Replace D3_TM With "999"
				Replace D3_COD With Z13->Z13_PROD
				Replace D3_UM With SB1->B1_UM
				Replace D3_CF With "RE4"
				Replace D3_QUANT With Z13->Z13_VOLUME
				Replace D3_LOCAL With Z13->Z13_LOCAL
				Replace D3_DOC With GETMV("MV_DOCSEQ")
				Replace D3_GRUPO With SB1->B1_GRUPO
				Replace D3_EMISSAO With _DATA
				Replace D3_CUSTO1 With Z13->Z13_TOTAL
				Replace D3_CUSTO2 With Z13->Z13_TOTAL
				Replace D3_CUSTO3 With Z13->Z13_TOTAL
				Replace D3_CUSTO4 With Z13->Z13_TOTAL
				Replace D3_CUSTO5 With Z13->Z13_TOTAL
				Replace D3_SEGUM With SB1->B1_SEGUM
				Replace D3_QTSEGUM With Z13->Z13_PECAS
				Replace D3_TIPO With SB1->B1_TIPO
				Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
				Replace D3_CHAVE WITH "E0"
				MsUnLock()
			EndIf
			
			dbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+Z13->Z13_PROD+Z13->Z13_LOCAL)
			If Found()
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU-Z13->Z13_VOLUME
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM-Z13->Z13_PECAS
					REPLACE B2_VATU1 WITH B2_VATU1-Z13->Z13_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU2-Z13->Z13_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU3-Z13->Z13_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU4-Z13->Z13_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU5-Z13->Z13_TOTAL
					MsUnLock("SB2")
				EndIf
			EndIf
			
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Z13->Z13_PROD)
			
			If RecLock("SD3",.T.)
				Replace D3_FILIAL With xFILIAL("SD3")
				Replace D3_TM With "499"
				Replace D3_COD With Z13->Z13_PROD
				Replace D3_UM With SB1->B1_UM
				Replace D3_CF With "DE4"
				Replace D3_QUANT With Z13->Z13_VOLUME
				Replace D3_LOCAL With aCols[_cont,_nPosLOCDST]
				Replace D3_DOC With GETMV("MV_DOCSEQ")
				Replace D3_GRUPO With SB1->B1_GRUPO
				Replace D3_EMISSAO With _DATA
				Replace D3_CUSTO1 With Z13->Z13_TOTAL
				Replace D3_CUSTO2 With Z13->Z13_TOTAL
				Replace D3_CUSTO3 With Z13->Z13_TOTAL
				Replace D3_CUSTO4 With Z13->Z13_TOTAL
				Replace D3_CUSTO5 With Z13->Z13_TOTAL
				Replace D3_SEGUM With SB1->B1_SEGUM
				Replace D3_QTSEGUM With Z13->Z13_PECAS
				Replace D3_TIPO With SB1->B1_TIPO
				Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
				Replace D3_CHAVE WITH "E9"
				MsUnLock()
			EndIf
			dbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+Z13->Z13_PROD+aCols[_cont,_nPosLOCDST])
			If Found()
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU+Z13->Z13_VOLUME
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+Z13->Z13_PECAS
					REPLACE B2_VATU1 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU2+Z13->Z13_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU3+Z13->Z13_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU4+Z13->Z13_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU5+Z13->Z13_TOTAL
					MsUnLock("SB2")
				EndIf
			Else
				If RecLock("SB2",.T.)
					Replace B2_FILIAL WITH xFilial("SB2")
					Replace B2_COD WITH Z13->Z13_PROD
					Replace B2_LOCAL WITH aCols[_cont,_nPosLOCDST]
					REPLACE B2_QATU WITH B2_QATU+Z13->Z13_VOLUME
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+Z13->Z13_PECAS
					REPLACE B2_VATU1 WITH B2_VATU1+Z13->Z13_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU2+Z13->Z13_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU3+Z13->Z13_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU4+Z13->Z13_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU5+Z13->Z13_TOTAL
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
			
			dbSelectArea("Z13")
			If RecLock("Z13",.F.)
				REPLACE Z13_LOCAL  WITH aCols[_cont,_nPosLOCDST]
				MsUnLock("Z13")
			EndIf
			dbskip()
		enddo
	Endif
Next
ALERT("Transferencias realizadas com sucesso!!!")
Return


User Function Vld18()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
SetPrvt("_LRET,ACOLS,nP,VEZ,")
nAcPec := 0
nAcVol := 0
nAcTot := 0
_mTotal := 0
For nIt := 1 To Len(aCols)
	_mTotal := _mTotal + IIf(!aCols[nIt,_nPosDel],1,0)
	nAcPEC := nAcPEC + IIf(!aCols[nIt,_nPosDel],ACOLS[nIt,_nPosPECAS],0)
	ACOLS[nIt,_nPosACPEC]:=nAcPEC
	nAcVOL := nAcVOL + IIf(!aCols[nIt,_nPosDel],ACOLS[nIt,_nPosVOLUME],0)
	ACOLS[nIt,_nPosACVOL]:=nAcVOL
	nAcTOT := nAcTOT + IIf(!aCols[nIt,_nPosDel],ACOLS[nIt,_nPosTOTAL],0)
	ACOLS[nIt,_nPosACTOT]:=nAcTOT
Next
_lRet := .T.
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
