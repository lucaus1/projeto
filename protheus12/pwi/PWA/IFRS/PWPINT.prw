#Include "PROTHEUS.CH"
#include "topconn.ch"
/*
Alteracoes 
Data       Consultor      Descricao  
03/04/2011 Franciney      novas perguntas para ignorar LP, precisa informar lote da apuração do LP
06/04/2011 Franciney      novo filtro para considerar apenas CT2_TPSALD = '1' 

  

*/


User Function PWPINT()
	Private	lEnd := .f.
	Private _cQuery  := ""
	Private _cGrupoS :=""
	Private _cGrupoT :=""
	Private _cGrupoF :=""
	Private _cSuper  :=""
	Private _cTot    :=""
    Private _TOConRs := 0
	Private _TOIntRs := 0
	Private _TOPWBRs := 0
   	Private _TOPWPRs := 0
   	Private _TOPMVRs := 0
    Private	_SUConRs := 0
	Private	_SUIntRs := 0
	Private	_SUPWBRs := 0
	Private	_SUPWPRs := 0
	Private	_SUPMVRs := 0
    Private	_EXConRs := 0
	Private	_EXIntRs := 0
	Private	_EXPWBRs := 0
	Private	_EXPWPRs := 0
	Private	_EXPMVRs := 0
    Private _VldClas := .F.
    Private _Cambio  := 0
    Private _Pagina  := 0
	Private _DataC   := GetMV("MV_DATAOLS") 
	Private qOLS     := ""
	Private _cTotalR1:= 0
	Private _cTotalU1:= 0	                 
	Private SAPWB    := 0
	Private SAPWP    := 0
	Private SAPMV    := 0
    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PWPINT    "

  	dbSelectArea("SX1")
  	dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data de      ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Data ate     ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Conta de     ?","mv_ch3","C",10,0,1,"G","","mv_par03","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Conta Ate    ?","mv_ch4","C",10,0,1,"G","","mv_par04","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Cambio       ?","mv_ch5","N",14,4,1,"G","","mv_par05","","","","","","","","","","","","","","",""})
	aadd(aPerg,{cPerg, "06", "Ignora LP    ?","mv_ch6","C",01,0,1,"G","","mv_par06","","","","","","","","","","","","","","",""}) 
  	aadd(aPerg,{cPerg, "07", "Lote LP      ?","mv_ch7","C",06,0,1,"G","","mv_par07","","","","","","","","","","","","","","",""}) 
  	aadd(aPerg,{cPerg, "08", "Data LP      ?","mv_ch8","D",08,0,1,"G","","mv_par08","","","","","","","","","","","","","","",""}) 
  	 
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
		//³Executa a rotina de impressao ³
		Processa({ |lEnd| xPrintRel(), OemToAnsi("Gerando o relatório.")}, OemToAnsi("Aguarde..."))
	Endif
	//³Restaura a area anterior ao processamento. !
Return

Static Function xPrintRel()
	oPrint		:= TMSPrinter():New(OemToAnsi("Relatorio InteCompany"))
	oBrush		:= TBrush():New(,4)
	oPen		:= TPen():New(0,5,CLR_BLACK)
	cFileLogo	:= GetSrvProfString("Startpath","") + "LOGORECH02" + ".BMP"
	oFont06		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
	oFont07		:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
	oFont07n	:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
	oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	oFont08n	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	oFont09		:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	oFont11		:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
	oFont12		:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	oFont12n	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	oFont13		:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
	oFont14		:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
	oFont15		:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
	oFont18		:= TFont():New("Arial",18,18,,.T.,,,,.T.,.T.)
	oFont16		:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
	oFont20		:= TFont():New("Arial",20,20,,.F.,,,,.T.,.F.)
	oFont22		:= TFont():New("Arial",22,22,,.T.,,,,.T.,.F.)

	nLinha		:= 3030	// Controla a linha por extenso
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define que a impressao deve ser RETRATO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SetPortrait()
	//oPrint:SetLandScape()

		_cQuery1 := " select ZT4_SEQ,ZT4_GRUPO,ZT4_TIPO,ZT4_CLAS "
	    _cQuery1 += " FROM ZT4060  WHERE ZT4060.D_E_L_E_T_<>'*' AND ZT4_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	    _cQuery1 += " ORDER BY ZT4_CLAS,ZT4_SEQ ASC "
		
		TcQuery _cQuery1 Alias qLGRUPO new
		
    dbGoTop()
	_Cambio := MV_PAR05
    _SltClas := qLGRUPO->ZT4_CLAS    
	nContador := 1
    Gauge := (qLGRUPO -> (RecCount())*5)
    ProcRegua( Gauge )	
    
	While (!qLGRUPO->(Eof()))
	    _cSeq := qLGRUPO->ZT4_SEQ
	
	    If Alltrim(qLGRUPO -> ZT4_TIPO) != "T" .and. Alltrim(qLGRUPO -> ZT4_TIPO) != ""
				    
				    _cQuery2 := " SELECT ZT5060.*, (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2070,CT1070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery2 += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                										
					_cQuery2 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1070,CT2070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND  "
	                _cQuery2 += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                										
					_cQuery2 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2080,CT1080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND  "
	                _cQuery2 += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                										
					_cQuery2 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1080,CT2080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND  "
	                _cQuery2 += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                										
					_cQuery2 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2090,CT1090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery2 += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                										
					_cQuery2 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1090,CT2090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery2 += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                										
					_cQuery2 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09'  "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV,  "
			    
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV "
			
				 			
					_cQuery2 += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery2 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        SUGrupo := qTGRUPO->ZT5_GRUPO 
                            xVerPag()
                            
							//DESCRICAO E CONTA OLS
                           if Alltrim(qLGRUPO -> ZT4_TIPO) == "E" 				 	   
						        oPrint:Say(nLinha,0050, "EX - " + PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       else
								oPrint:Say(nLinha,0050, PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       endif
							oPrint:Say(nLinha,0610, PadR(qTGRUPO->ZT5_CONTA,6), oFont07)

							//MOVIMENTOS CONSOLIDADOS
							oPrint:Say(nLinha,0770, Transform((((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05, "@E 999,999,999,999"), oFont07)

							//INTERCOMPANY
							oPrint:Say(nLinha,1080, Transform((qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05, "@E 999,999,999,999"), oFont07)

							//MOIVMENTOS CONTABEIS PWB
							oPrint:Say(nLinha,1380, Transform(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )*mv_par05, "@E 999,999,999,999"), oFont07)

							//MOVIMENTOS CONTABEIS PWPAMA
							oPrint:Say(nLinha,1680, Transform(((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )*mv_par05, "@E 999,999,999,999"), oFont07)

							//MOVIMENTOS CONTABEIS PMV
							oPrint:Say(nLinha,1980, Transform(((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )*mv_par05, "@E 999,999,999,999"), oFont07)

							nLinha += 40

                           if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
						 	    _SUConRS +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05
						 	    _SUIntRs +=(qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
			                    _SUPWBRs +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )*mv_par05
			                    _SUPWPRs +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )*mv_par05
			                    _SUPMVRs +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )*mv_par05
	                       endif
	                            
					        qTGRUPO->(dbSkip())
				    End	
                    
                    if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
	             		oPrint:Line(nLinha,050,nLinha,2190)
						nLinha += 20
						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(SUGrupo,6), oFont07)
						//SUBTOTAL CONSOLIDADAS
						oPrint:Say(nLinha,0770, Transform(_SUConRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL INTERCOMPANY
						oPrint:Say(nLinha,1080, Transform(_SUIntRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWB
						oPrint:Say(nLinha,1380, Transform(_SUPWBRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWPAMA
						oPrint:Say(nLinha,1680, Transform(_SUPWPRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PMV
						oPrint:Say(nLinha,1980, Transform(_SUPMVRs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,2190)
	   				    nLinha += 20

				        _SUConRS := 0
				 	    _SUIntRs := 0
				 	    _SUEliRS := 0
	                    _SUPWBRs := 0
	                    _SUPWPRs := 0
	                    _SUPMVRs := 0
	                endif
   	                qTGRUPO->(dbCloseArea())
   	                
	    Elseif Alltrim(qLGRUPO -> ZT4_TIPO) =='T'
	             
	                _cQuery3 := " SELECT ZT5060.*,ZT1_CONTA, "
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2070,CT1070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                						                
					_cQuery3 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1070,CT2070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND  "            
	                _cQuery3 += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                						                	                
					_cQuery3 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB, "
	
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2080,CT1080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND  "            
	                _cQuery3 += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                						                	                
					_cQuery3 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1080,CT2080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                						                	                
					_cQuery3 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
					_cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP,  "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP, "
	
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2090,CT1090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "             
	                _cQuery3 += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                						                	                
					_cQuery3 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1090,CT2090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "             
	                _cQuery3 += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                						                	                
					_cQuery3 += IF(UPPER(MV_PAR06)='S'," CT2_LOTE <> '"+MV_PAR07+"' AND "," ")
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV, "
	    
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV "
	
	                
	                _cQuery3 += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery3 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
                            xVerPag()
                                   	                   
					 	    _TOConRS +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05
					 	    _TOIntRs +=(qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
		                    _TOPWBRs +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  ))*mv_par05
		                    _TOPWPRs +=(((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  ))*mv_par05
		                    _TOPMVRs +=(((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  ))*mv_par05
		                    
					        qTGRUPO->(dbSkip())
				    
				    End	
	             		oPrint:Line(nLinha,050,nLinha,2190)
						nLinha += 20
						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(TOGrupo,6), oFont07)
						//SUBTOTAL CONSOLIDADAS
						oPrint:Say(nLinha,0770, Transform(_TOConRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL INTERCOMPANY
						oPrint:Say(nLinha,1080, Transform(_TOIntRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWB
						oPrint:Say(nLinha,1380, Transform(_TOPWBRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWPAMA
						oPrint:Say(nLinha,1680, Transform(_TOPWPRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PMV
						oPrint:Say(nLinha,1980, Transform(_TOPMVRs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,2190)
	   				    nLinha += 20

				        _TOConRS := 0
				 	    _TOIntRs := 0
				 	    _TOEliRS := 0
	                    _TOPWBRs := 0
	                    _TOPWPRs := 0
	                    _TOPMVRs := 0
           	    
	             	    qTGRUPO->(dbCloseArea())
	             
	    Endif
		qLGRUPO->(dbSkip())
        IncProc()         

        if Alltrim(_SltClas) != Alltrim(qLGRUPO->ZT4_CLAS)
		  	_Pagina := _Pagina + 1
			_SltClas := qLGRUPO->ZT4_CLAS
	      	if _Pagina <= 13
		      	oPrint:EndPage()
			  	nLinha:= 600   
			  	oPrint:StartPage()
			  	xCabec()
		  	Endif
	    Endif
    End	
   	qLGRUPO->(dbCloseArea())
	oPrint:Preview()
Return

Static Function xCabec()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o cabecalho da empresa. !³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SayBitmap(050,100,cFileLogo,1050,260)
	oPrint:Say(050,050,AllTrim( "Precious Woods Pará and Subsidiaries" ),oFont08)
    If qLGRUPO->ZT4_CLAS <= "04"
		oPrint:Say(090,050,AllTrim( "Balance Sheet" ), oFont07) 
		Else
		oPrint:Say(090,050,AllTrim( "Profit & Loss Statements " ), oFont07) 
	Endif	
	oPrint:Say(120,050,AllTrim( "As of"+" "+SUBSTR(DTOS(MV_PAR02),7,2)+" "+CMONTH(MV_PAR02)+" "+SUBSTR(DTOS(MV_PAR02),1,4) ), oFont07)
	oPrint:Say(120,2100,AllTrim("Page:"), oFont07)
	oPrint:Say(120,2295,AllTrim(Transform(_Pagina,"@E 999,999")), oFont07)
	oPrint:Line(150,050,150,2330)
	
	oPrint:Say(320,050, "Description", oFont07)
	oPrint:Say(320,610, "MembCode", oFont07)
	
	oPrint:Say(250,0800, "Consolidated", oFont07)
	oPrint:Line(275,760,275,0990)
	oPrint:Say(290,0800, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,0840,IIF(MV_PAR05 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,760,345,0990)

	oPrint:Say(250,1100, "Intercompany", oFont07)
	oPrint:Line(275,1060,275,1290)
	oPrint:Say(290,1100, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1150,IIF(MV_PAR05 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,1060,345,1290)

	oPrint:Say(250,1430, "PW Belem", oFont07)
	oPrint:Line(275,1360,275,1590)
	oPrint:Say(290,1400, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1450,IIF(MV_PAR05 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,1360,345,1590)

	oPrint:Say(250,1720, "PW Para", oFont07)
	oPrint:Line(275,1660,275,1890)
	oPrint:Say(290,1700, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1750,IIF(MV_PAR05 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,1660,345,1890)

	oPrint:Say(250,2020, "Monte Verde", oFont07)
	oPrint:Line(275,1960,275,2190)
	oPrint:Say(290,2000, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2050,IIF(MV_PAR05 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,1960,345,2190)

	nLinha := 380
	
Return


Static Function xVerPag()

	If	nLinha >= 3030 
		_Pagina := _Pagina + 1
        oPrint:EndPage()
		nLinha:= 600   
		oPrint:StartPage()
		xCabec()
	EndIf      

Return