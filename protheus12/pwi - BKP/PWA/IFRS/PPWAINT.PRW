#Include "PROTHEUS.CH"
#Include "TopConn.CH"

User Function PPWAINT()
	Local oReport
    
  	Private cPerg  := "PWAINT    "
  	Private cRel   := "Relatorio InteCompany"
	Private _DataC := GetMV("MV_DATAOLS") 
	
	Private _cTot    := ""
    Private _TOConRs := 0
	Private _TOIntRs := 0
	Private _TOPWBRs := 0
   	Private _TOPWPRs := 0
   	Private _TOPMVRs := 0
   	Private _TOIntRs := 0
   	Private _TOPwaRs := 0
   	Private _TOMadRs := 0
   	Private _TOCilRs := 0
    Private	_SUConRs := 0
	Private	_SUIntRs := 0
	Private	_SUPWBRs := 0
	Private _SUMadRs := 0
	Private	_SUPWPRs := 0
	Private	_SUPMVRs := 0
	Private _SUPwaRs := 0
	Private _SUCilRs := 0
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
	
	//oSection := TRSection():New(oReport,OemToAnsi("Teste de Impressão"), {"qLGRUPO"} )	
	//oSection:SetHeaderPage(.F.)
	
	//TRCell():New(oSection, "ZT4_SEQ"  , "qLGRUPO", "Grupo"  , "@!"            , 40*3, .T. )	
	
	oSubSec1 := TRSection():New(oReport, OemToAnsi("Relatorio InteCompany"), {"qTGRUPO"} )	
	//oSubSec1:SetHeaderPage(.F.)

	TRCell():New(oSubSec1, "ZT5_DESC"  , "qTGRUPO", "Description"  , "@!"            , 40*3, .T. )
	TRCell():New(oSubSec1, "ZT5_CONTA" , "qTGRUPO", "MembCode"     , "@!"            , 10*3, .T. )
	TRCell():New(oSubSec1, "INTECRE"   , "qTGRUPO", "Consolidated" , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "INTEDEB"   , "qTGRUPO", "Intercompany" , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "SLDDPWA"   , "qTGRUPO", "MIL"          , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "SLDCPWA"   , "qTGRUPO", "Madama"       , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "AJUCPWA"   , "qTGRUPO", "Carolina"     , "@E 999,999,999,999,999", 14*3, .T. )

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
			_cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "
	
			_cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
			_cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2010,CT1010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1010,CT2010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' " 
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' " 
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2040,CT1040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND  "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1040,CT2040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND  "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2020,CT1020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1020,CT2020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02'  "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL,  "
	    
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL "
	
			_cQuery += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
			//comente aqui
			TcQuery _cQuery Alias qTGRUPO new

						
			//Inicio da Impressão					
			While ( !qTGRUPO->(Eof()) )
				SUGrupo := qTGRUPO->ZT5_GRUPO 
			
             	//DESCRIÇÃO
             	if Alltrim(qLGRUPO->ZT4_TIPO) == "E" 				 	   
			    	oSubSec1:Cell("ZT5_DESC"):setValue("EX - " + PadR(qTGRUPO->ZT5_DESC,50))
		       	else
			    	oSubSec1:Cell("ZT5_DESC"):setValue(PadR(qTGRUPO->ZT5_DESC,50))
		       	endif
		    	
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(qTGRUPO->ZT5_CONTA,6) )

				//MOVIMENTOS CONSOLIDADOS
		    	oSubSec1:Cell("INTECRE"):setValue( (((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05 )
	
				//INTERCOMPANY
		    	oSubSec1:Cell("INTEDEB"):setValue( (qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05 )

				//MOIVMENTOS CONTABEIS PWB
		    	oSubSec1:Cell("SLDDPWA"):setValue( ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )*mv_par05 )

				//MOVIMENTOS CONTABEIS PWPAMA
		    	oSubSec1:Cell("SLDCPWA"):setValue( ((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )*mv_par05 )

				//MOVIMENTOS CONTABEIS PMV
		    	oSubSec1:Cell("AJUCPWA"):setValue( ((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )*mv_par05 )
				oSubSec1:PrintLine()

				if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
			 	    _SUConRS +=(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05
			 	    _SUIntRs +=(qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
	                _SUPwaRs +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )*mv_par05
	                _SUMadRs +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )*mv_par05
	                _SUCilRs +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )*mv_par05
                endif
	        
		        qTGRUPO->(dbSkip())
		    End	
		    
		    //oSubSec1:ThinLine()
		
			if Alltrim(qLGRUPO -> ZT4_TIPO) != "E"		    
		    	//DESCRIÇÃO
		    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50) )
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(SUGrupo,6) )
				
				//MOVIMENTOS CONSOLIDADOS
		    	oSubSec1:Cell("INTECRE"):setValue( _SUConRs )
	
				//INTERCOMPANY
		    	oSubSec1:Cell("INTEDEB"):setValue( _SUIntRs )

				//MOIVMENTOS CONTABEIS PWB
		    	oSubSec1:Cell("SLDDPWA"):setValue( _SUPwaRs )

				//MOVIMENTOS CONTABEIS PWPAMA
		    	oSubSec1:Cell("SLDCPWA"):setValue( _SUMadRs )

				//MOVIMENTOS CONTABEIS PMV
		    	oSubSec1:Cell("AJUCPWA"):setValue( _SUCilRs )
		        
			    oSubSec1:Cell("ZT5_DESC"):show()
			    oSubSec1:Cell("ZT5_CONTA"):show()
			    oSubSec1:Cell("INTECRE"):show()
			    oSubSec1:Cell("INTEDEB"):show()
			    oSubSec1:Cell("SLDDPWA"):show()
			    oSubSec1:Cell("SLDCPWA"):show()
			    oSubSec1:Cell("AJUCPWA"):show()
				oSubSec1:PrintLine()
	
		        _SUConRS := 0
		 	    _SUIntRs := 0
		 	    _SUEliRS := 0
                _SUPwaRs := 0
                _SUMadRs := 0
                _SUCilRs := 0

			    //oSubSec1:ThinLine()		        
	    	EndIf
	    
			qTGRUPO->(dbCloseArea())
			//finaliza comentario
		Elseif Alltrim(qLGRUPO -> ZT4_TIPO) == 'T'
			_cQuery := " SELECT ZT5060.*,ZT1_CONTA, "
            _cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
            _cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "

            _cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
            _cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2010,CT1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1010,CT2010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1010.D_E_L_E_T_<>'*' AND CT2010.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2040,CT1040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND   CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1040,CT2040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1040.D_E_L_E_T_<>'*' AND CT2040.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD,  "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2020,CT1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1020,CT2020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1020.D_E_L_E_T_<>'*' AND CT2020.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL, "
    
            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL "

            _cQuery += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
   			TcQuery _cQuery Alias qTGRUPO new         
			
			//Inicio da Impressão			
			While (!qTGRUPO->(Eof()))                                           
	 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
			
		 	    _TOConRS +=(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  )+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  )+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05
		 	    _TOIntRs +=(qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
                _TOPwaRs +=(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)  ))*mv_par05
                _TOMadRs +=(((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)  ))*mv_par05
                _TOCilRs +=(((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)  ))*mv_par05
        
		        qTGRUPO->(dbSkip())
		    End	                   
		    
	    	//DESCRIÇÃO
	    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50) )
	    	//CONTA
	    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(TOGrupo,6) )
			
			//MOVIMENTOS CONSOLIDADOS
	    	oSubSec1:Cell("INTECRE"):setValue( _TOConRs )

			//INTERCOMPANY
	    	oSubSec1:Cell("INTEDEB"):setValue( _TOIntRs )

			//MOIVMENTOS CONTABEIS PWB
	    	oSubSec1:Cell("SLDDPWA"):setValue( _TOPwaRs )

			//MOVIMENTOS CONTABEIS PWPAMA
	    	oSubSec1:Cell("SLDCPWA"):setValue( _TOMadRs )

			//MOVIMENTOS CONTABEIS PMV
	    	oSubSec1:Cell("AJUCPWA"):setValue( _TOCilRs )
    	
		    oSubSec1:Cell("ZT5_DESC"):show()
		    oSubSec1:Cell("ZT5_CONTA"):show()
		    oSubSec1:Cell("INTECRE"):show()
		    oSubSec1:Cell("INTEDEB"):show()
		    oSubSec1:Cell("SLDDPWA"):show()
		    oSubSec1:Cell("SLDCPWA"):show()
		    oSubSec1:Cell("AJUCPWA"):show()
			oSubSec1:PrintLine()
			
	 	    _TOConRS := 0
	 	    _TOIntRs := 0
            _TOPwaRs := 0
            _TOMadRs := 0
            _TOCilRs := 0
    
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
