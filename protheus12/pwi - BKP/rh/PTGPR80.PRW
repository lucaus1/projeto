#include "Protheus.ch"
#include "PTGPR80.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ gper080	³ Autor ³ R.H. - Jose Ricardo	³ Data ³ 12.04.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demonstrativo de Medias									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³ gper080(void)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³															  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso 	 ³ Generico 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data	³ BOPS ³  Motivo da Alteracao					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Aldo       ³02/02/99³------³ Alteracao da data para 4 digitos.        ³±±
±±³ Aldo       ³30/03/99³------³ Passagem de nTamanho para SetPrint().    ³±±
±±³ Mauro      ³15/04/99³------³ Carregar Sal.Minimo Antes da Cria_Trp.   ³±±
±±³ Emerson    ³15/03/00³------³ Impressao de Mais de Um Per. de Fer. Ven.³±±
±±³ Emerson    ³20/04/00³------³ Inclusao da funcao SetPrc() - O eject nao³±±
±±³            |        ³------³ posiciona na linha zero.                 ³±±
±±³ Emerson    ³28/04/00³------³ Inclusao de um novo parametro na GPEXMED ³±±
±±³            ³        |------³ correspondente a "lMovto".               ³±±
±±³ Emerson    ³04/05/00³------³ Alteracao da pergunta "Cons. Acum Mes" p/³±±
±±³            ³        |------³ "Considera Mes Atual".                   ³±±
±±³ Marina     ³29/05/00³004003³ Criacao da pergunte "Data Base ?"(referen³±±
±±³            ³        ³      ³ cia) que substitui a dDatabase.          ³±±
±±³ Emerson    ³30/05/00³------³ Impressao de mais de um per. de fer.venc.³±±
±±³ Emerson    ³30/06/00³------³ Posicionar (Data Base Ref) na 1a. posicao³±±
±±³ Marinaldo  ³27/07/00³------³ Retirada Dos e Validacao Filial/Acesso.  ³±±
±±³ Mauro      ³13/08/01³------³ Acerto na quebra de Pagina 		      ³±±
±±³ Emerson    ³02/07/02³------³ Carrega aPd com Rescisao para GPEXMED(). ³±±
±±³ Emerson    ³21/01/04³------³ Ajuste na atualizacao da Dat.Bse Ferias. ³±±
±±³ Ricardo D. ³22/10/04³------³ Limpar apd em caso de rescisao para nao  ³±±
±±³            ³        ³------³ duplicar os valores lancados no SRC que  ³±±
±±³            ³        ³------³ foram levados para rescisao              ³±±
±±³ Emerson    ³29/03/05³------³ Inclusao do ponto de entrada GP080ALT.   ³±±
±±³ Ricardo D. ³27/04/05³078953³ Ajuste na impressao da media de 13o sala-³±±
±±³            ³        ³      ³ rio listando somente quando houver pagto ³±±
±±³            ³        ³      ³ de 1a parcela nas ferias.                ³±±
±±³ Andreia    ³16/08/06³099291³Inclusao da opcao de impressao de medias  ³±±
±±³            ³        ³      ³de Licenca Maternidade.                   ³±±
±±³ Natie      ³26/09/06³102452³Imprime a dt Base Fer do periodo correspon³±±
±±³            ³        ³      ³dente                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
USER Function PTGPR80()

Local cDesc1 	:= STR0001		//"Demonstrativo de M‚dias"
Local cDesc2 	:= STR0002		//"Ser  impresso de acordo com os parametros solicitados pelo"
Local cDesc3 	:= STR0003		//"usu rio."
Local cString	:= "SRA"		// alias do arquivo principal (Base)
Local aOrd	 	:= {STR0004,STR0005,STR0006}		//"Matricula"###"Centro de Custo"###"Nome"
Local aRegs		:= {}
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Basicas)		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private aReturn := {STR0007, 1,STR0008, 2, 2, 1, "",1 }		// "Zebrado"###"Administra‡„o"
Private nomeprog:="PTGPR80"
Private aLinha	:= { },nLastKey := 0
Private cPerg	:="GPR080"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Private(Programa)		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private nOrdem
Private aInfo	 := {}
Private aFolBas[4] , aAdiBas[4] , aFerBas[4] , a13Bas[4]
Private aFolIR[4]  , aAdiIR[4]	, aFerIR[4]  , a13IR[4]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis Utilizadas na funcao IMPR 	³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Private titulo
Private AT_PRG	:= "PTGPR80"
Private wCabec0 := 1
Private wCabec1 := STR0009				//"DATA BASE: "
Private CONTFL	:= 1
Private LI		:= 0
Private nTamanho:= "M"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Ajusta o grupo de perguntas				 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Aadd(aRegs,{"GPR080    ","10","Media              ?","¨Promedio          ?","From Average        ?","mv_cha","N",01,0,01,"C" ,"","mv_par10","Ferias","Vacaciones","Vacation","","","13º salario","Aguinaldo","13th Salary",""	,""	,"Aviso Previo","Preaviso","Prior Notice","","","Lic.Maternidade","Lic.Maternidade","Lic.Maternidade","",""	,"Todos","Todos","All","","","",""})

ValidPerg(aRegs,"GPR080    ",.T.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas		 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("GPR080    ",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros					    ³
//³ mv_par01		//	Data Base (referencia)					³
//³ mv_par02		//	Filial	De								³
//³ mv_par03		//	Filial	Ate 							³
//³ mv_par04		//	Centro de Custo De						³
//³ mv_par05		//	Centro de Custo Ate 					³
//³ mv_par06		//	Matricula De							³
//³ mv_par07		//	Matricula Ate							³
//³ mv_par08		//	Nome De 								³
//³ mv_par09		//	Nome Ate								³
//³ mv_par10		//	Ferias, 13§ Salario, Aviso Previo, Todos³
//³ mv_par11		//	Situacao do Funcionario 				³
//³ mv_par12		//	Categoria do Funcionario				³
//³ mv_par13		//	Considera Mes Atual do Acumulado   		³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Titulo := STR0010		//"DEMONSTRATIVO DE MDIAS"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT						 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:="PTGPR80"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carregando variaveis mv_par?? para Variaveis do Sistema.	 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nOrdem	   := aReturn[8]
dDtBase    := mv_par01
cFilDe	   := mv_par02
cFilAte    := mv_par03
cCcDe	   := mv_par04
cCcAte	   := mv_par05
cMatDe	   := mv_par06
cMatAte    := mv_par07
cNomDe	   := mv_par08
cNomAte    := mv_par09
nTipoMed   := mv_par10
cSituacao  := mv_par11
cCategoria := mv_par12
lMesAtu    := If(mv_par13 == 3, .F., .T.)  // 1 - Mensal  2 - Acumulado  3 - Nao
lMovMensal := If(mv_par13 == 1, .T., .F.)
wCabec1    += DTOC(dDtBase)

If nLastKey = 27
	Return
Endif
SetDefault(aReturn,cString)
If nLastKey = 27
	Return
Endif

RptStatus({|lEnd| GR080Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o	 ³ GR080Imp ³ Autor ³ R.H. - Jose Ricardo	³ Data ³ 12.04.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Demonstrativo de Medias									  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ GPR080Imp(lEnd,wnRel,cString)							  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd 	   - A‡Æo do Codelock							  ³±±
±±³			 ³ wnRel	   - T¡tulo do relat¢rio						  ³±±
±±³Parametros³ cString	- Mensagem										  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso	 	 ³ Generico 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function Gr080Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Locais (Programa)						    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local CbTxt // Ambiente
Local CbCont
Local Val_SalMin := 0
Local dDt1,dDt3,dDt4,dDt6
Local cFilAnterior := "!!"
Local nSalario	:= nSalMes := nSalDia := nSalHora := 0
Local cArqDbf,cArqNtx

/*
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³ Variaveis de Acesso do Usuario                               ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER080" , "SRA" , "2" ) + " } " )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis Privates (Programa)					 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
c__Roteiro			:= "   "
Private aPdv		:= {} // Matriz Incidencia de Verbas Usado na Fvaloriza()
Private aCodFol		:= {}
Private aRoteiro	:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametro Salario Minimo								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// If !Sal_Min(@Val_SalMin,MesAno(dDtBase))
//	Return
// Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Parametro Salario Minimo								    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If !Sal_Min(@Val_SalMin,MesAno(dDtBase),SRA->RA_FILIAL)
	Return
Endif

//--Criar Arquivo de Medias Temporario
Cria_TRP(@cArqDbf,@cArqNtx)

dbSelectArea ("SRA")
DbGoTop()
If nOrdem == 1
	dbSetOrder(1)
	dbSeek( cFilDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim	 := cFilAte + cMatAte
ElseIf nOrdem == 2
	dbSetOrder(2)
	dbSeek( cFilDe + cCcDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim	 := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 3
	dbSetOrder(3)
	dbSeek( cFilDe + cNomDe + cMatDe,.T. )
	cInicio  := "SRA->RA_FILIAL + SRA->RA_NOME + SRA->RA_MAT"
	cFim	 := cFilAte + cNomAte + cMatAte
Endif

dbSelectArea("SRA")
SetRegua(SRA->(RecCount()))

While !Eof() .And. &cInicio <= cFim
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Movimenta Regua de Processamento							³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IncRegua()

	If lEnd
		@Prow()+1,0 PSAY cCancel
		Exit
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Consiste Parametrizacao do Intervalo de Impressao			³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (SRA->Ra_NOME < cNomDe) .Or. (SRA->RA_NOME > cNomAte) .Or. ;
	   (SRA->Ra_MAT < cMatDe)  .Or. (SRA->RA_MAT > cMatAte)  .Or. ;
		(SRA->RA_CC < cCcDe)	.Or. (SRA->RA_CC > cCcAte)
		SRA->(dbSkip(1))
		Loop
	EndIf

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³Consiste Filiais e Acessos                                             ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ*/
    IF !( SRA->RA_FILIAL $ fValidFil() ) .or. !Eval( cAcessaSRA )
       	dbSelectArea("SRA")
       	dbSkip()
       	Loop
    EndIF

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Despreza conforme Situacao e Categoria dos funcionarios     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	!( SRA->RA_SITFOLH $ cSituacao ) .Or. !( SRA->RA_CATFUNC $ cCategoria )
		dbSkip()
		Loop
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quebra de Filial									        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If	cFilAnterior # SRA->RA_FILIAL
		cFilAnterior := SRA->RA_FILIAL
		If !FP_CODFOL(@aCodFol,SRA->RA_FILIAL)
			Return
		Endif
	Endif

	dDt1 := ""
	If	nTipoMed == 1 .Or. nTipoMed == 5
		dbSelectArea( "SRF" )
		If dbSeek( SRA->RA_FILIAL + SRA->RA_MAT )
			dDt1 := SRF->RF_DATABAS
		Else
			dDt1 := SRA->RA_ADMISSA
		Endif
	Endif
    dDt3 := If(nTipoMed == 2 .OR. nTipoMed == 5,dDtBase,"")
    dDt4 := If(nTipoMed == 3 .OR. nTipoMed == 5,dDtBase,"")
    dDt6 := If(nTipoMed >= 4 ,dDtBase,"")
    	
	nSalario := 0
	nSalMes  := 0
	nSalDia  := 0
	nSalHora := 0

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta as Variaveis de Salario Incorporado					 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aPd := {} // Limpa a Matriz do SRC
	fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia,.T.)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Busca os valores de Rescisao e os carrega em aPd			 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lMovMensal .And. !Empty(SRA->RA_DEMISSAO)
		aPd := {}		// Limpar apd em caso de rescisao para nao duplicar os valores lancados no SRC que foram levados para rescisao
		fApdResc(dDtBase)
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta Media 												 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("TRP")
	Zap
    If GPEXMED(dDt1,,dDt3,dDt4,dDtBase,nSalHora,Val_SalMin,aCodfol,lMesAtu,lMovMensal,,dDt6)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Imprime Demonstrativo									    ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	   fImpr_Med(nSalMes,nSalDia,nSalHora)
    Endif
    DbSelecTarea("TRP")   
    if !File("TRPDEMMEDIA.DBF")
       Copy to TRPDEMMEDIA.DBF
    Else            
       COPY TO TRPMED2    
       USE TRPDEMMEDIA NEW ALIAS "TRPPOT"
       SELE "TRPPOT"
       APPEND FROM TRPMED2       
       dBCloseArea("TRPPOT")
    Endif  

	dbSelectArea( "SRA" )
	dbSkip()
Enddo


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Termino do relatorio										³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea( "SRA" )
Set Filter to 
dbSetOrder(1)

Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif
MS_FLUSH()
TRP->(dbCloseArea())
fErase(cArqNtx + OrdBagExt())
fErase(cArqDbf + GetDBExtension())

Return Nil

*------------------------------------------------*
USER Function fImpr_Med(nSalMes,nSalDia,nSalHora,cTipoMov)
*------------------------------------------------*
Local aTipoRel 		:= {STR0011,STR0012,STR0013,STR0014,STR0043}		//"F‚rias Vencidas"###"F‚rias a Vencer"###"13o Sal rio "###"Aviso Pr‚vio "#"Lic.Maternidade"
Local nTipo    		:= 0
Local cTipo      	:= "0"
Local cPd 			:= "000"
Local cTitulo    	:= ""
Local aTipMed
Local cCnt
Local cTipoRel
Local cImpressas 	:= ""
Local lAtuDatBse 	:= .F.
Local dDtBasVen  	:= SRF->RF_DATABAS
Local nCnt

Private A1COLUNA 	:= {}
Private A2COLUNA 	:= {}
Private	LI    		:= 0
Private nMes        := 0
Private nDia 		:= 0
Private nHor 		:= 0
Default cTipoMov	:= " "

nMes := nSalMes
nDia := nSalDia
nHor := nSalhora

// Ponto para alterar variaveis do de salario do cabecalho
If ExistBlock("GP080ALT")
	Execblock("GP080ALT",.F.,.F.)
Endif

cColuna := "A1COLUNA"
dbSelectArea( "TRP" )

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Tipos de Medias a Imprimir:                                 ³
//| 1-Ferias Vencidas 1o Periodo                                |
//| 2-Ferias a Vencer                                           |
//| 3-13o Salario                                            |
//| 4-Aviso Previo                                              |
//| 5 a 9-Ferias Vencidas Periodos 2o,3o,4o...                  |
//| A-Licenca Maternidade                                       |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
aTipMed    := { "1","5","6","7","8","9","2","3","4","A" }
For nCnt := 1 To 10
	If !dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + aTipMed[nCnt] )
		Loop
	ElseIf !(aTipMed[nCnt] $ "3*4*A") // 13o.Salario e Aviso Previo
		cImpressas += aTipMed[nCnt] + "*"
	EndIf

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se for impressao a partir das ferias e nao tiver 1a.parcela  |
	//³ nao imprime o demonstrativo de medias de 13o.salario.        |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If cTipoMov == "F"
		If M->RH_PERC13S == 0 .And. aTipMed[nCnt] == "3"
			Loop
		Endif
	Endif

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se houver mais de um periodo de vencida atualiza a data base|
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	lAtuDatBse := .F.
	Aeval( aTipMed, { |x| If( x $ cImpressas .And. x # aTipMed[nCnt], lAtuDatBse := .T., "" ) } )
	If aTipMed[nCnt] $ "2*5*6*7*8*9" .And. lAtuDatBse
		dDtBasVen := fCalcFimAq(dDtBasVen)+1 // Inicio do proximo periodo
	EndIf

	If Len(A1COLUNA) # 0
		DESCARREGA()
		cColuna := "A1COLUNA" 
		IMPR(" ","C")
	Endif
	cTipo := TRP->RP_TIPO
	LI    := 0
	
	While !Eof() .And. SRA->RA_FILIAL+SRA->RA_MAT+cTipo = TRP->RP_FILIAL+TRP->RP_MAT+TRP->RP_TIPO

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicio da Impressao Das Linhas Detalhes 					³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If LI = 0
			nTipo    := If( cTipo=="A",5,If( cTipo>"4",1,Val(cTipo)))
			cTipoRel := aTipoRel[nTipo]+If( nTipo==1, "("+Str(nCnt,1)+")", "" )
			TITULO := STR0015+cTipoRel+ " ***"		//"*** DEMONSTRATIVO DE MEDIA DE HORAS EXTRAS E ADICIONAIS PARA "
			IMPR(" "+REPL("_",130),"C")
			DET := STR0016+Left(SRA->RA_NOME,30)+SPACE(8)+STR0017+SRA->RA_NUMCP+" - "+SRA->RA_SERCP+SPACE(6)+STR0018	//"| Funcionario....: "###"Cart.Trab.:"###"Registro: "
			DET += SRA->RA_MAT+SPACE(6)+STR0019				//"Admissao:"
			DET += PADR(DTOC(SRA->RA_ADMISSAO),10) +" |"
			IMPR(DET,"C")
			DET := STR0020+Subs(SRA->RA_CC+Space(20),1,20)+" - "+DescCC(SRA->RA_CC,SRA->RA_FILIAL,25)+SPACE(1)		//"| Centro de Custo: "
			DET += STR0021+SRA->RA_CODFUNC + " - " + DescFun(SRA->RA_CODFUNC,SRA->RA_FILIAL)+iif(cPaisLoc == "BRA",SPACE(4),Space(2))					//"Funcao....: "
			DET += IF(nTipo<3,STR0022+If(nCnt==1 .and. !Empty(SRF->RF_IVENPEN), ;
			                              PADR(DTOC(SRF->RF_IVENPEN),10),  ;
			                              PADR(DTOC(dDtBasVen),10) )  ,SPACE(19))+"|"										//"Base Fer:"
			IMPR(DET,"C")
			DET := STR0023+TRANSFORM(nMes,"@E 999,999,999.99")+STR0024+SPACE(16)+TRANSFORM(ndia,"@E 999,999,999.99")+STR0025		//"| Salario Base...: "###" por mes"###" por dia"
			DET += SPACE(9)+TRANSFORM(nhor,"@E 999,999,999.99")+STR0026+SPACE(20)+"|"	//" por hora"									
			IMPR(DET,"C")
			IMPR("|"+REPL("_",130)+"|","C")
		Endif
	
		If TRP->RP_PD # cPd
			If cPd = "998" .OR. cPd = "997"
				FTrocaColuna()
			Endif
	
			nTipo    := If( cTipo=="A",5,If( cTipo>"4",1,Val(cTipo)))
			cTipoRel := aTipoRel[nTipo]+If( nTipo==1, "("+Str(nCnt,1)+")", "" )
			cTitulo  := If(TRP->RP_PD="999",STR0027+cTipoRel,If(TRP->RP_PD="998",STR0028+cTipoRel,;					//"TOTAIS - "###"TOTAL FALTAS - "
					        If(TRP->RP_PD="997",STR0029+cTipoRel,TRP->RP_PD+" - "+DescPd(TRP->RP_PD,SRA->RA_FILIAL,20))))	//"TOTAL ADTO. -  "
			DET := SPACE(12)+"*** "+ cTitulo + " ***" + SPACE(42-Len(cTitulo))
			AADD(&(cColuna),DET)
			If TRP->RP_PD = "998"
				DET := SPACE(21)+STR0030+SPACE(37)		//"DIAS"
			ElseIf TRP->RP_PD = "997"
				DET := SPACE(57)+STR0031					//"VALOR"
			Else
				DET := STR0032		//"REF.    DATA PGT     HORAS      VALOR ORIG.        VALOR ATUAL"
			Endif
			AADD(&(cColuna),DET)
			DET := REPL("_",62)
			AADD(&(cColuna),DET)
			cPd := TRP->RP_PD
		
		Endif
	
// | REF.    DATA PGT     HORAS      VALOR ORIG.        VALOR ATUAL |
// | 99/9999 99/99/9999 9999.99   999.999.999.99   9.999.999.999.99 |
// | ** TOTAL           9999,99           500,00             500,00 |
// | ** MEDIA     (12)  9999,99            41,67              41,67 |
// | ** MEDIA PGTO(12)  9999,99            41,67              41,67 |
// | * TOT OUTROS       9999,99         2.480,90           2.480,90 |
// | * MED OUTROS       9999,99           206,75             206,75 |
// | * OUTROS PGTO      9999,99           206,75             206,75 |
// | * TOT H.EXT        9999,99             0,00               0,00 |
// | * MED H.EXT        9999,99             0,00               0,00 |
// | * H.EXT PGTO       9999,99             0,00               0,00 |
// | ** TOTAL           9999,99         2.480,90           2.480,90 |
// | ** MEDIA           9999,99           206,75             206,75 |
// | ** MEDIA PGTO      9999,99           206,75             206,75 |
// | NO PERIODO         9999,99                                    
	
		If TRP->RP_DATARQ = "9798  "
			DET := STR0033+SPACE(7)+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;		//"* TOT OUTROS"
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "9799  "
			DET := STR0034+If(TRP->RP_PD=="999","    ","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+" "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* MED OUTROS  "
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "97MD  "
			DET := STR0035+If(TRP->RP_PD == "999","    ","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+" "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* OUTROS PGTO "
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "9898  "
			DET := STR0036+SPACE(6)+" "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* TOT H.EXT "
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "9899  "
			DET := STR0037+If(TRP->RP_PD == "999","    ","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+" "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* MED H.EXT   "
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "98MD  "
			DET := STR0038+If(TRP->RP_PD == "999","    ","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+" "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"* H.EXT PGTO  "
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "9998  "
			DET := STR0039+SPACE(2)+"   "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"** TOTAL      "
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "9999  "
			DET := STR0040+If(TRP->RP_PD == "999","     ","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+" "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"** MEDIA     "
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_DATARQ = "99MD  "
			DET := STR0041+If(TRP->RP_PD == "999","     ","("+StrZero(TRP->RP_MESMEDIA,2)+") ")+" "+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;	//"** MEDIA PGTO"
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
			FTrocaColuna()
		ElseIf TRP->RP_PD = "998"
			If TRP->RP_TIPO="3"
				DET := RIGHT(TRP->RP_DATARQ,2)+"/"
				DET += PADR(IF(nTData==8,SubStr(TRP->RP_DATARQ,3,2),Left(TRP->RP_DATARQ,4)),5)
			Else
				DET := STR0042		//"NO PERIODO"
			Endif
			DET += SPACE(10)+TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(35) 
			AADD(&(cColuna),DET)
		ElseIf TRP->RP_PD = "997"
			DET := SPACE(46)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		Else
			DET := PADR(RIGHT(TRP->RP_DATARQ,2)+"/"+IF(nTData==8,SubStr(TRP->RP_DATARQ,3,2),Left(TRP->RP_DATARQ,4)),8)
			DET += PADR(DTOC(TRP->RP_DATPGT),10)+SPACE(1)+;
				TRANSFORM(TRP->RP_HORAS,"@E 9999.99")+SPACE(3)+TRANSFORM(TRP->RP_VALOR,"@E 999,999,999.99")+;
				SPACE(3)+TRANSFORM(TRP->RP_VALATU,"@E 9,999,999,999.99")
			AADD(&(cColuna),DET)
		Endif
		dbSelectArea( "TRP" )
		dbSkip()
	EndDo
Next nCnt
If Len(A1COLUNA) # 0
	DESCARREGA()
	Li := 0
Endif
IMPR(" ","F")
Retu Nil

*---------------------------------------------------------------------------*
* FUNCAO PARA IMPRIMIR OS VETORES CONTENDO AS LINHAS DE DETALHE DE IMPRESSAO
*---------------------------------------------------------------------------*
USER Function DESCARREGA
Local x
If Len(A1COLUNA) > Len(A2COLUNA)
	cColuna = "A1COLUNA"
	ASIZE(A2COLUNA,Len(A1COLUNA))
Else
	cColuna = "A2COLUNA"
	ASIZE(A1COLUNA,Len(A2COLUNA))
Endif
For x = 1 TO Len(&(cColuna))
	DET = "| "+IF(A1COLUNA[x]=NIL,SPACE(62),A1COLUNA[x])+" || "+IF(A2COLUNA[x]=NIL,SPACE(62),A2COLUNA[x])+" |"
	IMPR(DET,"C")
NEXT x

IMPR("|"+REPL("_",130)+"|","C")
ASIZE(A1COLUNA,0)
ASIZE(A2COLUNA,0)

Return (.T.)

*-----------------------------*
User Function FTrocaColuna()
*-----------------------------*
If cColuna = "A2COLUNA"
	DESCARREGA()
	cColuna = "A1COLUNA"
Else
	cColuna = "A2COLUNA"
Endif

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fApdResc |Autor  ³ Recursos Hunano       ³ Data ³ 27/04/00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Verifica se deve incluir as medias do mes atual no         ³±±
±±³          ³ demonstrativo de medias.                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³fApdResc(dDtBase)											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ dDtBase     - mes atual de referencia                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³Generico                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function fApdResc(dDtBase)
Local cAlias := Alias()

dbSelectArea( "SRG" )
dbSeek( SRA->RA_FILIAL+SRA->RA_MAT )
While !Eof() .And. SRG->RG_FILIAL+SRG->RG_MAT == SRA->RA_FILIAL+SRA->RA_MAT
	If MesAno(SRG->RG_DTGERAR) == MesAno(dDtBase) .And. SRG->RG_MEDATU == "S"
		dbSelectArea("SRR")
		dbSeek( SRA->RA_FILIAL + SRA->RA_MAT + "R" )
		While !Eof() .And. RR_FILIAL + RR_MAT == SRA->RA_FILIAL + SRA->RA_MAT
			If SRR->RR_TIPO3 == "R"
				nPos := Ascan(aPd,{ |X| X[1] = SRR->RR_PD } )
				If nPos = 0
					Aadd(aPd,{SRR->RR_PD,"","",SRR->RR_HORAS,SRR->RR_VALOR,SRR->RR_TIPO1,SRR->RR_TIPO2,0," ",SRR->RR_DATA})
				Else
					aPd[nPos,5] += SRR->RR_VALOR
				Endif
			EndIf
			dbSkip()
		Enddo
		Exit
	EndIf
	dbSelectArea( "SRG" )
	dbSkip()
EndDo
dbSelectArea( cAlias )
Return( NIL )
