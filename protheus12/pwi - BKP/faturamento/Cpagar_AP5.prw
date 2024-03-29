#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 18/12/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function Cpagar()        // incluido pelo assistente de conversao do AP5 IDE em 18/12/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CAREA,NREC,CIND,TAMANHO,LIMITE,TITULO")
SetPrvt("CDESC1,CDESC2,CDESC3,ARETURN,LIMPRANT,ALINHA")
SetPrvt("CPERG,NOMEPROG,NLASTKEY,IMPRIME,CSAVSCR1,CSAVCUR1")
SetPrvt("CSAVROW1,CSAVCOL1,CSAVCOR1,CBTXT,CBCONT,CSTRING")
SetPrvt("LI,M_PAG,AORD,WNREL,TREGS,M_MULT")
SetPrvt("NTOTREGS,NMULT,NPOSANT,NPOSATU,NPOSCNT,CSAV20")
SetPrvt("CSAV7,P_ANT,P_ATU,P_CNT,M_SAV20,M_SAV7")
SetPrvt("MCONTPAG,MCONTLIN,MVL_TOT1,MVL_DIA1,MVL_TITU,MVL_MES")
SetPrvt("MJUR_MES,MQT_MES,MMES_ANT,MMES_ATU,MVENCIDOS,MT_VENCID")
SetPrvt("MT_QTVENC,MVENC_JUR,MAVENCER,MT_AVENC,MT_QTAVEN,MJUR_AVEN")
SetPrvt("MTOTTITU,MQT_VENC,MQT_AVEN,MDESDIA,MDESTOT,MDESMES")
SetPrvt("CNUMDE,CNUMATE,CNATDE,CNATATE,DVENCDE,DVENCATE")
SetPrvt("CPORTDE,CPORTATE,CFORNDE,CFORNATE,DEMISDE,DEMISATE")
SetPrvt("DBAIXAINI,DBAIXAFIM,CVAR_TIPOREL,CTIPO,CANASIN,VRELAT")
SetPrvt("NSEDORD,NSA6ORD,NSA2ORD,NSE2ORD,ASTRU,CARQTEMP")
SetPrvt("CORD,LATE,MKEY,CDESCTOT,DPES,CONDTIPO")
SetPrvt("MFILTRO,CARQTEMP2,MTEMREG,CCABEC1,CCABEC2,CFORNECE")
SetPrvt("VCUSTO,CNOMFOR,CNATUREZ,VCC,CNOMNAT,CNUMERO")
SetPrvt("DVENCTO,CPORTADO,CNOMPORT,DEMISSAO,DBAIXA,MMESATU")
SetPrvt("MMESANT,CVALOR,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 18/12/01 ==> 	#DEFINE PSAY SAY
#ENDIF

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컫컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � CPAGAR  쿌utor� Ionai Morais do Carmo    � Data � 13.05.98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컨컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Relatorio de Titulos a Pagar  (80 Colunas)                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Interpretador xBase                                        낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/    
SET SOFTSEEK ON

cArea   := Alias()
nRec    := Recno()
cInd    := IndexOrd()
tamanho :=' '
limite  :=132
titulo  :="EMISSAO DE TITULOS A PAGAR/PAGOS/AMBOS"
cDesc1  :=OemToAnsi('Emissao dos titulos a pagar/pagos, conforme parametros definidos pelo usuario')
cDesc2  :=OemToAnsi('Impressao em formulario de 80 colunas.')
cDesc3  :=' '
aReturn := { 'Zebrado', 1,'Financeiro ', 1, 2, 1,'',1 }
lImprAnt:= .F.
aLinha  := { }
cPerg   := 'CPAGAR'
nomeprog:= 'CPAGAR'
nLastKey:= 0
imprime := .T.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Salva a Integridade dos dados de Entrada                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

cSavCur1 := SetCursor(0)
cSavCor1 := SetColor('bg+/b,,,')

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Vari쟶eis utilizadas para Impress꼘 do Cabe놹lho e Rodap�    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

cbtxt    := SPACE(10)
cbcont   := 0
cString  := 'SE2'
li       := 15
m_pag    := 1
aOrd     := {' Por Fornecedor',' Por Natureza',' Por C.Custos',;
             ' Por Vencimento',' Por Portador',' Por Emissao',' Por Baixa '}
wnrel    := 'CPAGAR'   // nome default do relatorio em disco

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

Pergunte ('CPAGAR', .T.)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Ajuste dos par긩etros da impress꼘 via fun뇙o SETPRINT       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

set cursor off
wnrel:= 'CPAGAR'
wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd)

If LastKey() == 27 .Or. nLastKey == 27
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Aceita par긩etros e faz ajustes necess쟲ios                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetDefault(aReturn,cString)

If LastKey() == 27 .or. nLastKey == 27
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣ari쟶eis utilizadas na barra de status                   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

dbSelectArea('SE2')
tregs := reccount()
m_mult := 1

nTotregs := 0 //-- Regua.
nMult    := 0
nPosAnt  := 0
nPosAtu  := 0
nPosCnt  := 0
cSav20   := ''
cSav7    := ''

Tamanho := 'P'
Limite  := 80

IF tregs > 0
   m_mult := 70/tregs
ENDIF

p_ant := 4
p_atu := 4
p_cnt := 0
*m_sav20 := dcursor(3)

mContPag := 0
mContLin := 61
mvl_tot1 := 0
mvl_dia1 := 0
mvl_titu := 0
mVl_Mes  := 0
mJur_Mes := 0
mQt_Mes  := 0
mMes_Ant := ''
mMes_Atu := ''
mVencidos:= 0               // Valor Total dos Titulos Vencidos
mT_Vencid:= 0
mT_QtVenc:= 0
mVenc_Jur:= 0               // Valor Total de Juros dos Titulos Vencidos
mAVencer := 0               // Valor Total dos Titulos A Vencer
mT_AVenc := 0
mT_QtAven:= 0
mJur_AVen:= 0               // Valor Total de Juros dos Titulos a Vencer
mTotTitu := 0               // Quant. Total de Titulos Emitidos
mQt_Venc := 0               // Quant. total de titulos Vencidos
mQt_Aven := 0               // Quant. total de titulos a Vencer
mDesDia:=mDesTot:=mDesMes:=0

cNumDe      := mv_par01
cNumAte     := mv_par02
cNatDe      := mv_par03
cNatAte     := mv_par04
dVencDe     := mv_par05
dVencAte    := mv_par06
cPortDe     := mv_par07
cPortAte    := mv_par08
cFornDe     := mv_par09
cFornAte    := mv_par10
dEmisDe     := mv_par11
dEmisAte    := mv_par12
dBaixaIni   := mv_par13
dBaixaFim   := mv_par14
cVar_TipoRel:= mv_par15
cTipo       := mv_par16

cAnaSin     := iif(cVar_TipoRel==1,'Analitico','Sintetico')
vRelat      := iif(cTipo==1,'A PAGAR','PAGOS')

dbSelectArea('SED')
nSEDOrd := IndexOrd()
dbSetOrder(1)
dbSelectArea('SA6')
nSA6Ord := IndexOrd()
dbSetOrder(1)
dbSelectArea('SA2')
nSA2Ord := IndexOrd()
dbSetOrder(1)
dbSelectArea('SE2')
nSe2Ord := IndexOrd()

// Estrutura do Arquivo Temporario

aStru := {}
aadd(aStru , {'Doc','C',6,0} )
aadd(aStru , {'Portado','C',3,0} )  
aadd(aStru , {'Naturez','C',10,0} )
aadd(aStru , {'CCusto','C',9,0} )
aadd(aStru , {'Parcela','C',1,0} )
aadd(aStru , {'Fornece','C',6,0} )
aadd(aStru , {'Emissao','D',8,0} )
aadd(aStru , {'Vencto','D',8,0} )
aadd(aStru , {'Baixa','D',8,0} )
aadd(aStru , {'Valor','N',17,2} )
aadd(aStru , {'Perman','N',4,0} )
aadd(aStru , {'Hist','C',25,0} )
cArqTemp := CriaTrab(aStru , .t.)

dbUseArea(.T.,,cArqTemp,'TMP',.f.)

Set Device to Screen
set color to N/BG
dbSelectArea('SE2')

cOrd := ' '
lAte := '.t.'

DO CASE
   Case aReturn[8] == 1            // Fornecedor
        dbSetOrder(6)
        dbSeek(xFilial()+cFornDe)
        mKey := 'cFornece==FORNECE'
        cDescTot := 'LEFT(cNomFor,27)'
        cOrd := '(por Fornecedor)'
        lAte := '!eof() .and. SE2->E2_FORNECE<=cFornAte'
   Case aReturn[8] == 2            // Natureza 
        dbSetOrder(2)
        dbSeek(xFilial()+cNatDe)
        mKey := 'cNaturez==NATUREZ'
        cDescTot := 'cNaturez + cNomNat'
        cOrd := '(por Natureza)'
        lAte := '!eof() .and. SE2->E2_NATUREZ<=cNatAte'
   Case aReturn[8] == 3               // Por Numero
        dbSetOrder(7)
        dbSeek(xFilial()+cNumDe)
        mKey := 'vCusto==CCUSTO'
        cDescTot := 'vCusto'
        cOrd := '(por C.Custo)'
        lAte := '!eof() .and. SE2->E2_CC<=cNumAte'
   Case aReturn[8] == 4            // Vencimento
        dbSetOrder(3)
        dPes := dVencDe - 5
        dbSeek(xFilial()+dTos(dPes))
        mKey := 'dVencto==VENCTO'
        cDescTot := 'DToC(dVencto)'
        cOrd := '(por Vencimento)'
        lAte := '!eof() .and. SE2->E2_VENCTO<=dVencAte+5'
   Case aReturn[8] == 5           // Por Portador
        dbSetOrder(4)
        dbSeek(xFilial()+cPortDe)
        mKey := 'cPortado==PORTADO'
        cDescTot := 'cPortado + '-' + cNomPort'
        cOrd := '(por Portador)'
        lAte := '!eof() .and. SE2->E2_PORTADO<=cPortAte'
   Case aReturn[8] == 6            // Emissao
        dbSetOrder(5)
        dbSeek(xFilial()+dTos(dEmisDe))
        mKey := 'dEmissao==EMISSAO'
        cDescTot := 'DToC(dEmissao)'
        cOrd := '(por Emissao)'
        lAte := '!eof() .and. SE2->E2_EMIS1<=dEmisAte'
   Case aReturn[8] == 7            // Baixa
        dbSetOrder(5)
        dbSeek(xFilial()+dTos(dBaixaIni))
        mKey := 'dBaixa==Baixa'
        cDescTot := 'DTOC(dBaixa)'
        cOrd := '(por Baixa)'
        lAte := '!eof() .and. SE2->E2_BAIXA<=dBaixaFim'
ENDCASE

DO CASE
   CASE cTipo == 1
        CondTipo := 'E2_SALDO > 0'
        vRelat   := 'A PAGAR'
   CASE cTipo == 2
        CondTipo := '!Empty(E2_BAIXA)'  
        vRelat   := 'PAGOS'
   CASE cTipo == 3
        CondTipo := 'E2_BAIXA >= cTod("  /  /  ")'
        vRelat   := 'GERAL'
ENDCASE  

mFiltro := ;
      'cNumDe <= E2_CC      .and. cNumAte >= E2_CC .and. ' + ;
      'cNatDe <= E2_NATUREZ .and. cNatAte >= E2_NATUREZ .and. ' + ;
      'dVencDe<= E2_VENCTO  .and. dVencAte>= E2_VENCTO .and.  ' + ;
      'cPortDe<= E2_PORTADO .and. cPortAte>= E2_PORTADO .and. ' + ;
      'cFornDe<= E2_FORNECE .and. cFornAte>= E2_FORNECE .and. ' + ;
      'dEmisDe<= E2_EMISSAO .and. dEmisAte>= E2_EMISSAO .and. ' + ;
      'dBaixaIni<= E2_BAIXA .and. dBaixaFim>= E2_BAIXA .and. ' + CondTipo

While &lAte

   If &mFiltro
      dbSelectArea('TMP')
      RecLock('TMP',.t.)
      Repl Doc     with se2->e2_num
      Repl Parcela with se2->e2_parcela
      Repl Portado with se2->e2_portado
      Repl CCusto  with se2->e2_cc
      Repl Naturez with se2->e2_naturez
      Repl Fornece with se2->e2_fornece
      Repl Emissao with se2->e2_emis1
      Repl Vencto  with se2->e2_vencto
      Repl Baixa   with se2->e2_baixa
      QualValor()
      Repl Valor   with se2->e2_valor
      Repl Perman  with iif(dDataBase>se2->e2_vencto,dDataBase-se2->e2_vencto,0)
      Repl Hist    with se2->e2_hist
      If cTipo == 3 .and. !EMPTY(SE2->E2_BAIXA) .and. SE2->E2_SALDO > 0
         RecLock('TMP',.t.)
         Repl Doc     with SE2->E2_num
         Repl Parcela with SE2->E2_parcela
         Repl Portado with SE2->E2_portado
         Repl Naturez with SE2->E2_naturez
         Repl Cliente with SE2->E2_Cliente
         Repl Emissao with SE2->E2_emis1
         Repl Vencto  with SE2->E2_vencto
         Repl Baixa   with ctod("  /  /  ")
         Repl Valor   with SE2->E2_Saldo
         Repl Perman  with iif(dDataBase>SE2->E2_vencto,dDataBase-SE2->E2_vencto,0)
         Repl Hist    with SE2->E2_hist
      Endif

      dbUnLock()

   Endif
   dbSelectArea('SE2')
   dbSkip()
End

dbSelectArea('TMP')

DO CASE
   Case aReturn[8] == 1            // Fornecedor
        Index on Fornece+dtos(Vencto) to (cArqTemp)
   Case aReturn[8] == 2            // Natureza 
        Index on Naturez+Fornece+dtos(Vencto) to (cArqTemp)
   Case aReturn[8] == 3            // Por Numero
        Index on CCusto+Parcela+dtos(Vencto)+dtos(Emissao) to (cArqTemp)
   Case aReturn[8] == 4            // Vencimento
        Index on dtos(Vencto)+Fornece+Doc to (cArqTemp)
   Case aReturn[8] == 5            // Por Portador
        Index on Portado+dtos(Vencto) to (cArqTemp)
   Case aReturn[8] == 6            // Emissao
        Index on dtos(Emissao)+Fornece+Doc+Parcela to (cArqTemp)
   Case aReturn[8] == 7            // Baixa
        Index on dtos(Baixa)+Fornece+Doc+Parcela to (cArqTemp)
ENDCASE

set device to print
@ 0,0 PSAY Chr(15)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Impress꼘 dos dados                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

If nLastKey == 27
   Return Nil
Endif

#IFDEF WINDOWS
   RptStatus({|| ImpRel()})  //-- Chamada do Relatorio.// Substituido pelo assistente de conversao do AP5 IDE em 18/12/01 ==>    RptStatus({|| Execute(ImpRel)})  //-- Chamada do Relatorio.
#ENDIF

dbSelectArea('TMP')
dbCloseArea ()
cArqTemp2 := cArqTemp + '.DBF'
Delete File &cArqTemp2
cArqTemp2 := cArqTemp + '.NTX'
Delete File &cArqTemp2

dbSelectArea('SED')
dbSetOrder(nSEDOrd)
dbSelectArea('SA6')
dbSetOrder(nSA6Ord)
dbSelectArea('SA2')
dbSetOrder(nSA2Ord)
dbSelectArea('SE2')
dbSetOrder(nSE2Ord)

dbSelectArea(cArea)
dbSetOrder(cInd)
dbGoto(nRec)

SET SOFTSEEK OFF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Impress꼘 do rodap�                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
IF li != 80
   roda(cbcont,cbtxt,'M')
EndIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Restaura Tela e Set's                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Set Device To Screen


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Se impress꼘 em Disco, chama SPOOL                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

#IFNDEF WINDOWS
   Set Device To Screen
#ENDIF

If aReturn[5] == 1
   Set Printer TO 
   Commit
   ourspool(wnrel)
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Libera relat줿io para Spool da Rede               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

MS_FLUSH()


******************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 18/12/01 ==> Function ImpRel
Static Function ImpRel()

dbSelectArea('TMP')
dbgotop()

mtemreg := .f.

If cVar_TipoRel == 1
   cCabec1 := 'Titulo/P   Fornecedor                 Portador         Emissao    Vencimen    Baixa      Valor R$   Historico'
  Else
   cCabec1 := 'Totalizadores                                                                Vencidos               A Vencer       Valor Original' 
Endif

*              999999/9   9999-XXXXXXXXXXXXXXXXXXXXXX XXXXXXXXXX     99/99/99    99/99/99   99/99/99  99,999.99   XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX                                 
*           0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                     1         2         3         4         5         6         7         8         9         0         1         2         3  
cCabec2 := ' '

Titulo  :='RELATORIO DE TITULOS '+vRelat
Titulo  := Titulo + ' ' + cOrd + ' - ' + cAnaSin
mtemreg := .t.

SetRegua(RecCount()) //-- Total de elementos da regua.

While !eof()

   cFornece := FORNECE
   vCusto   := CCUSTO
   SA2->(dbSeek(xFilial()+cFornece))
   cNomFor  := LEFT(SA2->A2_NREDUZ,25)
   cNaturez := NATUREZ
   SI3->(dbSeek(xFilial()+vCusto))
   vCC      := SI3->I3_DESC
   SED->(dbSeek(xFilial()+cNaturez))
   cNomNat  := SED->ED_DESC2
   cNumero  := DOC
   dVencto  := VENCTO
   cPortado := PORTADO
   IF cPORTADO<>"   "
      SA6->(dbSeek(xFilial()+cPortado))
      cNomPort := LEFT(SA6->A6_NREDUZ,20)
     ELSE
      cNomPort := " "
   ENDIF

   dEmissao := EMISSAO
   dBaixa   := BAIXA

   While !eof() .and. &mKey 

      IncRegua()  //-- Move a regua.

      cFornece := FORNECE
      vCusto   := CCUSTO
      SA2->(dbSeek(xFilial()+cFornece))
      cNomFor  := LEFT(SA2->A2_NREDUZ,25)
      cNaturez := NATUREZ
      SI3->(dbSeek(xFilial()+vCusto))
      vCC      := SI3->I3_DESC
      SED->(dbSeek(xFilial()+cNaturez))
      cNomNat  := SED->ED_DESC2
      cNumero  := DOC
      dVencto  := VENCTO 
      cPortado := PORTADO
      IF CPORTADO<>"   "
         SA6->(dbSeek(xFilial()+cPortado))
         cNomPort := LEFT(SA6->A6_NREDUZ,20)
         ELSE
         cNomPort := " "
      ENDIF
      dEmissao := EMISSAO
      dBaixa   := BAIXA

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Atualiza barra de Status                         �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   
      p_cnt := p_cnt + 1
      p_atu := 3 + int(p_cnt*m_mult)
   
      IF p_atu >= p_ant
         p_ant := p_atu
      Endif

      if mContLin > 60
         ImpCabc()
         mContLin := 8
      endif   

      mtemreg := .t.
      If cVar_TipoRel == 1
         @ mContLin,00 PSAY Doc+'/'+Parcela
         @ mContLin,11 PSAY Alltrim(Fornece)+' '+Substr(cNomFor,1,21)
         @ mContLin,40 PSAY Left(cNomPort,14)
         @ mContLin,55 PSAY Emissao
         @ mContLin,66 PSAY Vencto
         @ mContLin,77 PSAY Baixa
         @ mContLin,84 PSAY Valor  picture '@E 99,999,999.99'
         @ mContLin,100 PSAY Subs(Hist,1,28)
*         @ mContLin,124 PSAY Perman picture '9999'
         mContLin := mContLin+1
      Endif
      mVencidos:= mVencidos+ iif(Vencto<dDataBase,VALOR,0) // Valor Vencidos
      mQt_Venc := mQt_Venc + iif(Vencto<dDataBase,1,0)     // Quant Vencidos
      mT_Vencid:= mT_Vencid + iif(Vencto<dDataBase,VALOR,0) // Tot.Vencid.
      mT_QtVenc:= mT_QtVenc+ iif(Vencto<dDataBase,1,0)      // Qt Tot Vencid
      mvl_tot1 := mvl_tot1 + VALOR                         // Tot Vlr Original
      mvl_dia1 := mvl_dia1 + VALOR                         // Vlr Original
      mvl_titu := mvl_titu + 1                             // Qt Titulos
      mVl_Mes  := mVl_Mes  + VALOR                         // Vl Orig. Mes
      mQt_Mes  := mQt_Mes  + 1                             // Qt Titu Mes
      mTotTitu := mTotTitu + 1                             // Qt tot Titulos
      mMesAtu := month(iif(aReturn[8]==4,VENCTO,EMISSAO))
      DbSkip()
   Enddo

   mMesAnt := month(iif(aReturn[8]==4,VENCTO,EMISSAO))

   If mvl_dia1 <> 0
      If cVar_TipoRel == 1
          @ mContLin,000 PSAY repl('-',129)
          mContLin := mContLin + 1       
      Endif
      @ mContLin,000 PSAY 'Total: ' + IIF(aReturn[8]==3,Alltrim(vCusto)+' - '+vCC,&cDescTot)
      IF cVar_TipoRel == 1
         @ mContLin,84 PSAY Transform(mvl_dia1,'@E 99,999,999.99')
         @ mContlin,99 PSAY '( ' +  Alltrim(Str(mvl_titu)) + ' Titulo'+IF(mvl_titu>1,'s )',' )')
       Else
          @ mContLin,116 PSAY Transform(mvl_dia1,'@E 99,999,999.99')
      ENDIF
      mAVencer := mVl_dia1 - mVencidos
      mQt_Aven := mvl_titu - mQt_Venc 
      If cVar_TipoRel == 2
*         mContLin := mContLin + 1
      Endif
  

      If cVar_TipoRel == 1 
         mContLin := mContLin + 1       
         @ mContLin,000 PSAY repl('-',129)
      Endif
      mAVencer := 0
      mVencidos:= 0
      mQt_AVen := 0
      mQt_Venc := 0
      mvl_titu := 0
      mvl_dia1 := 0
      mdesdia  :=0
      mContLin := mContLin + 2
   Endif

   If (aReturn[8] == 4 .or. aReturn[8] == 6) .AND. mMesAnt #mMesAtu
      @ mContLin,000 PSAY ' *** Total no Mes ' + strzero(mMesAtu,2)
      @ mContlin,99 PSAY '( ' + Alltrim(Str(mQt_Mes)) + ' Titulos )'

      If cVar_TipoRel == 1
         @ mContLin,84 PSAY mVl_Mes  picture '@E 99,999,999.99'
       Else
         @ mContLin,116 PSAY mVl_Mes  picture '@E 99,999,999.99'               
      Endif
      
      mVl_Mes  := 0
      mJur_Mes := 0
      mQt_Mes  := 0
      mMesAtu  := month(iif(aReturn[8]==4,VENCTO,EMISSAO))
      mMesAnt  := month(iif(aReturn[8]==4,VENCTO,EMISSAO))
      mContLin := mContLin + 1
      @ mContLin,000 PSAY repl('-',129)
      mContLin := mContLin + 1
   Endif
  
enddo      

if mtemreg 
   *  mContLin := mContLin + 1      
      @ mContLin,000 PSAY ' *** Total Geral'
      If cVar_TipoRel == 1
         @ mContLin,84 PSAY Transform(mvl_tot1,'@E 99,999,999.99')
       Else
         @ mContLin,116 PSAY Transform(mvl_tot1,'@E 99,999,999.99')
      Endif      
      mContLin := mContLin + 1
      @ mContLin,000 PSAY repl('-',129)
      mContLin := mContLin + 1
      
      IF cTipo == 1
         @ mContLin,000 PSAY 'Total Geral de Titulos Vencidos ('+strzero(mT_QtVenc,5)+')'
         If cVar_TipoRel == 1
            @ mContLin,84 PSAY mT_Vencid picture '@EZ 99,999,999.99'
           Else
            @ mContLin,116 PSAY mT_Vencid picture '@EZ 99,999,999.99'
         Endif
         mContLin := mContLin + 1
         mT_QtAven:= mTotTitu - mT_QtVenc
         mT_AVenc := mvl_tot1 - mT_Vencid
         @ mContLin,000 PSAY 'Total Geral de Titulos A Vencer ('+strzero(mT_QtAven,5)+')'
         If cVar_TipoRel == 1
            @ mContLin,84 PSAY mT_AVenc picture '@E 99,999,999.99'
           Else
            @ mContLin,116 PSAY mT_AVenc picture '@E 99,999,999.99'    
         Endif
         mContLin := mContLin + 1
         @ mContLin,000 PSAY repl('-',129)

      ENDIF
endif   

***************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 18/12/01 ==> Function ImpCabc
Static Function ImpCabc()

      @ 01,000 PSAY REPL("*",129)
      @ 02,000 PSAY "* "+SM0->M0_NOMECOM
      @ 02,110 PSAY "Folha..: " + strzero(m_pag,8) + " *"
      @ 03,000 PSAY "* SIGA/CPAGAR - " + cVersao
      @ 03,(129-len(titulo))/2 PSAY Titulo
      @ 03,110 PSAY "Dt.Ref.: " + dtoc(dDataBase) + " *"
      @ 04,000 PSAY "* Hora...: " + Time()
      @ 04,110 PSAY "Emissao: " + dtoc(Date()) + " *"
      @ 05,000 PSAY repl("*",129)
      @ 06,000 PSAY cCabec1
      @ 07,000 PSAY repl("-",129)
      m_pag := m_pag + 1

***************************************************************************


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 18/12/01

// Substituido pelo assistente de conversao do AP5 IDE em 18/12/01 ==> Function QualValor
Static Function QualValor()

Do Case
   Case cTipo == 1 
        cValor := SE2->E2_SALDO
   Case cTipo == 2
        cValor := SE2->E2_VALOR - SE2->E2_SALDO
   Case cTipo == 3
        If SE2->E2_VALOR == SE2->E2_SALDO
           cValor := SE2->E2_SALDO
          Else
           cValor := SE2->E2_VALOR - SE2->E2_SALDO
        Endif
Endcase

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 18/12/01

