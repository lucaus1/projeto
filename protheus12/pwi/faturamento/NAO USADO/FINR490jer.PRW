#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function finr490()        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,CFILIAL,NCHAR")
SetPrvt("CSAVCOR,TITULO,ARETURN,NOMEPROG,NLASTKEY,CPERG")
SetPrvt("LI,WNREL,CEXTENSO,NCONTADOR,NTIPO,MV_PAR01")
SetPrvt("MV_PAR02,MV_PAR03,MV_PAR04,LEND,CDOCTO,J")
SetPrvt("NREC,NFIRST,LAGLUT,CTAMANHO,ADRIVER,AA")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇� FINR490 -> ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.          낢�
굇쳐컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛rogramador � Data   � BOPS �  Motivo da Alteracao                     낢�
굇쳐컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Eduardo    �22/01/98�14115a� Exclusao do SETPRC() p/impressora default낢�
굇�            �        �      � do Windows                               낢�
굇� Mauricio   �20/07/98�      � Nro de titulo com 12 posicoes            낢�
굇� Julio      �22.04.99쿛roth.� Isolar setcolor() c/ #IFNDEF (Win/Proth.)낢�
굇� Mauricio   �16/09/99�23724A� Imprimir vencto real ao inv굎 de vencto  낢�
굇�            �        �      � para os titulos na c줽ia de cheques      낢�
굇읕컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
/*/
#IFNDEF WINDOWS
	// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 08/06/00 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o        � FINR490      � Autor � Paulo Boschetti                 � Data � 23.04.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � C줽ia de Cheques                                                                                                           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe       � FINR490(void)                                                                                                                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�      Uso     � Generico                                                                                                                               낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                                                                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cDesc1 := "Este programa ir� imprimir as copias dos cheques emitidos."
cDesc2 := "Ser� impresso 1 ou 2 cheques for folha."
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

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
IF !(pergunte("FIN490",.T.))
	RETURN Nil
ENDIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                                                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � FA490Imp � Autor � Wagner Xavier         � Data � 13.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Copia de cheques                                           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � FA490Imp(lEnd,wnRel,cString)                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros� lEnd    - A눯o do CodeBlock                                낢�
굇�          � wnRel   - T죜ulo do relat줿io                              낢�
굇쿛arametros� cString - Mensagem                                         낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==>  Function FA490Imp
Static Function FA490Imp()

cExtenso := ""
nContador:=0

nTipo   :=IIF(aReturn[4]==1,15,18)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica se existe o Banco                                                                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SA6")
dbSeek(xFilial()+mv_par01+mv_par02+mv_par03)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Localiza o 1.Cheque a ser impresso
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros
//� mv_par01                    // Codigo Do Banco
//� mv_par02                    // Da Agencia
//� mv_par03                    // Da Conta
//� mv_par04                    // Do Cheque
//� mv_par05                    // Ate o Cheque
//� mv_par06                    // Imprime composicao do cheque
//� mv_par07                    // Copias p/ pagina (1/2)
//� mv_par08                    // Imprime Numeracao Sequencial
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

dbSelectArea("SEF")
dbSeek(xFilial()+mv_par01+mv_par02+mv_par03+mv_par04,.T.)

SetRegua(RecCount())
fa490Cabec(nTipo)
While !Eof() .And. (EF_BANCO+EF_AGENCIA)==(MV_PAR01+MV_PAR02) .AND. ALLTRIM(EF_CONTA)==ALLTRIM(MV_PAR03) .AND. EF_NUM<=MV_PAR05
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
	
	li:=1
	
	nContador:=NCONTADOR+1
	IF nContador>2
	   nContador:=1
	   li:=1
	EndIF
	
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
		
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Pegar e gravar o proximo numero da Copia do Cheque                �
		//� Posicionar no sx6 utilizando GetMv. N꼘 Utilize Seek !!! �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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



	DBSELECTAREA("SEF")
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o        � fr490Cpos� Autor � Wagner Xavier               � Data � 13.11.92 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Copia de cheques                                                                                       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � FINR490(void)                                                                                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros�                                                                                                                           낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso     � Generico                                                                                                        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==>  Function fr490Cpos
Static Function fr490Cpos()
nFirst:=0
lAglut:=.F.
__TOT:=0
CCHEQUE:=SEF->EF_NUM

DbSelectArea("SEF")
While !Eof() .And. EF_BANCO==mv_par01 .And. EF_AGENCIA==mv_par02 .And. EF_CONTA==mv_par03 .And. EF_NUM==cCheque
	
	
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Verifica se nao � principal o cancelado                                      �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
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
	DBSETORDER(1)
	dbSeek(xFilial()+SEF->EF_PREFIXO+SEF->EF_TITULO+SEF->EF_PARCELA+SEF->EF_TIPO+SEF->EF_FORNECE+SEF->EF_LOJA)
	IF FOUND()
		dbSelectArea("SEF")
		@ LI, 0 PSAY "|"
		@ LI,02 PSAY EF_VALOR PicTure "@E 999,999.99"
		@ LI,13 PSAY EF_PREFIXO+"-"+SUBSTR(EF_TITULO,1,6)
		@ LI,24 PSAY SE2->E2_VENCREA
		@ LI,35 PSAY SUBSTR(SE2->E2_NOMFOR,1,15)
		@ LI,51 PSAY SUBSTR(SE2->E2_HIST,1,28)
		@ li,79 PSAY "|"
	ELSE
		dbSelectArea("SEF")
		@ LI, 0 PSAY "|"
		@ LI,02 PSAY EF_VALOR PicTure "@E 999,999.99"
		@ LI,13 PSAY EF_PREFIXO+"-"+SUBSTR(EF_TITULO,1,6)
		@ LI,24 PSAY " <- TITULO NAO ENCONTRADO NO CTAS A PAGAR (SE2) .. VERIFIQUE !!"
	ENDIF
	__TOT:=__TOT+EF_VALOR
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
		@ LI, 0 PSAY "| DecLaro para todos os fins  que recebi da  LISBOA MADEIRA LTDA.  a  quantia  |"
		LI:=LI+1
		@ LI, 0 PSAY "| acima discriminada no valor de R$ "
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o        쿑a490Cabec� Autor � Alessandro B. Freire  � Data � 18.12.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Rotina de leitura do driver correto de impressao              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe e � FA490cabec(nchar)                                                                                      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros� nChar . 15-Comprimido , 18-Normal                                                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso     � Finr490                                                                                                                 낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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
