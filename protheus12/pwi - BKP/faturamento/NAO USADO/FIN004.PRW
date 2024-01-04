#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
#IFNDEF WINDOWS
	#DEFINE PSAY SAY 
#ENDIF
 
User Function fin004()        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
 
SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,CFILIAL,NCHAR")
SetPrvt("CSAVCOR,TITULO,ARETURN,NOMEPROG,NLASTKEY,CPERG")
SetPrvt("LI,WNREL,CEXTENSO,NCONTADOR,NTIPO,MV_PAR01")
SetPrvt("MV_PAR02,MV_PAR03,LEND,CDOCTO,J")
SetPrvt("NREC,NFIRST,LAGLUT,CTAMANHO,ADRIVER,AA")


/*/
эээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээээ
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
╠╠зддддддддддбддддддддддбдддддддбдддддддддддддддддддддддбддддддбдддддддддд©╠╠
╠╠ЁFun┤┘o    Ё FIN004   Ё Autor Ё MACEDO                Ё Data Ё 24.05.02 Ё╠╠
╠╠цддддддддддеддддддддддадддддддадддддддддддддддддддддддаддддддадддддддддд╢╠╠
╠╠ЁDescri┤┘o Ё RELACAO DE BAIXAS POR NFISCAL                              Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠ЁSintaxe   Ё FIN004(void)                                               Ё╠╠
╠╠цддддддддддедддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢╠╠
╠╠Ё  Uso     Ё MODULO FINANCEIRO SE5/SEF                                  Ё╠╠
╠╠юддддддддддадддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды╠╠
╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠
ъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъъ
/*/
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Define Variaveis                                             Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
 cDesc1 := "Este programa ira imprimir extrato de baixas por banco"
 cDesc2 := "de acordo com parametros selecionado pelo usuario."
 cDesc3 :=""
 cString:="SEF"
 cFilial:=SM0->M0_CODFIL
 nChar:=18

#IFNDEF WINDOWS
	 cSavCor:=SetColor()
#ENDIF

 titulo  :="Relacao de Baixas"
 aReturn := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 4, 2, 1, "",1 }  
 nomeprog:="FIN004"
 nLastKey:= 0
 cPerg    :="FIN003"
 li       :=1

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica as perguntas selecionadas                                                            Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
pergunte("FIN003",.F.)

//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Variaveis utilizadas para parametros                         Ё
//Ё mv_par01                    // Codigo Do Banco               Ё
//Ё mv_par02                    // Da Agencia                    Ё
//Ё mv_par03                    // Da Conta                      Ё
//Ё mv_par04                    // EMISSAO DE                    Ё
//Ё mv_par05                    // EMISSAO ATE                   Ё
//Ё MV_PAR08                    // 1- ANALITICO ou 2-SINTETICO   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Envia controle para a funcao SETPRINT                        Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
wnrel := "FIN004"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,"M")

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
	RptStatus({|| FA004Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==> 	RptStatus({|| Execute(FA003Imp)})
#ELSE
	FA004Imp(.f.,Wnrel,cString)
#ENDIF
Return

**************************
Static Function FA004Imp()
**************************

nTipo   :=IIF(aReturn[4]==1,15,18)


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Verifica se existe oS BancoS SOLICITADOS                                                                                   Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
dbSelectArea("SA6")
dbSeek(xFilial()+mv_par01)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
DESCBAN01:=SUBSTR(A6_NOME,1,10)

dbSeek(xFilial()+mv_par02)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
DESCBAN02:=SUBSTR(A6_NOME,1,10)

dbSeek(xFilial()+mv_par03)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
DESCBAN03:=SUBSTR(A6_NOME,1,10)

__TOT:=0
__TOTG:=0
_TOTC01:=0
_TOTC02:=0
_TOTC03:=0
nTIT:=0
LI:=56


//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
//Ё Localiza o 1.Cheque a ser impresso                           Ё
//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
DBSELECTAREA("SD1")
DBSETORDER(9)                    // NUM+FORNECEDOR+LOJA+NATUREZA

dbSelectArea("SE5")
DBSETORDER(1)                   // DTOS(E5_DTDIGIT)+BANCO+AGENCIA+CONTA+NUMCHEQ
DBSEEK(xFilial("SE5")+DTOS(MV_PAR04))

SetRegua(RecCount())

FA003Cabec(nTipo)

While !Eof() .AND. E5_DTDIGIT <=MV_PAR05 

	IF LI>55 
           @ 00,000 PSAY REPLICATE("*",132)
           @ 01,000 PSAY "* "+SM0->M0_NOMECOM
           @ 01,131 PSAY "*"
           @ 02,000 PSAY "* "+SM0->M0_FILIAL
           @ 02,045 PSAY "Relacao de Baixas por NFiscal"
           @ 02,110 PSAY "Emissao : "+DTOC(dDATABASE)
           @ 02,131 PSAY "*"
           @ 03,000 PSAY "* Fin004"
           @ 03,035 PSAY "       Periodo de "+DTOC(MV_PAR04)+" ate "+DTOC(MV_PAR05)
           @ 03,131 PSAY "*"
           @ 04,000 PSAY REPLICATE("*",132)
           @ 05,000 PSAY " Data       Num Ch Beneficiario                    Historico                        "+MV_PAR01+"          "+MV_PAR02+"          "+MV_PAR03+"       Natureza"
           @ 06,000 PSAY "                                                                                    "+DESCBAN01+"   "+DESCBAN02+"   "+DESCBAN03
           @ 07,000 PSAY REPLICATE("*",132)
           LI:=8
    ENDIF

	If lEnd
		@ pRow()+1,1 PSAY "Cancelado pelo operador"
		Exit
	EndIF

	IncRegua()

  	COL01:=.F.
  	COL02:=.F.
  	COL03:=.F.
  	lCONT:=.F.
    DO CASE
       CASE E5_BANCO==MV_PAR01
            COL01:=.T.
            lCONT:=.T.
            COLVAL:= 83
       CASE E5_BANCO==MV_PAR02
            COL02:=.T.
            lCONT:=.T.
            COLVAL:= 96
       CASE E5_BANCO==MV_PAR03
            COL03:=.T.
            lCONT:=.T.
            COLVAL:=109
    ENDCASE        

    IF  lCONT
       _E5VALOR:=0
       IF E5_NUMCHEQUE>=MV_PAR06 .AND. E5_NUMCHEQUE<=MV_PAR07 .AND. E5_SITUACA<>"C" .AND. E5_TIPODOC<>"MT".AND. E5_TIPODOC<>"DC"
          IF E5_TIPODOC $ "ES.EC"      // CANCELAMENTO DE BAIXA - CHEQUE
             _E5VALOR:=(0 - E5_VALOR)
            ELSEIF E5_RECPAG=="P"
             _E5VALOR:=E5_VALOR
          ENDIF

          DBSELECTAREA("SEF")      // VERIFICA SE E CHEQUE AGLUTINADO
          DBSETORDER(4)
          DBSEEK(SM0->M0_CODFIL+SE5->E5_NUMCHEQUE+SE5->E5_BANCO+SE5->E5_AGENCIA)
          IF FOUND() 
             WHILE !EOF() .AND. EF_NUM==SE5->E5_NUMCHEQUE .AND. EF_BANCO==SE5->E5_BANCO .AND. EF_AGENCIA==SE5->E5_AGENCIA
                   IF EF_SEQUENC==SE5->E5_SEQ .AND. EF_IMPRESS=="A"
                      _E5VALOR:=0
                   ENDIF
                   DBSKIP()   
             ENDDO      
          ENDIF

          wNAT:=SE5->E5_NATUREZ
          DBSELECTAREA("SED")
          DBSEEK(xFILIAL()+wNAT)
          IF FOUND()
             IF MV_PAR09==1
                wDESCNAT:=ALLTRIM(wNAT)+"-"+ED_DESCRIC
               ELSE 
                wDESCNAT:=ALLTRIM(wNAT)+"-"+ED_DESC2
             ENDIF   
          ELSE
             wDESCNAT:=wNAT
          ENDIF    

          DBSELECTAREA("SE5")

          IF MV_PAR08==1 .AND. _E5VALOR <> 0
             @ LI,01     PSAY E5_DTDIGIT
             @ LI,12     PSAY LEFT(E5_NUMCHEQUE,6)
             @ LI,19     PSAY LEFT(E5_BENEF,29)+" "+LEFT(SE5->E5_PREFIXO,1)
             @ LI,51     PSAY LEFT(E5_HISTOR,30)
             @ LI,COLVAL PSAY _E5VALOR PICTURE "@E 999,999.99"

             DBSELECTAREA("SD1")                        // BUSCA ITENS DA NOTA REF AO CHEQUE
             DBSEEK(xFilial("SD1")+SE5->E5_NUMERO+SE5->E5_CLIFOR+SE5->E5_LOJA)
             IF FOUND()
                LI:=LI+1
      
                WHILE !EOF() .AND. D1_DOC==SE5->E5_NUMERO .AND. (D1_FORNECE+D1_LOJA)==(SE5->E5_CLIFOR+SE5->E5_LOJA)
                      wNAT:=SD1->D1_APLIC
                      _TOTNF:=0
                      _NUMNF:=D1_DOC
                      WHILE !EOF() .AND. D1_DOC==SE5->E5_NUMERO .AND. (D1_FORNECE+D1_LOJA)==(SE5->E5_CLIFOR+SE5->E5_LOJA) .AND. D1_APLIC==wNAT
                            _TOTNF:=_TOTNF + D1_TOTAL
                            DBSKIP()
                      ENDDO      
                      IF _TOTNF>0
                         DBSELECTAREA("SED")
                         DBSEEK(xFILIAL()+wNAT)
                         IF FOUND()
                            IF MV_PAR09==1
                               wDESCNAT:=ALLTRIM(wNAT)+"-"+ED_DESCRIC
                              ELSE 
                               wDESCNAT:=ALLTRIM(wNAT)+"-"+ED_DESC2
                            ENDIF   
                         ENDIF    
                         DBSELECTAREA("SD1")
                         @ LI,019 PSAY "Nf: "+_NUMNF
                         @ LI,069 PSAY "R$"
                         @ LI,072 PSAY _TOTNF PICTURE "@E 999,999.99"                         
                         @ LI,120 PSAY wDESCNAT
                         LI:=LI + 1
                      ENDIF   
                ENDDO
                DBSELECTAREA("SE5")

             ELSE
                          
                DBSELECTAREA("SE5")
                @ LI,120    PSAY wDESCNAT
                LI:=LI+1
             ENDIF

          ENDIF
          DO CASE
             CASE COL01
                  _TOTC01:=_TOTC01 + _E5VALOR
             CASE COL02
                  _TOTC02:=_TOTC02 + _E5VALOR
             CASE COL03
                  _TOTC03:=_TOTC03 + _E5VALOR
          ENDCASE                 
          __TOT:=__TOT+_E5VALOR
          nTIT:=nTIT+1
       ENDIF    
    ENDIF
	dbSkip()
EndDO

LI:=LI+1
@ LI,083 PSAY "----------"
@ LI,096 PSAY "----------"
@ LI,109 PSAY "----------"
LI:=LI+1
@ LI,019 PSAY ".Totais por Banco "
@ LI,083 PSAY _TOTC01 PICTURE "@E 999,999.99"
@ LI,096 PSAY _TOTC02 PICTURE "@E 999,999.99"
@ LI,109 PSAY _TOTC03 PICTURE "@E 999,999.99"
LI:=LI+2
__TOTG:=(_TOTC01+_TOTC02+_TOTC03)

@ LI,1 PSAY REPLICATE("#",131)
LI:=LI+1
@ LI,107 PSAY __TOTG PICTURE "@E 9,999,999.99"
@ LI,120 PSAY "Total Global."
LI:=LI+1
@ LI,1 PSAY REPLICATE("#",131)
@ LI+2,00 PSAY "END OF REPORT"

Set Device To Screen
Set Filter To

If aReturn[5]==1
	Set Printer To
	dbCommit()
	ourspool(wnrel)
Endif

MS_FLUSH()

RETURN


//*----------
Static Function FA003cabec()
//*----------

 cTamanho := "M"
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
