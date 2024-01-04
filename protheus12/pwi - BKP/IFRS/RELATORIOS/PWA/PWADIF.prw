#Include "PROTHEUS.CH"
#include "topconn.ch"


User Function PWADIF()
	Private	lEnd := .f.
	Private _cQuery  := ""
	Private _cGrupoS :=""
	Private _cGrupoT :=""
	Private _cGrupoF :=""
	Private _cSuper  :=""
	Private _cTot    :=""
    Private _TOConRs := 0
    Private _TOConUs := 0
	Private _TOAjuRs := 0
    Private _TOAjuUs := 0
	Private _TOEliRs := 0
    Private _TOEliUs := 0
	Private _TOPwaRs := 0
    Private _TOPwaUs := 0
   	Private _TOMadRs := 0
    Private _TOMadUs := 0
   	Private _TOCilRs := 0
    Private _TOCilUs := 0
    Private	_SUConRs := 0
    Private	_SUConUs := 0
	Private	_SUAjuRs := 0
	Private	_SUAjuUs := 0
	Private	_SUEliRs := 0
	Private	_SUEliUs := 0
	Private	_SUPwaRs := 0
	Private	_SUPwaUs := 0
	Private	_SUMadRs := 0
	Private	_SUMadUs := 0
	Private	_SUCilRs := 0
	Private	_SUCilUs := 0
    Private	_EXConRs := 0
    Private	_EXConUs := 0
	Private	_EXAjuRs := 0
	Private	_EXAjuUs := 0
	Private	_EXEliRs := 0
	Private	_EXEliUs := 0
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
    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PWADIF    "

  	dbSelectArea("SX1")
  	dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data de      ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Data ate     ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Conta de     ?","mv_ch3","C",10,0,1,"G","","mv_par03","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Conta Ate    ?","mv_ch4","C",10,0,1,"G","","mv_par04","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Empresa      ?","mv_ch5","N",1,0,1, "C","","mv_par05","Mil Madeireira","","","Madama","","","Carolina","","","","","","","",""})
  	aadd(aPerg,{cPerg, "06", "Cambio       ?","mv_ch6","N",14,4,1,"G","","mv_par06","","","","","","","","","","","","","","",""}) 
  	
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
	oPrint		:= TMSPrinter():New(OemToAnsi("Relatorio BR GAAP x IFRS"))
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
	//³Define que a impressao                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SetPortrait()
	//oPrint:SetLandScape()	

		_cQuery1 := " select ZT4_SEQ,ZT4_GRUPO,ZT4_TIPO,ZT4_CLAS "
	    _cQuery1 += " FROM ZT4060  WHERE ZT4060.D_E_L_E_T_<>'*' AND ZT4_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	    _cQuery1 += " ORDER BY ZT4_CLAS,ZT4_SEQ ASC "
		
		TcQuery _cQuery1 Alias qLGRUPO new
		
     dbGoTop()
     Gauge := (qLGRUPO -> (RecCount())*2)
     ProcRegua( Gauge )	
    _SltClas := qLGRUPO->ZT4_CLAS    
	nContador := 1

	While (!qLGRUPO->(Eof()))
	    _cSeq := qLGRUPO->ZT4_SEQ

	    If Alltrim(qLGRUPO -> ZT4_TIPO) != "T" .and. Alltrim(qLGRUPO -> ZT4_TIPO) != ""
	
				    _cQuery2 := " SELECT ZT5060.*, 

				If MV_PAR05 == 1				    		   

					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2010,CT1010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1010,CT2010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "


			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA "
					
					Elseif MV_PAR05 == 2			

					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2040,CT1040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1040,CT2040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD "

					ElseIf MV_PAR05 == 3				    
						
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT2020,CT1020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_DEBITO AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "
			
					_cQuery2 += " (SELECT SUM(CT2_VALOR) FROM CT1020,CT2020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
					_cQuery2 += " CT1_CONTA=CT2_CREDIT AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
					_cQuery2 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02'  "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL,  "
			    
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL "
					
					Endif
				 			
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

							//BR GAAP
 							If MV_par05 == 1
								oPrint:Say(nLinha,0790, Transform(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) )*MV_PAR06, "@E 999,999,999,999"), oFont07)
 							Elseif MV_par05 == 2
								oPrint:Say(nLinha,0790, Transform(((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) )*MV_PAR06, "@E 999,999,999,999"), oFont07)
                            Elseif MV_par05 == 3
								oPrint:Say(nLinha,0790, Transform(((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL) )*MV_PAR06, "@E 999,999,999,999"), oFont07)
                            Endif

							//IFRS 
 							If MV_par05 == 1
								oPrint:Say(nLinha,1060, Transform(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )*MV_PAR06, "@E 999,999,999,999"), oFont07)
							Elseif MV_par05 == 2
								oPrint:Say(nLinha,1060, Transform(((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )*MV_PAR06, "@E 999,999,999,999"), oFont07)
							Elseif MV_par05 == 3
								oPrint:Say(nLinha,1060, Transform(((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )*MV_PAR06, "@E 999,999,999,999"), oFont07)
							Endif

                            
							//DIFERENÇA IFRS - BRGAAP
 							If MV_par05 == 1
 								oPrint:Say(nLinha,1340, Transform(-(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)*MV_PAR06, "@E 999,999,999,999"), oFont07)
				            ElseIf MV_par05 == 2
 								oPrint:Say(nLinha,1340, Transform(-(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)*MV_PAR06, "@E 999,999,999,999"), oFont07)
							ElseIf MV_par05 == 3
 								oPrint:Say(nLinha,1340, Transform(-(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)*MV_PAR06, "@E 999,999,999,999"), oFont07)
							Endif
							
							nLinha += 40

                           if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
	 							If MV_par05 == 1
							 	    _SUConRS +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )*MV_PAR06
				                    _SUPwaRs +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)  )*MV_PAR06
 	 							    _SUAjuRs +=(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)*MV_PAR06
	 							Elseif MV_par05 == 2
							 	    _SUConRS +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )*MV_PAR06
				                    _SUMadRs +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) )*MV_PAR06
   	 							    _SUAjuRs +=(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)*MV_PAR06
							 	Elseif MV_par05 == 3
							 	    _SUConRS +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )*MV_PAR06
				                    _SUCilRs +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)  )*MV_PAR06
   	 							    _SUAjuRs +=(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)*MV_PAR06
							 	Endif
		                        
	                       endif
	                            
					        qTGRUPO->(dbSkip())
				    End	
                    
                    if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
	             		oPrint:Line(nLinha,050,nLinha,1570)
						nLinha += 20

						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(SUGrupo,6), oFont07)


						//BR GAAP
						If MV_par05 == 1
							oPrint:Say(nLinha,0790, Transform(_SUPwaRs, "@E 999,999,999,999"), oFont07)
                        Elseif MV_par05 == 2  
							oPrint:Say(nLinha,0790, Transform(_SUMadRs, "@E 999,999,999,999"), oFont07)
                        Elseif MV_par05 == 3
							oPrint:Say(nLinha,0790, Transform(_SUCilRs, "@E 999,999,999,999"), oFont07)
                        Endif
                        
						
						//SUBTOTAL IFRS
						oPrint:Say(nLinha,1060, Transform(_SUConRs, "@E 999,999,999,999"), oFont07)
						

						//SUBTOTOTAL DIFERENÇA IFRS - BRGAAP
						oPrint:Say(nLinha,1340, Transform(-_SUAjuRs, "@E 999,999,999,999"), oFont07)

						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,1570)
	   				    nLinha += 20

				        _SUConRS := 0
				 	    _SUAjuRs := 0
	                    _SUPwaRs := 0
	                    _SUMadRs := 0
	                    _SUCilRs := 0

	                endif
   	                qTGRUPO->(dbCloseArea())
   	                
	    Elseif Alltrim(qLGRUPO -> ZT4_TIPO) =='T'
	             
	                _cQuery3 := " SELECT ZT5060.*,ZT1_CONTA, "

				If MV_PAR05 == 1				    		   	                
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2010,CT1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1010,CT2010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
   	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA "
	
	                
				ElseIf MV_PAR05 == 2   
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2040,CT1040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
   	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1040,CT2040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
   	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD,  "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD "
	
	                
				ElseIf MV_PAR05 == 3	                
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT2020,CT1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_DEBITO AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
   	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "
	
	                _cQuery3 += " (SELECT SUM(CT2_VALOR) FROM CT1020,CT2020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
	                _cQuery3 += " CT1_CONTA=CT2_CREDIT AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
   	                _cQuery3 += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
	                _cQuery3 += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL, "
	    
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL "
	             Endif   
	                
	                _cQuery3 += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery3 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
                            xVerPag()
							
							If MV_par05 == 1 
					 	    	_TOConRS +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )*MV_PAR06
 						 	    _TOAjuRs +=(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)*MV_PAR06
   			                    _TOPwaRs +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) )*MV_PAR06
							Elseif MV_par05 == 2 
								_TOConRS +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )*MV_PAR06
 						 	    _TOAjuRs +=(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)*MV_PAR06
			                    _TOMadRs +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) )*MV_PAR06
							Elseif MV_par05 == 3
								_TOConRS +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )*MV_PAR06
 						 	    _TOAjuRs +=(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)*MV_PAR06
			                    _TOCilRs +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL) )*MV_PAR06
							Endif
		                    
					        qTGRUPO->(dbSkip())
				    
				    End	
	             		oPrint:Line(nLinha,050,nLinha,1570)
						nLinha += 20
						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(TOGrupo,6), oFont07)

						//SUBTOTAIS - BR GAAP
						If MV_par05 == 1
							oPrint:Say(nLinha,0790, Transform(_TOPwaRs, "@E 999,999,999,999"), oFont07)
						Elseif MV_par05 == 2
							oPrint:Say(nLinha,0790, Transform(_TOMadRs, "@E 999,999,999,999"), oFont07)
						Elseif MV_par05 == 3 
							oPrint:Say(nLinha,0790, Transform(_TOCilRs, "@E 999,999,999,999"), oFont07)
						Endif

						//SUBTOTAIS - IFRS
						    oPrint:Say(nLinha,1060, Transform(_TOConRs, "@E 999,999,999,999"), oFont07)

						//SUBTOTAIS DIFERENÇA IFRS - BRGAAP
						oPrint:Say(nLinha,1340, Transform(-_TOAjuRs, "@E 999,999,999,999"), oFont07)

						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,1570)
	   				    nLinha += 20
				        _TOConRS := 0
				 	    _TOAjuRs := 0
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
	oPrint:Say(050,050, IIF(MV_par05==1,"Mil Madeireira Itacoatiara Ltda",IIF(MV_par05==2,"Madeiras Preciosas da Amazonia","Carolina Industria Ltda" )),oFont08)
	oPrint:Say(090,050,AllTrim( "Difference BR GAAP x IFRS" ), oFont07) 
	oPrint:Say(120,050,AllTrim( "As of"+" "+SUBSTR(DTOS(MV_PAR02),7,2)+" "+CMONTH(MV_PAR02)+" "+SUBSTR(DTOS(MV_PAR02),1,4) ), oFont07)
	oPrint:Say(120,2100,AllTrim("Page:"), oFont07)
	oPrint:Say(120,2295,AllTrim(Transform(_Pagina,"@E 999,999")), oFont07)
	oPrint:Line(150,050,150,2300)
	
	oPrint:Say(320,050, "Description", oFont07)
	oPrint:Say(320,610, "MembCode", oFont07)
	
	oPrint:Say(250,850, "BR GAAP", oFont07)
	oPrint:Line(275,760,275,1000)
	oPrint:Say(290,0820, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,0860, IIF(MV_PAR06 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,760,345,1000)

	oPrint:Say(250,1120, "IFRS", oFont07)
	oPrint:Line(275,1030,275,1270)
	oPrint:Say(290,1090, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1130, IIF(MV_PAR06 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,1030,345,1270)

	oPrint:Say(250,1390, "Difference", oFont07)
	oPrint:Line(275,1300,275,1570)
	oPrint:Say(290,1370, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1410, IIF(MV_PAR06 <= 1,"BRL","USD"), oFont07)
	oPrint:Line(345,1300,345,1570)

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