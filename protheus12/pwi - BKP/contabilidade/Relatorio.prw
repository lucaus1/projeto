#Include "PROTHEUS.Ch"

User Function Relatorio()
	Local oReport
	
	If FindFunction("TRepInUse") .And. !TRepInUse() 
		oReport := imprime()
		
		if ValType( oReport ) == "O"
			oReport :PrintDialog()      
		end if
	EndIf
Return

Static Function imprime()
	Local oReport
	Local oSection
	
	oReport := TReport():New( "NOME", "NOME DO RELATORIO",, { |oReport| PrintReport( oReport ) }, "Teste de Relatorio" )    
	oReport:SetLandScape(.T.)
	
	oSection := TRSection():New(oReport,OemToAnsi("Teste de Impress�o"), {"SBM"} )	
	oSection:SetHeaderPage(.F.)
	
	TRCell():New(oSection,"BM_GRUPO", "SBM", "Grupo", "@!",  6*8, .T. )
	TRCell():New(oSection,"BM_DESC" , "SBM", "Descr", "@!", 30*8, .T. )
Return oReport

Static Function PrintReport( oReport )
	Local oSection1 := oReport:Section( 1 )
	
	DbSelectArea("SBM")
	DbSetOrder(1)      
	DbGotop()
	//DbSeek(xFilial()+MV_PAR01,.T.)
	
	oReport:SetMeter( RecCount() )
	
	While ( !Eof() )                                                                          
		If oReport:Cancel()
			Exit
		EndIf
		
		// oSection1:Init()
	
		//oSection:Cell("B1_DESC"):SetValue(SB1->B1_DESC)
		
		oSection1:Cell("BM_GRUPO"):Show()
		oSection1:Cell("BM_DESC"):Show()
		oSection1:PrintLine()
		
		DbSkip()
	
		// oSection1:Finish()
		//oReport:SkipLine()
		//oReport:IncMeter()
	End
	
	// CLOCREL := "U"
Return nil
