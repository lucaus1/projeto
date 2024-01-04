#include "rwmake.CH"
#include "font.CH"
#include "topconn.ch"
#include "vkey.ch"
#include "colors.ch"
#include "protheus.ch"


///ENCERRAMENTO ANUAL- CONVERSION
/*
Alteracoes 
Data       Consultor      Descricao  
02/04/2011 Franciney      tamanho da variavel de pesquisa de C 6 para C 10 



*/

User Function ENCCON()
	Private	lEnd := .f.
	Private _cQuery  := ""
	Private _DataC   := GetMV("MV_DATAOLS")
	
	//  .--------------------------------.
	// | Definição de Grupos de Perguntas |
	//  "--------------------------------"
	
	Private aPerg := {}
	Private cPerg := "ENCCON    "
	
	dbSelectArea("SX1")
	dbSetOrder(1)
	
	//- Defindo grupo de perguntas
	aadd(aPerg,{cPerg, "01", "Exerc de      ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
	aadd(aPerg,{cPerg, "02", "Exerc ate     ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
	aadd(aPerg,{cPerg, "03", "Data Inicial  ?","mv_ch3","D",08,0,1,"G","","mv_par03","","","","","","","","","","","","","","",""})
	
	//- Gravando grupo de perguntas
	For nA:= 1 To Len(aPerg)
		If !(dbSeek(cPerg+aPerg[nA,2]))
			RecLock("SX1",.t.)
			Replace X1_GRUPO    with aPerg[nA][1]
			Replace X1_ORDEM    with aPerg[nA][2]
			Replace X1_PERGUNT  with aPerg[nA][3]
			Replace X1_PERSPA   with aPerg[nA][3]
			Replace X1_PERENG   with aPerg[nA][3]
			Replace X1_VARIAVL  with aPerg[nA][4]
			Replace X1_TIPO     with aPerg[nA][5]
			Replace X1_TAMANHO  with aPerg[nA][6]
			Replace X1_GSC      with aPerg[nA][9]
			Replace X1_DECIMAL  with aPerg[nA][7]
			Replace X1_PRESEL   with aPerg[nA][8]
			Replace X1_DEF01    with aPerg[nA][12]
			Replace X1_DEF02    with aPerg[nA][15]
			Replace X1_DEFSPA1  with aPerg[nA][12]
			Replace X1_DEFSPA2  with aPerg[nA][15]
			Replace X1_DEFENG1  with aPerg[nA][12]
			Replace X1_F3       with aPerg[nA][13]
			Replace X1_DEFENG2  with aPerg[nA][15]
			MsUnlock()
		Endif
	Next
	
	if Pergunte(cPerg, .T.)
		Processa({ |lEnd| FechaCon()})
	Endif
Return

Static Function FechaCon()
	
	_cQuery :=  " SELECT ZT1_CONTA,   																											 																	 "
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_CREDIT=ZT1060.ZT1_CONTA AND ZT3_EMPRES='01' AND ZT3060.D_E_L_E_T_<>'*')AS DIFC01,         "
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_DEBITO=ZT1060.ZT1_CONTA AND ZT3_EMPRES='01' AND ZT3060.D_E_L_E_T_<>'*')AS DIFD01,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_CREDIT=ZT1060.ZT1_CONTA AND ZT3_EMPRES='02' AND ZT3060.D_E_L_E_T_<>'*')AS DIFC02,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_DEBITO=ZT1060.ZT1_CONTA AND ZT3_EMPRES='02' AND ZT3060.D_E_L_E_T_<>'*')AS DIFD02,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_CREDIT=ZT1060.ZT1_CONTA AND ZT3_EMPRES='03' AND ZT3060.D_E_L_E_T_<>'*')AS DIFC03,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_DEBITO=ZT1060.ZT1_CONTA AND ZT3_EMPRES='03' AND ZT3060.D_E_L_E_T_<>'*')AS DIFD03,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_CREDIT=ZT1060.ZT1_CONTA AND ZT3_EMPRES='04' AND ZT3060.D_E_L_E_T_<>'*')AS DIFC04,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_DEBITO=ZT1060.ZT1_CONTA AND ZT3_EMPRES='04' AND ZT3060.D_E_L_E_T_<>'*')AS DIFD04,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_CREDIT=ZT1060.ZT1_CONTA AND ZT3_EMPRES='07' AND ZT3060.D_E_L_E_T_<>'*')AS DIFC07,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_DEBITO=ZT1060.ZT1_CONTA AND ZT3_EMPRES='07' AND ZT3060.D_E_L_E_T_<>'*')AS DIFD07,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_CREDIT=ZT1060.ZT1_CONTA AND ZT3_EMPRES='08' AND ZT3060.D_E_L_E_T_<>'*')AS DIFC08,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_DEBITO=ZT1060.ZT1_CONTA AND ZT3_EMPRES='08' AND ZT3060.D_E_L_E_T_<>'*')AS DIFD08,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_CREDIT=ZT1060.ZT1_CONTA AND ZT3_EMPRES='09' AND ZT3060.D_E_L_E_T_<>'*')AS DIFC09,"
	_cQuery +=	"  (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE  ZT3_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT3_DEBITO=ZT1060.ZT1_CONTA AND ZT3_EMPRES='09' AND ZT3060.D_E_L_E_T_<>'*')AS DIFD09 "
	_cQuery +=	" FROM ZT1060																													 																	 "
	_cQuery +=	" WHERE                                                                                                                          																	 "
	_cQuery +=	" ZT1060.D_E_L_E_T_<>'*' "
	
	TcQuery _cQuery Alias qTotCon new
	dbGotop()
	
	dbSelectArea("ZT3")
	
	While (!qTotCon->(Eof()))
		//ATUALIZACAO S.I. MIL
		If !Substr(qTotCon->ZT1_CONTA,1,1)$"5/6" .and. qTotCon->DIFC01 - qTotCon->DIFD01 <> 0
			If qTotCon->DIFC01 - qTotCon->DIFD01 > 0
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '01'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_CREDIT  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := qTotCon->DIFC01 - qTotCon->DIFD01
				ZT3->ZT3_EMPRESA := "01"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Else
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '01'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_DEBITO  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := -(qTotCon->DIFC01 - qTotCon->DIFD01)
				ZT3->ZT3_EMPRESA := "01"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Endif
		Endif
		//ATUALIZACAO S.I. CAROLINA
		If !Substr(qTotCon->ZT1_CONTA,1,1)$"5/6" .and. qTotCon->DIFC02 - qTotCon->DIFD02 <> 0
			If qTotCon->DIFC02 - qTotCon->DIFD02 > 0
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '01'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_CREDIT  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := qTotCon->DIFC02 - qTotCon->DIFD02
				ZT3->ZT3_EMPRESA := "02"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Else
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '01'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_DEBITO  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := -(qTotCon->DIFC02 - qTotCon->DIFD02)
				ZT3->ZT3_EMPRESA := "02"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Endif
		Endif
		//ATUALIZACAO S.I. BK ENERGIA
		If qTotCon->DIFC03 - qTotCon->DIFD03 <> 0 .AND. !Substr(qTotCon->ZT1_CONTA,1,1)$"5/6"
			If qTotCon->DIFC03 - qTotCon->DIFD03 > 0
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '03'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_CREDIT  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := qTotCon->DIFC03 - qTotCon->DIFD03
				ZT3->ZT3_EMPRESA := "03"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Else
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '03'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_DEBITO  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := -(qTotCon->DIFC03 - qTotCon->DIFD03)
				ZT3->ZT3_EMPRESA := "03"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Endif
		Endif
		//ATUALIZACAO MADAMA
		If qTotCon->DIFC04 - qTotCon->DIFD04 <> 0 .AND. !Substr(qTotCon->ZT1_CONTA,1,1)$"5/6"
			If qTotCon->DIFC04 - qTotCon->DIFD04 > 0
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '01'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_CREDIT  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := qTotCon->DIFC04 - qTotCon->DIFD04
				ZT3->ZT3_EMPRESA := "04"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Else
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '01'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_DEBITO  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := -(qTotCon->DIFC04 - qTotCon->DIFD04)
				ZT3->ZT3_EMPRESA := "04"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Endif
		Endif
		//ATUALIZACAO S.I. PWB
		If qTotCon->DIFC07 - qTotCon->DIFD07 <> 0 .AND. !Substr(qTotCon->ZT1_CONTA,1,1)$"5/6"
			If qTotCon->DIFC07 - qTotCon->DIFD07 > 0
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '02'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_CREDIT  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := qTotCon->DIFC07 - qTotCon->DIFD07
				ZT3->ZT3_EMPRESA := "07"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Else
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '02'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_DEBITO  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := -(qTotCon->DIFC07 - qTotCon->DIFD07)
				ZT3->ZT3_EMPRESA := "07"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Endif
		Endif
		//ATUALIZACAO S.I. PWP
		If qTotCon->DIFC08 - qTotCon->DIFD08 <> 0 .AND. !Substr(qTotCon->ZT1_CONTA,1,1)$"5/6"
			If qTotCon->DIFC08 - qTotCon->DIFD08 > 0
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '02'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_CREDIT  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := qTotCon->DIFC08 - qTotCon->DIFD08
				ZT3->ZT3_EMPRESA := "08"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Else
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '02'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_DEBITO  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := -(qTotCon->DIFC08 - qTotCon->DIFD08)
				ZT3->ZT3_EMPRESA := "08"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Endif
		Endif
		//ATUALIZACAO S.I. MVERDE
		If qTotCon->DIFC09 - qTotCon->DIFD09 <> 0 .AND. !Substr(qTotCon->ZT1_CONTA,1,1)$"5/6"
			If qTotCon->DIFC09 - qTotCon->DIFD09 > 0
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '02'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_CREDIT  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := qTotCon->DIFC09 - qTotCon->DIFD09
				ZT3->ZT3_EMPRESA := "09"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Else
				Reclock("ZT3", .T.)
				ZT3->ZT3_FILIAL  := '02'
				ZT3->ZT3_DATA    := mv_par03
				ZT3->ZT3_DEBITO  := qTotCon->ZT1_CONTA
				ZT3->ZT3_VALOR   := -(qTotCon->DIFC09 - qTotCon->DIFD09)
				ZT3->ZT3_EMPRESA := "09"
				ZT3->ZT3_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
				MsUnlock()
			Endif
		Endif
		
		qTotCon->(dbSkip())
	Enddo
	
	DbSelectArea("SX6")
	IF DbSeek(xFilial("ZT1")+_DataC)
		RECLOCK("SX6",.F.)
		SX6->X6_CONTEUDO := DtoS(mv_par03)
		MSUNLOCK()
	Endif
	
	Msgbox("ATUALIZAÇÃO CONCLUÍDA", "Atenção" , "INFO")
	qTotCon->(dbCloseArea())
	Return
