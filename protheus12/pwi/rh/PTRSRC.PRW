#INCLUDE "rwmake.ch"
#include "Topconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PTRSRC     º Autor ³ Potencial - Franciney Alves 01/09/06   º±±
±±ºAlteracao para ³PTSRC º Autor ³ Potencial - Frankimar Alves 04/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Relatorio gerencial de agrupamento por verbas              º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 SIGA GPE                                               º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function PTRSRC


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de agrupamento por verbas"
Local cPict          := ""
Local titulo       := "Relatorio Gerencial de agrupamento por verbas"
Local nLin         := 80

Local Cabec1       := "Relatorio Gerencial de agrupamento por verbas"                                                                           
// Matricula	Nome	Salario (101)	HE 60%	 HE 110%	HE 150%	 Total Valor Extra		Dsr	Adcional Nort	Periculosidade (117)	Premio Assuidade (111)	Salario Familia	Vale transporte	Outros Proventos(124 +210)	Ajuda de Custo (211+212)	Aluguel (213)	Arredondamento de Salario (399) Inss Folha(401+402+403)	IRRF (404+407)	Adiantamento (415)	Faltas (510+511)		Atrasos (512+514)		Outros Adiantamentos (423+430.431+432+422)	Farmacia (446)	Outros Desconto (420+421+652+691)	contr. Sindical (460)
//																														  1	        1         1         1         1         1         1         1         1         1         2         2         2         2         2         2         2         2         2         2         3         3         3         3         3         3         3         3         3         3         4         4         4         4         4         4         4         4         4         4         5         5         5         5         5         5         5
// 						        1         2         3         4         5         6         7         8         9         0		    1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
//                     12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
Local Cabec2      := "| C.Custo       Matric  Nome                                    Salario   HE 60%    HE 110%   HE 150%   Dsr	     Ad.Not    Peric     P.Assid   Ferias    Sal.Fam   V.Transp  Out.Prov	Aj.Custo  Aluguel	  Arred.    (-)Inss   (-)IRRF   (-)Adto   (-)Faltas (-)Atras  (-)Ferias (-)Out.Adt(-)Farmac (-)O.Dcto (-)Ct.Sind |Liq(Verb) Liq.Calc |"
Local imprime      := .T.
Local aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 320
Private tamanho      := "G"
Private nomeprog     := "PTRSRC" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey	 := 0
Private aPerg 	:= {}
Private cPerg   := "PTRSRC"
Private cbtxt   := Space(10)
Private cbcont  := 00
Private CONTFL  := 01
Private m_pag   := 01
Private wnrel   := "NOME" // Coloque aqui o nome do arquivo usado para impressao em disco
Private cString := "SRC"



dbSelectArea("SX1")
dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Ano/Mes de      ?"   ,"mv_ch1","C",06,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Ano/Mes Ate     ?"   ,"mv_ch2","C",06,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Centro de Custo de ?","mv_ch3","C",09,0,1,"G","","mv_par03","","SI3","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Centro de Custo Ate?","mv_ch4","C",09,0,1,"G","","mv_par04","","SI3","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Matricula de ?"      ,"mv_ch5","C",06,0,1,"G","","mv_par05","","SRA","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "06", "Matricula Ate?"      ,"mv_ch6","C",06,0,1,"G","","mv_par06","","SRA","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "07", "Movimento ?"         ,"mv_ch7","N",01,0,1,"C","","mv_par07","Mensal","","Acumulado","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "08", "Outros Proventos?"   ,"mv_ch8","C",50,0,1,"G","","mv_par08","","SRV","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "09", "Outros Descontos?"   ,"mv_ch9","C",50,0,1,"G","","mv_par09","","SRV","","","","","","","","","","","","",""})  	
  	aadd(aPerg,{cPerg, "10", "Gera Arquivo    ?"   ,"mv_cha","N",01,0,1,"C","","mv_par10","Sim","","Nao","","","","","","","","","","","",""})  	


  	 
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


dbSelectArea("SRC")
dbSetOrder(1)


pergunte(cPerg,.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta a interface padrao com o usuario...                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif
                     

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  01/09/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)
Local nOrdem


  


aStru:= {{"FILIAL"     , "C", 02 , 0},; //Filial
{"CCUSTO"     , "C", 09 , 0},; //Centro de Custo
{"MATRIC"     , "C", 06 , 0},; //Matricula
{"NOME"       , "C", 30 , 0},; //Nome do funcionario
{"SALARIO"    , "N", 12 , 2},; //Valor do Salario - verba 101
{"QHE60"      , "N",  6 , 2},; //Qtde de Horas Extra 60% 
{"VHE60"      , "N", 12 , 2},; //Valor de Horas Extra 60% 
{"QHE110"     , "N",  6 , 2},; //Qtde de Horas Extra 110%
{"VHE110"     , "N", 12 , 2},; //Valor de Horas Extra 110%
{"QHE150"     , "N",  6 , 2},; //Qtde de Horas Extra 150%
{"VHE150"     , "N", 12 , 2},; //Valor de Horas Extra 150%
{"QTotalHE"   , "N", 12 , 2},; //Valor Total de Horas Extra
{"DSRSHE"     , "N",  6 , 2},; //Valor Reflexo DSR S/ HE
{"AdicNot"	  , "N",  6 , 2},; //Valor Horas Adic Noturno
{"Peric"      , "N", 12 , 2},; //Valor Periculosidade
{"Assid"	     , "N", 12 , 2},; //Valor Assiduidade   
{"ProvFer"	  , "N", 12 , 2},; //Valor Proventos de Ferias 
{"SalFam" 	  , "N", 12 , 2},; //Valor Salario Familia
{"ValeTr"     , "N", 12 , 2},; //Valor Vale transporte
{"OutPrv"     , "N", 12 , 2},; //Valor Outros proventos
{"AjCust"     , "N", 12 , 2},; //Valor Ajuda de Custo
{"Aluguel"    , "N", 12 , 2},; //Valor Ajuda de Custo Aluguel
{"Arred"      , "N", 12 , 2},; //Valor Prov Arredondamento
{"INSS"       , "N", 12 , 2},; //Valor INSS
{"IRRF"       , "N", 12 , 2},; //Valor IRRF
{"DESADTO"    , "N", 12 , 2},; //Valor Desconto Adiantamento
{"FaltasH"    , "N",  6 , 2},; //Qtde Horas Faltas 
{"FaltasV"    , "N", 12 , 2},; //Valor Faltas 
{"AtrasoH"    , "N",  6 , 2},; //Qtde Horas Atrasos
{"AtrasoV"    , "N", 12 , 2},; //Valor Atrasos
{"DescFer"	  , "N", 12 , 2},; //Valor Descontos de Ferias 
{"DOutAdto"   , "N", 12 , 2},; //Valor Desconto Outros Adiantamentos
{"Farmacia"   , "N", 12 , 2},; //Valor Farmacia
{"OutDesct"   , "N", 12 , 2},; //Valor Outros Descontos
{"ContSind"   , "N", 12 , 2},; //Valor Contribuicao Sindical
{"Liquido"    , "N", 16 , 2},; //Valor Liquido a Receber
{"LiqCalc"    , "N", 16 , 2},; //Valor Liquido a Receber
{"TotProv"    , "N", 16 , 2},; //Valor Total proventos
{"TotDesc"    , "N", 16 , 2},; //Valor Total Descontos
{"DifLiq"     , "N", 16 , 2},; //Valor Liquido a Receber
{"DataPgto"   , "D", 08 , 0}} //Data da Venda

//- Criando Abertura de Tabela Temporaria
c_Arq:= CriaTrab(aStru,.t.)
dbUseArea(.t.,,c_Arq,"wFolhaGer",.f.,.f.)

//- Indice por Boleto
c_Key:= "FILIAL + CCUSTO + MATRIC "
c_Ind:= CriaTrab(nil,.f.)
IndRegua("wFolhaGer",c_Ind,c_Key,,,"Criando Arquivo Temporário...")

DbSelectArea(cString)
dbSetOrder(1)              


if mv_par07 = 1 // Mensal 
 dbSelectArea(cString)
 dbSetOrder(2)  // Filial + ccusto + matricula
 DbGotop()
 Do While !EOF()
    cFilial := SRC->RC_FILIAL
    cCC  :=  SRC->RC_CC
    cMat := SRC->RC_MAT
	 SALARIO :=  VHE60  := VHE110  :=  VHE150  :=  DSRSHE  :=  AdicNot  := Peric    := Assid   := ProvFer  := SalFam  := 0
	 ValeTr  :=  OutPrv := AjCust  :=  Aluguel :=  Arred   :=  0
	 INSS    :=  IRRF   := DESADTO :=  FaltasV :=  AtrasoV :=  DOutAdto := Farmacia := OutDesct:= ContSind := DescFer := 0
    TotProv :=  0  //Valor Total proventos
	 TotDesc :=  0 //Valor Total Descontos

    
    if SRC->RC_CC < mv_par03 .AND. SRC->RC_CC > mv_par04 
       dbSelectArea(cString)    
       DbSkip()
       Loop
    Endif
    if SRC->RC_MAT < mv_par05 .AND. SRC->RC_MAT > mv_par06 
       dbSelectArea(cString)    
       DbSkip()
       Loop
    Endif       
    DbSelectArea("SRA")
    DbSetOrder(1)
    DbSeek(xFilial("SRA")+cMat)
    dbSelectArea(cString)    
    Do While   cFilial == SRC->RC_FILIAL .AND.  cCC  ==  SRC->RC_CC .AND.  cMat == SRC->RC_MAT
       DbSelecTArea("wFolhaGer")
       if !DbSeek(cFilial + cCC + cMat) 
          RecLock("wFolhaGer",.T.)
           replace FILIAL WITH cFilial
           replace CCUSTO with cCC
           replace MATRIC WITH cMat 
           replace NOME   WITH SRA->RA_NOME 
           
       Endif
       if DbSeek(cFilial + cCC + cMat) 
           Do Case
              Case SRC->RC_PD $ "101/105"
               replace SALARIO WITH (SALARIO+SRC->RC_VALOR)
              Case SRC->RC_PD == "121"  // HE 60
               replace QHE60 WITH SRC->RC_HORAS       
				   replace VHE60 WITH SRC->RC_VALOR                              
              Case SRC->RC_PD == "122"  
					replace QHE110      WITH SRC->RC_HORAS     //Qtde de Horas Extra 110%
					replace VHE110      WITH SRC->RC_VALOR      
	  			  Case SRC->RC_PD == "123"	
					replace QHE150      WITH SRC->RC_HORAS      //Qtde de Horas Extra 150%
					replace VHE150      WITH SRC->RC_VALOR      
				  Case SRC->RC_PD == "112"
					replace DSRSHE      WITH SRC->RC_VALOR     //Valor Reflexo DSR S/ HE
				  Case SRC->RC_PD == "119"
					replace AdicNot WITH SRC->RC_VALOR     //Valor Horas Adic Noturno
				  Case SRC->RC_PD $ "117/202"
					replace Peric WITH (Peric+SRC->RC_VALOR)     //Valor Periculosidade
   			  Case SRC->RC_PD == "111"
					replace Assid WITH SRC->RC_VALOR     //Valor Assiduidade
				  Case SRC->RC_PD $ "300/301/302/303/398/"
 					replace ProvFer WITH (ProvFer+SRC->RC_VALOR) //Valor Proventos de Ferias 
				  Case SRC->RC_PD $ "128/132"
					replace SalFam  WITH (SalFam+SRC->RC_VALOR)     //Valor Salario Familia
				  Case SRC->RC_PD == "139"
					replace ValeTr  WITH SRC->RC_VALOR     //Valor Vale transporte
	  			  Case SRC->RC_PD $ mv_par08  //124,210,308,396,
					replace OutPrv  WITH (OutPrv+SRC->RC_VALOR)     //Valor Outros proventos
				  Case SRC->RC_PD $ "211/212"
					replace AjCust  WITH (AjCust+SRC->RC_VALOR)     //Valor Ajuda de Custo
				  Case SRC->RC_PD $ "213"
					replace Aluguel     WITH SRC->RC_VALOR     //Valor Ajuda de Custo Aluguel
				  Case SRC->RC_PD $ "399"
					replace Arred   WITH SRC->RC_VALOR     //Valor Prov Arredondamento
				  Case SRC->RC_PD $ "401/403"
					replace INSS        WITH (INSS+SRC->RC_VALOR)     //Valor INSS
				  Case SRC->RC_PD $ "404"
					replace IRRF        WITH (IRRF+SRC->RC_VALOR)     //Valor IRRF
				  Case SRC->RC_PD $ "415"
					replace DESADTO    WITH SRC->RC_VALOR     //Valor Desconto Adiantamento
				  Case SRC->RC_PD $ "510/511"
					replace FaltasH WITH (FaltasH+SRC->RC_HORAS)      //Qtde Horas Faltas
					replace FaltasV WITH (FaltasV+SRC->RC_VALOR)     //Valor Faltas
				  Case SRC->RC_PD $ "512/514"
					replace AtrasoH WITH (AtrasoH+SRC->RC_HORAS)     //Qtde Horas Atrasos
					replace AtrasoV WITH (AtrasoV+SRC->RC_VALOR)     //Valor Atrasos
				  Case SRC->RC_PD $ "423/430/431/432/422"
					replace DOutAdto WITH (DOutAdto+SRC->RC_VALOR)     //Valor Desconto Outros Adiantamentos
				  Case SRC->RC_PD $ "446"
					replace Farmacia    WITH SRC->RC_VALOR     //Valor Farmacia
				  Case SRC->RC_PD $ "402/404/490"					                
					replace DescFer  WITH (DescFer+SRC->RC_VALOR)  //Valor Descontos de Ferias 
				  Case SRC->RC_PD $ mv_par09 //"420/421/652/691"
					replace OutDesct WITH (OutDesct+SRC->RC_VALOR)     //Valor Outros Descontos
				  Case SRC->RC_PD $ "460"
					replace ContSind WITH SRC->RC_VALOR     //Valor Contribuicao Sindical
				  Case SRC->RC_PD $ "799"
					replace Liquido     WITH SRC->RC_VALOR     //Valor Liquido a Receber
	           EndCase
   	   	   replace DataPgto    WITH SRC->RC_DATA
  				   replace QTotalHE    WITH  (VHE60+VHE110+VHE150)    //Valor Total de Horas Extra
  				   replace LiqCalc     WITH  ( SALARIO + VHE60 + VHE110 + VHE150 + DSRSHE+  AdicNot+ Peric+ Assid+ ProvFer+ SalFam + ;
										ValeTr+ OutPrv+ AjCust + Aluguel+ Arred - INSS - IRRF -DESADTO - FaltasV -;
										AtrasoV - DOutAdto - Farmacia - OutDesct - ContSind - DescFer)                       
					Replace DifLiq  with LiqCalc - Liquido 
					Replace TotProv with (SALARIO + VHE60 + VHE110 + VHE150 + DSRSHE+  AdicNot+ Peric+ Assid+ ProvFer+ SalFam + ;
										ValeTr+ OutPrv+ AjCust + Aluguel+ Arred)
					Replace TotDesc with (INSS + IRRF + DESADTO + FaltasV + AtrasoV + DOutAdto + Farmacia + OutDesct + ContSind + DescFer)                       
       Endif
       DbSelecTArea("SRC")
	   DbSkip()
	Enddo

 Enddo                           
ElseIf mv_par07 = 2
 dbSelectArea("SRD")
 dbSetOrder(2)  // Filial + ccusto + matricula
 DbGotop()
 Do While !EOF()
    cFilial := SRD->RD_FILIAL
    cCC     := SRD->RD_CC
    cMat    := SRD->RD_MAT
	 SALARIO :=  VHE60  := VHE110  :=  VHE150  :=  DSRSHE  :=  AdicNot  := Peric    := Assid   := ProvFer  := SalFam  := 0
	 ValeTr  :=  OutPrv := AjCust  :=  Aluguel :=  Arred   :=  0
	 INSS    :=  IRRF   := DESADTO :=  FaltasV :=  AtrasoV :=  DOutAdto := Farmacia := OutDesct:= ContSind := DescFer := 0
    TotProv :=  0  //Valor Total proventos
	 TotDesc :=  0  //Valor Total Descontos
    if SRD->RD_CC < mv_par03 .AND. SRD->RD_CC > mv_par04 
       dbSelectArea("SRD")    
       DbSkip()
       Loop
    Endif
    if SRD->RD_MAT < mv_par05 .AND. SRD->RD_MAT > mv_par06 
       dbSelectArea("SRD")    
       DbSkip()
       Loop
    Endif    
    DbSelectArea("SRA")
    DbSetOrder(1)
    DbSeek(xFilial("SRA")+cMat)
    dbSelectArea("SRD")    
    Do While   cFilial == SRD->RD_FILIAL .AND.  cCC  ==  SRD->RD_CC .AND.  cMat == SRD->RD_MAT
       
       If SRD->RD_DATARQ < mv_par01 .or. SRD->RD_DATARQ > mv_par02
          DbSkip()
          Loop
       Endif  
       
       DbSelecTArea("wFolhaGer")
       if !DbSeek(cFilial + cCC + cMat) 
          RecLock("wFolhaGer",.T.)
           replace FILIAL WITH cFilial
           replace CCUSTO with cCC
           replace MATRIC WITH cMat 
           replace NOME   WITH SRA->RA_NOME
       Endif
       if DbSeek(cFilial + cCC + cMat) 
           Do Case
           Case SRD->RD_PD $ "101/105"
                replace SALARIO WITH (SALARIO+SRD->RD_VALOR)            
           Case SRD->RD_PD == "121"  // HE 60
               replace QHE60 WITH SRD->RD_HORAS       
			   	replace VHE60 WITH SRD->RD_VALOR                              
           Case SRD->RD_PD == "122"  
			    	replace QHE110      WITH SRD->RD_HORAS     //Qtde de Horas Extra 110%
				   replace VHE110      WITH SRD->RD_VALOR      
  			  Case SRD->RD_PD == "123"	
				   replace QHE150      WITH SRD->RD_HORAS      //Qtde de Horas Extra 150%
					replace VHE150      WITH SRD->RD_VALOR      
			  Case SRD->RD_PD == "112"
					replace DSRSHE      WITH SRD->RD_VALOR     //Valor Reflexo DSR S/ HE
			  Case SRD->RD_PD == "119"
					replace AdicNot WITH SRD->RD_VALOR     //Valor Horas Adic Noturno
			  Case SRD->RD_PD $ "117/202"
					replace Peric WITH Peric+SRD->RD_VALOR     //Valor Periculosidade
   		  Case SRD->RD_PD == "111"
					replace Assid WITH SRD->RD_VALOR     //Valor Assiduidade
			  Case SRC->RC_PD $ "300/301/302/303/398/"
 					replace ProvFer WITH (ProvFer+SRD->RD_VALOR) //Valor Proventos de Ferias 
			  Case SRD->RD_PD $ "128/132"
					replace SalFam  WITH SalFam+SRD->RD_VALOR     //Valor Salario Familia
			  Case SRD->RD_PD == "139"
					replace ValeTr  WITH SRD->RD_VALOR     //Valor Vale transporte
  			  Case SRD->RD_PD $ mv_par08
					replace OutPrv  WITH (OutPrv+SRD->RD_VALOR)     //Valor Outros proventos
			  Case SRD->RD_PD $ "211/212"
					replace AjCust  WITH AjCust+SRD->RD_VALOR     //Valor Ajuda de Custo
			  Case SRD->RD_PD $ "213"
					replace Aluguel     WITH SRD->RD_VALOR     //Valor Ajuda de Custo Aluguel
			  Case SRD->RD_PD $ "399"
					replace Arred   WITH SRD->RD_VALOR     //Valor Prov Arredondamento
			  Case SRD->RD_PD $ "401/403"
					replace INSS        WITH INSS+SRD->RD_VALOR     //Valor INSS
			  Case SRD->RD_PD $ "404"
				replace IRRF        WITH IRRF+SRD->RD_VALOR     //Valor IRRF
			  Case SRD->RD_PD $ "415"
				replace DESADTO    WITH SRD->RD_VALOR     //Valor Desconto Adiantamento
			  Case SRD->RD_PD $ "510/511"
				replace FaltasH WITH FaltasH+SRD->RD_HORAS      //Qtde Horas Faltas
				replace FaltasV WITH FaltasV+SRD->RD_VALOR     //Valor Faltas
			  Case SRD->RD_PD $ "512/514"
				replace AtrasoH WITH AtrasoH+SRD->RD_HORAS     //Qtde Horas Atrasos
				replace AtrasoV WITH AtrasoV+SRD->RD_VALOR     //Valor Atrasos
			  Case SRD->RD_PD $ "423/430/431/432/422"
				replace DOutAdto WITH DOutAdto+SRD->RD_VALOR     //Valor Desconto Outros Adiantamentos
			  Case SRC->RC_PD $ "402/404/490"					                
					replace DescFer  WITH (DescFer+SRD->RD_VALOR)  //Valor Descontos de Ferias 
			  Case SRD->RD_PD $ "446"
				replace Farmacia    WITH SRD->RD_VALOR     //Valor Farmacia
			  Case SRD->RD_PD $ mv_par09 //"420/421/652/691"
				replace OutDesct WITH (OutDesct+SRD->RD_VALOR)     //Valor Outros Descontos
			  Case SRD->RD_PD $ "460"
				replace ContSind WITH SRD->RD_VALOR     //Valor Contribuicao Sindical
			  Case SRD->RD_PD $ "799"
				replace Liquido     WITH SRD->RD_VALOR     //Valor Liquido a Receber
           EndCase
         replace DataPgto    WITH SRD->RD_DATPGT
		   replace QTotalHE    WITH  (VHE60+VHE110+VHE150)    //Valor Total de Horas Extra
		   replace LiqCalc     WITH  ( SALARIO + VHE60 + VHE110 + VHE150 + DSRSHE+  AdicNot+ Peric+ Assid+ ProvFer+ SalFam + ;
										ValeTr+ OutPrv+ AjCust + Aluguel+ Arred - INSS - IRRF -DESADTO - FaltasV -;
										AtrasoV - DOutAdto - Farmacia - OutDesct - ContSind - DescFer)                       
			Replace DifLiq  with LiqCalc - Liquido										
			Replace TotProv with (SALARIO + VHE60 + VHE110 + VHE150 + DSRSHE+  AdicNot+ Peric+ Assid+ ProvFer+ SalFam + ;
										ValeTr+ OutPrv+ AjCust + Aluguel+ Arred)
			Replace TotDesc with (INSS + IRRF + DESADTO + FaltasV + AtrasoV + DOutAdto + Farmacia + OutDesct + ContSind + DescFer)                       
       Endif                                                               
       
       DbSelecTArea("SRD")
	   DbSkip()
	Enddo

 Enddo                           




Endif                    
if mv_par10 == 1                     

	DbSelecTArea("wFolhaGer")
	Copy to \Report_folha\GerencialRH 
	
	cArquivo := 'GerencialRh'
   cIndice  := '\Report_folha\GerencialRh'+ OrdBagExt()
   If !MSFILE( cArquivo )
	   If MSCREATE( 'GerencialRh', aStru, "TOPCONN" )
   	   APMsgInfo('Criado com sucesso!')
		Else
			APMsgInfo('Problemas ao criar o arquivo!')
		EndIf
	Endif	
	         // 1o nova area
           // 2o driver
           // 3o Nome da tabela
           // 4o Alias
           // 5o Shared
           // 6o ReadOnly
           //         1o, 2o   , 3o     , 4o  , 5o, 6o
    DbUseArea(.T.,"TOPCONN",'GerencialRh',"TRA",.T.,.F.)              
    DbSelectArea("TRA")         
	 if MSAPPEND('GerencialRh','\Report_folha\GerencialRH.dbf')
	   APMsgInfo('Append com sucesso!')
	 Else
	   APMsgInfo('Erro no Append!')  
	 Endif	 
	 DbSelectArea("TRA")         
	 DbCloseArea()

Endif
 

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DbSelecTArea("wFolhaGer")
SetRegua(RecCount())

dbGoTop()
While !EOF()                                       
    // FUNCIONARIOS
    DbSelectArea("SRA")
	DbSetOrder(1)
    DbSeek(xFilial()+wFolhaGer->MATRIC)                        
    // CENTRO DE CUSTOS
    DbSelectArea("SI3")
    DbSetOrder(1)
    DbSeek(xFilial()+wFolhaGer->CCusto)    
    DbSelectArea("wFolhaGer")						
   If lAbortPrint                                  
	  @0, 000 PSay Avalimp(132)
      @nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
      Exit
   Endif

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Impressao do cabecalho do relatorio. . .                            ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

   If nLin > 55 // Salto de Página. Neste caso o formulario tem 55 linhas...
      Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
      nLin := 8
   Endif
   
	@nLin,001 PSAY	"|"+wFolhaGer->CCUSTO
	@nLin,014 PSAY	"|"+wFolhaGer->MATRIC
	@nLin,023 PSAY	"|"+wFolhaGer->NOME
//			 																																						 1	        1         1         1         1         1         1         1         1         1         2         2         2         2         2         2         2         2         2         2         3         3         3         3         3         3         3         3         3         3         4         4         4         4         4         4         4         4         4         4         5         5         5         5         5         5         5
//    					             1         2         3         4         5         6         7         8         9         0		     1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6         7         8         9         0         1         2         3         4         5         6
//                       12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
//			Cabec2      := "C.Custo       Matric  Nome                                    Salario   HE 60%    HE 110%   HE 150%   Dsr	     Ad.Not    Peric     P.Assid   Ferias    Sal.Fam   V.Transp  Out.Prov	Aj.Custo  Aluguel	  Arred.    (-)Inss   (-)IRRF   (-)Adto   (-)Faltas (-)Atras  (-)Ferias (-)Out.Adt(-)Farmac (-)O.Dcto (-)Cont.Sind "
   nCol := 058
	@nLin,063 PSAY	"|"+Transform(wFolhaGer->SALARIO, "@E 99,999.99")	
	@nLin,073 PSAY	"|"+Transform(wFolhaGer->VHE60,"@E 9,999.99")
	@nLin,083 PSAY	"|"+Transform(wFolhaGer->VHE110,"@E 9,999.99")
	@nLin,093 PSAY "|"+Transform(wFolhaGer->VHE150,"@E 9,999.99")
	@nLin,103 PSAY "|"+Transform(wFolhaGer->DSRSHE,"@E 9,999.99")
	@nLin,113 PSAY "|"+Transform(wFolhaGer->AdicNot,"@E 9,999.99")
	@nLin,123 PSAY "|"+Transform(wFolhaGer->Peric,"@E 9,999.99")
	@nLin,133 PSAY "|"+Transform(wFolhaGer->Assid,"@E 9,999.99")
	@nLin,143 PSAY "|"+Transform(wFolhaGer->ProvFer,"@E 99,999.99")
	@nLin,153 PSAY "|"+Transform(wFolhaGer->SalFam,"@E 9,999.99")
	@nLin,163 PSAY "|"+Transform(wFolhaGer->ValeTr,"@E 9,999.99")
	@nLin,173 PSAY "|"+Transform(wFolhaGer->OutPrv,"@E 99,999.99")	
	@nLin,183 PSAY "|"+Transform(wFolhaGer->AjCust,"@E 9,999.99")
	@nLin,193 PSAY "|"+Transform(wFolhaGer->Aluguel,"@E 9,999.99")
	@nLin,203 PSAY "|"+Transform(wFolhaGer->Arred,"@E 9,999.99")
	@nLin,213 PSAY "|"+Transform(wFolhaGer->INSS,"@E 9,999.99")
	@nLin,223 PSAY "|"+Transform(wFolhaGer->IRRF,"@E 9,999.99")
	@nLin,233 PSAY "|"+Transform(wFolhaGer->DESADTO,"@E 99,999.99")
   @nLin,243 PSAY "|"+Transform(wFolhaGer->FaltasV,"@E 9,999.99") 
	@nLin,253 PSAY "|"+Transform(wFolhaGer->AtrasoV,"@E 9,999.99")
	@nLin,263 PSAY "|"+Transform(wFolhaGer->DescFer,"@E 99,999.99")
	@nLin,273 PSAY "|"+Transform(wFolhaGer->DOutAdto,"@E 99,999.99")
	@nLin,283 PSAY "|"+Transform(wFolhaGer->Farmacia,"@E 9,999.99")
	@nLin,293 PSAY "|"+Transform(wFolhaGer->OutDesct,"@E 99,999.99")
	@nLin,303 PSAY "|"+Transform(wFolhaGer->ContSind,"@E 9,999.99")
	@nLin,313 PSAY "|"+Transform(wFolhaGer->Liquido,"@E 99,999.99")
	@nLin,323 PSAY "|"+Transform(wFolhaGer->LiqCalc,"@E 99,999.99")+"|"

	
	nLin ++
    wFolhaGer->(dbSkip())
   	                
    IncProc()         

   nLin := nLin + 1 // Avanca a linha de impressao

   dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN    
wFolhaGer->(dbCloseArea())

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

	If !ApOleClient("MsExcel")
   	MsgStop("MsExcel não instalado.","Relatório de Previsão de Vendas x PMP")	
	Else
		oExcelApp := MsExcel():New()
		oExcelApp:WorkBooks:Open('\Report_folha\GerencialRH.dbf')
		oExcelApp:SetVisible(.T.)	
	Endif

Return
