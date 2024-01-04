#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 15/02/01


**********************
User Function CADSZZ()
**********************
// Funcao: Permite efetuar manutencao no cadastro de Produtos Acabados, usado
//         na inclusao de pedidos de venda, no Faturamento

AxCadastro("SZZ","Cadastro de Prod Acabados",.T.)

RETURN


**********************
User Function NUMREM()
**********************
// Incrementar o numero de remessa (no Header) e numero do pagamento a ser
// enviado ao banco (no Detalhes)
// Criar campos A6_REMES (CHR,5) e A6_NUMPAG (CHR,7)

SetPrvt("_REMESSA,NREG,CIND,CBANCO,CAGENC,CCONTA")
Private _Remessa := ""

DbSelectArea("SA6")
nReg    := Recno()
cInd    := IndexOrd()
cBanco  := "237"
cAgenc  := "08753"
cConta  := "28950-7   "

DbSetOrder(1)
DbSeek(xFilial("SA6")+cBanco+cAgenc+cConta)

Reclock("SA6",.f.)
SA6->A6_REMES  := SOMA1(SA6->A6_REMES,5)
SA6->A6_NUMPAG := SOMA1(SA6->A6_NUMPAG,7)
MSUNLOCK()

_Remessa := SA6->A6_REMES

Dbselectarea("SA6")
DbSetOrder(cInd)
DbGoTo(nReg)
Return(_Remessa)


**********************
User Function NUMPAG()
**********************
// Buscar o numero do pagamento no SA6. Usado no CNAB cartao salario Bradesco

SetPrvt("_NUMPAG,NREG,CIND,CBANCO,CAGENC,CCONTA")
Private _Numpag := ""

DbSelectArea("SA6")
nReg    := Recno()
cInd    := IndexOrd()
cBanco  := "237"
cAgenc  := "08753"
cConta  := "28950-7   "

dbSetOrder(1)
DbSeek(xFilial("SA6")+cBanco+cAgenc+cConta)

_Numpag := SA6->A6_NUMPAG

dbSetOrder(cInd)
DbGoTo(nReg)
Return(_Numpag)

**********************
User Function AC_HOR()
**********************
_QT:=FBUSCAPD("104","H")
IF _QT>SRA->RA_HRSMES
   _QT:=SRA->RA_HRSMES
ENDIF   
aPD[FLOCALIAPD("104"),9]:="D"
FGERAVERBA("104",SRA->RA_SALARIO*_QT,_QT,,,,,,,,.T.)

RETURN

**********************
User Function DC_HOR()
**********************

_QTH:=FBUSCAPD("437","H")
_SAL:=IIF(SRA->RA_CATFUNC=="H",SRA->RA_SALARIO,ROUND((SRA->RA_SALARIO/SRA->RA_HRSMES),2))

IF _QTH >  SRA->RA_HRSMES
   _QTH := SRA->RA_HRSMES
ENDIF   
aPD[FLOCALIAPD("437"),9]:="D"
FGERAVERBA("437",_SAL * _QTH,_QTH,,,,,,,,.T.)

Return
