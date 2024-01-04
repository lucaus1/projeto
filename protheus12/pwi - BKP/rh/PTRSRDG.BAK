#include "fivewin.ch"    
#include "topconn.ch"
/*
  Autor: Franciney Alves
  Descrição: Relatorio de Acumulados para PWI 
  Inicio desenvolvimento: 01/09/2006
  Termino:  20/11/2006
  
  Alterações:
  Data         Consultor      Descricao
  22/11/2006   Franciney      * como opção para todas as verbas
  

*/

User Function PTRSRD()
	Private	lEnd := .f.
	Private _cQuery  := ""
    Private _Pagina  := 0
    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PTRSRD"

  	dbSelectArea("SX1")
  	dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Ano/Mes de      ?","mv_ch1","C",06,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Ano/Mes Ate     ?","mv_ch2","C",06,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Centro de Custo de ?","mv_ch3","C",09,0,1,"G","","mv_par03","","SI3","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Centro de Custo Ate?","mv_ch4","C",09,0,1,"G","","mv_par04","","SI3","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Matricula de ?","mv_ch5","C",06,0,1,"G","","mv_par05","","SRA","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "06", "Matricula Ate?","mv_ch6","C",06,0,1,"G","","mv_par06","","SRA","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "07", "Verbas       ?","mv_ch7","C",50,0,1,"G","","mv_par07","","SRV","","","","","","","","","","","","",""})

  	 
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
	oPrint		:= TMSPrinter():New(OemToAnsi("Relatorio de Acumulados "))
	oBrush		:= TBrush():New(,4)
	oPen		:= TPen():New(0,5,CLR_BLACK)
	// cFileLogo	:= GetSrvProfString("Startpath","") + "LOGORECH02" + ".BMP"
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
     if ALLTRIM(MV_PAR07)== "*"
		_cQuery1 := " select RD_CC, RD_MAT, RD_PD, RD_DATARQ, RD_DATPGT, RD_TIPO1, RD_HORAS, RD_VALOR "
	    _cQuery1 += " FROM SRD010   WHERE SRD010.D_E_L_E_T_<>'*' AND RD_DATARQ BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
   	    _cQuery1 += " AND RD_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
    	_cQuery1 += " AND RD_MAT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
	    _cQuery1 += " ORDER BY RD_DATARQ, RD_CC, RD_MAT ASC "
	 Else
	 	_cQuery1 := " select RD_CC, RD_MAT, RD_PD, RD_DATARQ, RD_DATPGT, RD_TIPO1, RD_HORAS, RD_VALOR "
	    _cQuery1 += " FROM SRD010   WHERE SRD010.D_E_L_E_T_<>'*' AND RD_DATARQ BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' "
   	    _cQuery1 += " AND RD_CC BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
    	_cQuery1 += " AND RD_MAT BETWEEN '" + MV_PAR05 + "' AND '" + MV_PAR06 + "' "
  	    _cQuery1 += " AND RD_PD IN (" + ALLTRIM(MV_PAR07)+ ")"
	    _cQuery1 += " ORDER BY RD_DATARQ, RD_CC, RD_MAT ASC "
	 
	    
	 Endif	
		TcQuery _cQuery1 Alias "qRegSRD" new
		
    dbGoTop()

    dbGoTop()
	nContador := 1
    Gauge := (qRegSRD -> (RecCount())*5)
    ProcRegua( Gauge )	
    
	While (!qRegSRD->(Eof()))
                        xVerPag()          
                        // FUNCIONARIOS
                        DbSelectArea("SRA")
                        DbSetOrder(1)
                        DbSeek(xFilial()+qRegSRD->RD_MAT)                        
						// VERBAS
						DbSelectArea("SRV")
                        DbSetOrder(1)
                        DbSeek(xFilial()+qRegSRD->RD_PD)                        
                        // CENTRO DE CUSTOS
                        DbSelectArea("SI3")
                        DbSetOrder(1)
                        DbSeek(xFilial()+SRA->RA_CC)
                        
                        DbSelectArea("qRegSRD")
						
						
						oPrint:Say(nLinha,0050, PadR(SRA->RA_CC,10), oFont06)   
						oPrint:Say(nLinha,0150, PadR(qRegSRD->RD_MAT,10), oFont06)   
						oPrint:Say(nLinha,0250, PadR(SRA->RA_NOME,50), oFont06)   
						oPrint:Say(nLinha,0600, PadR(qRegSRD->RD_PD,10), oFont06)   
						oPrint:Say(nLinha,0650, PadR(SRV->RV_DESC,50), oFont06)                            
						oPrint:Say(nLinha,0900, Transform(qRegSRD->RD_HORAS, "@E 999.99"), oFont07)

						
						oPrint:Say(nLinha,1050, Transform(qRegSRD->RD_VALOR, "@E 999,999,999.99"), oFont07)
						oPrint:Say(nLinha,1250, PadR(qRegSRD->RD_DATARQ,10), oFont06)

							nLinha += 40
				        qRegSRD->(dbSkip())
	             		oPrint:Line(nLinha,050,nLinha,2190)
						nLinha += 20
   	                
    IncProc()         
         
         
    End	
   	  		_Pagina := _Pagina + 1

	      	oPrint:EndPage()
		  	nLinha:= 0150   
		  	oPrint:StartPage()
		  	xCabec()


   	qRegSRD->(dbCloseArea())
	oPrint:Preview()
Return

Static Function xCabec()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o cabecalho da empresa. !³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// oPrint:SayBitmap(050,100,cFileLogo,1050,260)
	nLinha := 200
	oPrint:Say(050,050,AllTrim( SM0->M0_NOMECOM ),oFont08)
	oPrint:Say(100,050,"Relatorio de Acumulados" ,oFont08)
	oPrint:Say(120,2100,AllTrim("Page:"), oFont07)
	oPrint:Say(120,2295,AllTrim(Transform(_Pagina,"@E 999,999")), oFont07)
	oPrint:Line(150,050,150,2330)
    oPrint:Say(nLinha,0050, "RA_CC"    , oFont06)   
	oPrint:Say(nLinha,0150, "RD_MAT"   , oFont06)   
	oPrint:Say(nLinha,0250, "RA_NOME"  , oFont06)   
	oPrint:Say(nLinha,0600, "Ver"      , oFont06)   
	oPrint:Say(nLinha,0650, "RV_DESC"  , oFont06)                            
	oPrint:Say(nLinha,0890, "RD_HORAS" , oFont07)						
	oPrint:Say(nLinha,1050, "RD_VALOR" , oFont07)
    oPrint:Say(nLinha,1250, "DATARQ"   , oFont06)
	oPrint:Line(250,050,250,2330)	
	nLinha := 300
Return


Static Function xVerPag()

	If	nLinha >= 3030 
		_Pagina := _Pagina + 1
        oPrint:EndPage()
		nLinha:= 0150   
		oPrint:StartPage()
		xCabec()
	EndIf      

Return