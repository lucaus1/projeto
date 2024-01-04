#Include "PROTHEUS.CH"
#Include "TopConn.CH"

User Function PABNINT()
	Local oReport
    
  	Private cPerg  := "ABNINT    "
  	Private cRel   := "Relatorio InteCompany"
	Private _DataC := GetMV("MV_DATAOLS") 
	
	Private _cTot    := ""
    Private _TOConRs := 0
	Private _TOIntRs := 0
	Private _TOABNRs := 0
    Private	_SUConRs := 0
	Private	_SUIntRs := 0
	Private	_SUABNRs := 0
    Private	_EXConRs := 0                     
	Private	_EXIntRs := 0
	Private	_EXABNRs := 0
	Private TOGrupo := 0
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
	
	
	oSubSec1 := TRSection():New(oReport, OemToAnsi("Relatorio InteCompany"), {"qTGRUPO"} )	
	//oSubSec1:SetHeaderPage(.F.)

	TRCell():New(oSubSec1, "ZT5_DESC"  , "qTGRUPO", "Description"  , "@!"            , , .T. )
	TRCell():New(oSubSec1, "ZT5_CONTA" , "qTGRUPO", "MembCode"     , "@!"            , , .T. )
	TRCell():New(oSubSec1, "SLDDABN"   , "qTGRUPO", "Consolidated" , "@E 999,999,999,999,999", , .T. )
	TRCell():New(oSubSec1, "SLDCABN"   , "qTGRUPO", "Intercompany" , "@E 999,999,999,999,999", , .T. )
	TRCell():New(oSubSec1, "AJUDABN"   , "qTGRUPO", "BK Energia"   , "@E 999,999,999,999,999", , .T. )
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
		    _cQuery := " SELECT ZT5060.*, ISNULL((SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
			_cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='04' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB),0) AS INTEDEB, "
	
			_cQuery += " ISNULL((SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
			_cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_FILIAL='04' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE),0) AS INTECRE, "
	
			_cQuery += " ISNULL((SELECT SUM(CT2_VALOR) FROM CT2110,CT1110 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1110.D_E_L_E_T_<>'*' AND CT2110.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"'), 0) AS SLDDABN, "
	
			_cQuery += " ISNULL((SELECT SUM(CT2_VALOR) FROM CT1110,CT2110 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1110.D_E_L_E_T_<>'*' AND CT2110.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
			_cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"'), 0) AS SLDCABN, "
	
			_cQuery += " ISNULL((SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '10' " 
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='04' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO), 0) AS AJUDABN, "
	
			_cQuery += " ISNULL((SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '10' " 
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='04' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT), 0) AS AJUCABN "
	
			_cQuery += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
			//comente aqui
			TcQuery _cQuery Alias qTGRUPO new

						
			//Inicio da Impressão					
			While ( !qTGRUPO->(Eof()) )
				SUGrupo := qTGRUPO->ZT5_GRUPO 
				//oSubSec1:Init()
			
             	//DESCRIÇÃO
             	if Alltrim(qLGRUPO->ZT4_TIPO) == "E" 				 	   
			    	oSubSec1:Cell("ZT5_DESC"):setValue("EX - " + PadR(qTGRUPO->ZT5_DESC,50))
		       	else
			    	oSubSec1:Cell("ZT5_DESC"):setValue(PadR(qTGRUPO->ZT5_DESC,50))
		       	endif
		    	
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(qTGRUPO->ZT5_CONTA,6) )

				//MOVIMENTOS CONSOLIDADOS
		    	oSubSec1:Cell("SLDDABN"):setValue( (qTGRUPO->SLDDABN - qTGRUPO->SLDCABN)+(qTGRUPO->AJUDABN - qTGRUPO->AJUCABN) )
	
				//INTERCOMPANY
		    	oSubSec1:Cell("SLDCABN"):setValue( (qTGRUPO->SLDDABN - qTGRUPO->SLDCABN)+(qTGRUPO->AJUDABN - qTGRUPO->AJUCABN) )

				//MOIVMENTOS CONTABEIS ABN
		    	oSubSec1:Cell("AJUDABN"):setValue( ((qTGRUPO->SLDDABN - qTGRUPO->SLDCABN)+(qTGRUPO->AJUDABN - qTGRUPO->AJUCABN)  ) * mv_par05 )

			    oSubSec1:Cell("ZT5_DESC"):show()
			    oSubSec1:Cell("ZT5_CONTA"):show()
			    oSubSec1:Cell("SLDDABN"):show()
			    oSubSec1:Cell("SLDCABN"):show()
			    oSubSec1:Cell("AJUDABN"):show()
				oSubSec1:PrintLine()

				if Alltrim(qLGRUPO->ZT4_TIPO) != "E" 				 	   
					_SUConRS += (((qTGRUPO->SLDDABN - qTGRUPO->SLDCABN)+(qTGRUPO->AJUDABN - qTGRUPO->AJUCABN)  ) + (qTGRUPO->INTEDEB - qTGRUPO->INTECRE)) * mv_par05
					_SUIntRs += (qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
					_SUABNRs += ((qTGRUPO->SLDDABN - qTGRUPO->SLDCABN)+(qTGRUPO->AJUDABN - qTGRUPO->AJUCABN)) * mv_par05
				endif
		        
		        qTGRUPO->(dbSkip())
		    End	
		    
		    //oSubSec1:ThinLine()
		    
		    if Alltrim(qLGRUPO->ZT4_TIPO) != "E"
		    	//--------------------------------------------------------------------------------
		    	oReport:ThinLine()
		    	//--------------------------------------------------------------------------------
		    	//DESCRIÇÃO
		    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50))
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(SUGrupo,6) )
				//MOVIMENTOS CONSOLIDADOS
		    	oSubSec1:Cell("SLDDABN"):setValue( _SUConRs )
				//INTERCOMPANY
		    	oSubSec1:Cell("SLDCABN"):setValue( _SUIntRs )
				//MOIVMENTOS CONTABEIS ABN
		    	oSubSec1:Cell("AJUDABN"):setValue( _SUABNRs )
		        
			    oSubSec1:Cell("ZT5_DESC"):show()
			    oSubSec1:Cell("ZT5_CONTA"):show()
			    oSubSec1:Cell("SLDDABN"):show()
			    oSubSec1:Cell("SLDCABN"):show()
			    oSubSec1:Cell("AJUDABN"):show()
				oSubSec1:PrintLine()

		    	//--------------------------------------------------------------------------------
		    	oReport:ThinLine()
		    	//--------------------------------------------------------------------------------
	
				_SUConRS := 0
				_SUIntRs := 0
				_SUABNRs := 0
            EndIf

		    //oSubSec1:ThinLine()
	    
		    //oSubSec1:finish()
			//oReport:SkipLine()

			qTGRUPO->(dbCloseArea())
			//finaliza comentario
		Elseif Alltrim(qLGRUPO -> ZT4_TIPO) == 'T'
			_cQuery := " SELECT ZT5060.*,ZT1_CONTA, "
            _cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
            _cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND ZT2_FILIAL='04' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS INTEDEB, "

            _cQuery += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
            _cQuery += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"'  AND ZT2_FILIAL='04' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS INTECRE, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2110,CT1110 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_DEBITO AND CT1110.D_E_L_E_T_<>'*' AND CT2110.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDABN, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1110,CT2110 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1110.D_E_L_E_T_<>'*' AND CT2110.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND CT1_CLASSE='2' AND  CT2_TPSALD='1' AND  "
            _cQuery += " CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCABN, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '10' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='04' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDABN, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '10' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='04' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCABN "

            _cQuery += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
			TcQuery _cQuery Alias qTGRUPO new         
			
			//Inicio da Impressão			
			While (!qTGRUPO->(Eof()))                                           
	 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
			
				//oSubSec1:Init()
			
		 	    _TOConRS +=(((qTGRUPO->SLDDABN - qTGRUPO->SLDCABN)+(qTGRUPO->AJUDABN - qTGRUPO->AJUCABN)  )+(qTGRUPO->INTEDEB - qTGRUPO->INTECRE))*mv_par05
		 	    _TOIntRs +=(qTGRUPO->INTEDEB - qTGRUPO->INTECRE)*mv_par05
                _TOABNRs +=(((qTGRUPO->SLDDABN - qTGRUPO->SLDCABN)+(qTGRUPO->AJUDABN - qTGRUPO->AJUCABN)  ))*mv_par05
		        
		        qTGRUPO->(dbSkip())
		    End	                   
	    	//--------------------------------------------------------------------------------
	    	oReport:ThinLine()
	    	//--------------------------------------------------------------------------------
	    
           	//DESCRIÇÃO
	    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial() + TOGrupo,"ZT1_DESC"),50) )
	    	
	    	//CONTA
	    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(TOGrupo,6) )

			//MOVIMENTOS CONSOLIDADOS
	    	oSubSec1:Cell("SLDDABN"):setValue( _TOConRs )

			//INTERCOMPANY
	    	oSubSec1:Cell("SLDCABN"):setValue( _TOIntRs )

			//MOIVMENTOS CONTABEIS ABN
	    	oSubSec1:Cell("AJUDABN"):setValue( _TOABNRs )
	    	
	    	oSubSec1:Cell("ZT5_DESC"):show()
	    	oSubSec1:Cell("ZT5_CONTA"):show()
	    	oSubSec1:Cell("SLDDABN"):show()
	    	oSubSec1:Cell("SLDCABN"):show()
	    	oSubSec1:Cell("AJUDABN"):show()
			oSubSec1:PrintLine()

	    	//--------------------------------------------------------------------------------
	    	oReport:ThinLine()
	    	//--------------------------------------------------------------------------------

            
	        _TOConRS := 0
	 	    _TOIntRs := 0
	 	    _TOEliRS := 0
            _TOABNRs := 0

		    
		    //oSubSec1:finish()
			//oReport:SkipLine()
            
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
