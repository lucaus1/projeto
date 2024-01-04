#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01

User Function Gpefunc()        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CAREA,NIND,CSTRING,CDESC1,CDESC2,CDESC3")
SetPrvt("TAMANHO,AORD,ARETURN,NOMEPROG,ALINHA,NLASTKEY")
SetPrvt("TITULO,CCANCEL,CPERG,M_PAG,WNREL,CFILDE")
SetPrvt("CFILATE,CCUSTINI,CCUSTFIM,CSITUA,CORDEM,CSALARIO")
SetPrvt("CRELATO,NREG,NTOT,NLIN,CABEC1,WCC")
SetPrvt("WLO,WFERIAS,WTRANSF,TSALARIO,T2,TT2")
SetPrvt("WDSIT,TREG,WT_EXPA,WT_MENS,WT_EST,WT_COOR")
SetPrvt("TT1,T1,WRR,")

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ GPEFUNC  ³ Autor ³ JOSE NORBERTO MACEDO  ³ Data ³ 07.12.00 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Listagem de Funcionarios                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MERCADAO DAS PECAS (QUEBRA POR CCUSTO)                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Exemplo  ³                                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

cArea := Alias()
nInd  := IndexOrd()

cString := "SRA"
cDesc1  := OemToAnsi("Esta rotina ir  imprimir a Rela‡ao de Funcion rios de")
cDesc2  := OemToAnsi("acordo com os parametros definidos pelo usuario.")
cDesc3  := ""
tamanho := "M"
aOrd    := {}
aReturn := { "Zebrado", 1,"Financeiro", 2, 2, 1, "",1 }
nomeprog:= "GPEFUNC"
aLinha  := { }
nLastKey:= 0
Titulo  := "Relacao de Funcionarios - "

cCancel := "***** CANCELADO PELO OPERADOR *****"
cPerg   := "GPEFUN"
m_pag   := 1 

wnrel   :="GPEFUN"

wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,tamanho)

Pergunte(cPerg,.F.)

If nLastKey == 27
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Return
Endif

// INICIALIZA VARIAVEIS DE PARAMETROS (PERGUNTAS)

cFilDe  := mv_par01  // Da Filial
cFilAte := mv_par02  // At‚ Filial
cCustIni:= mv_par03  // Do  C. Custos
cCustFim:= mv_par04  // At‚ C. Custos
cSitua  := mv_par05  // Situacoes
cOrdem  := mv_par06  // 1=Mat  /  2=Alf  /  3=CCustos / 4=Lotacoes
cSalario:= mv_par07  // 1=Imprime Salario  -  2=Nao Imprime Salario
dAdmDE  := mv_par08  // ADMISSAO DE
dAdmATE := mv_par09  // ADMISSAO ATE

DBSELECTAREA("SRC")
DBSETORDER(1)

dbSelectArea("SRA")

DO CASE
   CASE cOrdem == 1
        dbSetOrder(1)
        cRelato := " Por Matricula"
   CASE cOrdem == 2
        dbSetOrder(3)
        cRelato := " Ordem Alfabetica"
   CASE cOrdem == 3
        INDEX ON RA_FILIAL+RA_CC+RA_MAT TO TT
        cRelato := " Por Centro Custos"        
   CASE cOrdem == 4
        DBSETORDER(11)
        cRelato := " Por Lotac/Matric "
ENDCASE

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> RptStatus({|| Execute(RptDetail) })

dbSelectArea( cArea )
DBSETORDER(nIND)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> Function RptDetail
Static Function RptDetail()

Titulo := Titulo + cRelato
nReg   := 1
nTot   := 0
nLin   := 0
m_pag  := 1

cabec1 :="Matric   Nome                                      Funcao                         Admissao    Lotacao               Salario   Categor."     
   //        0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

@ 00,00 psay chr(15)

ImpCabec()

SET FILTER TO RA_CC >= cCustIni .and. RA_CC <= cCustFim .AND. SRA->RA_ADMISSA>=dAdmDE .AND. SRA->RA_ADMISSA<=dAdmATE
dbGoTop()

SetRegua(LastRec()) //Ajusta numero de elementos da regua de relatorios

Store 0 to TREG,TSALARIO,T1,T2,wT_EXPA,wT_MENS,wT_EST,wT_COOR,TT1,TT2

While !Eof()

  IncRegua() //Incrementa a posicao da regua de relatorios
  wCC:=RA_CC
  wLO:=RA_CC
  SI3->(DBSEEK(xFILIAL()+wCC))
  
  IF SRA->RA_SITFOLH $ cSitua
     wFERIAS:=.F.
     SRJ->(dbSeek(xFILIAL()+SRA->RA_CODFUNC))
     IF SRC->(dBSEEK(xFILIAL()+SRA->RA_MAT+"234"))
        wTRANSF:=SRC->RC_VALOR
       ELSE
        wTRANSF:=0
     ENDIF
     IF SRH->(dBSEEK(xFILIAL()+SRA->RA_MAT))
        IF MONTH(SRH->RH_DATAINI)==MONTH(dDATABASE) .AND. YEAR(SRH->RH_DATAINI)==YEAR(dDATABASE)
           wFERIAS:=.T.
        ENDIF
     ENDIF
     
     @ nLin,000 Psay SRA->RA_MAT + "   "+LEFT(SRA->RA_NOME,39)
     @ nLin,051 PSay LEFT(SRJ->RJ_DESC,30)
     @ nLin,082 Psay SRA->RA_ADMISSA
     @ nLin,094 Psay LEFT(SI3->I3_DESC,18)
     If cSalario == 1
        @ nLin,114 Psay SRA->RA_SALARIO Picture "@E 999,999.99"
     Endif
        TSALARIO := TSALARIO + SRA->RA_SALARIO
        T2:=T2+SRA->RA_SALARIO
        TT2:=TT2+SRA->RA_SALARIO
       
     DO CASE
        CASE SRA->RA_SITFOLH==" "
             wDSIT:="Sit Norm"
        CASE SRA->RA_SITFOLH=="F"
             IF wFERIAS
                wDSIT:="Ferias"
               ELSE
                wDSIT:="Sit Norm"
             ENDIF
        CASE SRA->RA_SITFOLH=="D"
             wDSIT:="Demitido"
        CASE SRA->RA_SITFOLH=="T"
             wDSIT:="Transf"
        CASE SRA->RA_SITFOLH=="A"
             wDSIT:="Afast"
     ENDCASE
     wDSIT:=SRA->RA_CATFUNC+"-"+wDSIT
     @ nLIN,126 PSAY wDSIT
     TREG := TREG + 1
     IF SRA->RA_CATFUNC=="S"
              wT_EXPA:=wT_EXPA + 1
         ELSEIF SRA->RA_CATFUNC=="M"
              wT_MENS:=wT_MENS + 1
         ELSEIF SRA->RA_CATFUNC=="E"
              wT_EST :=wT_EST  + 1
         ELSEIF SRA->RA_CATFUNC=="P"
              wT_COOR:=wT_COOR + 1
     ENDIF

     TT1  := TT1  + 1                // TOTAL DA LOTACAO
     T1   := T1   + 1                // TOTAL DO CENTRO DE CUSTO
     
     nLin := nlin + 1

     If nLin>59
        ImpCabec()
     Endif

  ENDIF

  dbSelectArea("SRA")
  dbSkip()

  IncRegua() //Incrementa a posicao da regua de relatorios
  
  
  IF RA_CC<>wCC .AND. cORDEM==3 .AND. T1 > 0
     @ nLIN,010 PSAY REPLICATE("-",114)
     nLIN:=nLIN+1
     @ nLin,010 Psay Alltrim(Str(T1))+" Tot Funcionario(s) do Centro de Custo: "+wCC+"-"+SI3->I3_DESC
     @ nLin,114 Psay T2 Picture "@E 999,999.99"
     nLIN:=nLIN+1
     @ nLIN,010 PSAY REPLICATE("-",114)
     nLIN:=nLIN+2

     T1:=0
     T2:=0
  ENDIF
  
  If nLin>59
     ImpCabec()
  Endif
End

@ nLin,000 psay repl("==",71)
nLin := nLin + 1
IF CSALARIO == 1
   wRR:="       Total de SALARIO CONTRATUAL"
  ELSE
   wRR:="       Total de BASE DE REMUNERACAO"
ENDIF

@ nLin,000 Psay Alltrim(Str(TREG))+" Funcionarios...     "+wRR
@ nLin,114 Psay TSALARIO Picture "@E 999,999.99"
nLIN:=nLIN+2

@ nLIN,005 PSAY "Empregados Mensalistas ......: "+STRZERO(wT_MENS,5)
nLIN:=nLIN+1
@ nLIN,005 PSAY "Empregados Estagiarios ......: "+STRZERO(wT_EST ,5)
nLIN:=nLIN+1
@ nLIN,005 PSAY "Empregados Semanalistas......: "+STRZERO(wT_EXPA,5)
nLIN:=nLIN+1
@ nLIN,005 PSAY "Empregados Coorporativ ......: "+STRZERO(wT_COOR,5)

dbClearFilter()

If aReturn[5] == 1
    Set Printer To
    Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool

DBSELECTAREA("SRA")
DBSETORDER(1)

Return

*****************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 15/02/01 ==> Function ImpCabec
Static Function ImpCabec()

@ 00,00  psay repl("*" ,141)
@ 01,00  psay "* " +sm0->m0_nome
@ 01,120 psay "Folha..:     "+strzero(m_Pag,6)+" *"
@ 02,00 psay "* SIGA/ "+nomeprog
@ 02,(141-len(titulo))/2 psay titulo
@ 02,120 psay "Dt.Ref.: "+ dtoc(dAdmATE)+" *"
@ 03,00 psay "* Hora...: " + time()
@ 03,120 psay "Emissao: " + dtoc(date())+" *" 
@ 04,00 psay repl("*",141)
@ 05,00 psay cabec1
@ 06,00 psay repl("*",141)
m_Pag := m_Pag + 1
nLin := 7
Return
