#INCLUDE "rwmake.ch"

User Function ST_CTR_SER()

Private cCadastro := "Controle de Pacotes - SERRARIA"
Private aRotina := { {"Pesquisar","AxPesqui",0,1} ,;
{"Visualizar","AxVisual",0,2} ,;
{"Alterar",'ExecBlock("ST_SER_CON",.F.,.F.)',0,4} ,;
{"Transferir...",'U_ST_TRF_MS(4)',0,4} ,;
{"Relatorio",'ExecBlock("ST_REL_SER",.F.,.F.)',0,4} ,;
{"Legenda",'U_ST_LG03()' , 0, 1}}

//					{"Excluir","AxVisual",0,4} ,;


Private aCampos := { {"ROMANEIO","Z06_CONTR","@!"} ,;
{"ITEM","Z06_SEQ","@!"},;
{"LOTE","Z06_LOTE","@!"},;
{"PRODUTO","Z06_PROD","@!"},;
{"DESCRICAO","Z06_DESCP","@!"},;
{"PEDIDO","Z06_PEDIDO","@!"},;
{"IT.PED","Z06_ITPED","@!"},;
{"TIPO","Z06_TIPO","@!"},;
{"CERT.","Z06_CERT","@!"},;
{"EMBALADA","Z06_EMB","@!"},;
{"QUAL.","Z06_QUAL","@!"},;
{"SECAGEM","Z06_SECAGE","@!"},;
{"UMIDADE","Z06_UMIDAD","@!"},;
{"COD.ESP.","Z06_COD","@!"},;
{"ESPECIE","Z06_ESPECI","@!"},;
{"ESPESSURA","Z06_ESPESS","@!"},;
{"LARGURA","Z06_LARGUR","@!"},;
{"COMPRIMENTO","Z06_COMPR","@!"},;
{"PECAS","Z06_PECAS","@!"},;
{"VOLUME","Z06_VOLUME","@!"},;
{"TP.MOEDA","Z06_TPMOED","@!"},;
{"PRECO","Z06_PRECO","@!"},;
{"TOTAL","Z06_TOTAL","@!"},;
{"OBS","Z06_OBS","@!"},;
{"BAIXA","Z06_BAIXA","@!"}}

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
Private cString := "Z06"
dbSelectArea("Z06")
dbSetOrder(1)

dbSelectArea(cString)
aCores := { { 'Z06_BAIXA == "LB"','BR_AMARELO'},;                           // Amarelo - a Ser Liberado
{ 'Z06_BAIXA == "ES" .AND. Z06_SECAGE == "A"','BR_VERDE'},;     // Verde - Estoque AD
{ 'Z06_BAIXA == "ES" .AND. Z06_SECAGE == "K"','BR_AZUL'},;      // Azul - Estoque KD
{ 'Z06_BAIXA == "EF"','BR_LARANJA'},;                           // Laranja - Processo de Estufagem
{ 'Z06_BAIXA == "BX"','BR_VERMELHO'}}                           // Vermelho - Baixado

mBrowse( 6,1,22,75,cString,,"Z06_BAIXA",,,,aCores)

Return


User Function ST_LG03()
BRWLEGENDA(cCadastro,"Legenda - Controle de Pacotes",;
{{"BR_VERMELHO","Pacote ja Baixado/Consumida"},;
{"BR_AMARELO","Pacote Necessita Liberacao"},;
{"BR_LARANJA","Pacote na Estufa"},;
{"BR_VERDE","Pacote em Estoque - AD"},;
{"BR_AZUL","Pacote em Estoque - Secagem KD" }})
Return


User Function ST_SER_CON()
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
	aCampos := {"Z06_CONTR"}
	aCampAl := {"Z06_PEDIDO","Z06_ITPED","Z06_TIPO","Z06_CERT","Z06_EMB","Z06_UMIDAD","Z06_TPMOED","Z06_PRECO","Z06_TOTAL","Z06_OBS"}
	cAlias := Alias()
	nReg   := Recno()
	nOpc   := 4
	DBSELECTAREA("Z06")
	nOpcA:=AxAltera("Z06", nReg, nOpc, aCampos, aCampAl)
	dbSelectArea(cAlias)
	Exit
EndDo
dbSelectArea(cAlias)
Return NIL



User Function ST_Trf_MS(nOpcx)

cAlias	:= ALIAS()

dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("Z36")
nUsado:=0
aHeader:={}
While !Eof() .And. (x3_arquivo == "Z36")
	IF X3USO(x3_usado) .AND. cNivel >= x3_nivel .AND. X3_CAMPO<>"Z36_FILIAL" .AND. X3_CAMPO<>"Z36_DATA"
		nUsado:=nUsado+1
		AADD(aHeader,{ TRIM(x3_titulo),x3_campo,x3_picture,x3_tamanho,x3_decimal,X3_VALID,x3_usado,x3_tipo, x3_arquivo, x3_context })
	Endif
	dbSkip()
End

aCols:={}

_Data:=date()
_mTotal := 0

/*
dbSelectArea("Z36")
dbSetOrder(1)
dbSeek(xFilial("Z36"),.F.)
While !eof() .AND. xFilial("Z36")=Z36_FILIAL
	
	_mTotal ++
	AADD(aCols,Array(nUsado+1))
	
	For _ni:=1 to nUsado
		If Upper(AllTrim(aHeader[_ni,10])) != "V"                        // Campo Real
			aCols[len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Else                                                             // Campo Virtual
			cCpo := AllTrim(Upper(aHeader[_nI,2]))
			Do Case
				Case cCpo == "Z36_FILIAL"
				OtherWise
					aCols[len(aCols),_ni] := CriaVar(aHeader[_ni,4])
			EndCase
		Endif
	Next
	aCols[len(aCols),nUsado+1]:=.F.
	dbSkip()
End
*/

_nPosSEQ    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_SEQ"    })
_nPosLOTE   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_LOTE"   })
_nPosPEDIDO := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_PEDIDO" })
_nPosITPED  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_ITPED"  })
_nPosCERT   := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_CERT"   })
_nPosLOCAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_LOCAL"  })
_nPosLOCDST := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_LOCDST" })
_nPosPECAS  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_PECAS"  })
_nPosVOLUME := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_VOLUME" })
_nPosTPMOED := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_TPMOED" })
_nPosDESCM  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_DESCM"  })
_nPosPRECO  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_PRECO"  })
_nPosTOTAL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_TOTAL"  })
_nPosOBS    := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_OBS"    })
_nPosBAIXA  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_BAIXA"  })
_nPosACPEC  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_ACPEC"  })
_nPosACVOL  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_ACVOL"  })
_nPosACTOT  := aScan(aHeader,{|x| AllTrim(Upper(x[2]))=="Z36_ACTOT"  })
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

cLinhaOk := 'ExecBlock("Vld17",.F.,.F.)'
cTudoOk  := "AllwaysTrue()"

_lRet:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk)

IF _lRet
	If nOpcx==3
		
	ElseIf nOpcx==4
		U_ST_GrvTR()
	ElseIf nOpcx==5
		
	EndIf
EndIf

dbSelectArea(cAlias)
Return



User Function ST_GrvTR()
For _cont := 1 To Len(aCols)
	dbSelectArea("Z36")
	dbSetOrder(1)
	If !aCols[_cont,_nPosDel]
		IF RecLock("Z36",.T.)
			Z36_FILIAL  := xFilial("Z36")
			Z36_DATA    := _Data
			Z36_SEQ     := aCols[_cont,_nPosSEQ]
			Z36_LOTE    := aCols[_cont,_nPosLOTE]
			Z36_PEDIDO  := aCols[_cont,_nPosPEDIDO]
			Z36_ITPED   := aCols[_cont,_nPosITPED]
			Z36_CERT    := aCols[_cont,_nPosCERT]
			Z36_LOCAL   := aCols[_cont,_nPosLOCAL]
			Z36_LOCDST  := aCols[_cont,_nPosLOCDST]
			Z36_PECAS   := aCols[_cont,_nPosPECAS]
			Z36_VOLUME  := aCols[_cont,_nPosVOLUME]
			Z36_TPMOED  := aCols[_cont,_nPosTPMOED]
			Z36_DESCM   := aCols[_cont,_nPosDESCM]
			Z36_PRECO   := aCols[_cont,_nPosPRECO]
			Z36_TOTAL   := aCols[_cont,_nPosTOTAL]
			Z36_OBS     := aCols[_cont,_nPosOBS]
			Z36_BAIXA   := aCols[_cont,_nPosBAIXA]
			Z36_ACPEC   := aCols[_cont,_nPosACPEC]
			Z36_ACVOL   := aCols[_cont,_nPosACVOL]
			Z36_ACTOT   := aCols[_cont,_nPosACTOT]
			MsUnLock()
		Endif
		
		dbSelectArea("Z06")
		dbSetOrder(3)
		DbSeek(xFilial("Z06")+Z36->Z36_LOTE)
		While !eof() .AND. xFilial("Z06")=Z06_FILIAL .AND. Z06_LOTE==Z36->Z36_LOTE
			
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Z06->Z06_PROD)
			
			dbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  "+"MV_DOCSEQ")
			
			dbSelectArea("SD3")
			If RecLock("SD3",.T.)
				Replace D3_FILIAL With xFILIAL("SD3")
				Replace D3_TM With "999"
				Replace D3_COD With Z06->Z06_PROD
				Replace D3_UM With SB1->B1_UM
				Replace D3_CF With "RE4"
				Replace D3_QUANT With Z06->Z06_VOLUME
				Replace D3_LOCAL With Z06->Z06_LOCAL
				Replace D3_DOC With GETMV("MV_DOCSEQ")
				Replace D3_GRUPO With SB1->B1_GRUPO
				Replace D3_EMISSAO With _DATA
				Replace D3_CUSTO1 With Z06->Z06_TOTAL
				Replace D3_CUSTO2 With Z06->Z06_TOTAL
				Replace D3_CUSTO3 With Z06->Z06_TOTAL
				Replace D3_CUSTO4 With Z06->Z06_TOTAL
				Replace D3_CUSTO5 With Z06->Z06_TOTAL
				Replace D3_SEGUM With SB1->B1_SEGUM
				Replace D3_QTSEGUM With Z06->Z06_PECAS
				Replace D3_TIPO With SB1->B1_TIPO
				Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
				Replace D3_CHAVE WITH "E0"
				MsUnLock()
			EndIf
			
			dbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+Z06->Z06_PROD+Z06->Z06_LOCAL)
			If Found()
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU-Z06->Z06_VOLUME
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM-Z06->Z06_PECAS
					REPLACE B2_VATU1 WITH B2_VATU1-Z06->Z06_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU2-Z06->Z06_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU3-Z06->Z06_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU4-Z06->Z06_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU5-Z06->Z06_TOTAL
					MsUnLock("SB2")
				EndIf
			EndIf
			
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Z06->Z06_PROD)
			
			If RecLock("SD3",.T.)
				Replace D3_FILIAL With xFILIAL("SD3")
				Replace D3_TM With "499"
				Replace D3_COD With Z06->Z06_PROD
				Replace D3_UM With SB1->B1_UM
				Replace D3_CF With "DE4"
				Replace D3_QUANT With Z06->Z06_VOLUME
				Replace D3_LOCAL With aCols[_cont,_nPosLOCDST]
				Replace D3_DOC With GETMV("MV_DOCSEQ")
				Replace D3_GRUPO With SB1->B1_GRUPO
				Replace D3_EMISSAO With _DATA
				Replace D3_CUSTO1 With Z06->Z06_TOTAL
				Replace D3_CUSTO2 With Z06->Z06_TOTAL
				Replace D3_CUSTO3 With Z06->Z06_TOTAL
				Replace D3_CUSTO4 With Z06->Z06_TOTAL
				Replace D3_CUSTO5 With Z06->Z06_TOTAL
				Replace D3_SEGUM With SB1->B1_SEGUM
				Replace D3_QTSEGUM With Z06->Z06_PECAS
				Replace D3_TIPO With SB1->B1_TIPO
				Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
				Replace D3_CHAVE WITH "E9"
				MsUnLock()
			EndIf
			dbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+Z06->Z06_PROD+aCols[_cont,_nPosLOCDST])
			If Found()
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU+Z06->Z06_VOLUME
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+Z06->Z06_PECAS
					REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU2+Z06->Z06_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU3+Z06->Z06_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU4+Z06->Z06_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU5+Z06->Z06_TOTAL
					MsUnLock("SB2")
				EndIf
			Else
				If RecLock("SB2",.T.)
					Replace B2_FILIAL WITH xFilial("SB2")
					Replace B2_COD WITH Z06->Z06_PROD
					Replace B2_LOCAL WITH aCols[_cont,_nPosLOCDST]
					REPLACE B2_QATU WITH B2_QATU+Z06->Z06_VOLUME
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+Z06->Z06_PECAS
					REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU2+Z06->Z06_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU3+Z06->Z06_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU4+Z06->Z06_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU5+Z06->Z06_TOTAL
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
			
			dbSelectArea("Z06")
			If RecLock("Z06",.F.)
				REPLACE Z06_LOCAL  WITH aCols[_cont,_nPosLOCDST]
				MsUnLock("Z06")
			EndIf
			dbskip()
		enddo
	Endif
Next
ALERT("Transferencias realizadas com sucesso!!!")
Return


User Function Vld17()        // incluido pelo assistente de conversao do AP5 IDE em 24/07/00
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
