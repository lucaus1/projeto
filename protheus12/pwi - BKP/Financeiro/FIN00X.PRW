#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/11/99
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF
User Function FIN00X()

/*/
____________________________________________________________________________
�����������������������������������������������������������������������������
��+-----------------------------------------------------------------------+��
���Programa  �  FIN00Xl � Autor �   MACEDO              � Data � SET 2002 ���
��+----------+------------------------------------------------------------���
���Descri��o � EXTRATO DE CONTA CORRENTE DE FORNECEDORES                  ���
��+----------+------------------------------------------------------------���
���Uso       � TRADELINK MADEIRAS LTDA                                    ���
��+-----------------------------------------------------------------------+��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//+--------------------------------------------------------------+
//� Define Variaveis Ambientais                                  �
//+--------------------------------------------------------------+
//+--------------------------------------------------------------+
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // FORNECEDOR DE                        �
//� mv_par02             // FORNECEDOR ATE                       �
//� mv_par03             // DATA INICIAL                         �
//� mv_par04             // DATA FINAL                           �
//� mv_par05             // 1-REAL  2-DOLAR                      �
//+--------------------------------------------------------------+
CbTxt:=""
CbCont:=""
nOrdem :=0
Alfa := 0
Z:=0
M:=0
tamanho:="M"
M_Pag  :=01
limite:=220
titulo :=PADC("Extrato de Fornecedor II",74)
cDesc1 :=PADC("Este programa ira emitir O EXTRATO DE FORNECEDOR",74)
cDesc2 :=""
cDesc3 :=PADC("CONF PARAMETRO INFORMADO PELO OPERADOR.",74)
cNatureza:=""
aReturn  := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
nomeprog :="FIN00X"
cPerg    :="FIN004"
nLastKey := 0
lContinua:= .T.
nLin     :=0
wnrel    := "FIN00X"
nTipo := IIF(aReturn[04]==1,15,18)

_TXCORREA:=0
_TXJURREA:=0
_QUAL    :=""
_xSALDO  :=0                             // SALDO GRAVADO NO DBF TEMPORARIO

IF !(Pergunte(cPerg,.T.))               // Pergunta no SX1
	RETURN Nil
ENDIF

//+-----------------------------------------------------------+
//� CRIA ARQUIVO TEMPORARIO                                   �
//+-----------------------------------------------------------+
// Estrutura do Arquivo Temporario

aStru := {}
aadd(aStru , {'TMP_FOR' ,'C',06,0} )
aadd(aStru , {'TMP_PRE' ,'C',03,0} )
aadd(aStru , {'TMP_NUM' ,'C',06,0} )
aadd(aStru , {'TMP_TIP' ,'C',02,0} )
aadd(aStru , {'TMP_DEB' ,'N',12,2} )
aadd(aStru , {'TMP_CRE' ,'N',12,2} )
aadd(aStru , {'TMP_SLD' ,'N',14,2} )
aadd(aStru , {'TMP_DAT' ,'D',08,0} )
aadd(aStru , {'TMP_HIS' ,'C',50,2} )
aadd(aStru , {'TMP_JUR' ,'N',12,2} )

cArqTemp := CriaTrab(aStru , .t.)

dbUseArea(.T.,,cArqTemp,'TMP',.f.)

DBSELECTAREA("TMP")
INDEX ON TMP_FOR+DTOS(TMP_DAT)+TMP_NUM+TMP_PRE TO &cArqTemp
//+-------------------------------------------------------------------------+
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//+-------------------------------------------------------------------------+


nMOEDA := MV_PAR05
_SALDO := 0
cString:= "SE2"

IF MV_PAR06==1
	_cVarEmi:="SE2->E2_EMISSAO"        // PELA DATA DE EMISSAO   DA NF
	_cDescEm:="Pela Dt Emissao NF  "
	nOrdSE2  :=12 // REAL+DIGITACAO
ELSE
	_cVarEmi:="SE2->E2_EMIS1"          // PELA DATA DE DIGITACAO DA NF
	_cDescEm:="Pela Dt Digitacao NF"
	nOrdSE2  :=13 // REAL+EMISSAO                    
ENDIF
//+--------------------------------------------------------------+
//� Envia controle para a funcao SETPRINT                        �
//+--------------------------------------------------------------+

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

If nLastKey == 27
	Return
Endif

//+--------------------------------------------------------------+
//� Verifica Posicao do Formulario na Impressora                 �
//+--------------------------------------------------------------+
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif


//+--------------------------------------------------------------+
//�                                                              �
//� Inicio do Processamento da Nota Fiscal                       �
//�                                                              �
//+--------------------------------------------------------------+
#IFDEF WINDOWS
	RptStatus({|| RptDetail()})// Substituido pelo assistente de conversao do AP5 IDE em 19/11/99 ==>       RptStatus({|| Execute(RptDetail)})
	Return
	Static Function RptDetail()
#ENDIF
//*********************************************************************


//**********************************************************************



DBSELECTAREA("SA2")
DBSETORDER(1)
DBSEEK(xFilial("SA2")+MV_PAR01)
IF !FOUND()
	ALERT("COD DO FORNEC INICIAL NAO CONSTA NO CADASTRO .. VERIFIQUE !")
	RETURN nil
ENDIF

IF MV_PAR03 < CTOD("01/01/2001")
	MV_PAR03 :=CTOD("01/01/2001")
ENDIF
_DATAINICIAL:="01/01/2001"      // DATA INICIAL DE MOV EXTRATO NA TRADELINK

nTXDOLAR:=1

_SALDO:=0
/*
IF nMOEDA==2
	_SALDO:=A2_SDOPA                     // MANTEM SDO INICIAL EM USD
	DBSELECTAREA("SM2")
	DBSEEK(SA2->A2_DTSDOPA)
	IF M2_MOEDA2==0
		ALERT("Taxa de Dollar nao cadastrada para a data de "+DTOC(SA2->A2_DTSDOPA))
		RETURN nil
	ENDIF
ELSEIF A2_SDOPA<>0
	DBSELECTAREA("SM2")
	DBSEEK(SA2->A2_DTSDOPA)
	IF M2_MOEDA2==0
		ALERT("Taxa de Dollar nao cadastrada para a data de "+DTOC(SA2->A2_DTSDOPA))
		RETURN nil
	ELSE
		_SALDO:=(SA2->A2_SDOPA*M2_MOEDA2) // CONVERTE SDO INI DE USD P/ REAL
	ENDIF
ENDIF
*/
//************************************************** 0001 - BUSCA E GRAVA SALDO INICIAL
_ARQ:="CC"+SA2->A2_COD+".DBF"

xTMP_FOR:=SA2->A2_COD
xTMP_PRE:=""
xTMP_NUM:=""
xTMP_TIP:=""
IF _SALDO<0
	xTMP_DEB:=ABS(_SALDO)
	xTMP_CRE:=0
ELSE
	xTMP_DEB:=0
	xTMP_CRE:=ABS(_SALDO)
ENDIF
xTMP_DAT:=CTOD(_DATAINICIAL)
xTMP_HIS:="SDO AB : SALDO DE ABERTURA EM "+_DATAINICIAL
xTMP_JUR:=0

DBSELECTAREA("TMP")
RECLOCK("TMP",.T.)
REPLACE TMP_HIS WITH SA2->A2_NOME
MSUNLOCK()

fGravaTMP()


_PAGANTEC:=0
_NOTAFISC:=0
_ZCIMPR:=""

LINHA:=61
wPRI:=.T.

_VER_M_ANT:=.T.    //  VERIFICA MOV DE LANC ANTERIOR AO PRIMEIRO &_cVarEmi


//+-----------------------------------------------------------+
//� Inicializa  regua de impressao                            �
//+-----------------------------------------------------------+

dbSelectArea("SE2")
DBSETORDER(nOrdSE2)

SetRegua(RECCOUNT())
// INICIO DA IMPRESSAO

DBSEEK(xFilial("SE2")+SA2->A2_COD+DTOS(CTOD(_DATAINICIAL)),.T.)
WHILE !EOF() .AND. E2_FORNECE==SA2->A2_COD .AND. &_cVarEmi<=MV_PAR04 .AND. E2_FILIAL==SM0->M0_CODFIL
       
	IF nMOEDA==2
		DBSELECTAREA("SM2")
		DBSEEK(&_cVarEmi)
		IF FOUND()
			WHILE M2_MOEDA2==0
				DBSKIP(-1)
			ENDDO
			nTXDOLAR:=M2_MOEDA2
		ELSE
			ALERT(DTOC(&_cVarEmi)+" sem cadastro de Tx de Dollar !!")
			DBGOBOTTOM()
			WHILE M2_MOEDA2==0
				DBSKIP(-1)
			ENDDO
			nTXDOLAR:=M2_MOEDA2
		ENDIF
		dbSelectArea("SE2")
	ENDIF
	
	// ************************************************             0002 - BUSCA PA
	
	IF ALLTRIM(E2_TIPO)=="PA"
		xTMP_FOR:=E2_FORNECE
		xTMP_PRE:=E2_PREFIXO
		xTMP_NUM:=E2_NUM
		xTMP_TIP:=E2_TIPO
		xTMP_DEB:=((E2_VALOR)/nTXDOLAR)
		xTMP_CRE:=0
		xTMP_DAT:=&_cVarEmi
		xTMP_HIS:="HIST PA: "+LEFT(E2_HIST,30)
		xTMP_JUR:=0
		fGravaTMP()
		DBSELECTAREA("SE2")
	ENDIF
	
	//******************************************************    0003 -  BUSCA NF
	IF LEFT(E2_TIPO,2)=="NF"
		xTMP_FOR:=E2_FORNECE
		xTMP_PRE:=E2_PREFIXO
		xTMP_NUM:=E2_NUM
		xTMP_TIP:=E2_TIPO
		xTMP_DEB:=0
		xTMP_CRE:=(E2_VALOR/nTXDOLAR)
		xTMP_DAT:=&_cVarEmi
		xTMP_JUR:=0
		
		_HISTORI:=""
		DBSELECTAREA("SF1")
		DBSETORDER(1)
		DBSEEK(xFilial("SF1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
		
		DBSELECTAREA("SE2")
		_HISTORI:=_HISTORI+"* "
		_HIST01:=""
		_HIST02:=""
		_HIST03:=""
		DBSELECTAREA("SD1")
		DBSETORDER(1)
		DBSEEK(xFilial("SD1")+SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA)
		IF FOUND()
			WHILE (D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA)==(SE2->E2_NUM+SE2->E2_PREFIXO+SE2->E2_FORNECE+SE2->E2_LOJA) .AND. !EOF()
                _DESCPRO:=Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_DESC")
				_HISTORI:=_HISTORI+ALLTRIM(_DESCPRO)+" "+ALLTRIM(STR(D1_QUANT,10,4))+" * "
				DBSKIP()
			ENDDO
			_HIST01:=SUBSTR(_HISTORI,001,50)
			_HIST02:=SUBSTR(_HISTORI,051,50)
			_HIST03:=SUBSTR(_HISTORI,101,50)
		ELSE
			_HIST01:=LEFT(("*CPAGAR: "+ALLTRIM(SE2->E2_HIST)),50)
		ENDIF
		
		xTMP_HIS:=_HIST01
		fGravaTmp()
		
		IF !EMPTY(_HIST02) .AND. LEN(ALLTRIM(_HIST02)) > 3
			xTMP_DEB:=0
			xTMP_CRE:=0
			xTMP_TIP:="--"                 // COMPLEMENTO DE HISTORICO 02
			xTMP_HIS:=_HIST02
			fGravaTMP()
			IF !EMPTY(_HIST03) .AND. LEN(ALLTRIM(_HIST03)) > 3
				xTMP_DEB:=0
				xTMP_CRE:=0
				xTMP_TIP:="--"             // COMPLEMENTO DE HISTORICO 03
				xTMP_HIS:=_HIST03
				fGravaTMP()
			ENDIF
		ENDIF
		
		//************************************************************** 0004 - MOV BAIXAS
		
		DBSELECTAREA("SE5")     // MOVIMENTACOES DE BAIXAS REF AO TITULO (NF)
		DBSETORDER(7)
		DBSEEK(xFilial("SE5")+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA+SE2->E2_TIPO+SE2->E2_FORNECE)
		IF FOUND()
			WHILE !EOF() .AND. E5_CLIFOR==SE2->E2_FORNECE .AND. SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA==E5_PREFIXO+E5_NUMERO+E5_PARCELA
				IF E5_DATA>=CTOD(_DATAINICIAL) .AND. E5_DATA<=MV_PAR04 .AND. E5_TIPO<>"PA" .AND. !E5_TIPODOC$"CP/BA" .AND. LEFT(E5_BANCO,1)<>"C"
					xTMP_FOR:=SE2->E2_FORNECE
					xTMP_PRE:=E5_PREFIXO
					xTMP_NUM:=E5_NUMERO
					xTMP_TIP:=E5_TIPO
					
					IF E5_RECPAG="P"
						xTMP_DEB:= (E5_VALOR/nTXDOLAR)
						xTMP_CRE:=0
					ELSE
						xTMP_DEB:=0
						xTMP_CRE:=E5_VALOR/nTXDOLAR
					ENDIF
					xTMP_DAT:=E5_DATA
					IF !EMPTY(SE5->E5_NUMCHEQ)
						_SEQBX:=SE5->E5_NUMCHEQ
					ELSE
						_SEQBX:=SE5->E5_TIPODOC+SE5->E5_MOTBX
					ENDIF
					xTMP_HIS:=LEFT(("BX TIT: "+ALLTRIM(SE5->E5_HISTOR)+" "+E5_BANCO+" "+E5_AGENCIA+" "+_SEQBX),50)
					xTMP_JUR:=0
					fGravaTMP()
					DBSELECTAREA("SE5")
				ENDIF
				DBSKIP()
			ENDDO
		ENDIF
	ENDIF
	
	DBSELECTAREA("SE2")
	_MESEMISSAO:=MONTH(&_cVarEmi)
	_ANOEMISSAO:=YEAR(&_cVarEmi)
	_EMISSAOANT:=&_cVarEmi
	_FORNANT   :=E2_FORNECE
	DBSKIP()
ENDDO

//************************************************************   0005 - DEVOLUCOES

DBSELECTAREA("SD2")                       // BUSCA DEV ENTRADA   *** (SD2)
DBSETORDER(9)
DBSEEK(xFilial("SD2")+SA2->A2_COD)
IF FOUND()
	WHILE ALLTRIM(D2_CLIENTE)==ALLTRIM(SA2->A2_COD) .AND. !EOF() .AND. D2_FILIAL==SM0->M0_CODFIL
		IF D2_EMISSAO>=CTOD(_DATAINICIAL) .AND. D2_EMISSAO<=MV_PAR04
			IF D2_TIPO=="D"
				
				xTMP_FOR:=SA2->A2_COD
				xTMP_PRE:=D2_SERIE
				xTMP_NUM:=D2_DOC
				xTMP_TIP:=D2_TIPO
				xTMP_DEB:=(D2_TOTAL/nTxDolar)
				xTMP_CRE:=0
				xTMP_DAT:=D2_EMISSAO
				xTMP_HIS:="DEVOLUC: N FISCAL DE DEVOLUC "+D2_NFORI
				xTMP_JUR:=0
				fGravaTMP()
				DBSELECTAREA("SD2")
			ENDIF
		ENDIF
		DBSKIP()
	ENDDO
ENDIF
dbSelectArea("SE2")

//****************************************************** 0006 - LANC ANTER
// BUSCA LANC EXTRATO (SZC) ****
/*
DBSELECTAREA("SZC")
DBSETORDER(1)
DBSEEK(xFilial("SZC")+SA2->A2_COD)
WHILE !EOF() .AND. ZC_FORNECE==SA2->A2_COD .AND. ZC_DATA>=CTOD(_DATAINICIAL) .AND. ZC_DATA<=MV_PAR04
	IF ZC_DC<>"T" .AND. ZC_VALOR > 0
		xTMP_FOR:=ZC_FORNECE
		xTMP_PRE:=ZC_PREFIXO
		xTMP_NUM:=ZC_NUM
		xTMP_TIP:=""
		IF ZC_DC=="D"
			xTMP_DEB:=(ZC_VALOR/nTXDOLAR)
			xTMP_CRE:=0
		ELSEIF ZC_DC=="C"
			xTMP_DEB:=0
			xTMP_CRE:=(ZC_VALOR/nTXDOLAR)
		ENDIF
		xTMP_DAT:= ZC_DATA
		xTMP_HIS:= "MANUAL1: "+ALLTRIM(SZC->ZC_HIST)
		xTMP_JUR:=0
		fGravaTMP()
		DBSELECTAREA("SZC")
	ENDIF
	DBSKIP()
ENDDO
*/
************************************************************** IMPRIME

_ULTDATAP:=CTOD("  /  /  ")    // ULTIMO MOVIMENTO IMPRESSO

DBSELECTAREA("TMP")
DBSEEK(MV_PAR01)
WHILE !EOF()
	LINHA :=61
	_SALDO:=0
	_TOTDEB:=0
	_TOTCRE:=0
	wPRI:=.T.
	wPRIJUR:=.T.
	_SOBRESALDO:=.T.
	_xJUROS:=0
	_SOBREFM:=.F.
	WHILE !EOF() .AND. TMP_FOR>=MV_PAR01 .AND. TMP_FOR<=MV_PAR02
		IF LINHA>60
			IMPCABEC()
		ENDIF
		
		IF TMP_DAT>=MV_PAR03
			IF wPRI
				wPRI:=.F.
				@ LINHA,001 PSAY "Fornecedor : "+SA2->A2_COD+" "+SA2->A2_NOME
				LINHA:=LINHA + 1
				IF _SALDO<>0
					@ LINHA,047 PSAY _SALDO PICTURE "@EZ 9,999,999.99"
					@ LINHA,060 PSAY MV_PAR03-1
					@ LINHA,071 PSAY "SDO AB : SALDO FINAL EM "+DTOC(MV_PAR03-1)
					LINHA:=LINHA + 2
				ENDIF
			ENDIF
			@ LINHA,001 PSAY TMP_PRE
			@ LINHA,005 PSAY TMP_NUM
			@ LINHA,014 PSAY TMP_TIP
			@ LINHA,020 PSAY TMP_DEB PICTURE "@EZ 9,999,999.99"
			@ LINHA,033 PSAY TMP_CRE PICTURE "@EZ 9,999,999.99"
			_SALDO:=(_SALDO-TMP_DEB)+TMP_CRE
			@ LINHA,047 PSAY _SALDO  PICTURE "@EZ 9,999,999.99"
			@ LINHA,060 PSAY TMP_DAT
			@ LINHA,071 PSAY TMP_HIS
			
			RECLOCK("TMP",.F.)
			REPLACE TMP_SLD WITH _SALDO
			MSUNLOCK()
			
			_UltDataP:=TMP_DAT
			IF !_SOBRESALDO  .OR. (_SALDO<0 .AND. TMP_DAT>=MV_PAR07)
				_FIMDOMES:=CTOD("01/"+STRZERO(MONTH((TMP_DAT+35)),2,0)+"/"+STRZERO(YEAR((TMP_DAT+35)),4,0))
				_FIMDOMES:=_FIMDOMES-1
				IF DAY(_FIMDOMES)==31
					_FIMDOMES:=CTOD("30/"+STRZERO(MONTH(_FIMDOMES),2,0)+"/"+STRZERO(YEAR(_FIMDOMES),4,0))
				ENDIF
				IF _FIMDOMES>MV_PAR04
					_FIMDOMES:=MV_PAR04
				ENDIF
				
				_tvValor:=IIF(TMP_DEB>0,-TMP_DEB,TMP_CRE) // CALCULA JUROS DA TRANSACAO
				IF _tvVALOR<>0
					fBuscaTXJUR()
					DBSELECTAREA("TMP")
					_DIAS:=(_FIMDOMES-TMP_DAT)+1   // DT LIMITE DO EXTRATO - DATA DA TRANSACAO
					IF MONTH(_FIMDOMES)==2 .AND. _DIAS>=28
						_DIAS:=30
					ENDIF
					_TXCORREA:=(_TXCORREA/30)*_Dias
					_tvCORREC:=(_tvVALOR*_TXCORREA)/100
					_TXJURREA:=(_TXJURREA/30)*_Dias
					_tvJUROS :=(_tvVALOR*_TXJURREA)/100
					_xJUROS:=_xJuros+(_tvCORREC+_tvJUROS)
					@ LINHA,122 PSAY (_tvCORREC+_tvJUROS) PICTURE "@E 999,999.99"
				ENDIF
			ENDIF
			
			LINHA:=LINHA+1
			IF TMP_DAT>=MV_PAR03
				_TOTDEB:=_TOTDEB+TMP_DEB
				_TOTCRE:=_TOTCRE+TMP_CRE
			ENDIF
		ELSE
			_SALDO:=(_SALDO-TMP_DEB)+TMP_CRE
			IF TMP_DAT>=MV_PAR03
				_TOTDEB:=_TOTDEB+TMP_DEB
				_TOTCRE:=_TOTCRE+TMP_CRE
			ENDIF
		ENDIF
		_DATAANT:=TMP_DAT
		
		DBSKIP()
		
		IF TMP_TIP=="--" .AND. TMP_DAT>=MV_PAR03    // IMPRIME COMPLEMENTO DE HISTORICO
			WHILE !EOF() .AND. TMP_TIP=="--"
				@ LINHA,071 PSAY TMP_HIS
				LINHA:=LINHA + 1
				DBSKIP()
			ENDDO
		ENDIF
		
		IF SUBSTR(DTOS(TMP_DAT),1,6) > SUBSTR(DTOS(_DATAANT),1,6)  // VIRADA DE MES
			_FIMDOMES:=CTOD("01/"+STRZERO(MONTH((TMP_DAT+35)),2,0)+"/"+STRZERO(YEAR((TMP_DAT+35)),4,0))
			_FIMDOMES:=_FIMDOMES-1
			IF _FIMDOMES>MV_PAR04
				_FIMDOMES:=MV_PAR04
			ENDIF
			
			IF _SOBRESALDO .AND. TMP_DAT>=MV_PAR07 .AND. _SALDO < 0 // CALC JUROS S/SALDO
				_SOBRESALDO:=.F.
				fBuscaTXJUR()
				DBSELECTAREA("TMP")
				_DIAS:=(_FIMDOMES-MV_PAR07)+1   // DATA ATE DO EXTRATO - DATA DE INICIO DE JUROS
				
				IF MONTH(_FIMDOMES)==2 .AND. _DIAS>=28
					_DIAS:=30
				ENDIF
				
				_TXCORREA:=(_TXCORREA/30)*_Dias
				_tvCORREC:=(_SALDO*_TXCORREA)/100
				_TXJURREA:=(_TXJURREA/30)*_Dias
				_tvJUROS :=(_SALDO*_TXJURREA)/100
				_xJUROS:=(_tvCORREC+_tvJUROS)
			ENDIF
			
			IF TMP_DAT>=MV_PAR03                    // IMPRIME A PARTIR DE MV_PAR03
				@ LINHA,001 PSAY "---------------"
				IF wPRIJUR .AND. _xJUROS<>0             // IMPRIME SOMENTE NO SALDO ANTERIOR INICIAL
					@ LINHA,122 PSAY _xJUROS PICTURE "@EZ 999,999.99"
					wPRIJUR:=.F.
				ENDIF
				LINHA:=LINHA + 1
			ENDIF
			
			IF _xJUROS<0 .AND. _SOBREFM                               // SOMA JUROS DO MES
				_TOTDEB:=_TOTDEB+ABS(_xJUROS)
				_SALDO:=_SALDO-ABS(_xJUROS)
				IF TMP_DAT>=MV_PAR03
					@ LINHA,005 PSAY "Juros Mes Anter"
					@ LINHA,020 PSAY ABS(_xJUROS) PICTURE "@EZ 9,999,999.99"
					@ LINHA,047 PSAY _SALDO  PICTURE "@EZ 9,999,999.99"
					@ LINHA,071 PSAY "SDOATU: SALDO+JUROS ATUALIZADO "
					LINHA:=LINHA+1
				ENDIF
				_xJUROS:=0
				
				fBuscaTXJUR()
				DBSELECTAREA("TMP")
				_DIAS:=DAY(_FIMDOMES)
				IF _DIAS<>30
					_DIAS:=30
				ENDIF
				_TXCORREA:=(_TXCORREA/30)*_Dias
				_tvCORREC:=(_SALDO*_TXCORREA)/100
				_TXJURREA:=(_TXJURREA/30)*_Dias
				_tvJUROS :=(_SALDO*_TXJURREA)/100
				_xJUROS:=(_tvCORREC+_tvJUROS)
				
			ENDIF
			IF TMP_DAT>=MV_PAR07
				_SOBREFM:=.T.
			ENDIF
		ENDIF
		
		
	ENDDO
	
	DBSELECTAREA("TMP")
	
	
	
	
	@ LINHA,001 PSAY REPLICATE("-",132)
	LINHA:=LINHA+1
	@ LINHA,020 PSAY _TOTDEB PICTURE "@EZ 9,999,999.99"
	@ LINHA,033 PSAY _TOTCRE PICTURE "@EZ 9,999,999.99"
	@ LINHA,047 PSAY _SALDO  PICTURE "@EZ 9,999,999.99"
	LINHA:=LINHA+1
	IF _xJUROS<0
		@ LINHA,005 PSAY "Juros"
		@ LINHA,020 PSAY ABS(_xJUROS) PICTURE "@EZ 9,999,999.99"
		_SALDO:=_SALDO-ABS(_xJUROS)
		@ LINHA,047 PSAY _SALDO  PICTURE "@EZ 9,999,999.99"
		@ LINHA,060 PSAY MV_PAR04
		@ LINHA,071 PSAY "SDOATU: SALDO+JUROS ATUALIZADO ATE A DATA"
		LINHA:=LINHA+1
	ENDIF
	@ LINHA,001 PSAY REPLICATE("-",132)
ENDDO


//+--------------------------------------------------------------+
//�                                                              �
//�                      FIM DA IMPRESSAO                        �
//�                                                              �
//+--------------------------------------------------------------+


Set Device To Screen

If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

dbSelectArea('TMP')
DBGOTOP()

COPY TO &_ARQ //FIN00X.DBF

_arquivo:="G:\SIGAADV\"+_ARQ
If !File(_arquivo)
    _arquivo:="F:\SIGAADV\"+_ARQ
    If !File(_arquivo)
       _arquivo:="E:\PROTHEUS_DATA\SIGAADV\"+_ARQ   // SERVIDOR PWAMAZON
    endif   
EndIf
Winexec("C:\Arquivos de programas\Microsoft Office\OFFICE11\EXCEL.EXE"+" "+_arquivo  )




dbCloseArea ()
cArqTemp2 := cArqTemp + '.DBF'
Delete File &cArqTemp2

cArqTemp3 := cArqTemp + '.CDX'
Delete File &cArqTemp3

DBSELECTAREA("SA2")           // RETORNA INDICE FORNECEDORES
DBSETORDER(1)

DBSELECTAREA("SE2")           // RETORNA INDICE CONTAS A PAGAR
DBSETORDER(1)

RETURN

//*************************
STATIC FUNCTION fGravaTMP()      // GRAVA LANCAMENTO NO ARQ TEMPORARIO
//*************************

DBSELECTAREA("TMP")
RECLOCK("TMP",.T.)
REPLACE TMP_FOR WITH xTMP_FOR
REPLACE TMP_PRE WITH xTMP_PRE
REPLACE TMP_NUM WITH xTMP_NUM
REPLACE TMP_DAT WITH xTMP_DAT
REPLACE TMP_TIP WITH xTMP_TIP
REPLACE TMP_DEB WITH xTMP_DEB
REPLACE TMP_CRE WITH xTMP_CRE
REPLACE TMP_HIS WITH xTMP_HIS
REPLACE TMP_JUR WITH xTMP_JUR
MSUNLOCK()

RETURN Nil

//************************
STATIC FUNCTION fBuscaTXJUR()
//************************
// BUSCA AS TAXAS JUROS E CM

_TXCORREA :=0
_TXJURREA :=0
_QUAL     :=""
/*
IF SA2->A2_CALJUR<>"S"
	RETURN Nil
ENDIF

DBSELECTAREA("SZC")         // BUSCA TAXAS ESPECIFICAS
DBSETORDER(1)
DBSEEK(xFilial("SZC")+xTMP_FOR+SUBSTR(DTOS(TMP->TMP_DAT),1,6))
IF FOUND()
	WHILE !EOF() .AND. ZC_FORNECE==xTMP_FOR .AND. SUBSTR(DTOS(ZC_DATA),1,6)==SUBSTR(DTOS(TMP->TMP_DAT),1,6)
		IF ZC_DC=="T"
			_TXCORREA :=ZC_TXJUR
			_TXJURREA :=ZB_TXCM
			_QUAL     :=" Especif"
		ENDIF
		DBSKIP()
	ENDDO
	
ENDIF
IF EMPTY(_QUAL)
	DBSELECTAREA("SZB")         // BUSCA TAXAS GLOBAIS
	DBSETORDER(1)
	DBSEEK(xFilial("SZB")+SUBSTR(DTOS(TMP->TMP_DAT),1,6))
	IF FOUND()
		_TXCORREA :=ZB_TXCOR
		_TXJURREA :=ZB_TXJUR
		_QUAL     :=" Global"
	ENDIF
	
	
ENDIF
*/

RETURN Nil

**************************
STATIC FUNCTION IMPCABEC()
**************************
Titulo:="Periodo de "+DTOC(MV_PAR03)+" ate "+DTOC(MV_PAR04)
_TEMP :="   JUROS"
Cabec1:="PRF NUMERO PC TP   PAGAMENT/DEV.    ENTRADAS      S A L D O  EMISSAO   HISTORICO DO TITULO                                  "+_TEMP
CABEC2:=" "

Linha:= Cabec(titulo,cabec1,cabec2,wnrel,Tamanho,nTipo) + 1


IF nMOEDA==2
	@ Linha,048 PSAY "( Em USD   ) - "+_cDescEm
ELSE
	@ Linha,048 PSAY "( Em REAIS ) - "+_cDescEm
ENDIF
LINHA:=Linha + 1
RETURN nil

//+--------------------------------------------------------------+
//� Fim do Programa                                              �
//+--------------------------------------------------------------+

