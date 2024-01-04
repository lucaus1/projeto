#include "rwmake.ch"


User Function ST_INT_SER(_Contr)
dbSelectArea("Z05")
dbSetOrder(1)
dbSeek(xFilial("Z05")+MV_PAR01)
IF FOUND()
	dbSelectArea("Z05")
	IF Z05_STATUS="F"
		MSGBOX("Movimentacao ja foi Gerada!!!")
	ELSEIF ALLTRIM(Z05_TPENTR)<>"P"
		MSGBOX("Tipo do Documento nao e Romaneio!")
	ELSEIF ALLTRIM(Z05_CC)=""
		MSGBOX("Informe o Centro de Custo para Producao!")
	ELSEIF POSICIONE("SF5",1,xFilial("SF5")+MV_PAR04,"F5_TIPO")=="R" 
		MSGBOX("Tipo de movimentacao incompativel!!! "+MV_PAR04)
	ELSE
		dbSelectArea("Z06")
		dbSetOrder(1)
		DbSeek(xFilial("Z06")+MV_PAR01)
		While !eof() .AND. xFilial("Z06")=Z06_FILIAL .AND. Z06_CONTR==MV_PAR01
			
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+Z06->Z06_PROD)
			
			dbSelectArea("SX6")
			DbSetOrder(1)
			DbSeek("  "+"MV_DOCSEQ")
			
			dbSelectArea("SD3")
			If RecLock("SD3",.T.)
				Replace D3_FILIAL With xFILIAL("SD3")
				Replace D3_TM With MV_PAR04
				Replace D3_COD With Z06->Z06_PROD
				Replace D3_UM With SB1->B1_UM
				Replace D3_CF With "PR0"
				Replace D3_QUANT With IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
				Replace D3_LOCAL With Z06->Z06_LOCAL
				Replace D3_DOC With GETMV("MV_DOCSEQ")
				Replace D3_GRUPO With SB1->B1_GRUPO
				Replace D3_EMISSAO With Z05->Z05_DATA
				Replace D3_CUSTO1 With Z06->Z06_TOTAL
				Replace D3_CUSTO2 With Z06->Z06_TOTAL
				Replace D3_CUSTO3 With Z06->Z06_TOTAL
				Replace D3_CUSTO4 With Z06->Z06_TOTAL
				Replace D3_CUSTO5 With Z06->Z06_TOTAL
				Replace D3_CC With Z05->Z05_CC
				Replace D3_SEGUM With SB1->B1_SEGUM
				Replace D3_QTSEGUM With IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR03=2,1,Z06->Z06_PECAS))
				Replace D3_TIPO With SB1->B1_TIPO
				Replace D3_USUARIO WITH SUBSTR(cUsuario,7,15)
				Replace D3_CHAVE WITH "R0"
				MsUnLock()
			EndIf
			
			dbSelectArea("SB2")
			DbSetOrder(1)
			DbSeek(xFilial("SB2")+Z06->Z06_PROD)
			If Found()
				If RecLock("SB2",.F.)
					REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU1+Z06->Z06_TOTAL
					MsUnLock("SB2")
				EndIf
			Else
				If RecLock("SB2",.T.)
					Replace B2_FILIAL WITH xFilial("SB2")
					Replace B2_COD WITH Z06->Z06_PROD
					Replace B2_LOCAL WITH Z06->Z06_LOCAL
					REPLACE B2_QATU WITH B2_QATU+IIF(MV_PAR02=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					REPLACE B2_QTSEGUM WITH B2_QTSEGUM+IIF(MV_PAR03=1,Z06->Z06_VOLUME,IIF(MV_PAR02=2,1,Z06->Z06_PECAS))
					REPLACE B2_VATU1 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU2 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU3 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU4 WITH B2_VATU1+Z06->Z06_TOTAL
					REPLACE B2_VATU5 WITH B2_VATU1+Z06->Z06_TOTAL
					MsUnLock("SB2")
				EndIf
			EndIf
			
			dbSelectArea("Z06")
			If RecLock("Z06",.F.)
				REPLACE Z06_BAIXA  WITH "ES"
				MsUnLock("Z06")
			EndIf
			dbskip()
		enddo
		
		dbSelectArea("Z05")
		If RecLock("Z05",.F.)
			REPLACE Z05_DOCREQ WITH GETMV("MV_DOCSEQ")
			REPLACE Z05_STATUS WITH "F"
			MsUnLock("Z05")
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
