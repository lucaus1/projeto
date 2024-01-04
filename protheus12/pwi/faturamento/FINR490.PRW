#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function finr490()        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,CFILIAL,NCHAR")
SetPrvt("CSAVCOR,TITULO,ARETURN,NOMEPROG,NLASTKEY,CPERG")
SetPrvt("LI,WNREL,CEXTENSO,NCONTADOR,NTIPO,MV_PAR01")
SetPrvt("MV_PAR02,MV_PAR03,MV_PAR04,LEND,CDOCTO,J")
SetPrvt("NREC,NFIRST,LAGLUT,CTAMANHO,ADRIVER,AA")

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ FINR490 -> ATUALIZACOES SOFRIDAS DESDE A CONSTRU€AO INICIAL.          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Programador ³ Data   ³ BOPS ³  Motivo da Alteracao                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Eduardo    ³22/01/98³14115a³ Exclusao do SETPRC() p/impressora default³±±
±±³            ³        ³      ³ do Windows                               ³±±
±±³ Mauricio   ³20/07/98³      ³ Nro de titulo com 12 posicoes            ³±±
±±³ Julio      ³22.04.99³Proth.³ Isolar setcolor() c/ #IFNDEF (Win/Proth.)³±±
±±³ Mauricio   ³16/09/99³23724A³ Imprimir vencto real ao inv‚s de vencto  ³±±
±±³            ³        ³      ³ para os titulos na c¢pia de cheques      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
/*/
#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/06/00 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o        ³ FINR490      ³ Autor ³ Paulo Boschetti                 ³ Data ³ 23.04.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ C¢pia de Cheques                                                                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe       ³ FINR490(void)                                                                                                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³      Uso     ³ Generico                                                                                                                               ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                                                                                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cDesc1 := "Este programa ir  imprimir as copias dos cheques emitidos."
cDesc2 := "Ser  impresso 1 ou 2 cheques for folha."
cDesc3 :=""
cString:="SEF"
cFilial:=SM0->M0_CODFIL
nChar:=18

#IFNDEF WINDOWS
	cSavCor:=SetColor()
#ENDIF

titulo  :="Copias de Cheques"
aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1 }
nomeprog:="FINR490"
nLastKey:= 0
cPerg    :="FIN490"
li       :=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN490",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                                                                  ³
//³ mv_par01                    // Codigo Do Banco                                                                ³
//³ mv_par02                    // Da Agencia                                                                             ³
//³ mv_par03                    // Da Conta                                                                               ³
//³ mv_par04                    // Do Cheque                                                                              ³
//³ mv_par05                    // Ate o Cheque                                                                   ³
//³ mv_par06                    // Imprime composicao do cheque                           ³
//³ mv_par07                    // Copias p/ pagina (1/2)                                                 ³
//³ mv_par08                    // Imprime Numeracao Sequencial                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                                                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FINR490"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"P")

If nLastKey==27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	#IFNDEF WINDOWS
		SetColor(cSavCor)
	#ENDIF
	Return
Endif

#IFDEF WINDOWS
	RptStatus({|| Fa490Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==> 	RptStatus({|| Execute(Fa490Imp)})
#ELSE
	fa490Imp(.f.,Wnrel,cString)
#ENDIF
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA490Imp ³ Autor ³ Wagner Xavier         ³ Data ³ 13.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copia de cheques                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA490Imp(lEnd,wnRel,cString)                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lEnd    - A‡Æo do CodeBlock                                ³±±
±±³          ³ wnRel   - T¡tulo do relat¢rio                              ³±±
±±³Parametros³ cString - Mensagem                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==>  Function FA490Imp
Static Function FA490Imp()

cExtenso := ""
nContador:=0

nTipo   :=IIF(aReturn[4]==1,15,18)
mv_par01:=mv_par01+Space( 3-Len(mv_par01))
mv_par02:=mv_par02+Space( 5-Len(mv_par02))
mv_par03:=mv_par03+Space(10-Len(mv_par03))
mv_par04:=mv_par04+Space(15-Len(mv_par04))



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe o Banco                                                                                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA6")
dbSeek(xFilial()+mv_par01+mv_par02+mv_par03)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o 1.Cheque a ser impresso                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEF")
dbSeek(xFilial()+mv_par01+mv_par02+mv_par03+mv_par04,.T.)

SetRegua(RecCount())
fa490Cabec(nTipo)
While !Eof() .And. EF_FILIAL+EF_BANCO=cFilial+mv_par01 .And. ;
	EF_AGENCIA=mv_par02 .And. EF_CONTA=mv_par03 .And. ;
	EF_NUM<=mv_par05
	
	#IFNDEF WINDOWS
		Inkey()
		If LastKey()==K_ALT_A
			lEnd := .t.
		End
	#ENDIF
	
	If lEnd
		@Prow()+1,1 PSAY "Cancelado pelo operador"
		Exit
	EndIF
	
	IncRegua()
	
	IF EF_IMPRESS $ "AC" .or. SubStr(EF_TIPO,1,2) == "TB"
		dbSkip()
		Loop
	EndIF
	
	IF mv_par07 == 1                //uma copia por folha
		li:=1
	Elseif li > 32          //so coube uma copia
		li:=1
	Else                            //2 copias por folha
		IF nContador == 0
			li:=1
		Else
			li:=33
		EndIF
	EndIF
	
	nContador:=NCONTADOR+1
	IF nContador>2;nContador:=1;li:=1;EndIF
	__LogPages()
	@ LI, 1 PSAY Alltrim(SM0->M0_NOMECOM) + " - " + Alltrim(SM0->M0_FILIAL) + "  -  COPIA DE CHEQUE"
	LI:=LI+1
	@ LI, 0 PSAY Replicate("-",80)
	LI:=LI+1
	@ LI, 0 PSAY "|  Numero Cheque "  +EF_NUM
	_NUMC:=EF_NUM
	@ LI,35 PSAY "Data da Emissao "  +Dtoc(EF_DATA)
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|  Banco "+EF_BANCO+  "     "    +SA6->A6_NREDUZ
	@ LI,35 PSAY "Agencia "+EF_AGENCIA+"   Conta "+EF_CONTA
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|  Valor Cheque "+Transform(EF_VALOR,"@E 9999,999,999.99")
	@ LI,35 PSAY "Data do Cheque  "+Dtoc(EF_DATA)
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|  Favorecido "+EF_BENEF
	_FAVOREC:=EF_BENEF
	_DATACHE:=EF_DATA
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|  Historico  "+EF_HIST
	__HIST:=EF_HIST
	@ LI,79 PSAY "|"
	LI:=LI+1
	If mv_par08 == 1
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Pegar e gravar o proximo numero da Copia do Cheque                ³
		//³ Posicionar no sx6 utilizando GetMv. N„o Utilize Seek !!! ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDocto := STRZERO(VAL(Getmv("MV_NUMCOP"))+1,6)
		dbSelectArea("SX6")
		GetMv("MV_NUMCOP")
		RecLock("SX6",.F.)
		Replace X6_CONTEUD With cDocto
		MsUnlock()
		dbSelectArea("SEF")
		
		@ LI, 0 PSAY "|  Copia de Cheque No. "+cDocto+"      # PAYMENT AUTORIZATION (OTHER) #"
		@ LI,79 PSAY "|"
	Else
		@ LI, 0 PSAY "|"
		@ LI,79 PSAY "|"
	End
	LI:=LI+1
	@ LI, 0 PSAY Replicate("-",80)
	
	nRec:=RecNo()
	IF mv_par06 == 1
		fr490Cpos(SEF->EF_NUM)
	EndIF
    DBSELECTAREA("SEF")
	dbGoTo(nRec)
	dbSkip()
End

Set Device To Screen
Set Filter To

If aReturn[5]==1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o        ³ fr490Cpos³ Autor ³ Wagner Xavier               ³ Data ³ 13.11.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Copia de cheques                                                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FINR490(void)                                                                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                                                                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso     ³ Generico                                                                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==>  Function fr490Cpos
Static Function fr490Cpos()
nFirst:=0
lAglut:=.F.
__TOT:=0
CCHEQUE:=SEF->EF_NUM

DbSelectArea("SEF")
Seek xFILIAL()+mv_par01+mv_par02+mv_par03+cCheque
While !Eof() .And. EF_FILIAL+EF_BANCO=cFilial+mv_par01 .And. ;
	EF_AGENCIA=mv_par02 .And. EF_CONTA=mv_par03 .And. ;
	EF_NUM==cCheque
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se nao ‚ principal o cancelado                                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF EF_IMPRESS == "C"
		dbSkip()
		Loop
	End
	IF li > 58
		li:=1
		@ LI,0 PSAY "COPIA DO CHEQUE : "+ cCheque + " - Continuacao"
		LI:=LI+1
	EndIF
	IF nFirst == 0
		IF EF_IMPRESS=="A"
			lAglut:=.T.
		EndIF
		IF !lAglut .and. Empty(SEF->EF_TITULO)
			dbSkip()
			Loop
		End
		LI:=LI+1
		@ LI,0 PSAY "|-----------------------"+Replicate("-",55)+"|"
		LI:=LI+1
		@ LI,0 PSAY "|   Valor    N.Fiscal     Dt Venc  Fornecedor      Historico                   |"
		LI:=LI+1
		@ LI,0 PSAY Replicate("-",80)
	EndIF
	IF Empty(SEF->EF_TITULO)
		dbSkip()
		Loop
	End
	nFirst:=nFirst + 1
	LI:=LI+1
	
	dbSelectArea("SE2")
	dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
	
	dbSelectArea("SEF")
	
	@ LI, 0 PSAY "|"
	@ LI,02 PSAY EF_VALOR PicTure "@E 999,999.99"
	@ LI,13 PSAY EF_PREFIXO+"-"+SUBSTR(EF_TITULO,1,6)
	@ LI,24 PSAY SE2->E2_VENCREA
	@ LI,35 PSAY SUBSTR(SE2->E2_NOMFOR,1,15)
	@ LI,51 PSAY SUBSTR(SE2->E2_HIST,1,28)
	@ li,79 PSAY "|"
	__TOT:=__TOT+EF_VALOR
	//    DBSELECTAREA("SA2")
	//    DBSETORDER(1)
	//    DBSEEK("  "+SE2->E2_FORNECE)
	//    IF FOUND() .AND. A2_BCOAGE<>SPACE(15)
	//       LI:=LI+1
	//       @ LI, 0 PSAY "|"
	//       @ LI,13 PSAY "* Deposito : "+ALLTRIM(A2_BCOAGE)+" - "+A2_NUMCON+" - "+A2_FAVOREC
	//       @ li,79 PSAY "|"
	//    ENDIF
	dbSelectArea("SEF")
	dbSkip()
EndDO
IF nFirst>0
	LI:=LI+1
	@ LI, 0 PSAY Replicate("-",80)
	LI:=LI+1
	@ LI, 0 PSAY "|  Total R$ =======> "
	@ LI,21 PSAY __TOT PICTURE "@E 999,999.99"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY Replicate("-",80)
	
	LI:=LI+2
	
	@ LI, 0 PSAY Replicate("-",80)
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,35 PSAY _NUMC
	@ LI,60 PSAY __TOT PICTURE "@E 999,999.99"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,79 PSAY "|"
	LI:=LI+1
	_EXT:=EXTENSO(__TOT)+REPLICATE("*",200)
	@ LI, 0 PSAY "|"
	@ LI,10 PSAY "("+LEFT(_EXT,60)
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,10 PSAY SUBSTR(_EXT,61,60)+")"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,10 PSAY IIF(!EMPTY(_FAVOREC),_FAVOREC,"# DIVERSOS #")
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,60 PSAY +DTOC(_DATACHE)
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY Replicate("-",80)
	LI:=LI+1
	@ LI, 0 PSAY "|   Banco: "+SEF->EF_BANCO+"-"+SA6->A6_NREDUZ
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "    Agenc: "+SEF->EF_AGENCIA+"  Conta: "+SEF->EF_CONTA
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY Replicate("-",80)
	
	LI:=LI+2
	@ LI, 0 PSAY Replicate("-",80)
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "| Conferido Por :                   Data:     /    /     Ass:                  |"
	LI:=LI+1
	@ LI, 0 PSAY "| (checked by)   ------------------ (date)             (Sign) -----------------|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "|"
	@ LI,79 PSAY "|"
	LI:=LI+1
	@ LI, 0 PSAY "| Autorizad Por :                   Data:     /    /     Ass:                  |"
	LI:=LI+1
	@ LI, 0 PSAY "| (checked by)   ------------------ (date)             (Sign) -----------------|"
	LI:=LI+1
	@ LI, 0 PSAY Replicate("-",80)
	IF nFirst == 1
		LI:=LI+2
		@ LI,0 PSAY REPLICATE("-",80)
		LI:=LI+1
		@ LI, 0 PSAY "|                                  R E C I B O "
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "|"
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "|Declaro para todos os fins que recebi da PRECIOUS WOODS BELEM LTDA. a quantia |"
		LI:=LI+1
		@ LI, 0 PSAY "|acima discriminada no valor de R$ "
		@ LI,36 PSAY __TOT PICTURE "@E 999,999.99"
		@ LI,48 PSAY "referente a: "
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "| "+__HIST
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "| ao qual dou plena, total e irrevogavel quitacao."
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "|"
		@ LI,10 PSAY "BELEM, "+DTOC(_DATACHE)
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "|"
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "|"
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "|"
		@ LI,32 PSAY "-----------------------------------"
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY "|"
		@ LI,32 PSAY "              Assinatura"
		@ LI,79 PSAY "|"
		LI:=LI+1
		@ LI, 0 PSAY REPLICATE("-",80)
		
	ENDIF
	
End

Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o        ³Fa490Cabec³ Autor ³ Alessandro B. Freire  ³ Data ³ 18.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de leitura do driver correto de impressao              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA490cabec(nchar)                                                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nChar . 15-Comprimido , 18-Normal                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso     ³ Finr490                                                                                                                 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==>  Function Fa490cabec
Static Function Fa490cabec()

cTamanho := "P"
aDriver := ReadDriver()

If !( "DEFAULT" $ Upper( __DRIVER ) )
	SetPrc(000,000)
Endif
if nChar == NIL
	@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
else
	if nChar == 15
		@ pRow(),pCol() PSAY &(if(cTamanho=="P",aDriver[1],if(cTamanho=="G",aDriver[5],aDriver[3])))
	else
		AA:=(if(cTamanho=="P",aDriver[2],if(cTamanho=="G",aDriver[6],aDriver[4])))
		@ pRow(),pCol() PSAY &AA
	endif
endif
Return(.T.)
