#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function CON006() 
 
 
/*/
_____________________________________________________________________________
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦Programa  ¦  CON006l ¦ Autor ¦   MACEDO              ¦ Data ¦ 14/02/02 ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Descriçào ¦ DIARIO DE LANCAMENTOS CONTABEIS (RELACAO)                  ¦¦¦
¦¦+----------+------------------------------------------------------------¦¦¦
¦¦¦Uso       ¦ AMASA                                                      ¦¦¦
¦¦+-----------------------------------------------------------------------+¦¦
¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦¦
¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*/

//+--------------------------------------------------------------+
//¦ Define Variaveis Ambientais                                  ¦
//+--------------------------------------------------------------+

CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M" 
aOrd:={ }
limite:=220
titulo :="Relacao dos Lancamentos Contabeis em REAIS"
cDesc1 :=""
cDesc2 :=""
cDesc3 :=PADC("CONF PARAMETRO INFORMADO PELO OPERADOR.",74)
cNatureza:="" 
aReturn := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog:="CON006"
cPerg:="CON001"
nLastKey:= 0 
lContinua := .T.
nLin:=0
wnrel    := "CON006"
m_pag    := 1


cAREA:=ALIAS()
nORD :=IndexOrd()


nTamNf:=72     // Apenas Informativo 



CABEC0:="DATA"
CABEC1:="  Numero            Debito                       Credito                          Valor       Historico"
//+-------------------------------------------------------------------------+
//¦ Verifica as perguntas selecionadas, busca o padrao da Nfiscal           ¦
//+-------------------------------------------------------------------------+

Pergunte(cPerg,.T.)               // Pergunta no SX1

CSTRING:="SI2"


//+--------------------------------------------------------------+
//¦ Envia controle para a funcao SETPRINT                        ¦
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho)

If nLastKey == 27
   DBSELECTAREA(cAREA)
   DBSETORDER(nORD)

   Return
Endif

//+--------------------------------------------------------------+
//¦ Verifica Posicao do Formulario na Impressora                 ¦          
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
   DBSELECTAREA(cAREA)
   DBSETORDER(nORD)

   Return
Endif



#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==>       RptStatus({|| Execute(RptDetail)})      
	Return
    Static Function RptDetail()
#ENDIF

 

//+-----------------------------------------------------------+
//¦ Inicializa  regua de impressao                            ¦
//+-----------------------------------------------------------+
DBSELECTAREA("SI1")
DBSETORDER(1)

DBSELECTAREA("SI2")
DBSETORDER(3)
IF I2_FILIAL=="  "
   _Fil:="  "
  ELSE
   _FIL:=SM0->M0_CODFIL
ENDIF

DBSEEK(_Fil+DTOS(MV_PAR01)+MV_PAR03,.T.)

SETPRC(0,0)
nLIN:=61
SetRegua(RECCOUNT())

// INICIO DA IMPRESSAO



@ 00,00 PSAY CHR(15)     // COMPACTA IMPRESSAO
_TOTDEBG:=0
_TOTCREG:=0
_FILTRO:="SI2->I2_DATA>=MV_PAR01 .AND. SI2->I2_DATA<=MV_PAR02 .AND. LEFT(SI2->I2_NUM,4)>=MV_PAR03 .AND. LEFT(SI2->I2_NUM,4)<=MV_PAR04"

WHILE !EOF() .and. &_FILTRO
   IF nLIN>60
      IMPCABEC()
   ENDIF
   @ nLIN,00 PSAY I2_DATA
   _DATAANT:=I2_DATA
   nLin:=nLin + 1
   _TOTDEB:=0
   _TOTCRE:=0
   WHILE !EOF() .and. &_FILTRO .AND. I2_DATA==_DATAANT
         IF nLIN>60
            IMPCABEC()
         ENDIF
         DBSELECTAREA("SI1")
         DBSEEK(xFilial("SI1")+SI2->I2_DEBITO)
         IF FOUND()
            cDESCD:=I1_DESC
           ELSE
            cDESCD:=""
         ENDIF

         DBSEEK(xFilial("SI1")+SI2->I2_CREDITO)
         IF FOUND()
            cDESCC:=I1_DESC
           ELSE
            cDESCC:=""
         ENDIF

         DBSELECTAREA("SI2")
         @ nLIN,02 PSAY LEFT(I2_NUM,4)+"-"+SUBSTR(I2_NUM,5,6)+"-"+I2_LINHA
         @ nLIN,18 PSAY LEFT(I2_DEBITO,12) +" "+LEFT(cDESCD,15)
         @ nLIN,48 PSAY LEFT(I2_CREDITO,12)+" "+LEFT(cDESCC,15)
         @ nLIN,78 PSAY I2_VALOR PICTURE "@E 9999,999.99"
         @ nLIN,92 PSAY I2_HIST

         nLIN:=nLIN + 1
         IF I2_DC$"DX"
            _TOTDEB:=_TOTDEB+I2_VALOR
         ENDIF
         IF I2_DC$"CX"
            _TOTCRE:=_TOTCRE+I2_VALOR
         ENDIF

         DBSKIP()
         IF I2_DC=="-"
            WHILE I2_DC=="-" .AND. !EOF() .AND. &_FILTRO .AND. I2_DATA==_DATAANT
                  @ nLIN,90 PSAY I2_HIST
                  DBSKIP()
            ENDDO      
         ENDIF
   ENDDO
   nLIN:=nLIN+1
   @ nLIN,00 PSAY "Total Debito no Dia ...... "
   @ nLIN,28 PSAY _TOTDEB PICTURE "@E 9,999,999.99"
   @ nLIN,42 PSAY "Total Credito no Dia ..... "
   @ nLIN,71 PSAY _TOTCRE PICTURE "@E 9,999,999.99"
   _TOTDEBG:=_TOTDEBG + _TOTDEB
   _TOTCREG:=_TOTCREG + _TOTCRE
   nLIN:=nLIN+2
ENDDO
nLIN:=nLIN+1
@ nLIN,00 PSAY "Total Debito no Periodo...:"
@ nLIN,28 PSAY _TOTDEBG PICTURE "@E 9,999,999.99"
@ nLIN,42 PSAY "Total Credito no Periodo..:"
@ nLIN,71 PSAY _TOTCREG PICTURE "@E 9,999,999.99"
nLIN:=nLIN+1
@ nLIN,00 PSAY REPLICATE("-",136)

//+--------------------------------------------------------------+
//¦                                                              ¦
//¦                      FIM DA IMPRESSAO                        ¦
//¦                                                              ¦
//+--------------------------------------------------------------+


Set Device To Screen

If aReturn[5] == 1
   Set Printer TO
   dbcommitAll()
   ourspool(wnrel)
Endif

MS_FLUSH()


DBSELECTAREA(cAREA)
DBSETORDER(nORD)

RETURN

//+--------------------------------------------------------------+
//¦ Fim do Programa                                              ¦
//+--------------------------------------------------------------+
 

*****************************************************************************

Static Function ImpCabec()

@ 00,00  psay repl("*" ,136)
@ 01,00  psay "* " +sm0->m0_nome
@ 01,117 psay "Folha..:   "+strzero(m_Pag,6)+" *"
@ 02,00 psay "* SIGA/ "+nomeprog
@ 02,(136-len(titulo))/2 psay titulo
@ 02,117 psay "Dt.Ref.: "+ dtoc(MV_PAR01)+" *"
@ 03,00 psay "* Hora...: " + time()
@ 03,117 psay "Emissao: " + dtoc(date())+" *" 
@ 04,00 psay repl("*",136)
@ 05,00 PSAY CABEC0
@ 06,00 psay cabec1
@ 07,00 psay repl("-",136)
m_Pag := m_Pag + 1
nLin := 8
Return


