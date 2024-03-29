#Include "PROTHEUS.CH"
#Include "TopConn.CH"

User Function PBKEDIF()
	Local oReport
    
  	Private cPerg  := "BKEDIF    "
  	Private cRel   := "Relatorio BR GAAP x IFRS"
	Private _DataC := GetMV("MV_DATAOLS") 
	
	Private _cTot    := ""
    Private _TOConRs := 0
	Private _TOIntRs := 0
	Private _TOBKERs := 0
    Private	_SUConRs := 0
	Private	_SUIntRs := 0
	Private	_SUBKERs := 0
    Private	_EXConRs := 0                     //???  -  2101-8182 / Serginho - Proview
	Private	_EXIntRs := 0
	Private	_EXBKERs := 0
	Private _TOAjuRs := 0
	
	Private _SUAjuRs := 0
	
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
	
	oReport := TReport():New( cPerg, cRel, cPerg, { |oReport| PrintReport( oReport ) }, "Relatorio BR GAAP x IFRS" )    
	oReport:SetPortrait()
	
	//oSection := TRSection():New(oReport,OemToAnsi("Teste de Impress�o"), {"qLGRUPO"} )	
	//oSection:SetHeaderPage(.F.)
	
	//TRCell():New(oSection, "ZT4_SEQ"  , "qLGRUPO", "Grupo"  , "@!"            , 40*3, .T. )	
	
	oSubSec1 := TRSection():New(oReport, OemToAnsi("Relatorio BR GAAP x IFRS"), {"qTGRUPO"} )	
	//oSubSec1:SetHeaderPage(.F.)

	TRCell():New(oSubSec1, "ZT5_DESC"  , "qTGRUPO", "Description"  , "@!"            , 40*3, .T. )
	TRCell():New(oSubSec1, "ZT5_CONTA" , "qTGRUPO", "MembCode"     , "@!"            , 10*3, .T. )
	TRCell():New(oSubSec1, "SLDDBKE"   , "qTGRUPO", "BR GAAP"      , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "SLDCBKE"   , "qTGRUPO", "IFRS"         , "@E 999,999,999,999,999", 14*3, .T. )
	TRCell():New(oSubSec1, "AJUDBKE"   , "qTGRUPO", "Difference"   , "@E 999,999,999,999,999", 14*3, .T. )

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
		    _cQuery := " SELECT ZT5060.*, " 
			             
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2030,CT1030 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1030.D_E_L_E_T_<>'*' AND CT2030.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
		    _cQuery += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                													   	                			
			_cQuery += "  CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDBKE, "
	
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1030,CT2030 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(CT1_IFRS) AND "
			_cQuery += " CT1_CONTA=CT2_CREDIT AND CT1030.D_E_L_E_T_<>'*' AND CT2030.D_E_L_E_T_<>'*' AND "
			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
		    _cQuery += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                													   	                			
			_cQuery += "  CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCBKE, "
	                                                            
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '03' " 
 			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='03' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDBKE, "
	
			_cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '03' " 
			_cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='03' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCBKE "

			_cQuery += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO= '"+ qLGRUPO->ZT4_GRUPO + "' "

			//comente aqui
			TcQuery _cQuery Alias qTGRUPO new

			//Inicio da Impress�o					
			While ( !qTGRUPO->(Eof()) )
				SUGrupo := qTGRUPO->ZT5_GRUPO 
			
             	//DESCRI��O
             	if Alltrim(qLGRUPO->ZT4_TIPO) == "E" 				 	   
			    	oSubSec1:Cell("ZT5_DESC"):setValue("EX - " + PadR(qTGRUPO->ZT5_DESC,50))
		       	else
			    	oSubSec1:Cell("ZT5_DESC"):setValue(PadR(qTGRUPO->ZT5_DESC,50))
		       	endif
		    	
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(qTGRUPO->ZT5_CONTA,6) )

				//BR GAAP
		    	oSubSec1:Cell("SLDDBKE"):setValue( ((qTGRUPO->SLDDBKE - qTGRUPO->SLDCBKE) ) * MV_PAR06 )
	
				//IFRS 
		    	oSubSec1:Cell("SLDCBKE"):setValue( ((qTGRUPO->SLDDBKE - qTGRUPO->SLDCBKE)+(qTGRUPO->AJUDBKE - qTGRUPO->AJUCBKE)  ) * MV_PAR06 )

				//DIFEREN�A IFRS - BRGAAP
		    	oSubSec1:Cell("AJUDBKE"):setValue( -(qTGRUPO->AJUDBKE - qTGRUPO->AJUCBKE) * MV_PAR06 )
				oSubSec1:PrintLine()

				if Alltrim(qLGRUPO->ZT4_TIPO) != "E" 				 	   
			 	    _SUConRS += ((qTGRUPO->SLDDBKE - qTGRUPO->SLDCBKE) + (qTGRUPO->AJUDBKE - qTGRUPO->AJUCBKE)  ) * MV_PAR06
                    _SUBKERs += ((qTGRUPO->SLDDBKE - qTGRUPO->SLDCBKE)  ) * MV_PAR06
				    _SUAjuRs += (qTGRUPO->AJUDBKE - qTGRUPO->AJUCBKE) * MV_PAR06
				endif
		        
		        qTGRUPO->(dbSkip())
		    End	
		    
		    //oSubSec1:ThinLine()
		    if Alltrim(qLGRUPO->ZT4_TIPO) != "E"
		    	//DESCRI��O
		    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50) )
		    	//CONTA
		    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(SUGrupo,6) )
				//MOVIMENTOS CONSOLIDADOS
		    	oSubSec1:Cell("SLDDBKE"):setValue( _SUBKERs )
				//INTERCOMPANY
		    	oSubSec1:Cell("SLDCBKE"):setValue( _SUConRs )
				//MOIVMENTOS CONTABEIS BKE
		    	oSubSec1:Cell("AJUDBKE"):setValue( -_SUAjuRs )
				oSubSec1:PrintLine()
		        
			    oSubSec1:Cell("ZT5_DESC"):show()
			    oSubSec1:Cell("ZT5_CONTA"):show()
			    oSubSec1:Cell("SLDDBKE"):show()
			    oSubSec1:Cell("SLDCBKE"):show()
			    oSubSec1:Cell("AJUDBKE"):show()
		    EndIf

	 	    _SUConRS := 0
            _SUBKERs := 0
		    _SUAjuRs := 0
		    
			qTGRUPO->(dbCloseArea())
		Elseif Alltrim(qLGRUPO -> ZT4_TIPO) == 'T'
			_cQuery := " SELECT ZT5060.*,ZT1_CONTA, "
			
			_cQuery += " (SELECT SUM(CT2_VALOR) FROM CT2030,CT1030 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
   			_cQuery += " CT1_CONTA=CT2_DEBITO AND CT1030.D_E_L_E_T_<>'*' AND CT2030.D_E_L_E_T_<>'*' AND "
  			_cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND CT2_TPSALD='1' AND "
		    _cQuery += " (CT2_DC ='1' OR CT2_DC='3')  AND "	                													   	                
            _cQuery += "  CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDBKE, "

            _cQuery += " (SELECT SUM(CT2_VALOR) FROM CT1030,CT2030 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(CT1_IFRS) AND "
            _cQuery += " CT1_CONTA=CT2_CREDIT AND CT1030.D_E_L_E_T_<>'*' AND CT2030.D_E_L_E_T_<>'*' AND "
            _cQuery += " CT2_FILIAL='01' AND CT1_FILIAL='01'   AND  CT1_CLASSE='2' AND  CT2_TPSALD='1' AND "
		    _cQuery += " (CT2_DC ='2' OR CT2_DC='3')  AND "	                													   	                            
            _cQuery += "  CT2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCBKE, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '03' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='03' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDBKE, "

            _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '03' "
            _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='03' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCBKE "
                
            _cQuery += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "

			TcQuery _cQuery Alias qTGRUPO new         
			
			While (!qTGRUPO->(Eof()))                                           
	 	        TOGrupo := qTGRUPO->ZT5_GRUPO                                  
			
	 	    	_TOConRS +=((qTGRUPO->SLDDBKE - qTGRUPO->SLDCBKE)+(qTGRUPO->AJUDBKE - qTGRUPO->AJUCBKE)  )*MV_PAR06
				_TOAjuRs +=(qTGRUPO->AJUDBKE - qTGRUPO->AJUCBKE)*MV_PAR06     //Essa linha deu erro
   			    _TOBKERs +=((qTGRUPO->SLDDBKE - qTGRUPO->SLDCBKE) )*MV_PAR06
        
		        qTGRUPO->(dbSkip())
		    End	                   
		    
           	//DESCRI��O
	    	oSubSec1:Cell("ZT5_DESC"):setValue( _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50) )
	    	
	    	//CONTA
	    	oSubSec1:Cell("ZT5_CONTA"):setValue( PadR(TOGrupo,6) )

			//MOVIMENTOS CONSOLIDADOS
	    	oSubSec1:Cell("SLDDBKE"):setValue( _TOBKERs )

			//INTERCOMPANY
	    	oSubSec1:Cell("SLDCBKE"):setValue( _TOConRs )

			//MOIVMENTOS CONTABEIS BKE
	    	oSubSec1:Cell("AJUDBKE"):setValue( -_TOAjuRs )
	    	
	    	oSubSec1:Cell("ZT5_DESC"):show()
	    	oSubSec1:Cell("ZT5_CONTA"):show()
	    	oSubSec1:Cell("SLDDBKE"):show()
	    	oSubSec1:Cell("SLDCBKE"):show()
	    	oSubSec1:Cell("AJUDBKE"):show()
			oSubSec1:PrintLine()

 	    	_TOConRS := 0
			_TOAjuRs := 0
   		    _TOBKERs := 0
		    
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
