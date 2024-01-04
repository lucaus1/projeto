#Include "Ctbr070.Ch"
#Include "PROTHEUS.Ch"
#DEFINE CENTRO_CUSTO	1
#DEFINE ITEM_CONTABIL	2
#DEFINE CLASSE_VALOR 	3
#DEFINE VALOR_DEBITO 	4
#DEFINE VALOR_CREDITO	5
#DEFINE CODIGO_HP    	6
#DEFINE HISTORICO    	7
#define TAM_CEL			18

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr070	³ Autor ³ Pilar S Albaladejo	³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia de Digitacao               	 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr070()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PCtbR070()     
PRIVATE titulo		:= "" 
Private nomeprog	:= "CTBR070"

If FindFunction("TRepInUse") .And. TRepInUse() 
	CTBR070R4()
Else
	Return CTBR070R3()
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ CTBR070R4 ³ Autor³ Daniel Sakavicius		³ Data ³ 19/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia de Digitacao - R4           	 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ CTBR070R4												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function CTBR070R4()         

PRIVATE CPERG	   	:= "CTR070    "        

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Interface de impressao                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ            

Pergunte( CPERG, .T. )

oReport := ReportDef()      

IF ValType( oReport ) == "O"
	oReport :PrintDialog()      
ENDIF

Return                                

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Daniel Sakavicius		³ Data ³ 20/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Esta funcao tem como objetivo definir as secoes, celulas,   ³±±
±±³          ³totalizadores do relatorio que poderao ser configurados     ³±±
±±³          ³pelo relatorio.                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ SIGACTB                                    				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef() 
Local oReport
local aArea	   		:= GetArea()   
Local cReport		:= "CTBR070"
Local cTitulo		:= STR0004				   			// "Conferencia de Digitacao - Modelo 1"
Local cDesc			:= STR0001+STR0002+STR0003	  		// "Este programa ira imprimir o Relatorio para Conferencia"
Local cDifDC  		:= ""			  
Local cDifIF		:= ""
Local cDiger		:= ""
Local cCredito		:= ""
Local cDebito		:= ""                    
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local cSayItem		:= "ITEM"
Local cSayCC		:= "CUSTO"
Local cSayCV		:= "CLVL"

Local nTamCusto     := TAMSX3("CTT_CUSTO")[1]
Local nTamItem      := TAMSX3("CTD_ITEM")[1]
Local nTamCLVL      := TAMSX3("CTH_CLVL")[1]

PRIVATE cPerg		:= "CTR070"		   
Private cPictVal  := PesqPict("CT2","CT2_VALOR")					

IF MV_PAR09 != 1
	nTamCusto := 0
ENDIF

IF MV_PAR10 != 1
	nTamItem  := 0
ENDIF

IF MV_PAR14 != 1
	nTamCLVL  := 0
ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//"Este programa tem o objetivo de emitir o Cadastro de Itens Classe de Valor "
//"Sera impresso de acordo com os parametros solicitados pelo"
//"usuario"                                
oReport	:= TReport():New( cReport,cTitulo,cPerg, { |oReport| ReportPrint( oReport ) }, cDesc ) 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oSection0  := TRSection():New( oReport, STR0032, {"CTC"},, .F., .F. )	//"Resumido"
oReport:SetLandScape(.T.)
	
TRCell():New( oSection0, "CTC_DATA"  , "CTC",STR0036/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //DATA
TRCell():New( oSection0, "CTC_LOTE"  , "CTC",STR0037/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //LOTE
TRCell():New( oSection0, "CTC_SBLOTE", "CTC",STR0038/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //SUB LOTE
TRCell():New( oSection0, "CTC_DOC"   , "CTC",STR0039/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)   //DOCUMENTO
TRCell():New( oSection0, "CTC_INF"   , "CTC",STR0040+" "+STR0041/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)   //TOTAL INFORMADO
TRCell():New( oSection0, "CTC_DEBITO", "CTC",STR0042/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //VALOR A DEBITO
TRCell():New( oSection0, "CTC_CREDIT", "CTC",STR0043/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //VALOR A CREDITO
TRCell():New( oSection0, "CDIFDC"    ,,STR0044,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //DIFERENCA
TRCell():New( oSection0, "CTC_DIG"   , "CTC",STR0040+" "+STR0045/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)  //TOTAL DIGITADO
TRCell():New( oSection0, "CDIFIF"    ,,STR0046,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")  //"DIFERENCA INF/DIG"
	
oSection1  := TRSection():New( oReport, STR0033, {"CT2"},, .F., .F. )	//"Completo"

TRCell():New( oSection1, "CT2_DATA"  , "CT2",STR0012/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT2_LOTE"  , "CT2",STR0013/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT2_SBLOTE", "CT2",STR0017/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection1, "CT2_DOC"   , "CT2",STR0014/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

oSection11  := TRSection():New( oSection1, STR0034, {"CT2"},, .F., .F. )	//"Lancamentos Contabeis"

TRCell():New( oSection11, "CT2_LINHA" 	, "CT2",STR0047/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CT2_DC"    	, "CT2",STR0048/*Titulo*/,/*Picture*/,4/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CCONTAD"		, ,STR0049+" "+STR0010,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)	
TRCell():New( oSection11, "CCONTAC"		, ,STR0049+" "+STR0011,/*Picture*/,aTamConta[1]/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)		
TRCell():New( oSection11, "CCUSTOD" 	, ,cSayCC+" D"/*Titulo*/,/*Picture*/,nTamCusto/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CCUSTOC" 	, ,cSayCC+" C"/*Titulo*/,/*Picture*/,nTamCusto/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CITEMD" 		, ,cSayItem+" D"/*Titulo*/,/*Picture*/,nTamItem/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CITEMC" 		, ,cSayItem+" C"/*Titulo*/,/*Picture*/,nTamItem/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CCLASSED"	, ,cSayCV+" D"/*Titulo*/,/*Picture*/,nTamClvl/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CCLASSEC"	, ,cSayCV+" C"/*Titulo*/,/*Picture*/,nTamClvl/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CDEBITO" 	, ,STR0050+" "+STR0010,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection11, "CCREDITO" 	, ,STR0050+" "+STR0011,cPictVal/*Picture*/,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")
TRCell():New( oSection11, "CT2_HP" 		, ,STR0051,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)
TRCell():New( oSection11, "CT2_HIST"  	, "CT2",STR0052/*Titulo*/,/*Picture*/,/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)

oSection11:SetHeaderPage(.T.)


oSection2  := TRSection():New( oReport, STR0035,,, .F., .F. )	//"Totais"

TRCell():New( oSection2, "TOT_DESCRI" ,,,,64/*Tamanho*/,/*lPixel*/,/*CodeBlock*/)	//Total Debito
TRCell():New( oSection2, "TOT_DEBITO" ,,OemToAnsi(STR0010),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//Total Debito
TRCell():New( oSection2, "TOT_CREDITO",,OemToAnsi(STR0011),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//Total Credito

If mv_par22 == 1
	TRCell():New( oSection2, "TOT_INF"    ,,OemToAnsi(STR0025),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//"Total Informado"
	TRCell():New( oSection2, "TOT_DIG"    ,,OemToAnsi(STR0026),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//"Total "
	TRCell():New( oSection2, "TOT_DIFINF" ,,OemToAnsi(STR0027),,18/*Tamanho*/,/*lPixel*/,/*CodeBlock*/,"RIGHT",,"RIGHT")	//"Diferenca:"
Endif

oSection2:Cell("TOT_DESCRI"):HideHeader()

Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrint³ Autor ³ Daniel Sakavicius	³ Data ³ 20/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Imprime o relatorio definido pelo usuario de acordo com as  ³±±
±±³          ³secoes/celulas criadas na funcao ReportDef definida acima.  ³±±
±±³          ³Nesta funcao deve ser criada a query das secoes se SQL ou   ³±±
±±³          ³definido o relacionamento e filtros das tabelas em CodeBase.³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ ReportPrint(oReport)                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³EXPO1: Objeto do relatório                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function ReportPrint( oReport )

Local oSection0 	:= oReport:Section(1)
Local oSection1 	:= oReport:Section(2)
Local oSection11 	:= oReport:Section(2):Section(1)
Local oSection2 	:= oReport:Section(3)
Local lTotal		:= (mv_par13 == 1)
Local lTot123 		:= If( cPaisLoc = "CHI", mv_par24 == 1, mv_par22 == 1)
Local lResumo		:= (mv_par17 == 1)
Local cMoeda		:= mv_par07 
Local cQuery		:= "CT2"
Local n				:= 0
Local cLote			:= ""
Local cSubLote		:= ""
Local cDoc      	:= ""
Local cLoteRes      := ""
Local cSubRes		:= ""
Local cDocRes    	:= ""
Local nTotalDeb	 	:= 0
Local nTotalCrd	 	:= 0
Local nTotLotDeb	:= 0
Local nTotLotCrd 	:= 0
Local nTotGerDeb 	:= 0
Local nTotGerCrd 	:= 0
Local nTotGerInf 	:= 0
Local nTotGerDig 	:= 0
Local nDifInf	 	:= 0
Local cDebit	 	:= "1"
Local cCredit	 	:= "2"
Local cPdobr	 	:= "3"  
Local nStr		 	:= 0
Local cFilUser	 	:= ".T."
Local lAllSL		:= If(Empty(mv_par11) .or. mv_par11=="*",.T.,.F.)
Local nReccount		:= 0
Local     nInf 		:= 0
Local     nDig 		:= 0
local     nDocInf   := 0
Local     nDocDig   := 0

If lResumo
	oSection1:Disable()
	oSection11:Disable()
	oSection2:Disable()

	cQuery	:= "CTC"
Else
	oSection0:Disable()

	cQuery	:= "CT2"
Endif

If mv_par09 == 1 
	lCusto := .T.
Else 
	oSection11:Cell("CCUSTOD"):Disable()
	oSection11:Cell("CCUSTOC"):Disable()
	lCusto := .F.	
Endif	

If mv_par10 == 1 
	lItem := .T.
Else 
	oSection11:Cell("CITEMD"):Disable()
	oSection11:Cell("CITEMC"):Disable()
	lItem := .F.	
Endif	

If mv_par14 == 1 
	lCV := .T.
Else
	oSection11:Cell("CCLASSED"):Disable() 
	oSection11:Cell("CCLASSEC"):Disable() 
	lCV := .F.	
Endif	

aCtbMoeda  	:= CtbMoeda(mv_par07)
If Empty(aCtbMoeda[1])
	Help(" ",1,"NOMOEDA")
	Set Filter To
	Return
Endif

cDescMoeda 	:= Alltrim(aCtbMoeda[2])

If mv_par17 == 1		// Resumido
	Titulo := STR0004+STR0022+cDescMoeda                                          
Else
	Titulo	:= STR0004+STR0030+cDescMoeda                                          
EndIf	                                                                       

oReport:SetCustomText({|| CtCGCCabTR(,,,,,dDataBase,titulo,,,,,oReport)} )

If lTot123
	oReport:SetLandScape(.T.)
Else
	oReport:SetPortrait(.T.)
EndIf	
          
If lResumo // se imprimir no modo resumido
	cFilter := "CTC->CTC_FILIAL == '"+xFilial('CTC')+"' .and. "
	cFilter += "DTOS(CTC->CTC_DATA) >=  '"+DTOS(mv_par01)+"' .and. "
	cFilter += "DTOS(CTC->CTC_DATA) <=  '"+DTOS(mv_par02)+"' .and. "
	cFilter += "CTC->CTC_LOTE >= '"+mv_par03+"' .and. "
	cFilter += "CTC->CTC_LOTE <= '"+mv_par04+"' .and. "
	cFilter += "CTC->CTC_DOC >= '"+mv_par05+"' .and. "
	cFilter += "CTC->CTC_DOC <= '"+mv_par06+"' .and. "
	cFilter += "CTC->CTC_MOEDA  =  '"+mv_par07+"' .and. "
	IF MV_PAR11 <> "*"
	cFilter += "CTC->CTC_TPSALD = '" +MV_PAR11+"' .and."
	ENDIF
	cFilter += "CTC->CTC_CREDIT + CTC->CTC_DEBITO + CTC->CTC_DIG +  CTC->CTC_INF <> 0 "

	CTC->(DbSetOrder(1))
	CTC->(DbSeek(xFilial('CTC')+DTOS(mv_par01)+mv_par03+mv_par15+mv_par05))

	oSection0:SetFilter( cFilter )

	If mv_par12 == 1 //Lote
		oBreak2 := TRBreak():New( oSection0, {|| CTC->(Dtos(CTC_DATA)+CTC_LOTE) } )
		oBreak2:SetPageBreak(.T.)

	ElseIf mv_par12 == 2 //Documento
		oBreak2 := TRBreak():New( oSection0, {|| CTC->(Dtos(CTC_DATA)+CTC_LOTE+CTC_SBLOTE+CTC_DOC) } )
		oBreak2:SetPageBreak(.T.)

	Endif
	
	If lTotal
		oBreak1 := TRBreak():New( oSection0, {|| CTC->(eof()) }, STR0019 )
		
		TRFunction():New(oSection0:Cell("CTC_INF"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		TRFunction():New(oSection0:Cell("CTC_DEBITO"), ,"SUM",oBreak1/*oBreak */,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		TRFunction():New(oSection0:Cell("CTC_CREDIT"), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		TRFunction():New(oSection0:Cell("CDIFDC"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		TRFunction():New(oSection0:Cell("CTC_DIG"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
		TRFunction():New(oSection0:Cell("CDIFIF"	 ), ,"SUM",oBreak1/*oBreak*/ ,STR0019,/*[ cPicture ]*/,/*[ uFormula ]*/,.F.,.F.,)
	Endif
	
	oSection0:Cell("CDIFDC"):SetBlock( { || CTC->CTC_CREDIT - CTC->CTC_DEBITO } )
	oSection0:Cell("CDIFIF"):SetBlock( { || CTC->CTC_DIG - CTC->CTC_INF } )
	
	oSection0:Print()

Else

	#IFDEF TOP
		If TcSrvType() <> "AS/400"
		                       
			oReport:NoUserFilter()
		
			cFilUser := oSection1:GetSqlExp()

			cQuery := "SELECT * FROM " + RetSqlName("CT2")     + " "
			cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND " 
			cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
			cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
			cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
			cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
			cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
			cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
			cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
			cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' AND "
			cQuery += 		"CT2_MOEDLC = '"+ mv_par07 + "' AND "
			If !lAllSL
				cQuery += 		"CT2_TPSALD = '"+ mv_par11 + "' AND "		
			EndIf
			cQuery += 		"CT2_DC <> '4' AND "

			If !Empty(cFilUser)
				cQuery += cFilUser + " AND "
			EndIf
			cQuery +=       "D_E_L_E_T_ = '' " 
			cQuery += "ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA"

			cQuery := ChangeQuery(cQuery)		   

			If Select("cArqCT2") > 0
				dbSelectArea("cArqCT2")
				dbCloseArea()
			Endif
        	
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

			dbSelectArea("cArqCT2")
            DbGobottom()

            nReccount := 0
		    do while ! eof()
			    nReccount += 1
		       dbSkip()
		    EndDo

            DbGoTop()
    	    aStrSTRU := CT2->(dbStruct())      //// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
        
			For nStr := 1 to Len( CT2->(dbStruct()) )        //// LE A ESTRUTURA DA TABELA
				If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
					TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
				EndIf
			Next

			dbSelectArea("cArqCT2")
			cAliasCT2 := "cArqCT2"            
			
			TRPosition():New(oSection1,"CT2",1,;
				{|| xFilial("CT2")+(cAliasCT2)->(DtoS(CT2_DATA)+CT2_LOTE+CT2_SBLOTE+CT2_DOC+CT2_LINHA+CT2_TPSALD+CT2_EMPORI+CT2_FILORI+CT2_MOEDLC) })
			
		Else	
	#ENDIF
		dbSelectArea("CT2")
		dbSetOrder(1)                         
		dbSeek(xFilial()+DTOS(mv_par01)+mv_par03+mv_par15+mv_par05,.T.)
	    	
		cAliasCT2 := "CT2"

		cFilUser := oSection1:GetAdvplExpr()
		If !Empty(cFilUser)
			oSection1:SetFilter(cFilUser)
		EndIf
	
	    nReccount := CT2->(Reccount())
	#IFDEF TOP
		EndIf
	#ENDIF
                                  
    // section 1 
	oSection1:Cell( "CT2_DATA"   ):SetBlock( { || (cAliasCT2)->CT2_DATA	} )
	oSection1:Cell( "CT2_LOTE"   ):SetBlock( { || (cAliasCT2)->CT2_LOTE	} )
	oSection1:Cell( "CT2_SBLOTE" ):SetBlock( { || (cAliasCT2)->CT2_SBLOTE	} )
	oSection1:Cell( "CT2_DOC"    ):SetBlock( { || (cAliasCT2)->CT2_DOC 	} )

    // section 11
	oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )
	oSection11:Cell( "CT2_DC"    ):SetBlock( { || (cAliasCT2)->CT2_DC		} )
	oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
	oSection11:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} )
/*
	If lCusto .And. lItem .And. lCv //Se imprime C.C, Item E Cl.Valores
		oSection11:Cell( "CCONTAD"  ):Disable()
		oSection11:Cell( "CCONTAC"  ):Disable()
		oSection11:Cell( "CCUSTOD"  ):Disable()
		oSection11:Cell( "CCUSTOC"  ):Disable()
		oSection11:Cell( "CITEMD"   ):Disable()
		oSection11:Cell( "CITEMC"   ):Disable()
		oSection11:Cell( "CCLASSED" ):Disable() 
		oSection11:Cell( "CCLASSEC" ):Disable()
	Else
		oSection11:Cell( "CCONTA"  ):Disable()	
		oSection11:Cell("CCUSTO"   ):Disable() 
		oSection11:Cell("CITEM"    ):Disable()
		oSection11:Cell("CCLASSE"  ):Disable()		
	EndIf
*/
	oReport:SetMeter( nReccount )

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Define bloco de codigo com as variaveis para impressao das celulas de totais  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While !Eof() .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") .And. (cAliasCT2)->CT2_DATA <= mv_par02 .And. !oReport:Cancel()
		If oReport:Cancel()
			Exit
		EndIf	

		#IFNDEF TOP
			If Ctr070Skip(cAliasCT2,lAllSL)
				Loop
			EndIf
		#ELSE
			If TcSrvType() == "AS/400"
				If Ctr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
			EndIf
		#ENDIF
	
		cLote 		:= (cAliasCT2)->CT2_LOTE
		cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
		cDoc		:= (cAliasCT2)->CT2_DOC
		dData 		:= (cAliasCT2)->CT2_DATA
	
		lFirst:= .T.
		nTotalDeb := 0
		nTotalCrd := 0
	
		oSection1:Init()
		oSection1:PrintLine()
		oSection1:Finish()

		oSection11:Init()

		While (cAliasCT2)->(!Eof()) .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") 	.And.;
			Dtos((cAliasCT2)->CT2_DATA) == Dtos(dData) 	.And.;
			(cAliasCT2)->CT2_LOTE == cLote 				.And.;
			(cAliasCT2)->CT2_SBLOTE == cSubLote 		.And.;
			(cAliasCT2)->CT2_DOC == cDoc


			If oReport:Cancel()
				Exit
			EndIf

			#IFNDEF TOP
				If Ctr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
			#ELSE
				If TcSrvType() == "AS/400"
					If Ctr070Skip(cAliasCT2,lAllSL)
						Loop
					EndIf
				EndIf
			#ENDIF

			oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )

			If (cAliasCT2)->CT2_DC = "1" 

				oSection11:Cell("CT2_DC"):SetBlock( { || cDebit } )									

				If mv_par08 == 2
					dbSelectArea("CT1")
					oSection11:Cell("CCONTAD"):SetBlock( { || CT1->CT1_RES} )													
                   	dbSelectArea( cAliasCT2 )									
                ELSE
					oSection11:Cell("CCONTAD"):SetBlock( { || (cAliasCT2)->CT2_DEBITO } )					                	    
                ENDIF
                	
				oSection11:Cell("CCUSTOD"):SetBlock( { || Ctr070CTT((cAliasCT2)->CT2_CCD) } )
					
				oSection11:Cell("CITEMD"):SetBlock( { || Ctr070CTD((cAliasCT2)->CT2_ITEMD) } )					

				oSection11:Cell("CCLASSED"):SetBlock( { || Ctr070CTH((cAliasCT2)->CT2_CLVLDB) } )							

				oSection11:Cell("CDEBITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )					
				oSection11:Cell("CCREDITO"):SetBlock( { || 0 } )						


				nTotalDeb += (cAliasCT2)->CT2_VALOR

			ElseIf (cAliasCT2)->CT2_DC = "2" 
				
				oSection11:Cell("CT2_DC"):SetBlock( { || cCredit } )  

				If mv_par08 == 2
					dbSelectArea("CT1")
						oSection11:Cell("CCONTAC"):SetBlock( { || CT1->CT1_RES} )													
					dbSelectArea( cAliasCT2 )									
				ELSE 
					oSection11:Cell("CCONTAC"):SetBlock( { || (cAliasCT2)->CT2_CREDITO } )						
				ENDIF						
					
				oSection11:Cell("CCUSTOC"):SetBlock( { || Ctr070CTT((cAliasCT2)->CT2_CCC) } )
			
				oSection11:Cell("CITEMC"):SetBlock( { || Ctr070CTD((cAliasCT2)->CT2_ITEMC) } )					
		
				oSection11:Cell("CCLASSEC"):SetBlock( { || Ctr070CTH((cAliasCT2)->CT2_CLVLCR) } )							
		
				oSection11:Cell("CDEBITO"):SetBlock( { || 0 } )
				oSection11:Cell("CCREDITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )						

				nTotalCrd += (cAliasCT2)->CT2_VALOR
  

			ElseIf (cAliasCT2)->CT2_DC = "3"
					  
				dbSelectArea( cAliasCT2 )

				oSection11:Cell( "CT2_LINHA" ):SetBlock( { || (cAliasCT2)->CT2_LINHA	} )
 				oSection11:Cell( "CT2_DC" ):SetBlock( { || (cAliasCT2)->CT2_DC } )
 						
 						

				If mv_par08 == 2
					dbSelectArea("CT1")

					oSection11:Cell("CCONTAD"):SetBlock( { || CT1->CT1_RES} )
					oSection11:Cell("CCONTAC"):SetBlock( { || CT1->CT1_RES} )

					dbSelectArea( cAliasCT2 )
				Else                             
					oSection11:Cell("CCONTAD"):SetBlock( { || (cAliasCT2)->CT2_DEBITO })
					oSection11:Cell("CCONTAC"):SetBlock( { || (cAliasCT2)->CT2_CREDIT })
				Endif

				oSection11:Cell("CCUSTOD"):SetBlock( { || Ctr070CTT((cAliasCT2)->CT2_CCD) } )
				oSection11:Cell("CCUSTOC"):SetBlock( { || Ctr070CTT((cAliasCT2)->CT2_CCC) } )
			
				oSection11:Cell("CITEMD"):SetBlock( { || Ctr070CTD((cAliasCT2)->CT2_ITEMD) } )	
				oSection11:Cell("CITEMC"):SetBlock( { || Ctr070CTD((cAliasCT2)->CT2_ITEMC) } )	

				oSection11:Cell("CCLASSED"):SetBlock( { || Ctr070CTH((cAliasCT2)->CT2_CLVLCR) } )							
				oSection11:Cell("CCLASSEC"):SetBlock( { || Ctr070CTH((cAliasCT2)->CT2_CLVLDB) } ) 
				
				oSection11:Cell("CDEBITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )							
				oSection11:Cell("CCREDITO"):SetBlock( { || (cAliasCT2)->CT2_VALOR } )						
				
				nTotalDeb += (cAliasCT2)->CT2_VALOR
				nTotalCrd += (cAliasCT2)->CT2_VALOR

			Endif            			
		
	   		oSection11:PrintLine()   
   		
   			IF mv_par21 == 1 
				// Procura pelo complemento de historico
				cSeq 	:= (cAliasCT2)->CT2_SEQLAN
				cEmpOri	:= (cAliasCT2)->CT2_EMPORI
				cFilOri	:= (cAliasCT2)->CT2_FILORI
				nReg := Recno()
				dbSelectArea("CT2")
				dbSetOrder(10)
				If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
					CT2->(dbSkip())
					If CT2->CT2_DC == "4"
						While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
								CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
								CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
								CT2->CT2_FILORI == cFilOri 	.And. ;
								DTOS(CT2->CT2_DATA) == DTOS(dData)
										
									If CT2->CT2_DC == "4"
											oSection11:Cell( "CT2_HP"    ):SetBlock( { || (cAliasCT2)->CT2_HP 		} )
											oSection11:Cell( "CT2_HIST"  ):SetBlock( { || (cAliasCT2)->CT2_HIST	} )
											RpPrintHist( cAliasCT2 , oSection11 ) // faz a impressao do historico detalhado				
       											
											
										CT2->(dbSkip())
									ENDIF	
						EndDo
					EndIf
				EndIf
				dbSelectArea("CT2")
				dbSetOrder(1)					
				dbGoto(nReg) 
							
				dbSelectArea(cAliasCT2)
           ENDIF
			(cAliasCT2)->( DbSkip() )		
		Enddo

		oSection11:Finish()
	 	
		If lTotal
			oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0018 } )	// "TOTAL DOCUMENTO"
			oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform(nTotalDeb,Tm(nTotalDeb, 18) ) } )
			oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform(nTotalCrd,Tm(nTotalCrd, 18) ) } )
			If lTot123
				CTC->(DbSetOrder(1))		
				CTC->(MsSeek(xFilial("CTC")+dtos(dData)+cLote+cSubLote+cDoc+cMoeda))		
                //Davi Torchio  17/07/07	                                ///
                //Tratamento para nao pegar valor de tipo de saldo diferente///
			    /////////////////////////////////////////////////////////////// 
				While dtos(dData)== DTOS(CTC->CTC_DATA) 
				   If cLote == CTC->CTC_LOTE .AND. cSubLote == CTC->CTC_SBLOTE .AND. cDoc == CTC->CTC_DOC .AND. cMoeda == CTC->CTC_MOEDA
					  IF CTC->CTC_TPSALD == MV_PAR11 .OR. MV_PAR11 == "*" 
					         nDocInf += CTC->CTC_INF
        	                 nDocDig += CTC->CTC_DIG
				 			 oSection2:Cell( "TOT_INF"    ):SetBlock( { || Transform(nDocInf, Tm(nDocInf, 18) ) } )
							 oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform(nDocDig, Tm(nDocDig, 18) ) } )
							 oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform(ROUND(NOROUND(nDocDig - nDocInf,10),2), Tm(nDocDig, 18) ) } )
					  ENDIF		
				   ENDIF 
				   CTC->(DBSKIP())   
				ENDDO              
			Endif

			oSection2:Init()
			oSection2:PrintLine()
			oSection2:Finish()
	                          
	         nDocInf := 0
             nDocDig := 0

			If mv_par12 == 2
				oReport:EndPage()
			EndIf
			
			nTotalDeb := 0	
			nTotalCrd := 0	
			
		   // Davi Torchio 17/07/07                                              ///
           // Total do Lote soma todos os tipos de lançamentos que contem no lote///  
           /////////////////////////////////////////////////////////////////////////
  			If	cLote <> (cAliasCT2)->CT2_LOTE .Or.;
				cSubLote <> (cAliasCT2)->CT2_SBLOTE .Or.;
				DtoS(dData) <> DtoS((cAliasCT2)->CT2_DATA)
			
				CT6->(DbSetOrder(1))		
				CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))           
				WHILE DtoS(dData) == DtoS(CT6->CT6_DATA)
				  IF cLote == CT6->CT6_LOTE .AND. cSubLote == CT6->CT6_SBLOTE .AND. cMoeda == CT6->CT6_MOEDA
				       nTotLotDeb += CT6->CT6_DEBITO
			           nTotLotCrd += CT6->CT6_CREDIT       

			           nInf += CT6->CT6_INF
			           nDig += CT6->CT6_DIG 
				  Endif
				  CT6->(DBSKIP())
				ENDDO
				oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0020 } )	// "TOTAL LOTE"
				oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform( nTotLotDeb, Tm(nTotLotDeb, 18) ) } )
				oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform( nTotLotCrd, Tm(nTotLotCrd, 18) ) } )
				If lTot123
					CT6->(DbSetOrder(1))		
				 	CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))
	    		 	IF cLote == CT6->CT6_LOTE .AND. CT6->CT6_TPSALD == MV_PAR11
						oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform( nDig, Tm( nDig, 18 ) ) } )
						oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform( nDig - nInf, Tm( nDig, 18 ) ) } )
						oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform( ROUND(NOROUND(CT6->CT6_DIG - CT6->CT6_INF,10),2), Tm(CT6->CT6_DIG, 18 ) ) } )
					ENDIF    
				Endif  

				oSection2:Init()				
				oSection2:PrintLine()
				oSection2:Finish()

				If mv_par12 == 1
					oReport:EndPage()
				EndIf
                // Pego os valores dos Lotes para o Total geral
				nTotGerDeb += nTotLotDeb
				nTotGerCrd += nTotLotCrd
				nTotGerInf += nInf
				nTotGerDig += nDig     
				// zero as variais para nao acumular valor
				nTotLotDeb := 0
				nTotLotCrd := 0
     		    nInf 	   := 0
			 	nDig 	   := 0
					 					
			Endif

		Endif

		dbselectarea( cAliasCT2 )
		oReport:IncMeter()
	Enddo

Endif  

If lTotal 

	oSection2:Cell( "TOT_DESCRI" ):SetBlock( { || STR0019 } ) // "TOTAL GERAL"
	oSection2:Cell( "TOT_DEBITO" ):SetBlock( { || Transform( nTotGerDeb, Tm( nTotGerDeb, 18 ) ) } )
	oSection2:Cell( "TOT_CREDITO"):SetBlock( { || Transform( nTotGerCrd, Tm( nTotGerCrd, 18 ) ) } )

	If lTot123
		oSection2:Cell( "TOT_INF"    ):SetBlock( { || Transform( nTotGerInf, Tm(nTotGerInf, 18) ) } )
		oSection2:Cell( "TOT_DIG"    ):SetBlock( { || Transform( nTotGerDig, Tm(nTotGerDig, 18) ) } )
		oSection2:Cell( "TOT_DIFINF" ):SetBlock( { || Transform( ROUND(NOROUND(nTotGerDig - nTotGerInf, 10) , 2), Tm(nTotGerInf, 18) ) } )
	Endif

	oSection2:Init()
	oSection2:PrintLine()
	oSection2:Finish()
	
    // ZERO AS VARIAS DO TOTAL GERAL PARA NAO ACUMULAR VALOR INDEVIDO
	nTotGerDeb := 0
	nTotGerCrd := 0
	nTotGerInf := 0
	nTotGerDig := 0
    
Endif

oReport:IncMeter()

Return
                     
/*
-------------------------------------------------------- RELEASE 3 -------------------------------------------------------------
*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ Ctbr070	³ Autor ³ Pilar S Albaladejo	³ Data ³ 12.09.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Conferencia de Digitacao               	 				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctbr070()    											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctbr070R3()
Local aCtbMoeda		:= {}
LOCAL cDesc1 		:= STR0001	//"Este programa ira imprimir o Relatorio para Conferencia"
LOCAL cDesc2 		:= STR0002   //"de Digitacao - Modelo 1. Ideal para Plano de Contas "
LOCAL cDesc3		:= STR0003   //"que possuam codigos nao muito extensos.            "
LOCAL wnrel
LOCAL cString		:= "CT2"
Local titulo 		:= STR0004 	//"Conferencia de Digitacao - Modelo 1"
Local lRet			:= .T.
Local lCusto 		:= .F.
Local lItem 		:= .F.
Local lCV	 		:= .F.
Local Limite		:= 132
Local cDescMoeda	:= ""

PRIVATE Tamanho		:="M"
PRIVATE nLastKey 	:= 0
PRIVATE cPerg	 	:= "CTR070"
PRIVATE aReturn 	:= { STR0005, 1,STR0006, 2, 2, 1, "",1 }  //"Zebrado"###"Administracao"
PRIVATE aLinha		:= {}
PRIVATE nomeProg  := "CTBR070"

Private lTot123
li 		:= 80
m_pag	:= 1

Pergunte("CTR070",.F.)
            
If mv_par17 == 1		// Resumido
	Titulo += STR0022
EndIf	

If mv_par09 == 1 
	lCusto := .T.
Else 
	lCusto := .F.	
Endif	

If mv_par10 == 1 
	lItem := .T.
Else 
	lItem := .F.	
Endif	

If mv_par14 == 1 
	lCV := .T.
Else 
	lCV := .F.	
Endif	

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros						 	³
//³ mv_par01				// Data Inicial                  	 	³
//³ mv_par02				// Data Final                         	³
//³ mv_par03				// Lote  Inicial                        ³
//³ mv_par04				// Lote  Final  						³
//³ mv_par05				// Documento Inicial                    ³
//³ mv_par06				// Documento Final			    		³
//³ mv_par07				// Moeda?						     	³
//³ mv_par08				// Cod Conta? Normal / Reduzido 		³
//³ mv_par09				// Imprime C. Custo? Sim / Nao	    	³
//³ mv_par10				// Imprime Item? Sim / Nao			    ³
//³ mv_par11				// Imprime Lcto? Realiz. / Orcado / Pre ³
//³ mv_par12				// Quebra Pagina por?Lote/Doc/Nao Quebra³
//³ mv_par13				// Totaliza    ? Sim / Nao			    ³
//³ mv_par14				// Imprime Classe de Valores? Sim / Nao ³
//³ mv_par15				// Sub-Lote Inicial                  	³
//³ mv_par16				// Sub-Lote Final  						³
//³ mv_par17				// Imprime? Resumido / Completo			³
//³ mv_par18				// Cod C.C. ? Normal / Reduzido			³
//³ mv_par19				// Cod Item ? Normal / Reduzido 		³
//³ mv_par20				// Cod Cl.Vlr? Normal / Reduzido 		³
//³ mv_par21				// Impr. Compl. Part. Dobrada? Sim/Não  ³
//³ SE FOR PARA O CHILE							               	 	³
//³ mv_par22				// Do Corrrelativo               	 	³
//³ mv_par23				// Ate Correlativo                    	³
//³ mv_par24				// Imp.Tot.Inf/Dig/Dif?           	 	³
//³ SE NAO FOR PARA O CHILE        				              	 	³
//³ mv_par22				// Imp.Tot.Inf/Dig/Dif?           	 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel	:= "CTBR070"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If mv_par09 == 1                   
	lCusto := .T.
Else 
	lCusto := .F.	 
Endif	

If mv_par10 == 1 
	lItem := .T.
Else 
	lItem := .F.	
Endif	

If mv_par14 == 1 
	lCV := .T.
Else 
	lCV := .F.	
Endif	
                                                                      
lTot123 := If( cPaisLoc = "CHI", mv_par24, mv_par22)

If nLastKey == 27
	Set Filter To
	Return
Endif

If lRet
	aCtbMoeda  	:= CtbMoeda(mv_par07)
	If Empty(aCtbMoeda[1])                       
      Help(" ",1,"NOMOEDA")
      Set Filter To
      Return
   Endif
Endif

cDescMoeda 	:= Alltrim(aCtbMoeda[2])

Titulo	+= STR0030 + cDescMoeda

// Somente caso imprima dois tipos juntos envio como 220 colunas
If (mv_par17 == 2) .And. ((lCusto .And. lItem) .Or. (lItem .And. lCv) .Or. (lCusto .And. lCv) .Or.;
   (lCusto .And. lItem .And. lCv)) .Or. ( mv_par17 = 1 .And. lTot123 == 1)
	tamanho := "G"
	Limite  := 220
Endif

SetDefault(aReturn,cString,,,Tamanho,If(Tamanho="G",2,1))	

If nLastKey == 27
	Set Filter To
	Return
Endif

RptStatus({|lEnd| CTR070Imp(@lEnd,wnRel,cString,Titulo,lCusto,lItem,lCV,Limite)})

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CTR070IMP ³ Autor ³ Pilar S. Albaladejo   ³ Data ³ 24.07.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Imprime relatorio -> Conferencia Digitacao Modelo 1        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CTR070Imp(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV)       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpL1   - A‡ao do Codeblock                                ³±±
±±³          ³ ExpC1   - T¡tulo do relat¢rio                              ³±±
±±³          ³ ExpC2   - Mensagem                                         ³±±
±±³          ³ ExpC3   - Titulo                                           ³±±
±±³          ³ ExpL1   - Define se imprime o centro de custo              ³±±
±±³          ³ ExpL2   - Define se imprime o item                         ³±±
±±³          ³ ExpL3   - Define se imprime a classe de valor              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function CTR070Imp(lEnd,WnRel,cString,Titulo,lCusto,lItem,lCV,Limite)

LOCAL CbTxt		:= Space(10)
Local CbCont	:= 0
Local cabec1  	:= ""                                       
Local cabec2  	:= " "

Local aColunas		:= {}
Local cLote
Local cSubLote
Local cDoc                
Local cMoeda		:= mv_par07
Local cSayItem		:= CtbSayApro("CTD")
Local cSayCC		:= CtbSayApro("CTT")
Local cSayCV		:= CtbSayApro("CTH")
Local cLoteRes
Local cSubRes
Local cDocRes
Local dDataRes		:= CTOD("  /  /  ")
Local dData
Local lTotal		:= Iif(mv_par13 == 1,.T.,.F.)
Local lResumo	    := Iif(mv_par17 == 1,.T.,.F.)
Local lPrimPag		:= .T.
Local lQuebraDoc	:= .F.
Local cSEGOFI		:= "" //Correlativo para o Chile
Local nTotalDeb		:= 0
Local nTotalCrd		:= 0
Local nTotLotDeb	:= 0
Local nTotLotCrd	:= 0
Local nTotGerDeb	:= 0
Local nTotGerCrd	:= 0
Local nTotGerInf	:= nTotGerDig := 0
Local nDif			:= 0
Local nCol
Local n       
Local nStr
Local lAllSL		:= If(Empty(mv_par11) .or. mv_par11=="*",.T.,.F.)
Local nLotInf       := 0
Local nLotDig       := 0 
Local nDocInf       := 0
Local nDocDig       := 0

If !lResumo
	If !lCusto .And. !lItem .And. !lCV //So imprime a conta
		Cabec1 := STR0007+space(19)+STR0015
	Else
	
	/*
	
	LI TP CONTA                C CUSTO              ITEM CONTA           COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST
	
	      12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890
	
	LI TP CONTA                ITEM CONTA           COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST
	
	      12345678901234567890 12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890
	      
	LI TP CONTA                COD CL VAL                   VALOR DEB        VALOR CRED  HP HIST
	                           12345678901234567890         VALOR DEB        VALOR CRED  HP HIST 
	
	      12345678901234567890 12345678901234567890 12345678901234567 12345678901234567 123 1234567890123456789012345678901234567890
	*/
	
		Cabec1 := STR0008
		If lCusto .And. lItem .And. lCv
			aColunas := { 027, 048, 069, 090, 108, 126, 130 }
		ElseIf (lCusto .And. lItem)
			aColunas := { 027, 048, 000, 069, 087, 105, 109 }
		ElseIf (lCusto .And. lCv)
			aColunas := { 027, 000, 048, 069, 087, 105, 109 }
		ElseIf (lItem .And. lCv)
			aColunas := { 000, 027, 048, 069, 087, 105, 109 }
		ElseIf lCusto
			aColunas := { 027, 000, 000, 048, 066, 084, 088 }
		ElseIf lItem
			aColunas := { 000, 027, 000, 048, 066, 084, 088 }
		Else
			aColunas := { 000, 000, 027, 048, 066, 084, 088 }
		Endif 
		If lCusto
			Cabec1 += Upper(Left(cSayCC + Space(21), 21))
		Endif
		If lItem
			Cabec1 += Upper(Left(cSayItem + Space(21), 21))
		Endif
		If lCv
			Cabec1 += Upper(Left(cSayCv + Space(21), 21))
		Endif
		Cabec1 += STR0016
	EndIf
Else     
	If lTot123 == 1
		Cabec1 := STR0021 
	Else
		Cabec1 := STR0031 
	EndIF
	
	CTC->(DbSetOrder(1))
/*
DATA          LOTE      SUBLOTE    DOCUMENTO      TOTAL INFORMADO       VALOR A DEBITO      VALOR A CREDITO           DIFERENCA                        TOTAL DIGITADO    DIFERENCA INF/DIG
***********************************************************************************************************************************************************************************************************
10/06/2002    008850        001       000001             2.500,00             2.500,00             2.500,00                0,00    1234567890123             2.500,00                 0,00    1234567890123
*/                                                                                                                                                                                         
EndIf	


#IFDEF TOP
	If TcSrvType() <> "AS/400"

		cQuery := "SELECT * FROM " + RetSqlName("CT2")     + " "
		cQuery += "WHERE CT2_FILIAL  = '" + xFilial("CT2") + "' AND " 
		cQuery +=       "CT2_DATA   >= '" + DTOS(mv_par01) + "' AND "
		cQuery += 	    "CT2_DATA   <= '" + DTOS(mv_par02) + "' AND "
		cQuery += 	    "CT2_LOTE   >= '" + mv_par03 	   + "' AND "
		cQuery += 	    "CT2_LOTE   <= '" + mv_par04 	   + "' AND "
		cQuery += 	    "CT2_SBLOTE >= '" + mv_par15 	   + "' AND "
		cQuery += 		"CT2_SBLOTE <= '" + mv_par16 	   + "' AND "
		cQuery +=   	"CT2_DOC    >= '" + mv_par05 	   + "' AND "
		cQuery += 		"CT2_DOC    <= '" + mv_par06 	   + "' AND "
		cQuery += 		"CT2_MOEDLC = '"+ mv_par07 + "' AND "
		If !lAllSL
			cQuery += 		"CT2_TPSALD = '"+ mv_par11 + "' AND "		
		EndIf
		cQuery += 		"CT2_DC <> '4' AND "
		cQuery +=       "D_E_L_E_T_ = '' " 
		cQuery += "ORDER BY CT2_FILIAL, CT2_DATA, CT2_LOTE, CT2_SBLOTE, CT2_DOC, CT2_LINHA"

		cQuery := ChangeQuery(cQuery)		   

		If Select("cArqCT2") > 0
			dbSelectArea("cArqCT2")
			dbCloseArea()
		Endif

		dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cArqCT2",.T.,.F.)

        aStrSTRU := CT2->(dbStruct())      //// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
        
		For nStr := 1 to Len( CT2->(dbStruct()) )        //// LE A ESTRUTURA DA TABELA
			If aStrSTRU[nStr][2] <> "C" .and. cArqCT2->(FieldPos(aStrSTRU[nStr][1])) > 0
				TcSetField("cArqCT2",aStrSTRU[nStr][1],aStrSTRU[nStr][2],aStrSTRU[nStr][3],aStrSTRU[nStr][4])
			EndIf
		Next

		dbSelectArea("cArqCT2")
		cAliasCT2 := "cArqCT2"
	Else
#ENDIF

	dbSelectArea("CT2")
	dbSetOrder(1)                         
	dbSeek( xFilial("CT2") + DTOS( mv_par01 ) + mv_par03 + mv_par15 + mv_par05 ,.T.)
	
	cAliasCT2 := "CT2"
	
#IFDEF TOP
	EndIf
#ENDIF

SetRegua(RecCount())

While !Eof() .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") .And.;
				   (cAliasCT2)->CT2_DATA <= mv_par02                       

	// Tratando o filtro que o usuario informou para o relatorio
	If ! Empty( aReturn[7] )
		If ! &(aReturn[7])
			(cAliasCT2)->( DbSkip() )
			Loop
		EndIf
	EndIf
						
	If lEnd
		@Prow()+1,0 PSAY STR0009   //"***** CANCELADO PELO OPERADOR *****"
		Exit
	EndIF                      
	
	#IFNDEF TOP
		If Ctr070Skip(cAliasCT2,lAllSL)   
			Loop
		EndIf	
	#ELSE
		If TcSrvType() == "AS/400"
			If Ctr070Skip(cAliasCT2,lALLSL)
				Loop
			EndIf		
		EndIf
	#ENDIF

	IncRegua()

	cLote 		:= (cAliasCT2)->CT2_LOTE
	cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
	cDoc		:= (cAliasCT2)->CT2_DOC
	dData 		:= (cAliasCT2)->CT2_DATA
	
	cLoteRes 	:= (cAliasCT2)->CT2_LOTE
	cSubRes		:= (cAliasCT2)->CT2_SBLOTE
	cDocRes		:= (cAliasCT2)->CT2_DOC
	dDataRes	:= (cAliasCT2)->CT2_DATA

	
	If cPaisLoc == "CHI"	
		cSegOfi := (cAliasCT2)->CT2_SEGOFI
	EndIf		
	lFirst:= .T.
	nTotalDeb := 0
	nTotalCrd := 0

	lQuebraDoc := Iif(mv_par12==2,.T.,.F.)
	While (cAliasCT2)->(!Eof()) .And. (cAliasCT2)->CT2_FILIAL == xFilial("CT2") 	.And.;
						Dtos((cAliasCT2)->CT2_DATA) == Dtos(dData) 	.And.;
						(cAliasCT2)->CT2_LOTE == cLote 				.And.;
						(cAliasCT2)->CT2_SBLOTE == cSubLote 		.And.;
						(cAliasCT2)->CT2_DOC == cDoc

		// Tratando o filtro que o usuario informou para o relatorio
		If ! Empty( aReturn[7] )
			If ! &(aReturn[7])
				(cAliasCT2)->( DbSkip() )
				Loop
			EndIf
		EndIf
						
		#IFNDEF TOP
			If Ctr070Skip(cAliasCT2,lAllSL)
				Loop
			EndIf
		#ELSE
			If TcSrvType() == "AS/400"
				If Ctr070Skip(cAliasCT2,lAllSL)
					Loop
				EndIf
			EndIf
		#ENDIF

		IncRegua()

		IF (!lResumo .And. li > 62) .Or. lQuebraDoc
			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			If lQuebraDoc .Or. lPrimPag
				lPrimPag	:= .F.				
			EndIf	
			lQuebraDoc := .F.
		EndIf

		If lFirst .And. !lResumo
			@ li,00 PSAY Replicate("-",Limite)			
			li++
			@ li,000 PSAY STR0012
			@ li,007 PSAY DTOC(dData)
			@ li,019 PSAY STR0013
			@ li,027 PSAY cLote
			@ li,038 PSAY STR0017 //"Sub-Lote"
			@ li,049 PSAY cSubLote
			@ li,058 PSAY STR0014
			@ li,064 PSAY cDoc
			If cPaisLoc == "CHI"
				@ Li,80 PSAY STR0029 + cSegOfi
			EndIf		
			lFirst := .F.
			li ++
			@ li,00 PSAY Replicate("-",Limite)						
			li++
		EndIf
	
		If !lResumo			// Imprime o relatorio detalhado
			If ! lCusto .And. ! lItem .And. ! lCv //Se nao imprime C.C, Item E Cl.Valores
				@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
				@ li, 004 PSAY (cAliasCT2)->CT2_DC
				If mv_par08 == 2
					dbSelectArea("CT1")
					dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
					@ li, 006 PSAY CT1->CT1_RES
					dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)				
					@ li, 027 PSAY CT1->CT1_RES
					dbSelectArea(cAliasCT2)				
				Else
					@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
					@ li, 027 PSAY (cAliasCT2)->CT2_CREDIT
				Endif			
	  	
				nValor	:= (cAliasCT2)->CT2_VALOR
  	
				If (cAliasCT2)->CT2_DC == "1" .Or. (cAliasCT2)->CT2_DC == "3" 
					@ li, 049 PSAY nValor Picture Tm(nValor,17)
					nTotalDeb += nValor
				Endif
				If (cAliasCT2)->CT2_DC == "2" .Or. (cAliasCT2)->CT2_DC == "3"
					@ li, 070 PSAY nValor Picture Tm(nValor,17)
					nTotalCrd += nValor
				Endif
				@ li, 088 PSAY (cAliasCT2)->CT2_HP
				@ li, 092 PSAY (cAliasCT2)->CT2_HIST

			Else //Se imprime C.C ou Item ou Cl. Valores os lanc. tipo '3' serao desdobrados
				If (cAliasCT2)->CT2_DC == '1' .Or. (cAliasCT2)->CT2_DC =='2'//Se o lancamento e tipo '1' ou '2'
					@ li, 000 PSAY (cAliasCT2)->CT2_LINHA
					@ li, 004 PSAY (cAliasCT2)->CT2_DC
					If mv_par08 == 2
						dbSelectArea("CT1")
						If (cAliasCT2)->CT2_DC == '1'
							dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
							@ li, 006 PSAY CT1->CT1_RES      
						ElseIf (cAliasCT2)->CT2_DC == '2'												
							dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)				
							@ li, 006 PSAY CT1->CT1_RES
						Endif
						dbSelectArea(cAliasCT2)
					Else
						If (cAliasCT2)->CT2_DC == '1'
							@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
						ElseIf (cAliasCT2)->CT2_DC == '2'					
							@ li, 006 PSAY (cAliasCT2)->CT2_CREDIT
						Endif
					Endif			
	  	
					nValor := (cAliasCT2)->CT2_VALOR
					If (cAliasCT2)->CT2_DC == '1'
						If lCusto
							@ li,aColunas[CENTRO_CUSTO] PSAY Ctr070CTT((cAliasCT2)->CT2_CCD)
						Endif
						If lItem
							@ li,aColunas[ITEM_CONTABIL] PSAY Ctr070CTD((cAliasCT2)->CT2_ITEMD)
						Endif   
						If lCv
							@ li,aColunas[CLASSE_VALOR] PSAY Ctr070CTH((cAliasCT2)->CT2_CLVLDB)
						Endif						
						@ li,aColunas[VALOR_DEBITO] PSAY nValor Picture Tm(nValor,17)
						nTotalDeb += nValor
					ElseIf (cAliasCT2)->CT2_DC =='2'
						If lCusto
							@ li,aColunas[CENTRO_CUSTO] PSAY Ctr070CTT((cAliasCT2)->CT2_CCC)
						Endif
						If lItem
							@ li,aColunas[ITEM_CONTABIL] PSAY Ctr070CTD((cAliasCT2)->CT2_ITEMC)
						Endif   
						If lCv
							@ li,aColunas[CLASSE_VALOR] PSAY Ctr070CTH((cAliasCT2)->CT2_CLVLCR)
						Endif						
						@ li,aColunas[VALOR_CREDITO] PSAY nValor Picture Tm(nValor,17)
						nTotalCrd += nValor
					Endif	
					@ li, aColunas[CODIGO_HP] PSAY (cAliasCT2)->CT2_HP
					@ li, aColunas[HISTORICO] PSAY (cAliasCT2)->CT2_HIST                       
									
				Elseif (cAliasCT2)->CT2_DC == '3' //Se o lancamento e tipo '3', e desdobrado
					For n:=1 to 2
					   @ li, 000 PSAY (cAliasCT2)->CT2_LINHA
					   If n == 1
							@ li, 004 PSAY '1'
						Else                
							@ li, 004 PSAY '2'
						Endif						
						If mv_par08 == 2
							dbSelectArea("CT1")
							If n==1
								dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_DEBITO)
								@ li, 006 PSAY CT1->CT1_RES
							Else
								dbSeek(xFilial("CT1")+(cAliasCT2)->CT2_CREDIT)				
								@ li, 006 PSAY CT1->CT1_RES
							Endif
							dbSelectArea(cAliasCT2)
						Else                             
							If n==1
								@ li, 006 PSAY (cAliasCT2)->CT2_DEBITO
							Else
								@ li, 006 PSAY (cAliasCT2)->CT2_CREDIT
							Endif
						Endif			
	  		
						nValor	:= (cAliasCT2)->CT2_VALOR
						If n == 1
							If lCusto
								@ li,aColunas[CENTRO_CUSTO] PSAY Ctr070CTT((cAliasCT2)->CT2_CCD)
							Endif
							If lItem
								@ li,aColunas[ITEM_CONTABIL] PSAY Ctr070CTD((cAliasCT2)->CT2_ITEMD)
							Endif   
							If lCv
								@ li,aColunas[CLASSE_VALOR] PSAY Ctr070CTH((cAliasCT2)->CT2_CLVLDB)
							Endif						
							@ li,aColunas[VALOR_DEBITO] PSAY nValor Picture Tm(nValor,17)
							nTotalDeb += nValor
						Else
							If lCusto
								@ li,aColunas[CENTRO_CUSTO] PSAY Ctr070CTT((cAliasCT2)->CT2_CCC)
							Endif
							If lItem
								@ li,aColunas[ITEM_CONTABIL] PSAY Ctr070CTD((cAliasCT2)->CT2_ITEMC)
							Endif   
							If lCv
								@ li,aColunas[CLASSE_VALOR] PSAY Ctr070CTH((cAliasCT2)->CT2_CLVLCR)
							Endif						
							@ li,aColunas[VALOR_CREDITO] PSAY nValor Picture Tm(nValor,17)						
							nTotalCrd += nValor
						Endif
						@ li, aColunas[CODIGO_HP]	PSAY (cAliasCT2)->CT2_HP
						@ li,aColunas[HISTORICO] 	PSAY (cAliasCT2)->CT2_HIST
						
						If n == 1 .and. mv_par21 == 1
							// Procura pelo complemento de historico
							cSeq 	:= (cAliasCT2)->CT2_SEQLAN
							cEmpOri	:= (cAliasCT2)->CT2_EMPORI
							cFilOri	:= (cAliasCT2)->CT2_FILORI
							nReg := Recno()
							dbSelectArea("CT2")
							dbSetOrder(10)
							If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
								dbSkip()
								If CT2->CT2_DC == "4"
									While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
										CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
										CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
										CT2->CT2_FILORI == cFilOri 	.And. ;
										DTOS(CT2->CT2_DATA) == DTOS(dData)
										
										If CT2->CT2_DC == "4"
											li++
											IF li > 62
												/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
												Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
										   		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
											EndIf
											If !lCusto .And. !lItem .And. !lCV
												@ li, 000 PSAY CT2->CT2_LINHA
												@ li, 004 PSAY CT2->CT2_DC
												@ li, 097 PSAY CT2->CT2_HIST
											Else
												@ li, 000 PSAY CT2->CT2_LINHA
												@ li, 004 PSAY CT2->CT2_DC
												@ li, aColunas[HISTORICO] PSAY CT2->CT2_HIST
											EndIf
										EndIf
										dbSkip()
									EndDo
								EndIf
							EndIf
							dbSelectArea("CT2")
							dbSetOrder(1)					
							dbGoto(nReg) 
							
							dbSelectArea(cAliasCT2)
							li++
						ElseIf n == 1
							li++
						EndIf
					Next
				Endif
			EndIf
			
			// Procura pelo complemento de historico
			cSeq 	:= (cAliasCT2)->CT2_SEQLAN
			cEmpOri	:= (cAliasCT2)->CT2_EMPORI
			cFilOri	:= (cAliasCT2)->CT2_FILORI
			nReg := Recno()
			dbSelectArea("CT2")
			dbSetOrder(10)
			If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
				dbSkip()
				If CT2->CT2_DC == "4"
					While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
						CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
						CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
						CT2->CT2_FILORI == cFilOri 	.And. ;
						DTOS(CT2->CT2_DATA) == DTOS(dData)
						
						If CT2->CT2_DC == "4"
							li++
							IF li > 62
								/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
								Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
						   		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)							
							EndIf
							If !lCusto .And. !lItem .And. !lCV
								@ li, 000 PSAY CT2->CT2_LINHA
								@ li, 004 PSAY CT2->CT2_DC
								@ li, 097 PSAY CT2->CT2_HIST
							Else
								@ li, 000 PSAY CT2->CT2_LINHA
								@ li, 004 PSAY CT2->CT2_DC
								@ li, aColunas[HISTORICO] PSAY CT2->CT2_HIST
							EndIf
						EndIf
						dbSkip()
					EndDo
				EndIf
			EndIf
			dbSetOrder(1)			
			
			dbSelectArea(cAliasCT2)
			dbGoto(nReg)
			dbSkip()
			li++
			IF li > 62
		   		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
				/*Cabec( Titulo, Cabec1, Cabec2, NomeProg, Tamanho,;
					Iif(aReturn[4] == 1, GetMv("MV_COMP"), GetMv("MV_NORM")))*/
			EndIf
		Else						// Armazena valores para impressa resumida
			cLoteRes 	:= (cAliasCT2)->CT2_LOTE
			cSubRes		:= (cAliasCT2)->CT2_SBLOTE
			cDocRes		:= (cAliasCT2)->CT2_DOC
			dDataRes	:= (cAliasCT2)->CT2_DATA
			If (cAliasCT2)->CT2_DC == "1" .Or. (cAliasCT2)->CT2_DC == "3"
			nValor := (cAliasCT2)->CT2_VALOR
				nTotalDeb += nValor
			EndIf
			If (cAliasCT2)->CT2_DC == "2" .Or. (cAliasCT2)->CT2_DC == "3"
			nValor := (cAliasCT2)->CT2_VALOR
				nTotalCrd += nValor
			EndIf	
			dbSkip()
		EndIf
	EndDO

	If lTotal .And. !lResumo			// Relatorio Completo
		li++
		@ li,02 PSAY STR0018
		CTC->(MsSeek(xFilial("CTC")+dtos(dData)+cLote+cSubLote+cDoc+cMoeda))
		///Davi Torchio 18/07/07                                         ///
		///Tratamento para soma dos documentos por tipo de saldo         ///
		////////////////////////////////////////////////////////////////////
		While cLote == CTC->CTC_LOTE 
			IF MV_PAR11 == "*"
				nDocInf += CTC->CTC_INF      
				nDocDig += CTC->CTC_DIG      
		    ELSEIF MV_PAR11 == CTC->CTC_TPSALD
		        nDocInf += CTC->CTC_INF      
				nDocDig += CTC->CTC_DIG
			ENDIF
		 CTC->(DBSKIP())
		ENDDO
		If !lCusto .And. !lItem  .And. !lCV                     
			@ li, 049 		PSAY nTotalDeb Picture Tm(nTotalDeb,17)
			@ li, 070 		PSAY nTotalCrd Picture Tm(nTotalCrd,17)
		Else
			@ li, aColunas[VALOR_DEBITO] 	PSAY nTotalDeb Picture Tm(nTotalDeb,17)
			@ li, aColunas[VALOR_CREDITO] 	PSAY nTotalCrd Picture Tm(nTotalCrd,17)
		Endif
		
		If lTot123 == 1	//Se imprime total informado, digitado e diferenca		
			If limite = 132
				nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
				@ li ++, nCol	PSAY STR0025 + 	Trans(CTC->CTC_INF, Tm(CTC->CTC_INF,17)) //"INFORMADO"
				@ li   , nCol	PSAY STR0026 + 	Trans(CTC->CTC_DIG, Tm(CTC->CTC_DIG,17)) //"DIGITADO "
				If Round(NoRound(CTC->CTC_DIG - CTC->CTC_INF, 10), 2) # 0
					li ++
					@ li,nCol PSAY STR0027 + Trans(Abs(CTC->CTC_DIG - CTC->CTC_INF),; //"DIFERENCA"
							   					 Tm(CTC->CTC_DIG,17))
				Endif
			Else
				@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(nDocInf,; //"INFORMADO "
																	Tm(nDocInf,17)) +;
				 								     Space(4) + STR0026 +; //"DIGITADO "
				 								     Trans(nDocDig, Tm(nDocDig,17)) +;
				 								     Space(4) + STR0027 +; //"DIFERENCA"
													 Trans(	Abs(nDocDig - nDocInf),;
													 Tm(nDocDig,17))
			Endif
		EndIf
		li++
		nTotalDeb := 0	
		nTotalCrd := 0	
        nDocInf   := 0
		nDocDig   := 0
		
		   // Davi Torchio 17/07/07                                              ///
           // Total do Lote soma todos os tipos de lançamentos que contem no lote///  
           /////////////////////////////////////////////////////////////////////////
	
		// TOTALIZA O LOTE
		If cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
		   cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
		   Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)

	  		CT6->(DbSetOrder(1))		
			CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))           
			WHILE cLote == CT6->CT6_LOTE
			    IF DtoS(dData) == DtoS(CT6->CT6_DATA)
			        nTotLotDeb += CT6->CT6_DEBITO
	                nTotLotCrd += CT6->CT6_CREDIT       
	                //Total de Lote
		            nLotInf += CT6->CT6_INF
			        nLotDig += CT6->CT6_DIG 
				Endif
			 	CT6->(DBSKIP())
			ENDDO

	       	// Total Geral
	       	nTotGerDeb += nTotLotDeb
	       	nTotGerCrd += nTotLotCrd
	       	nTotGerInf += nLotInf
	       	nTotGerDig += nLotDig		


			li++
			@ li,02 PSAY STR0020
		 //	CT6->(MsSeek(xFilial()+dtos(dData)+cLote+cSubLote+"01"))
		 	CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))
			If !lCusto .And. !lItem  .And. !lCV                     
				@ li, 049 PSAY nTotLotDeb Picture Tm(nTotLotDeb,17)
				@ li, 070 PSAY nTotLotCrd Picture Tm(nTotLotCrd,17)
			Else
				@ li, aColunas[VALOR_DEBITO] 	PSAY nTotLotDeb Picture Tm(nTotLotDeb,17)
				@ li, aColunas[VALOR_CREDITO] 	PSAY nTotLotCrd Picture Tm(nTotLotCrd,17)
			Endif
			If lTot123 == 1	//Se imprime total informado, digitado e diferenca											
			   If limite = 132
				  IF cLote == CT6->CT6_LOTE .AND. CT6->CT6_TPSALD == MV_PAR11
					nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
					@ li ++, nCol PSAY STR0025 + 	Trans(CT6->CT6_INF,; //"INFORMADO"
														Tm(CT6->CT6_INF,17))
					@ li   , nCol PSAY STR0026 + 	Trans(CT6->CT6_DIG,; //"DIGITADO "
														Tm(CT6->CT6_DIG,17))
					If Round(NoRound(CT6->CT6_DIG - CT6->CT6_INF, 10), 2) # 0
						li ++
						@ li,nCol PSAY STR0027 + 	Trans(Abs(CT6->CT6_DIG -; //"DIFERENCA"
														CT6->CT6_INF), Tm(CT6->CT6_DIG,17))
					Endif				
                  ELSE  
				       CT6->(DBSKIP())
				    	IF cLote == CT6->CT6_LOTE .AND. CT6->CT6_TPSALD == MV_PAR11
					  		@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(CT6->CT6_INF,; //"INFORMADO "
					   																Tm(CT6->CT6_INF,17)) +;
			 											     Space(4) + STR0026 +; //"DIGITADO "
			 											     Trans(CT6->CT6_DIG, Tm(CT6->CT6_DIG,17)) +;
			 											     Space(4) + STR0027 +;  //"DIFERENCA"
															 Trans(	Abs(CT6->CT6_DIG-CT6->CT6_INF),;
															 Tm(CT6->CT6_DIG,17))     
						ENDIF								 									 
				  ENDIF									 					
			   Else
	              CT6->(MsSeek(xFilial("CT6")+dtos(dData)+cLote+cSubLote+cMoeda))
				  WHILE cLote == CT6->CT6_LOTE 
				    	IF CT6->CT6_TPSALD == MV_PAR11 .OR. MV_PAR11 == "*"
							@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(nLotInf,; //"INFORMADO "
																				Tm(nLotInf,17)) +;
							    	                                       Space(4) + STR0026 +; //"DIGITADO "
					                	                                   Trans(nLotDig, Tm(nLotDig,17)) +;
					                    	                               Space(4) + STR0027 +;  //"DIFERENCA"
                                            	                           Trans(	Abs(nLotDig - nLotInf),;
													                         Tm(nLotDig,17))  
							EXIT							   
	    				ENDIF
				     CT6->(DBSKIP())
				  ENDDO 
			   Endif
			EndIf
			li++
			nTotLotDeb := 0	
			nTotLotCrd := 0	
        EndIf
       nTotLotDeb 	:= 0
       nTotLotCrd 	:= 0
       nLotInf 		:= 0
       nLotDig 		:= 0
	ElseiF lResumo       			// Relatorio Resumido
		IF li > 62
			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
		EndIf
		nDif := Round(NoRound(nTotalDeb - nTotalCrd, 10), 2)
		CTC->(MsSeek(xFilial("CTC")+dtos(dDataRes)+cLoteRes+cSubRes+cDocRes+cMoeda))
		///Davi Torchio 18/07/07                                         ///
		///Tratamento para soma dos documentos por tipo de saldo         ///
		////////////////////////////////////////////////////////////////////
		While cLote == CTC->CTC_LOTE 
			IF MV_PAR11 == "*" .OR. MV_PAR11 == CTC->CTC_TPSALD
				nDocInf += CTC->CTC_INF      
				nDocDig += CTC->CTC_DIG      
			ENDIF
		 CTC->(DBSKIP())
		ENDDO		
		
		nTotGerDig += nDocDig
		nTotGerInf += nDocInf

		@ li,000 PSAY DTOC(dDataRes)
		@ li,014 PSAY cLoteRes
		@ li,028 PSAY cSubRes
		@ li,038 PSAY cDocRes
		If lTot123 == 1
          CTC->(MsSeek(xFilial("CTC")+dtos(dDataRes)+cLoteRes+cSubRes+cDocRes+cMoeda))
		  WHILE cLote == CTC->CTC_LOTE
			  IF CTC->CTC_TPSALD == MV_PAR11 
				@ li,048 PSAY CTC->CTC_INF 	Picture Tm(CTC->CTC_INF,17)		
				@ li,069 PSAY nTotalDeb 	Picture Tm(nTotalDeb,17)		
				@ li,090 PSAY nTotalCrd 	Picture Tm(nTotalCrd,17)    
				@ li,110 PSAY Abs(nDif)		Picture Tm(Abs(nDif),17)
				If nDif > 0
					@ li,131 PSAY STR0023 		// "DIF A DEBITO"
				ElseIf nDif < 0
					@ li,131 PSAY STR0024		// "DIF A CREDITO"
				EndIf			
				@ li,148 PSAY nDocDig 	Picture Tm(nDocDig,17)
	

				nDif := Round(NoRound(nDocDig - nDocInf, 10), 2)
				@ li,169 PSAY Abs(nDif)		Picture Tm(nDif,17)
			    EXIT	 
              ELSEIF  MV_PAR11 == "*"
				@ li,048 PSAY CTC->CTC_INF 	Picture Tm(CTC->CTC_INF,17)		
				@ li,069 PSAY nTotalDeb 	Picture Tm(nTotalDeb,17)		
				@ li,090 PSAY nTotalCrd 	Picture Tm(nTotalCrd,17)    
				@ li,110 PSAY Abs(nDif)		Picture Tm(Abs(nDif),17)
				If nDif > 0
					@ li,131 PSAY STR0023 		// "DIF A DEBITO"
				ElseIf nDif < 0
					@ li,131 PSAY STR0024		// "DIF A CREDITO"
				EndIf			
				@ li,148 PSAY nDocDig 	Picture Tm(nDocDig,17)		
	

				nDif := Round(NoRound(nDocDig - nDocInf, 10), 2)
				@ li,169 PSAY Abs(nDif)		Picture Tm(nDif,17)						 
				
				EXIT
              ENDIF
           CTC->(DBSKIP())
      	  ENDDO
		nTotGerDeb += nTotalDeb
		nTotGerCrd += nTotalCrd
		Else
			@ li,069 PSAY nTotalDeb 	Picture Tm(nTotalDeb,17)		
			@ li,090 PSAY nTotalCrd 	Picture Tm(nTotalCrd,17)    		
		EndIf
		li++
		nTotalDeb 	:= 0	
		nTotalCrd 	:= 0			         
        nDocInf 	:= 0
		nDocDig 	:= 0
	Endif                                    
	// Impressao do Cabecalho
	If mv_par12 == 1			// Quebra pagina quando for lote diferente
		#IFNDEF TOP
			If	cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
				cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
				Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)   .And. Ctr070Skip(cAliasCT2,lAllSL)
		   		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
		#ELSE	
			If	cLote != (cAliasCT2)->CT2_LOTE 				.Or.;
				cSubLote != (cAliasCT2)->CT2_SBLOTE 			.Or.;
				Dtos(dData) != Dtos((cAliasCT2)->CT2_DATA)   .And. (If(TcSrvType() == "AS/400", Ctr070Skip(cAliasCT2,lAllSL),.T.))
		   		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
			EndIf
		#ENDIF		                                                
		
	ElseIF li > 62
		CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)
	EndIf
EndDo

If li != 80
	If lTotal
		IF li > 62 
			CtCGCCabec(,,,Cabec1,Cabec2,dDataBase,Titulo,,"2",Tamanho)		
		EndIf		
		li+=2
		@ li,00 PSAY Replicate("-",Limite)
		li++
		@ li,02 PSAY STR0019
		If !lResumo
			If !lCusto .And. !lItem  .And. !lCV                     
				@ li, 049 PSAY nTotGerDeb Picture Tm(nTotGerDeb,17)
				@ li, 070 PSAY nTotGerCrd Picture Tm(nTotGerCrd,17)
			Else
				@ li, aColunas[VALOR_DEBITO] 	PSAY nTotGerDeb Picture Tm(nTotGerDeb,17)
				@ li, aColunas[VALOR_CREDITO] 	PSAY nTotGerCrd Picture Tm(nTotGerCrd,17)
			Endif
			If lTot123 == 1			
				If limite = 132			
					nCol := If(Len(aColunas) > 0, aColunas[HISTORICO], 097)
					@ li ++, nCol  	PSAY STR0025 + 	Trans(nTotGerInf, Tm(nTotGerInf,17)) //"INFORMADO"
					@ li   , nCol	PSAY STR0026 + 	Trans(nTotGerDig, Tm(nTotGerDig,17)) //"DIGITADO "
					If Round(NoRound(nTotGerDig - nTotGerInf, 10), 2) # 0
						li ++
						@ li,nCol	PSAY STR0027 + 	Trans(Abs(nTotGerDig - nTotGerInf),; //"DIFERENCA"
														Tm(nTotGerDig,17))
					Endif
				Else
					@ li, aColunas[HISTORICO] 		PSAY STR0028 + Trans(nTotGerInf,; //"INFORMADO "
																		Tm(nTotGerInf,17)) +;
				 								     Space(4) + STR0026 +; //"DIGITADO "
				 								     Trans(nTotGerDig, Tm(nTotGerDig,17)) +;
				 								     Space(4) + STR0027 +;  //"DIFERENCA"
													 Trans(	Abs(nTotGerDig-nTotGerInf),;
													 Tm(nTotGerDig,17))
				Endif                     
			EndIf
		Else 
			If lTot123 == 1
				nDif := nTotGerDeb - nTotGerCrd
	
				@ li,048 PSAY nTotGerInf 	Picture Tm(nTotGerInf,17)		
				@ li,069 PSAY nTotGerDeb 	Picture Tm(nTotGerDeb,17)		
				@ li,090 PSAY nTotGerCrd 	Picture Tm(nTotGerCrd,17)    
				@ li,110 PSAY Abs(nDif)		Picture Tm(Abs(nDif),17)
				@ li,148 PSAY nTotGerDig 	Picture Tm(nTotGerDig,17)		
	
				nDif := Round(NoRound(nTotGerDig - nTotGerInf, 10), 2)				
				@ li,169 PSAY Abs(nDif)		Picture Tm(nDif,17)		  
			Else
				@ li,069 PSAY nTotGerDeb 	Picture Tm(nTotGerDeb,17)		
				@ li,090 PSAY nTotGerCrd 	Picture Tm(nTotGerCrd,17)    			
			EndIf
		Endif                                               
		li++
		@ li,00 PSAY Replicate("-",Limite)
	EndIf	
	roda(cbcont,cbtxt,"M")
	Set Filter To
EndIf	

If aReturn[5] = 1
	Set Printer To
	Commit
	Ourspool(wnrel)
EndIf

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³Ctr070Skip³ Autor ³ Pilar S Albaladejo	³ Data ³ 02.04.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica condicoes para pular os registros			      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ Ctr070Skip(cAlias) 										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno	 ³ Nenhum       											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso		 ³ Generico      											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cAlias = Se for TOP, receberá o ALIAS da query gerada.      ±±
±±           ³          O Default será "CT2".                              ±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctr070Skip(cAlias,lAllSL)
           
DEFAULT cAlias := "CT2"
DEFAULT lAllSL := .F.

If !lAllSL
	If mv_par11 <> (cAlias)->CT2_TPSALD                    
		(cAlias)->( DbSkip() )
		Return .T.
	Endif
EndIf

If ! ( ( cAlias )->CT2_LOTE >= mv_par03 .And. (cAlias)->CT2_LOTE <= mv_par04 )
	MsSeek( Soma1( xFilial("CT2")+DTOS((cAlias)->CT2_DATA)+(cAlias)->CT2_LOTE )+mv_par15+mv_par05, .T.)
	Return .T.
Endif
	
If ! ( (cAlias)->CT2_DOC >= mv_par05 .And. (cAlias)->CT2_DOC <= mv_par06 )
	MsSeek( Soma1( xFilial("CT2")+DTOS((cAlias)->CT2_DATA)+(cAlias)->CT2_LOTE+(cAlias)->CT2_SBLOTE+(cAlias)->CT2_DOC ), .T.)
	Return .T.
Endif
	
If ! ( (cAlias)->CT2_SBLOTE >= mv_par15 .And. (cAlias)->CT2_SBLOTE <= mv_par16 )
	MsSeek( Soma1( xFilial("CT2")+DTOS((cAlias)->CT2_DATA)+(cAlias)->CT2_LOTE+(cAlias)->CT2_SBLOTE )+mv_par05, .T.)
	Return .T.
Endif

If (cAlias)->CT2_MOEDLC <> mv_par07
	(cAlias)->( DbSkip() )
	Return .T.
Endif            

If (cAlias)->CT2_DC = "4"
	(cAlias)->( DbSkip() )
	Return .T.
EndIf

If cPaisLoc == "CHI" .And. ! ( (cAlias)->CT2_SEGOFI >= mv_par22 .And. (cAlias)->CT2_SEGOFI <= mv_par23 )
	(cAlias)->( DbSkip() )
	Return .T.
EndIf	        

Return .F.


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ctr070Ctt ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 17.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a troca para impressao de codigo reduzido de acordo com ³±±
±±³          ³mv_par15 = 2                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr070Ctt(cCC)                                              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cCC = Conteudo a Ser impresso                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ctbr070                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cCc = Centro de custo a ser substituido (se for o caso)    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctr070Ctt(cCc)

Local aSaveArea := GetArea()

If mv_par18 = 2
	dbSelectArea("CTT")
	dbSetOrder(1)		
	MsSeek(xFilial() + cCC)
	cCC := CTT->CTT_RES
Endif

RestArea(aSaveArea)
Return cCC

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ctr070Ctd ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 17.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a troca para impressao de codigo reduzido de acordo com ³±±
±±³          ³mv_par16 = 2                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr070Ctd(cItem)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cItem = Conteudo a Ser impresso                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ctbr070                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cItem = Item a ser substituido (se for o caso)    	      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctr070Ctd(cItem)

Local aSaveArea := GetArea()

If mv_par19 = 2
	dbSelectArea("CTD")
	dbSetOrder(1)
	MsSeek(xFilial() + cItem)
	cItem := CTD->CTD_RES
Endif

RestArea(aSaveArea)
Return cItem

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ctr070Cth ³ Autor ³ Wagner Mobile Costa   ³ Data ³ 17.02.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a troca para impressao de codigo reduzido de acordo com ³±±
±±³          ³mv_par17 = 2                                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³Ctr070Cth(cClVl)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³cItem = Conteudo a Ser impresso                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Ctbr070                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cClVl = Classe de valor a ser substituida (se for o caso)  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function Ctr070Cth(cClVl)

Local aSaveArea := GetArea()

If mv_par20 = 2
	dbSelectArea("CTH")
	dbSetOrder(1)
	MsSeek(xFilial() + cCLVL)
	cCLVL := CTH->CTH_RES
Endif

RestArea(aSaveArea)
Return cCLVL

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³RpPrintHistºAutor ³Renato F. Campos    º Data ³  02/16/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressão do historico detalhado do lançamento contabil    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ R4                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function RpPrintHist( cAliasCT2 , oSection11 )

Local cLote 	:= (cAliasCT2)->CT2_LOTE
Local cSubLote 	:= (cAliasCT2)->CT2_SBLOTE
Local cDoc		:= (cAliasCT2)->CT2_DOC
Local dData 	:= (cAliasCT2)->CT2_DATA
Local cSeq 		:= (cAliasCT2)->CT2_SEQLAN
Local cEmpOri	:= (cAliasCT2)->CT2_EMPORI
Local cFilOri	:= (cAliasCT2)->CT2_FILORI
Local nReg		:= 0

Default cAliasCT2 := 'CT2'

oSection11:Cell( "CT2_LINHA"	):SetBlock( { || '' } )
oSection11:Cell( "CCONTAD"		):SetBlock( { || '' } )
oSection11:Cell( "CCONTAC"		):SetBlock( { || '' } )

oSection11:Cell( "CCUSTOD"		):SetBlock( { || '' } )
oSection11:Cell( "CCUSTOC"		):SetBlock( { || '' } )
oSection11:Cell( "CITEMD"		):SetBlock( { || '' } )					
oSection11:Cell( "CITEMC"		):SetBlock( { || '' } )					
oSection11:Cell( "CCLASSED"		):SetBlock( { || '' } )									
oSection11:Cell( "CCLASSEC"		):SetBlock( { || '' } )									
oSection11:Cell( "CDEBITO"		):SetBlock( { || 0  } )
oSection11:Cell( "CCREDITO"		):SetBlock( { || 0  } )

oSection11:Cell( "CT2_HP"   	):SetBlock( { || '' } )
oSection11:Cell( "CT2_HIST" 	):SetBlock( { || '' } )

// Procura pelo complemento de historico
dbSelectArea( cAliasCT2 )
nReg := Recno()

dbSelectArea("CT2")
dbSetOrder( 10 )

oSection11:Cell( "CT2_DC" ):SetBlock( { || '4' } )

If dbSeek(xFilial("CT2")+DTOS(dData)+cLote+cSubLote+cDoc+cSeq+cEmpOri+cFilOri)
	dbSkip()

	If CT2->CT2_DC == "4"

		While !Eof() .And. CT2->CT2_FILIAL == xFilial("CT2") .And.;
			CT2->CT2_LOTE == cLote .And. CT2->CT2_DOC == cDoc .And.;
			CT2->CT2_SEQLAN == cSeq .And. CT2->CT2_EMPORI == cEmpOri .And. ;
			CT2->CT2_FILORI == cFilOri 	.And. ;
			DTOS(CT2->CT2_DATA) == DTOS(dData)

			If CT2->CT2_DC == "4"

				oSection11:Cell( "CT2_LINHA" ):SetBlock( { || CT2->CT2_LINHA	} )
				oSection11:Cell( "CT2_HP"    ):SetBlock( { || CT2->CT2_HP 		} )
				oSection11:Cell( "CT2_HIST"  ):SetBlock( { || CT2->CT2_HIST	} )

		    	oSection11:PrintLine()																	
		  	EndIf
 			dbSkip()
		EndDo
	Endif
EndIf

dbSelectArea("CT2")
dbSetOrder(1)					

dbSelectArea(cAliasCT2)
dbGoto( nReg )
