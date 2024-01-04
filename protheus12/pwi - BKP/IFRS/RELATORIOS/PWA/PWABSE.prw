#include "topconn.ch"

User Function PWABSE()
	Private	lEnd := .f.
	Private _cQuery  := ""
	Private _cGrupoS :=""
	Private _cGrupoT :=""
	Private _cGrupoF :=""
	Private _cSuper  :=""
	Private _cTot    :=""
	Private	_TOConRs := 0
	Private _TOPwaRs := 0
    Private _TOPwaUs := 0
   	Private _TOMadRs := 0
    Private _TOMadUs := 0
   	Private _TOCilRs := 0
    Private _TOCilUs := 0
	Private	_SUConRs := 0
	Private	_SUPwaRs := 0
	Private	_SUPwaUs := 0
	Private	_SUMadRs := 0
	Private	_SUMadUs := 0
	Private	_SUCilRs := 0
	Private	_SUCilUs := 0
	Private	_EXPwaRs := 0
	Private	_EXPwaUs := 0
	Private	_EXMadRs := 0
	Private	_EXMadUs := 0
	Private	_EXCilRs := 0
	Private	_EXCilUs := 0
    Private _VldClas := .F.
    Private _Cambio  := 0
    Private _Pagina  := 0
	Private _DataC   := GetMV("MV_DATAOLS") 
	Private qOLS     := ""
	Private _cTotalR1:= 0
	Private _cTotalU1:= 0	
	Private mv_par05 :=""
	Private mv_par06 :=""
    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PWABSE    "

  	dbSelectArea("SX1")
  	dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data de      ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Data ate     ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Conta de     ?","mv_ch3","C",10,0,1,"G","","mv_par03","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Conta Ate    ?","mv_ch4","C",10,0,1,"G","","mv_par04","","ZT1","","","","","","","","","","","","",""})
  	 
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
			Replace X1_DEF03    with aPerg[nA][18]
			Replace X1_DEFSPA1  with aPerg[nA][12]
			Replace X1_DEFSPA2  with aPerg[nA][15]
			Replace X1_DEFSPA2  with aPerg[nA][18]
			Replace X1_DEFENG1  with aPerg[nA][12]
			Replace X1_DEFENG2  with aPerg[nA][15]
			Replace X1_DEFENG3  with aPerg[nA][18]
			Replace X1_F3       with aPerg[nA][13]
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
	oPrint		:= TMSPrinter():New(OemToAnsi("Relatorio de OLS"))
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
	ProcRegua( 500 )

	_Cambio := MV_PAR05
    _SltClas := qLGRUPO->ZT4_CLAS    
	nContador := 1

	While (!qLGRUPO->(Eof()))
	    _cSeq := qLGRUPO->ZT4_SEQ
	
	    If Alltrim(qLGRUPO -> ZT4_TIPO) != "T" .and. Alltrim(qLGRUPO -> ZT4_TIPO) != ""
				    
				    _cQuery2 := " SELECT ZT5060.*,(SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "
			   
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2010,CT1010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1010,CT2010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "
			
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2040,CT1040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1040,CT2040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "
			
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2020,CT1020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1020,CT2020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02'  "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL,  "
			    
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL "
			
				 			
					_cQuery2 += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery2 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        SUGrupo := qTGRUPO->ZT5_GRUPO 
                            xVerPag()
                            
                            //CONDICIONAMENTO DA TAXA DO DOLAR
							if Alltrim(qTGRUPO->ZT5_CONTA) < "500000"
								_Cambio := MV_PAR05
							elseif Alltrim(qTGRUPO->ZT5_CONTA) >= "500000" .and. Alltrim(qTGRUPO->ZT5_CONTA) < "699999"
								_Cambio := MV_PAR06
							elseif Alltrim(qTGRUPO->ZT5_CONTA) = "800000"
							    _Cambio := MV_PAR06
							else 
						    _Cambio := 0	
							endif					 	   						 	   		
							//DESCRICAO E CONTA OLS
                           if Alltrim(qLGRUPO -> ZT4_TIPO) == "E" 				 	   
						        oPrint:Say(nLinha,0050, "EX - " + PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       else
								oPrint:Say(nLinha,0050, PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       endif
							oPrint:Say(nLinha,0610, PadR(qTGRUPO->ZT5_CONTA,6), oFont07)

							//MOIVMENTOS CONTABEIS CONSOLODATED
							oPrint:Say(nLinha,850, Transform((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  +(qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  +(qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)   , "@E 999,999,999,999"), oFont07)
							//MOIVMENTOS CONTABEIS PWA
							oPrint:Say(nLinha,1250, Transform((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  , "@E 999,999,999,999"), oFont07)
							//MOVIMENTOS CONTABEIS MADAMA
							oPrint:Say(nLinha,1650, Transform((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  , "@E 999,999,999,999"), oFont07)
							//MOVIMENTOS CONTABEIS CIL
							oPrint:Say(nLinha,2050, Transform((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)   , "@E 999,999,999,999"), oFont07)
				
							nLinha += 40
                                    

                           if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
                                _SUConRs += (qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  +(qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  +(qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)   
			                    _SUPwaRs +=(qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  
			                    _SUMadRs +=(qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  
			                    _SUCilRs +=(qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)   

	                       endif
	                            
					        qTGRUPO->(dbSkip())
				    End	
                    
                    if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
	             		oPrint:Line(nLinha,050,nLinha,2330)
						nLinha += 20
						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(SUGrupo,6), oFont07)
						//SUBTOTAL CONSOLIDATED
						oPrint:Say(nLinha,0850, Transform(_SUConRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWA
						oPrint:Say(nLinha,1250, Transform(_SUPwaRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL MADAMA
						oPrint:Say(nLinha,1650, Transform(_SUMadRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL CIL
						oPrint:Say(nLinha,2050, Transform(_SUCilRs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,2330)
	   				    nLinha += 20

	                    _SUConRs := 0
	                    _SUPwaRs := 0
	                    _SUMadRs := 0
	                    _SUCilRs := 0
	                endif
   	                qTGRUPO->(dbCloseArea())
   	                
	    Elseif Alltrim(qLGRUPO -> ZT4_TIPO) =='T'
	             
	                _cQuery3 := " SELECT ZT5060.*,ZT1_CONTA, "

	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2010,CT1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1010,CT2010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "
	
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2040,CT1040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1040,CT2040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD,  "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "
	
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2020,CT1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1020,CT2020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL, "
	    
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL "
	
	                
	                _cQuery3 += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery3 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
                            xVerPag()
                                   	                   
		                    _TOConRs += (qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  +(qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  +(qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)   
		                    _TOPwaRs +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )
		                    _TOMadRs +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )
		                    _TOCilRs +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)   )
		                    
					        qTGRUPO->(dbSkip())
				    
				    End	
	             		oPrint:Line(nLinha,050,nLinha,2330)
						nLinha += 20
						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(TOGrupo,6), oFont07)
						//SUBTOTAL CONSOLIDATED
						oPrint:Say(nLinha,0850, Transform(_TOConRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWA
						oPrint:Say(nLinha,1250, Transform(_TOPwaRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL MADAMA
						oPrint:Say(nLinha,1650, Transform(_TOMadRs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL CIL
						oPrint:Say(nLinha,2050, Transform(_TOCilRs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,2330)
	   				    nLinha += 20
                        
                        _TOConRs := 0             
                        _TOPwaRs := 0
	                    _TOPwaRs := 0
	                    _TOMadRs := 0
	                    _TOCilRs := 0
	             	    
	             	    qTGRUPO->(dbCloseArea())
	             
	    Endif
		qLGRUPO->(dbSkip())
        IncProc()         

        if Alltrim(_SltClas) != Alltrim(qLGRUPO->ZT4_CLAS)
		  	_Pagina := _Pagina + 1
			_SltClas := qLGRUPO->ZT4_CLAS
	      	if _Pagina <= 11
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
	oPrint:Say(050,050,AllTrim( "Precious Woods Amazon and Subsidiaries" ),oFont08)
    If qLGRUPO->ZT4_CLAS <= "04"
		oPrint:Say(090,050,AllTrim( "Balance Sheet - P&L" ), oFont07) 
		Else
		oPrint:Say(090,050,AllTrim( "Profit and Loss Statements " ), oFont07) 
	Endif	
	oPrint:Say(090,2100,AllTrim( "BRL" ), oFont07)
	oPrint:Say(120,050,AllTrim( "As of"+" "+SUBSTR(DTOS(MV_PAR02),7,2)+" "+CMONTH(MV_PAR02)+" "+SUBSTR(DTOS(MV_PAR02),1,4) ), oFont07)
	oPrint:Say(120,2100,AllTrim("Page:"), oFont07)
	oPrint:Say(120,2295,AllTrim(Transform(_Pagina,"@E 999,999")), oFont07)
	oPrint:Line(150,050,150,2330)
	
	oPrint:Say(320,050, "Description", oFont07)
	oPrint:Say(320,610, "MembCode", oFont07)
	
	oPrint:Say(250,0890, "Consolidated", oFont07)
	oPrint:Line(275,760,275,1130)
	oPrint:Say(290,0880, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,0920, "BRL", oFont07)
	oPrint:Line(345,760,345,1130)
	
	oPrint:Say(250,1280, "Mil Madeireira", oFont07)
	oPrint:Line(275,1160,275,1530)
	oPrint:Say(290,1280, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1320, "BRL", oFont07)
	oPrint:Line(345,1160,345,1530)

	oPrint:Say(250,1700, "Madama", oFont07)
	oPrint:Line(275,1560,275,1930)
	oPrint:Say(290,1680, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1720, "BRL", oFont07)
	oPrint:Line(345,1560,345,1930)

	oPrint:Say(250,2100, "Carolina", oFont07)
	oPrint:Line(275,1960,275,2330)
	oPrint:Say(290,2080, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2120, "BRL", oFont07)
	oPrint:Line(345,1960,345,2330)	
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