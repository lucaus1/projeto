#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
#IFNDEF WINDOWS
	#DEFINE PSAY SAY 
#ENDIF
 
User Function fin003()        // incluido pelo assistente de conversao do AP5 IDE em 08/06/00
 
SetPrvt("CDESC1,CDESC2,CDESC3,CSTRING,CFILIAL,NCHAR")
SetPrvt("CSAVCOR,TITULO,ARETURN,NOMEPROG,NLASTKEY,CPERG")
SetPrvt("LI,WNREL,CEXTENSO,NCONTADOR,NTIPO,MV_PAR01")
SetPrvt("MV_PAR02,MV_PAR03,LEND,CDOCTO,J")
SetPrvt("NREC,NFIRST,LAGLUT,CTAMANHO,ADRIVER,AA")


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FIN003   ³ Autor ³ MACEDO                ³ Data ³ 14.09.01 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ RELACAO DE BAIXAS POR BANCO                                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FIN003(void)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³  Uso     ³ MODULO FINANCEIRO SE5/SEF                                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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
 nomeprog:="FIN003"
 nLastKey:= 0
 cPerg    :="FIN003"
 li       :=1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte("FIN003",.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01                    // Codigo Do Banco               ³
//³ mv_par02                    // Da Agencia                    ³
//³ mv_par03                    // Da Conta                      ³
//³ mv_par04                    // EMISSAO DE                    ³
//³ mv_par05                    // EMISSAO ATE                   ³
//³ MV_PAR08                    // 1- ANALITICO ou 2-SINTETICO   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "FIN003"            //Nome Default do relatorio em Disco
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
	RptStatus({|| FA003Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==> 	RptStatus({|| Execute(FA003Imp)})
#ELSE
	FA003Imp(.f.,Wnrel,cString)
#ENDIF
Return

**************************
Static Function FA003Imp()
**************************

nTipo   :=IIF(aReturn[4]==1,15,18)


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se existe oS BancoS SOLICITADOS                                                                                   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SA6")
dbSeek(xFilial()+mv_par01)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
//DESCBAN01:=LEFT(A6_NREDUZ,10)
DESCBAN01:=SUBSTR(A6_NOME,1,10)

dbSeek(xFilial()+mv_par02)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
//DESCBAN02:=LEFT(A6_NREDUZ,10)
DESCBAN02:=SUBSTR(A6_NOME,1,10)

dbSeek(xFilial()+mv_par03)
IF !Found()
	Set Device To Screen
	Help(" ",1,"BCONOEXIST")
	Return
EndIF
//DESCBAN03:=LEFT(A6_NREDUZ,10)
DESCBAN03:=SUBSTR(A6_NOME,1,10)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Localiza o 1.Cheque a ser impresso                                                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SE5")
DBSETORDER(4)

DBGOTOP()

SetRegua(RecCount())

FA003Cabec(nTipo)

wNAT:=E5_NATUREZ
DBSELECTAREA("SED")
DBSEEK(xFILIAL()+wNAT)
IF FOUND()
   IF MV_PAR09==1
      wDESCNAT:=ED_DESCRIC
     ELSE 
      wDESCNAT:=ED_DESC2
   ENDIF   
ELSE
//   wDESCNAT:="** not found in SED **"
   wDESCNAT:=wNAT
ENDIF    
dbSelectArea("SE5")

__TOT:=0
__TOTG:=0
_TOTC01:=0
_TOTC02:=0
_TOTC03:=0
nTIT:=0
LI:=56
While !Eof()
	#IFNDEF WINDOWS
	   Inkey()
		If LastKey()==K_ALT_A
			lEnd := .t.
		End
	#ENDIF

	IF LI>55 
           @ 00,000 PSAY REPLICATE("*",132)
           @ 01,000 PSAY "* "+SM0->M0_NOMECOM
           @ 01,131 PSAY "*"
           @ 02,000 PSAY "* "+SM0->M0_FILIAL
           @ 02,045 PSAY "Relacao de Baixas por Banco"
           @ 02,110 PSAY "Emissao : "+DTOC(dDATABASE)
           @ 02,131 PSAY "*"
           @ 03,000 PSAY "* Fin003"
           @ 03,035 PSAY "       Periodo de "+DTOC(MV_PAR04)+" ate "+DTOC(MV_PAR05)
           @ 03,131 PSAY "*"
           @ 04,000 PSAY REPLICATE("*",132)
           @ 05,000 PSAY " Data       Num Ch Beneficiario                    Historico                        "+MV_PAR01+"          "+MV_PAR02+"          "+MV_PAR03+"       Natureza"
           @ 06,000 PSAY "                                                                                    "+DESCBAN01+"   "+DESCBAN02+"   "+DESCBAN03
           @ 07,000 PSAY REPLICATE("*",132)
           LI:=8
        ENDIF

	If lEnd
		@Prow()+1,1 PSAY "Cancelado pelo operador"
		Exit
	EndIF

	IncRegua()
  	dbSelectArea("SE5")
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
    
    IF E5_DATA >= MV_PAR04 .AND. E5_DATA <=MV_PAR05 .AND. lCONT_E5VALOR =0
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
          DBSELECTAREA("SE5")

          IF MV_PAR08==1 .AND. _E5VALOR <> 0 
             @ LI,01     PSAY E5_DATA
             @ LI,12     PSAY LEFT(E5_NUMCHEQUE,6)
             @ LI,19     PSAY LEFT(E5_BENEF,30)
             @ LI,51     PSAY LEFT(E5_HISTOR,30)
             @ LI,COLVAL PSAY _E5VALOR PICTURE "@E 999,999.99"
             @ LI,120    PSAY wDESCNAT
             LI:=LI+1
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
    IF E5_NATUREZ<>wNAT .AND. __TOT > 0 .OR. EOF()
//          IF MV_PAR08==1
//             @ LI,083 PSAY "----------"
//             @ LI,096 PSAY "----------"
//             @ LI,109 PSAY "----------"
//             LI:=LI+1
//             @ LI,083 PSAY _TOTC01 PICTURE "@E 999,999.99"
//             @ LI,096 PSAY _TOTC02 PICTURE "@E 999,999.99"
//             @ LI,109 PSAY _TOTC03 PICTURE "@E 999,999.99"

//             LI:=LI+1              
//             @ LI, 95 PSAY ". Sub-Total"
//             @ LI,107 PSAY __TOT PICTURE "@E 9,999,999.99"       
//             @ LI,120 PSAY wDESCNAT                                
//             LI:=LI+1
//             @ LI, 95 PSAY "--------------------------------------"
//            ELSE
//             @ LI,083 PSAY _TOTC01 PICTURE "@E 999,999.99"
//             @ LI,096 PSAY _TOTC02 PICTURE "@E 999,999.99"
//             @ LI,109 PSAY _TOTC03 PICTURE "@E 999,999.99"
//             LI:=LI+1              
//             @ LI,001 PSAY ". Sub-Total "+wDESCNAT
//             @ LI,107 PSAY __TOT PICTURE "@E 9,999,999.99"       
//             LI:=LI+1
//             @ LI, 87 PSAY "-----------------------------------------------"

//          ENDIF   


          __TOTG:=__TOTG+__TOT
          __TOT:=0
          nTIT:=0
          LI:=LI+1
          wNAT:=E5_NATUREZ
          DBSELECTAREA("SED")
          DBSEEK(xFILIAL()+wNAT)
          IF FOUND()
             IF MV_PAR09==1
                wDESCNAT:=ED_DESCRIC
               ELSE 
                wDESCNAT:=ED_DESC2
             ENDIF   
            ELSE
             wDESCNAT:="** not found in SED **"
          ENDIF    
          dbSelectArea("SE5")
//          _TOTC01:=0
//          _TOTC02:=0
//          _TOTC03:=0
    ENDIF
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
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³FA003Cabec³ Autor ³ Alessandro B. Freire  ³ Data ³ 18.12.96 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina de leitura do driver correto de impressao           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ FA003cabec(nchar)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ nChar . 15-Comprimido , 18-Normal                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FIN003                                                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 08/06/00 ==>  Function FA003cabec
Static Function FA003cabec()

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
