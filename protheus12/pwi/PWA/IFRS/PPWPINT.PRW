#Include "PROTHEUS.CH"
#Include "TopConn.CH"

User Function PPWPINT()
	Local oReport
    
  	Private cPerg  := "PWPINT    "
  	Private cRel   := "Relatorio InteCompany"
	Private _DataC := GetMV("MV_DATAOLS") 
	
	Private _cTot    := ""
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
	Private _cTotalR1:= 0
	Private _cTotalU1:= 0	                 
	Private SAPWB    := 0
	Private SAPWP    := 0
	Private SAPMV    := 0
	Private _cSeq := ""
	
	Pergunte(cPerg, .F.)
	
	oReport := imprime()
	oReport:PrintDialog()      
Return           

Static Function imprime()
	Local oReport
	Local oSection
	Local oSubSec1
	
	oReport := TReport():New( cPerg, cRel, cPerg, { |oReport| PrintReport( oReport ) }, "Relatorio InteCompany" )    
	//oReport:SetLandScape(.T.)
	
	//oSection := TRSection():New(oReport,OemToAnsi("Teste de Impress�o"), {"qLGRUPO"} )	
	//oSection:SetHeaderPage(.F.)
	
	//TRCell():New(oSection, "ZT4_SEQ"  , "qLGRUPO", "Grupo"  , "@!"            , 40*3, .T. )	
	
	oSubSec1 := TRSection():New(oReport, OemToAnsi("Relatorio InteCompany"), {"qTGRUPO"} )	
	//oSubSec1:SetHeaderPage(.F.)

	TRCell():New(oSubSec1, "ZT5_DESC"  , "qTGRUPO", "Description"  , "@!"            , 20*3, .T. )
	TRCell():New(oSubSec1, "ZT5_CONTA" , "qTGRUPO", "MembCode"     , "@!"            , 10*3, .T. )
	TRCell():New(oSubSec1, "INTECRE"   , "qTGRUPO", "Consolidated" , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "INTEDEB"   , "qTGRUPO", "Intercompany" , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "SLDDPWB"   , "qTGRUPO", "PW Belem"     , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "SLDCPWB"   , "qTGRUPO", "PW Para"      , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "AJUCPWP"   , "qTGRUPO", "Monte Verde"  , "@E 999,999,999,999,999", 14*3, .T. )

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
		    _cQuery := " SELECT ZT5060.*, (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
			_cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "
	
			_cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
			_cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2070,CT1070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1070,CT2070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' " 
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' " 
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2080,CT1080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1080,CT2080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2090,CT1090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1090,CT2090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09'  "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV,  "
	    
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV "
	
			_cQuery += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
			//comente aqui
			TcQuery _cQuery Alias qTGRUPO new

						
			//Inicio da Impress�o					
			While ( !qTGRUPO->(Eof()) )
				SUGrupo := qTGRUPO->ZT5_GRUPO 
			
             	//DESCRI��O
             	if Alltrim(qLGRUPO->ZT4_TIPO) == "E" 				 	   
			    	oSubSec1:Cell("ZT5_DESC"):setValue("EX - " + PadL(qTGRUPO->ZT5_DESC,50))
		       	else
			    	oSubSec1:Cell("ZT5_DESC"):setValue(PadL(qTGRUPO->ZT5_DESC,50))
		       	endif
		    	
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(qTGRUPO->ZT5_CONTA, 6) )

				//MOVIMENTOS CONSOLIDADOS
		    	oSubSec1:Cell("INTECRE"):setValue( (((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05 )
	
				//INTERCOMPANY
		    	oSubSec1:Cell("INTEDEB"):setValue( (qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05 )

				//MOIVMENTOS CONTABEIS PWB
		    	oSubSec1:Cell("SLDDPWB"):setValue( ((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )*mv_par05 )

				//MOVIMENTOS CONTABEIS PWPAMA
		    	oSubSec1:Cell("SLDCPWB"):setValue( ((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )*mv_par05 )

				//MOVIMENTOS CONTABEIS PMV
		    	oSubSec1:Cell("AJUCPWP"):setValue( ((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )*mv_par05 )
				oSubSec1:PrintLine()

				if Alltrim(qLGRUPO->ZT4_TIPO) != "E" 				 	   
			 	    _SUConRS +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05
			 	    _SUIntRs +=(qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
                    _SUPWBRs +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )*mv_par05
                    _SUPWPRs +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )*mv_par05
                    _SUPMVRs +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )*mv_par05
				endif
		        
		        qTGRUPO->(dbSkip())
		    End	
		    
		    //oSubSec1:ThinLine()
		
			if Alltrim(qLGRUPO -> ZT4_TIPO) != "E"		    
		    	//DESCRI��O
		    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadL (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50) )
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(SUGrupo,6) )
				
				//MOVIMENTOS CONSOLIDADOS
		    	oSubSec1:Cell("INTECRE"):setValue( _SUConRs )
	
				//INTERCOMPANY
		    	oSubSec1:Cell("INTEDEB"):setValue( _SUIntRs )

				//MOIVMENTOS CONTABEIS PWB
		    	oSubSec1:Cell("SLDDPWB"):setValue( _SUPWBRs )

				//MOVIMENTOS CONTABEIS PWPAMA
		    	oSubSec1:Cell("SLDCPWB"):setValue( _SUPWPRs )

				//MOVIMENTOS CONTABEIS PMV
		    	oSubSec1:Cell("AJUCPWP"):setValue( _SUPMVRs )
				oSubSec1:PrintLine()
		        
			    oSubSec1:Cell("ZT5_DESC"):show()
			    oSubSec1:Cell("ZT5_CONTA"):show()
			    oSubSec1:Cell("INTECRE"):show()
			    oSubSec1:Cell("INTEDEB"):show()
			    oSubSec1:Cell("SLDDPWB"):show()
			    oSubSec1:Cell("SLDCPWB"):show()
			    oSubSec1:Cell("AJUCPWP"):show()
	
		        _SUConRS := 0
		 	    _SUIntRs := 0
		 	    _SUEliRS := 0
	            _SUPWBRs := 0
	            _SUPWPRs := 0
	            _SUPMVRs := 0

			    //oSubSec1:ThinLine()		        
	    	EndIf
	    
			qTGRUPO->(dbCloseArea())
			//finaliza comentario
		Elseif Alltrim(qLGRUPO -> ZT4_TIPO) == 'T'
	        _cQuery := " SELECT ZT5060.*,ZT1_CONTA, "
            _cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
            _cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "
            _cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
            _cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2070,CT1070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1070,CT2070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1070.D_E_L_E_T_<>'*' AND CT2070.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2080,CT1080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "

			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1080,CT2080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1080.D_E_L_E_T_<>'*' AND CT2080.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP,  "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2090,CT1090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1090,CT2090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1090.D_E_L_E_T_<>'*' AND CT2090.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV, "
    
            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV "

            _cQuery += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
   			TcQuery _cQuery Alias qTGRUPO new         
			
			//Inicio da Impress�o			
	 	    _TOConRS := 0
	 	    _TOIntRs := 0
            _TOPWBRs := 0
            _TOPWPRs := 0
            _TOPMVRs := 0

			While (!qTGRUPO->(Eof()))                                           
	 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
			
		 	    _TOConRS +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  )+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  )+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05
		 	    _TOIntRs +=(qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
                _TOPWBRs +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB)  ))*mv_par05
                _TOPWPRs +=(((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP)  ))*mv_par05
                _TOPMVRs +=(((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV)  ))*mv_par05
        
		        qTGRUPO->(dbSkip())
		    End	                   
		    
	    	//DESCRI��O
	    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadL(Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50) )
	    	//CONTA
	    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadL(TOGrupo,6) )
			
			//MOVIMENTOS CONSOLIDADOS
	    	oSubSec1:Cell("INTECRE"):setValue( _TOConRS )

			//INTERCOMPANY
	    	oSubSec1:Cell("INTEDEB"):setValue( _TOIntRs )

			//MOIVMENTOS CONTABEIS PWB
	    	oSubSec1:Cell("SLDDPWB"):setValue( _TOPWBRs )

			//MOVIMENTOS CONTABEIS PWPAMA
	    	oSubSec1:Cell("SLDCPWB"):setValue( _TOPWPRs )

			//MOVIMENTOS CONTABEIS PMV
	    	oSubSec1:Cell("AJUCPWP"):setValue( _TOPMVRs )
    	
		    oSubSec1:Cell("ZT5_DESC"):show()
		    oSubSec1:Cell("ZT5_CONTA"):show()
		    oSubSec1:Cell("INTECRE"):show()
		    oSubSec1:Cell("INTEDEB"):show()
		    oSubSec1:Cell("SLDDPWB"):show()
		    oSubSec1:Cell("SLDCPWB"):show()
		    oSubSec1:Cell("AJUCPWP"):show()
			oSubSec1:PrintLine()
	    
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
