#include "rwmake.CH"
#include "font.CH"
#include "topconn.ch"
#include "vkey.ch"
#include "colors.ch"
#include "fivewin.ch"
#include "protheus.ch"


///ENCERRAMENTO ANUAL- IFRS


User Function ENCIFR()
    Private	lEnd := .f.
	Private _cQuery  := ""
	Private _DataC   := GetMV("MV_DATAOLS") 

    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"

  	Private aPerg := {}
  	Private cPerg := "ENCIFR"

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
		Processa({ |lEnd| FechaIfr()})
	Endif
Return

Static Function FechaIfr()
 
	
	_cQuery :=  " SELECT ZT1_CONTA, "
	_cQuery +=	" (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT2_FILIAL='"+xFilial("ZT2")+"' AND ZT2_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT2_CTACRE=ZT1060.ZT1_CONTA AND ZT2060.D_E_L_E_T_<>'*') AS DIFC, "
	_cQuery +=	" (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT2_FILIAL='"+xFilial("ZT2")+"' AND ZT2_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT2_CTADEB=ZT1060.ZT1_CONTA AND ZT2060.D_E_L_E_T_<>'*')AS DIFD "
	_cQuery +=	" FROM ZT1060 "
	_cQuery +=	" WHERE        "
	_cQuery +=	" (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT2_FILIAL='"+xFilial("ZT2")+"' AND ZT2_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT2_CTADEB = ZT1060.ZT1_CONTA AND ZT2060.D_E_L_E_T_<>'*') IS NOT NULL AND "
	_cQuery +=	" (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT2_FILIAL='"+xFilial("ZT2")+"' AND ZT2_DATA BETWEEN '"+DtoS(mv_par01)+"' AND '"+DtoS(mv_par02)+"' AND ZT2_CTACRE = ZT1060.ZT1_CONTA AND ZT2060.D_E_L_E_T_<>'*') IS NOT NULL AND "
	_cQuery +=	" ZT1060.D_E_L_E_T_<>'*' "


TcQuery _cQuery Alias qTotIfr new
dbGotop()

dbSelectArea("ZT2")

	While (!qTotIfr->(Eof()))
	  //ATUALIZACAO S.I. MIL
		If qTotIfr->DIFC - qTotIfr->DIFD <> 0 .AND. !Substr(qTotIfr->ZT1_CONTA,1,1)$"5/6" 
          If qTotIfr->DIFC - qTotIfr->DIFD > 0
	          Reclock("ZT2", .T.)
				ZT2->ZT2_FILIAL  := xFilial("ZT2") 
				ZT2->ZT2_DATA    := mv_par03
				ZT2->ZT2_CTACRE  := qTotIfr->ZT1_CONTA
				ZT2->ZT2_CTAVAL  := qTotIfr->DIFC - qTotIfr->DIFD
				ZT2->ZT2_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
	          MsUnlock()
		  Else          
	          Reclock("ZT2", .T.)
				ZT2->ZT2_FILIAL  := xFilial("ZT2") 
				ZT2->ZT2_DATA    := mv_par03
				ZT2->ZT2_CTADEB  := qTotIfr->ZT1_CONTA
				ZT2->ZT2_CTAVAL  := -(qTotIfr->DIFC - qTotIfr->DIFD)
				ZT2->ZT2_HIST    := "SALDO INICIAL"+"-"+Substr(DtoS(mv_par03),1,4)
	          MsUnlock()
	      Endif
		Endif 
    qTotIfr->(dbSkip())
    Enddo   

   	DbSelectArea("SX6")
	IF DbSeek(xFilial("ZT1")+_DataC)
		RECLOCK("SX6",.F.)
			SX6->X6_CONTEUDO := DtoS(mv_par03)
		MSUNLOCK()				
	Endif	
	
   Msgbox("ATUALIZAÇÃO CONCLUÍDA", "Atenção" , "INFO")
  qTotIfr->(dbCloseArea())
Return