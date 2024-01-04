#Include "PROTHEUS.CH"
#Include "TopConn.CH"

User Function PPWPDIF()
	Local oReport
    
  	Private cPerg  := "PWPDIF    "
  	Private cRel   := "Relatorio BR GAAP x IFRS"
	Private _DataC := GetMV("MV_DATAOLS") 
	Private _cTot    := ""

    Private _TOConRs := 0
    Private _TOConUs := 0
	Private _TOAjuRs := 0
    Private _TOAjuUs := 0
	Private _TOEliRs := 0
    Private _TOEliUs := 0
	Private _TOPWBRs := 0
    Private _TOPWBUs := 0
   	Private _TOPWPRs := 0
    Private _TOPWPUs := 0
   	Private _TOPMVRs := 0
    Private _TOPMVUs := 0
    Private	_SUConRs := 0
    Private	_SUConUs := 0
	Private	_SUAjuRs := 0
	Private	_SUAjuUs := 0
	Private	_SUEliRs := 0
	Private	_SUEliUs := 0
	Private	_SUPWBRs := 0
	Private	_SUPWBUs := 0
	Private	_SUPWPRs := 0
	Private	_SUPWPUs := 0
	Private	_SUPMVRs := 0
	Private	_SUPMVUs := 0
    Private	_EXConRs := 0
    Private	_EXConUs := 0
	Private	_EXAjuRs := 0
	Private	_EXAjuUs := 0
	Private	_EXEliRs := 0
	Private	_EXEliUs := 0
	Private	_EXPWBRs := 0
	Private	_EXPWBUs := 0
	Private	_EXPWPRs := 0
	Private	_EXPWPUs := 0
	Private	_EXPMVRs := 0
	Private	_EXPMVUs := 0

	Private _cSeq := ""
	
	Pergunte(cPerg, .F.)
	
	oReport := imprime()
	oReport:PrintDialog()      
Return           

Static Function imprime()
	Local oReport
	Local oSection
	Local oSubSec1
	
	oReport := TReport():New( cPerg, cRel, cPerg, { |oReport| PrintReport( oReport ) }, "Relatorio BR GAAP x IFRS" )    
	//oReport:SetLandScape(.T.)
	
	//oSection := TRSection():New(oReport,OemToAnsi("Teste de Impressão"), {"qLGRUPO"} )	
	//oSection:SetHeaderPage(.F.)
	
	//TRCell():New(oSection, "ZT4_SEQ"  , "qLGRUPO", "Grupo"  , "@!"            , 40*3, .T. )	
	
	oSubSec1 := TRSection():New(oReport, OemToAnsi("Relatorio BR GAAP x IFRS"), {"qTGRUPO"} )	
	//oSubSec1:SetHeaderPage(.F.)

	TRCell():New(oSubSec1, "ZT5_DESC"  , "qTGRUPO", "Description"  , "@!"            , 40*3, .T. )
	TRCell():New(oSubSec1, "ZT5_CONTA" , "qTGRUPO", "MembCode"     , "@!"            , 10*3, .T. )
	TRCell():New(oSubSec1, "SLDDPWB"   , "qTGRUPO", "BR GAAP"      , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "SLDCPWB"   , "qTGRUPO", "IFRS"         , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "AJUDPWB"   , "qTGRUPO", "Difference"   , "@E 999,999,999,999,999", 14*3, .T. )

	//Quebra de Grupo
	//oBreak := TRBreak():New(oSubSec1, oSubSec1:Cell("ZT5_CONTA"), "Total de Registros")
	//TRFunction():New(oSection:Cell("TOTAL"), NIL, "SUM")
	//TRFunction():New(oSection:Cell("GUSTAVO"), NIL, "COUNT")
Return oReport

Static Function PrintReport( oReport )
	//Local oSection1 := oReport:Section( 1 )
	Local oSubSec1 := oReport:Section(1)
	Local _cQuery := ""
	Local _nQuant := 0
	            
	_cQuery := " SELECT COUNT(*) AS QUANT "
    _cQuery += " FROM ZT4060 WHERE ZT4060.D_E_L_E_T_ <> '*' AND ZT4_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	TcQuery _cQuery Alias qQTD new

	dbSelectArea("qQTD")
	if !qQTD->(EOF())
		_nQuant := qQTD->QUANT
	EndIf

	_cQuery := " SELECT ZT4_SEQ, ZT4_GRUPO, ZT4_TIPO, ZT4_CLAS "
    _cQuery += " FROM ZT4060 WHERE ZT4060.D_E_L_E_T_ <> '*' AND ZT4_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
    _cQuery += " ORDER BY ZT4_CLAS, ZT4_SEQ ASC "
	TcQuery _cQuery Alias qLGRUPO new
	            
	oReport:SetMeter( _nQuant )

	Do While !qLGRUPO->(EOF())
		If oReport:Cancel()
			Exit
		EndIf
	
		_cSeq := qLGRUPO->ZT4_SEQ
		oSubSec1:Init()

		
		If Alltrim(qLGRUPO -> ZT4_TIPO) != "T" .and. Alltrim(qLGRUPO -> ZT4_TIPO) != ""
			_cQuery := " SELECT ZT5060.*, 

			If MV_PAR05 == 1				    		   
				_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2070,CT1070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
				_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
				_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
				_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "
		
				_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1070,CT2070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
				_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
				_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
				_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "
		
				_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' " 
				_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "
		
				_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' " 
				_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB "
			Elseif MV_PAR05 == 2			
				_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2080,CT1080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
				_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
				_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
				_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "
		
				_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1080,CT2080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
				_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
				_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
				_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "
		
				_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
				_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP, "
		
				_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
				_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP "
			ElseIf MV_PAR05 == 3				    
				_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2090,CT1090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
				_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
				_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
				_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "
		
				_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1090,CT2090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
				_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
				_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
				_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "
		
				_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09'  "
				_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV,  "
		    
				_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
				_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV "
			Endif
		 			
			_cQuery += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "

			//comente aqui
			TcQuery _cQuery Alias qTGRUPO new

						
			//Inicio da Impressão					
			While ( !qTGRUPO->(Eof()) )
				SUGrupo := qTGRUPO->ZT5_GRUPO 
			                   
             	//DESCRICAO E CONTA OLS
             	if Alltrim(qLGRUPO->ZT4_TIPO) == "E" 				 	   
			    	oSubSec1:Cell("ZT5_DESC"):setValue("EX - " + PadR(qTGRUPO->ZT5_DESC,50))
		       	else
			    	oSubSec1:Cell("ZT5_DESC"):setValue(PadR(qTGRUPO->ZT5_DESC,50))
		       	endif
		    	
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(qTGRUPO->ZT5_CONTA,6) )

				//SUBTOTAIS - BR GAAP
 				If MV_par05 == 1
			    	oSubSec1:Cell("SLDDPWB"):setValue( ((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB) )*MV_PAR06 )
	 			Elseif MV_par05 == 2
			    	oSubSec1:Cell("SLDDPWB"):setValue( ((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP) )*MV_PAR06 )
	            Elseif MV_par05 == 3
			    	oSubSec1:Cell("SLDDPWB"):setValue( ((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV) )*MV_PAR06 )
				Endif
	
				//SUBTOTAIS - IFRS
 				If MV_par05 == 1
			    	oSubSec1:Cell("SLDCPWB"):setValue( ((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )*MV_PAR06 )
	 			Elseif MV_par05 == 2
			    	oSubSec1:Cell("SLDCPWB"):setValue( ((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )*MV_PAR06 )
	            Elseif MV_par05 == 3
			    	oSubSec1:Cell("SLDCPWB"):setValue( ((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )*MV_PAR06 )
				Endif

				//SUBTOTAIS DIFERENÇA IFRS - BRGAAP
 				If MV_par05 == 1
			    	oSubSec1:Cell("AJUDPWB"):setValue( -(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)*MV_PAR06 )
	 			Elseif MV_par05 == 2
			    	oSubSec1:Cell("AJUDPWB"):setValue( -(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)*MV_PAR06 )
	            Elseif MV_par05 == 3
			    	oSubSec1:Cell("AJUDPWB"):setValue( -(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)*MV_PAR06 )
				Endif
				oSubSec1:PrintLine()


                if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
					If MV_par05 == 1
			 	    	_SUConRS +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )*MV_PAR06
     					_SUAjuRs +=(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)
                    	_SUPWBRs +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)  )*MV_PAR06
					Elseif MV_par05 == 2
			 	    	_SUConRS +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )
			 	    	_SUAjuRs +=(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)
                    	_SUPWPRs +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP) )*MV_PAR06
			 		Elseif MV_par05 == 3
			 	    	_SUConRS +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )
			 	    	_SUAjuRs +=(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)
                    	_SUPMVRs +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)  )*MV_PAR06
			 		Endif
				endif

		        qTGRUPO->(dbSkip())
		    End	
		    
		    //oSubSec1:ThinLine()
		
			if Alltrim(qLGRUPO -> ZT4_TIPO) != "E"		    
		    	//DESCRIÇÃO
		    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50) )
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(SUGrupo,6) )
				
				//SUBTOTAIS - BR GAAP
 				If MV_par05 == 1
			    	oSubSec1:Cell("SLDDPWB"):setValue( _SUPWBRs )
	 			Elseif MV_par05 == 2
			    	oSubSec1:Cell("SLDDPWB"):setValue( _SUPWPRs )
	            Elseif MV_par05 == 3
			    	oSubSec1:Cell("SLDDPWB"):setValue( _SUPMVRs )
				Endif
	
				//SUBTOTAIS - IFRS
		    	oSubSec1:Cell("SLDCPWB"):setValue( _SUConRs )

		    	oSubSec1:Cell("AJUDPWB"):setValue( -_SUAjuRs )
				oSubSec1:PrintLine()
		        
			    oSubSec1:Cell("ZT5_DESC"):show()
			    oSubSec1:Cell("ZT5_CONTA"):show()
			    oSubSec1:Cell("SLDDPWB"):show()
			    oSubSec1:Cell("SLDCPWB"):show()
			    oSubSec1:Cell("AJUDPWB"):show()
	
		        _SUConRS := 0
		 	    _SUAjuRs := 0
				_SUPWBRs := 0
				_SUPWPRs := 0
				_SUPMVRs := 0

			    //oSubSec1:ThinLine()		        
	    	EndIf
	    
			qTGRUPO->(dbCloseArea())
			//finaliza comentario
		Elseif Alltrim(qLGRUPO -> ZT4_TIPO) == 'T'
            _cQuery := " SELECT ZT5060.*,ZT1_CONTA, "

			If MV_PAR05 == 1				    		   	                
                _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2070,CT1070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
                _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
                _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
                _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "

                _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1070,CT2070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
                _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
                _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
                _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "

                _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' "
                _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "

                _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' "
                _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB "
			ElseIf MV_PAR05 == 2   
                _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2080,CT1080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
                _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
                _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
                _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "

                _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1080,CT2080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
                _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
                _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
                _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "

                _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
                _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP,  "

                _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
                _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP "
			ElseIf MV_PAR05 == 3	                
                _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2090,CT1090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
                _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
                _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
                _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "

                _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1090,CT2090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
                _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
                _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
                _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "

                _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09' "
                _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV, "
				_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
               	_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV "
            Endif   
                
			_cQuery += " FROM ZT5060, ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "

   			TcQuery _cQuery Alias qTGRUPO new         
			
			//Inicio da Impressão			

			While (!qTGRUPO->(Eof()))                                           
	 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
			
				If MV_par05 == 1 
		 	    	_TOConRS +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )
					_TOAjuRs +=(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)
					_TOPWBRs +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB) )
				Elseif MV_par05 == 2 
					_TOConRS +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )
 					_TOAjuRs +=(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)
                    _TOPWPRs +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP) )
				Elseif MV_par05 == 3
					_TOConRS +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )
 					_TOAjuRs +=(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)
                    _TOPMVRs +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV) )
				Endif

        
		        qTGRUPO->(dbSkip())
		    End	                   
		    
	    	//DESCRIÇÃO
	    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50) )
	    	//CONTA
	    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(SUGrupo,6) )
			
			//SUBTOTAIS - BR GAAP
 			If MV_par05 == 1
		    	oSubSec1:Cell("SLDDPWB"):setValue( _TOPWBRs )
 			Elseif MV_par05 == 2
		    	oSubSec1:Cell("SLDDPWB"):setValue( _TOPWPRs )
            Elseif MV_par05 == 3
		    	oSubSec1:Cell("SLDDPWB"):setValue( _TOPMVRs )
			Endif

			//SUBTOTAIS - IFRS
	    	oSubSec1:Cell("SLDCPWB"):setValue( _SUConRs )

	    	oSubSec1:Cell("AJUDPWB"):setValue( -_SUAjuRs )
			oSubSec1:PrintLine()
	        
		    oSubSec1:Cell("ZT5_DESC"):show()
		    oSubSec1:Cell("ZT5_CONTA"):show()
		    oSubSec1:Cell("SLDDPWB"):show()
		    oSubSec1:Cell("SLDCPWB"):show()
		    oSubSec1:Cell("AJUDPWB"):show()

	        _SUConRS := 0
	 	    _SUAjuRs := 0
			_SUPWBRs := 0
			_SUPWPRs := 0
			_SUPMVRs := 0
    
			qTGRUPO->(dbCloseArea())		
		EndIf
		
		qLGRUPO->( dbSkip() )
		
		oReport:IncMeter()
	EndDo

    oSubSec1:finish()
	
	//Finalizando Query
	qQTD->(dbCloseArea())
	qLGRUPO->(dbCloseArea())
Return nil
