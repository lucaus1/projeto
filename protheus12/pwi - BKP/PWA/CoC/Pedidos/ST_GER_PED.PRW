#include "rwmake.ch"
#include 'topconn.ch'

// GERAR PEDIDO DE VENDA (SC5 E SC6)
User Function ST_PR06()

Private cPerg := "Z18"
Private oGeraTxt
Private cString := "Z18"

ValidPerg()

dbSelectArea("Z16")
dbSetOrder(1)

Pergunte(cPerg,.T.)

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Pedido de Venda")
@ 02,10 TO 070,185
@ 10,018 Say " Este programa ira gerar o pedido de venda de acordo com o Pa- "
@ 18,018 Say " cking List criado...                                          "
@ 26,018 Say "                                                               "

@ 75,98 BMPBUTTON TYPE 01 ACTION OkGeraPED()
@ 75,128 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)
@ 75,158 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

Activate Dialog oGeraTxt Centered

Return

Static Function OkGeraPED
dbSelectArea("Z16")
dbSetOrder(1)
dbSeek(xFilial("Z16")+MV_PAR01)
IF FOUND()
	dbSelectArea("Z16")
	IF Z16_STATUS="F"
		MSGBOX("Pedido ja foi Gerada!!!")
	ELSEIF Z16_STATUS="A"
		MSGBOX("Packing List ainda nao foi processado!!!")
	ELSE
		_NumPed:=GETSX8NUM("SC5","C5_NUM")
		ConfirmSx8()
		dbSelectArea("Z18")
		dbSetOrder(4)
		dbSeek(xFilial("Z18")+Z16->Z16_CONTR)
		_Item:=0
		_Volume:=0
		_Quant:=0
		_Vltotal:=0
		IF FOUND()
			_Produto:=Z18_PROD
			_Local:=Z18_LOCAL
			_Moeda:=Z18_TPMOED
			_Preco:=STRZERO(Z18_PRECO,12)
		ELSE
			_Produto:=""
			_Local:=""
			_Moeda:=""
			_Preco:=""
		ENDIF
		do While !EOF() .AND. Z18_FILIAL=xFilial("Z18") .AND. Z18_CONTR=Z16->Z16_CONTR
			IF _Produto<>Z18_PROD .OR. _Local<>Z18_LOCAL .OR. _Moeda<>Z18_TPMOED .OR. _Preco<>STRZERO(Z18_PRECO,12)
				
				dbSelectArea("SB1")
				DbSetOrder(1)
				DbSeek(xFilial("SB1")+_Produto)
				
				
				dbSelectArea("SC6")
				If RecLock("SC6",.T.)
					
					REPLACE C6_FILIAL WITH xFilial("SC6")
					REPLACE C6_NUM WITH _NumPed
					REPLACE C6_ITEM WITH strzero(_Item+1,2)
					REPLACE C6_PRODUTO WITH _Produto
					REPLACE C6_UM WITH SB1->B1_UM
					REPLACE C6_QTDVEN WITH IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
					REPLACE C6_PRCVEN WITH _Vltotal/IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
					REPLACE C6_VALOR WITH _Vltotal
					REPLACE C6_TES WITH MV_PAR04
					REPLACE C6_LOCAL WITH _Local
					REPLACE C6_CF WITH POSICIONE("SF4",1,xFilial("SF4")+MV_PAR04,"F4_CF")
					REPLACE C6_CLASFIS WITH SB1->B1_ORIGEM+POSICIONE("SF4",1,xFilial("SF4")+MV_PAR04,"F4_SITTRIB")
					REPLACE C6_TPOP WITH "F"
//					REPLACE C6_QTDENT WITH IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
					REPLACE C6_CLI WITH Z16->Z16_CLIENT
					REPLACE C6_ENTREG WITH Date() //Z16->Z16_DATA
					REPLACE C6_LOJA WITH Z16->Z16_LOJA
					REPLACE C6_DESCRI WITH SB1->B1_DESC
					
					MsUnLock()
				End If
				dbSelectArea("Z18")
				_Item:=_Item+1
				_Volume:=0
				_Quant:=0
				_Vltotal:=0
				_Produto:=Z18_PROD
				_Local:=Z18_LOCAL
				_Moeda:=Z18_TPMOED
				_Preco:=STRZERO(Z18_PRECO,12)
			ENDIF
			_Volume:=_Volume+Z18_VOLUME
			_Vltotal:=_Vltotal+Z18_TOTAL
			_Quant:=_Quant+Z18_PECAS
			
			If Z18_TPCT="S"                 
				dbSelectArea("Z06")
				dbSetOrder(3)
				If dbseek(xfilial("Z06")+Z18->Z18_LOTE,.F.)
					While !eof() .and. Z06_FILIAL == xFilial("Z06") .And. Z06_LOTE == Z18->Z18_LOTE

						IF RecLock("Z06",.F.)
							
							REPLACE Z06_BAIXA  WITH "BX"
							REPLACE Z06_DOCBX  WITH _NumPed
							REPLACE Z06_DTBX   WITH Date()
							REPLACE Z06_CCBX   WITH ""
							REPLACE Z06_DESTBX WITH "C"
							
							MsUnLock()
						Endif
						dbSkip()
					EndDo
				EndIf
			Else
				dbSelectArea("Z13")
				dbSetOrder(3)
				If dbseek(xfilial("Z13")+Z18->Z18_LOTE,.F.)
					While !eof() .and. Z13_FILIAL == xFilial("Z13") .And. Z13_LOTE == Z18->Z18_LOTE

						IF RecLock("Z13",.F.)
							
							REPLACE Z13_BAIXA  WITH "BX"
							REPLACE Z13_DOCBX  WITH _NumPed
							REPLACE Z13_DTBX   WITH Date()
							REPLACE Z13_CCBX   WITH ""
							REPLACE Z13_DESTBX WITH "C"
							
							MsUnLock()
						Endif
						dbSkip()
					EndDo
				EndIf
			Endif
			
			dbSelectArea("Z18")
			dbskip()
		enddo
		
		IF _Quant>0
			dbSelectArea("SB1")
			DbSetOrder(1)
			DbSeek(xFilial("SB1")+_Produto)
			
			dbSelectArea("SC6")
			If RecLock("SC6",.T.)
				
				REPLACE C6_FILIAL WITH xFilial("SC6")
				REPLACE C6_NUM WITH _NumPed
				REPLACE C6_ITEM WITH strzero(_Item+1,2)
				REPLACE C6_PRODUTO WITH _Produto
				REPLACE C6_UM WITH SB1->B1_UM
				REPLACE C6_QTDVEN WITH IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
				REPLACE C6_PRCVEN WITH _Vltotal/IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
				REPLACE C6_VALOR WITH _Vltotal
				REPLACE C6_TES WITH MV_PAR04
				REPLACE C6_LOCAL WITH _Local
				REPLACE C6_CF WITH POSICIONE("SF4",1,xFilial("SF4")+MV_PAR04,"F4_CF")
				REPLACE C6_CLASFIS WITH SB1->B1_ORIGEM+POSICIONE("SF4",1,xFilial("SF4")+MV_PAR04,"F4_SITTRIB")
				REPLACE C6_TPOP WITH "F"
//				REPLACE C6_QTDENT WITH IIF(MV_PAR02=1,_Volume,IIF(MV_PAR02=2,_Item,_Quant))
				REPLACE C6_CLI WITH Z16->Z16_CLIENT
				REPLACE C6_ENTREG WITH Date() //Z16->Z16_DATA
				REPLACE C6_LOJA WITH Z16->Z16_LOJA
				REPLACE C6_DESCRI WITH SB1->B1_DESC
				
				MsUnLock()
			End If
		ENDIF
		
		cSELECT :=	'C5_TRANSP,C5_CONDPAG,C5_PESOL,C5_PBRUTO,C5_VOLUME1,C5_ESPECI1,C5_MENNOTA,C5_MENPAD,C5_TXTMSG,C5_IDFORM1,C5_TXTMSG1,C5_IDFORM2,C5_TXTMSG2 '
		cFROM   :=	RetSqlName('SC5') + ' '
		cWHERE  :=	'D_E_L_E_T_ <>   '+CHR(39) + '*'            +CHR(39) + ' AND '+;
		'C5_FILIAL  =    '+CHR(39) + xFilial('SC5') +CHR(39) + ' AND '+;
		'C5_CLIENTE    =    '+CHR(39) + Z16->Z16_CLIENT +CHR(39)
		'C5_LOJA    =    '+CHR(39) + Z16->Z16_LOJA +CHR(39)
		cORDER  :=	'C5_EMISSAO DESC'
		cQuery  :=	' SELECT TOP 1 '   + cSELECT + ;
		' FROM '     + cFROM   + ;
		' WHERE '    + cWHERE  + ;
		' ORDER BY ' + cORDER
		TCQUERY cQuery NEW ALIAS 'TRA'
		If	! USED()
			MsgBox(cQuery+'. Query errada','Erro!!!','STOP')
		EndIf
		DbSelectArea('TRA')
		TRA->(DbGoTop())
		
		dbSelectArea("SC5")
		If RecLock("SC5",.T.)
			
			Replace C5_FILIAL With xFilial("SC5")
			Replace C5_NUM With _NumPed
			Replace C5_TIPO With "N"
			Replace C5_CLIENTE With Z16->Z16_CLIENT
			Replace C5_LOJACLI With Z16->Z16_LOJA
			Replace C5_CLIENT With Z16->Z16_CLIENT
			Replace C5_LOJAENT With Z16->Z16_LOJA
			Replace C5_TIPOCLI With Posicione("SA1",1,xFilial("SA1")+Z16->Z16_CLIENT+Z16->Z16_LOJA,"A1_TIPO")
			Replace C5_EMISSAO With Date()
			Replace C5_MOEDA With 1
			Replace C5_TXMOEDA With 1
			Replace C5_TIPLIB With "1"
			Replace C5_TPCARGA With "2"
			Replace C5_GERAWMS With "1"
			Replace C5_SOLOPC With "1"
			Replace C5_TRANSP With TRA->C5_TRANSP
			Replace C5_CONDPAG With TRA->C5_CONDPAG
			Replace C5_PESOL With TRA->C5_PESOL
			Replace C5_PBRUTO With TRA->C5_PBRUTO
			Replace C5_VOLUME1 With TRA->C5_VOLUME1
			Replace C5_ESPECI1 With TRA->C5_ESPECI1
			Replace C5_MENNOTA With TRA->C5_MENNOTA
			Replace C5_MENPAD With TRA->C5_MENPAD
			Replace C5_TXTMSG With TRA->C5_TXTMSG
			Replace C5_IDFORM1 With TRA->C5_IDFORM1
			Replace C5_TXTMSG1 With TRA->C5_TXTMSG1
			Replace C5_IDFORM2 With TRA->C5_IDFORM2
			Replace C5_TXTMSG2 With TRA->C5_TXTMSG2
			
			MsUnLock()
		End If
		
		TRA->(DbCloseArea())
		
		dbSelectArea("Z16")
		If RecLock("Z16",.F.)
			REPLACE Z16_STATUS WITH "F"
			REPLACE Z16_PEDFAT WITH _NumPed
			MsUnLock()
		End If
		MSGBOX("Pedido "+_NumPed+" gerado com sucesso, verifique na rotina correspondente!!!")
	EndIf
ELSE
	MSGBOX("Packing List não encontrado, verifique os parâmetros!!!")
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
aAdd(aRegs,{cPerg,"01","Num. Packing List?","Num. Packing List?","Num. Packing List?","mv_ch1","C",9,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","1a. U. Medida?","1a. U. Medida?","1a. U. Medida?","mv_ch2","C",1,0,0,"C","","mv_par02","Volume","Volume","Volume","","","Pacotes","Pacotes","Pacotes","","","Pecas","Pecas","Pecas","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","2a. U. Medida?","2a. U. Medida?","2a. U. Medida?","mv_ch3","C",1,0,0,"C","","mv_par03","Volume","Volume","Volume","","","Pacotes","Pacotes","Pacotes","","","Pecas","Pecas","Pecas","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","TES para Venda?","TES para Venda?","TES para Venda?","mv_ch4","C",3,0,0,"G","EXISTCPO('SF4')","","","","","","","","","","","","","","","","","","","","","","","","","","SF4",""})

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
