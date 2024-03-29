#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  25/01/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
Altera��es
Data       Consultor Tecnico               Descricao
13/03/2007 Franciney                       compilac�o na PWA


/*/

User Function pwbr001()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Movimentacao de Ativos"
Local cPict          := ""
Local titulo       := "Movimentacao de Ativos"
Local nLin         := 80

local Cabec1       := "                      ------ VALOR ORIGINAL -------  ---------------------- DEPRECIACAO ------------------------ "
local Cabec2       := " CTA. BEM                         R$    US$ (SIST.)          MES R$    US$ (SIST.)       ACUM. R$    US$ (SIST.) "
//                      99999999999999999999 999,999,999,99 999,999,999,99  999,999,999,99 999,999,999,99 999,999,999,99 999,999,999,99
//                     01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
//                               1         2         3         4         5         6         7         8         9         0         1         2         3

Local imprime      := .T.
Private aOrd             := {} //{"Por Conta","Por Ativo"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 130
Private tamanho          := "M"
Private nomeprog         := "PWBR001" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "PWBR01"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "PWBR001" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SN3"

dbSelectArea("SN3")
dbSetOrder(2)

criaperg(cPerg)
pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.f.,aOrd,.t.,Tamanho,,.f.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  25/01/06   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

//dbSelectArea(cString)

//���������������������������������������������������������������������Ŀ
//� Tratamento das ordens. A ordem selecionada pelo usuario esta contida�
//� na posicao 8 do array aReturn. E um numero que indica a opcao sele- �
//� cionada na mesma ordem em que foi definida no array aOrd. Portanto, �
//� basta selecionar a ordem do indice ideal para a ordem selecionada   �
//� pelo usuario, ou criar um indice temporario para uma que nao exista.�
//� Por exemplo:                                                        �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem < 5                                                       �
//�     dbSetOrder(nOrdem)                                              �
//� Else                                                                �
//�     cInd := CriaTrab(NIL,.F.)                                       �
//�     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") �
//� Endif                                                               �
//�����������������������������������������������������������������������

//nOrdem := aReturn[8]
//dbSetOrder(nOrdem)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

_dDataref := mv_par01
_nOrdem   := mv_par02
_cCtaDe   := mv_par03
_cCtaAte  := mv_par04
_cBemDe   := mv_par05
_cBemAte  := mv_par06
_nTipo    := mv_par07
_nUpdate  := mv_par08
_nBAIXA   := mv_par09
_nMoeda   := mv_par10


if _nMoeda == 2
	Cabec2       := " CTA. BEM                         R$    US$ (CALC.)          MES R$    US$ (CALC.)       ACUM. R$    US$ (CALC.) "
Endif

dbSelectArea("SN3")
SetRegua(RecCount())
if _nOrdem == 1
	dbSetOrder(2)
	dbGoTop()
	dbseek(xfilial("SN3")+_cCtaDe,.t.)
Else
	dbSetOrder(1)
	dbGoTop()
	dbseek(xfilial("SN3")+_cBemDe,.t.)
Endif


//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Note que o descrito acima deve ser tratado de acordo com as ordens  �
//� definidas. Para cada ordem, o indice muda. Portanto a condicao deve �
//� ser tratada de acordo com a ordem selecionada. Um modo de fazer isto�
//� pode ser como a seguir:                                             �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem == 1                                                      �
//�     dbSetOrder(1)                                                   �
//�     cCond := "A1_COD <= mv_par02"                                   �
//� ElseIf nOrdem == 2                                                  �
//�     dbSetOrder(2)                                                   �
//�     cCond := "A1_NOME <= mv_par02"                                  �
//� ElseIf nOrdem == 3                                                  �
//�     dbSetOrder(3)                                                   �
//�     cCond := "A1_CGC <= mv_par02"                                   �
//� Endif                                                               �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.)                                      �
//� While !EOF() .And. &cCond                                           �
//�                                                                     �
//�����������������������������������������������������������������������

_lImpDad := .f.
_lImpSub := .f.
_cBase   := " "


if ! eof()
	
	if _nordem == 1
		_cCtaDe := n3_ccontab
		_cCond  := " ! eof() .and. n3_ccontab >= _cCtade .and.  n3_ccontab <= _cCtaAte "
	Else
		_cBemDE := n3_cbase
		_cCond  := " ! eof() .and. n3_cbase >= _cBemDe .and. n3_cbase <= _cBemAte "
	Endif
	
	
	_nTotOrig1 := 0
	_nTotOrig2 := 0
	_nTotOrig3 := 0
	_nTotOrigc := 0
	_nTotOrigu := 0
	
	_nTotMes1  := 0
	_nTotMes2  := 0
	_nTotMes3  := 0
	_nTotMesc  := 0
	_nTotMesu  := 0
	
	_nTotAcm1  := 0
	_nTotAcm2  := 0
	_nTotAcm3  := 0
	_nTotAcmc  := 0
	_nTotAcmu  := 0
	
	While &_cCond
		
		//���������������������������������������������������������������������Ŀ
		//� Verifica o cancelamento pelo usuario...                             �
		//�����������������������������������������������������������������������
		
		if _nordem == 1
			_cChave := n3_ccontab
			_cCond2  := " ! eof() .and. _cChave == SN3->n3_ccontab "
		Else
			_cChave := n3_cbase+n3_item+N3_TIPO
			_cCond2  := " ! eof() .and. _cChave == SN3->n3_cbase+SN3->n3_item+SN3->N3_TIPO "
		Endif
		
		_nCtaOrig1 := 0
		_nCtaOrig2 := 0
		_nCtaOrig3 := 0
		_nCtaOrigc := 0
		_nCtaOrigU := 0
		
		_nCtaMes1  := 0
		_nCtaMes2  := 0
		_nCtaMes3  := 0
		_nCtaMesc  := 0
		_nCtaMesu  := 0
		
		_nCtaAcm1  := 0
		_nCtaAcm2  := 0
		_nCtaAcm3  := 0
		_nCtaAcmc  := 0
		_nCtaAcmu  := 0
		
		While &_cCond2
			
			incregua()
			
			IF _nBaixa == 2 .and. (!empty(n3_dtbaixa) .and. n3_dtbaixa <= _dDataref)
				dbskip()
				loop
			Endif
			
			dbselectarea("SM2")
			dbsetorder(1)
			dbgotop()
			
			dbseek(sn3->n3_aquisic,.T.)
			
			_nTaxa  := 0
			_nTaxau := 0
			
			if ! eof()
				if m2_data == sn3->n3_aquisic
					_nTaxa  := m2_moeda2
					_nTaxau := m2_moeda3
				Else
					dbskip(-1)
					if ! bof()
						_nTaxa  := m2_moeda2
						_nTaxau := m2_moeda3
					Endif
				Endif
			Endif
			
			dbselectarea("SN3")
			
			_nBemOrig1 := n3_vorig1
			_nBemAmpl1 := n3_amplia1
			_nBemOrig2 := n3_vorig2
			_nBemAmpl2 := n3_amplia2
			_nBemOrig3 := n3_vorig3
			_nBemAmpl3 := n3_amplia3
			
			_nCtaOrig1 += (_nBemOrig1+_nBemAmpl1)
			_nCtaOrig2 += (_nBemOrig2+_nBemAmpl2)
			_nCtaOrig3 += (_nBemOrig3+_nBemAmpl3)
			
			_nBemOrigc := 0
			_nBemAmplc := 0
			_nBemOrigu := 0
			_nBemAmplu := 0
			
			if _nTaxa > 0
				_nBemOrigc := (_nBemOrig1/_nTaxa)
				_nBemAmplc := (_nBemAmpl1/_nTaxa)
			Endif
			
			if _nTaxau > 0
				_nBemOrigu := (_nBemOrig1/_nTaxau)
				_nBemAmplu := (_nBemAmpl1/_nTaxau)
			Endif
			
			_nCtaOrigc += (_nBemOrigc + _nBemAmplc)
			_nCtaOrigu += (_nBemOrigu + _nBemAmplu)
			
			_nDepMes1  := 0
			_nDepMes2  := 0
			_nDepMes3  := 0
			_nDepMesc  := 0
			_nDepMesu  := 0
			
			_nDepAcm1  := 0
			_nDepAcm2  := 0
			_nDepAcm3  := 0
			_nDepAcmc  := 0
			_nDepAcmu  := 0
			
			_nBemMes1  := 0
			_nBemMes2  := 0
			_nBemMes3  := 0
			_nBemMesc  := 0
			_nBemMesu  := 0
			
			_nBemAcm1  := 0
			_nBemAcm2  := 0
			_nBemAcm3  := 0
			_nBemAcmc  := 0
			_nBemAcmu  := 0
			
			
			dbselectarea("SN4")
			dbsetorder(1)
			dbgotop()
			
			if dbseek(xfilial("SN4")+SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO,.F.)
				
				Do While ! eof() .and. n4_cbase+n4_item+n4_tipo == SN3->N3_CBASE+SN3->N3_ITEM+SN3->N3_TIPO
					
					_lImpAna := .f.
					
					_nDepMes1 := 0
					_nDepMes2 := 0
					_nDepMes3 := 0
					_nDepMesc := 0
					_nDepMesu := 0
					
					_nDepAcm1 := 0
					_nDepAcm2 := 0
					_nDepAcm3 := 0
					_nDepAcmc := 0
					_nDepAcmu := 0
					
					dbselectarea("SM2")
					dbsetorder(1)
					dbgotop()
					
					dbseek(SN4->N4_DATA,.T.)
					
					_nTaxa  := 0
					_nTaxau := 0
					
					if ! eof()
						if m2_data == sn4->n4_data
							_nTaxa  := m2_moeda2
							_nTaxau := m2_moeda3
						Else
							dbskip(-1)
							if ! bof()
								_nTaxa  := m2_moeda2
								_nTaxau := m2_moeda3
							Endif
						Endif
					Endif
					
					dbselectarea("SN4")
					
					IF ( (n4_ocorr == "06" .and. n4_tipocnt == "3") ) //.or. n4_ocorr == "09" )
						
						if n4_data = _dDataRef
					
							_lImpAna := .t.
					
							_nDepMes1 := n4_vlroc1
							_nDepMes2 := n4_vlroc2
							_nDepMes3 := n4_vlroc3
							
							if _nTaxa > 0
								_nDepMesc := n4_vlroc1/_nTaxa
							Endif
							
							if _nTaxau > 0
								_nDepMesu := n4_vlroc1/_nTaxau
							Endif
							
							_nCtaMes1 += _nDepMes1
							_nCtaMes2 += _nDepMes2
							_nCtaMes3 += _nDepMes3
							_nCtaMesc += _nDepMesc
							_nCtaMesu += _nDepMesu
							
							_nBemMes1  += _nDepMes1
							_nBemMes2  += _nDepMes2
							_nBemMes3  += _nDepMes3
							_nBemMesc  += _nDepMesc
							_nBemMesu  += _nDepMesu
							
							if _nMoeda == 2 .and. _nUpdate == 1
								if reclock("SN4",.f.)
									SN4->N4_VLROC2  := _nDepMesc
									SN4->N4_VLROC3  := _nDepMesU
									msunlock()
								Endif
							Endif
							
						Elseif n4_data < _dDataRef 
							
							_lImpAna := .t.
							
							_nDepAcm1 := n4_vlroc1
							_nDepAcm2 := n4_vlroc2
							_nDepAcm3 := n4_vlroc3
							
							if _nTaxa > 0
								_nDepAcmc := n4_vlroc1/_nTaxa
							Endif
							
							if _nTaxau > 0
								_nDepAcmu := n4_vlroc1/_nTaxau
							Endif
							
							_nCtaAcm1 += _nDepAcm1
							_nCtaAcm2 += _nDepAcm2
							_nCtaAcm3 += _nDepAcm3
							_nCtaAcmc += _nDepAcmc
							_nCtaAcmu += _nDepAcmu
							
							_nBemAcm1  += _nDepAcm1
							_nBemAcm2  += _nDepAcm2
							_nBemAcm3  += _nDepAcm3
							_nBemAcmc  += _nDepAcmc
							_nBemAcmu  += _nDepAcmu
							
							if _nMoeda == 2 .and. _nUpdate == 1
								if reclock("SN4",.f.)
									SN4->N4_VLROC2  := _nDepAcmc
									SN4->N4_VLROC3  := _nDepAcmu
									msunlock()
								Endif
							Endif
							
						Endif
					Else
						if _nMoeda == 2 .and. _nUpdate == 1
							
							_nDepMes1 := n4_vlroc1
							_nDepMes2 := n4_vlroc2
							_nDepMes3 := n4_vlroc3
							
							if _nTaxa > 0
								_nDepMesc := n4_vlroc1/_nTaxa
							Endif
							
							if _nTaxau > 0
								_nDepMesu := n4_vlroc1/_nTaxau
							Endif
							
							if reclock("SN4",.f.)
								SN4->N4_VLROC2  := _nDepMesc
								SN4->N4_VLROC3  := _nDepMesU
								msunlock()
							Endif
						
						Endif
					Endif
					
					
					if _nTipo == 1 .and. _lImpAna
						
						If lAbortPrint
							@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
							Exit
						Endif
						
						If lAbortPrint
							Exit
						Endif
						
						If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 9
						Endif
						
						if _nTipo == 1 .and. _lImpDad
							@nLin,00  PSAY " "
							nLin := nLin + 1 // Avanca a linha de impressao
							//@nLin,01 PSAY _cChave
							_lImpDad := .f.
							_lImpSub := .t.
						Endif
						
						// Coloque aqui a logica da impressao do seu programa...
						// Utilize PSAY para saida na impressora. Por exemplo:
						
						if _cBase <> n4_cbase
							@nLin,01 PSAY n4_cbase
							_cBase := n4_cbase
						Endif
						
						@nLin,13 PSAY n4_data
						
						@nLin,53 PSAY _nDepMes1 PICTURE "@E 999,999,999.99"
						if _nMoeda == 1
							@nLin,68 PSAY _nDepMes2 PICTURE "@E 999,999,999.99"
						Else
							@nLin,68 PSAY _nDepMesc PICTURE "@E 999,999,999.99"
						Endif
						
						@nLin,83 PSAY _nDepAcm1 PICTURE "@E 999,999,999.99"
						if _nMoeda == 1
							@nLin,98 PSAY _nDepAcm2 PICTURE "@E 999,999,999.99"
						else
							@nLin,98 PSAY _nDepAcmc PICTURE "@E 999,999,999.99"
						Endif
						
						nLin := nLin + 1 // Avanca a linha de impressao
						
					Endif
					
					
					dbSkip() // Avanca o ponteiro do registro no arquivo
					
				Enddo
				
			Endif
			
			dbselectarea("SN3")
			
			if _nMoeda == 2 .and. _nUpdate == 1
				if reclock("SN3",.f.)
					SN3->N3_VORIG2  := _nBemOrigc
					SN3->N3_VORIG3  := _nBemOrigu
					SN3->N3_AMPLIA2 := _nBemAmplc
					SN3->N3_AMPLIA3 := _nBemAmplu
					SN3->N3_VRDMES2 := _nBemMesc
					SN3->N3_VRDMES3 := _nBemMesu
					SN3->N3_VRDBAL2 := _nBemAcmc
					SN3->N3_VRDBAL3	:= _nBemAcmu
					SN3->N3_VRDACM2 := _nBemAcmc
					SN3->N3_VRDACM3 := _nBemAcmu
					msunlock()
				Endif
			Endif
			
			dbskip()
			
		EndDo
		
		
		//���������������������������������������������������������������������Ŀ
		//� Impressao do cabecalho do relatorio. . .                            �
		//�����������������������������������������������������������������������
		
		
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If lAbortPrint
			Exit
		Endif
		
		If nLin > 55 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 9
		Endif
		
		if _nTipo == 1 .and. _lImpSub
			@nLin,00  PSAY replicate("-",limite)
			nLin := nLin + 1 // Avanca a linha de impressao
			_lImpSub := .f.
		Endif
		
		// Coloque aqui a logica da impressao do seu programa...
		// Utilize PSAY para saida na impressora. Por exemplo:
		
		@nLin,01 PSAY _cChave
		
		@nLin,22 PSAY _nCtaOrig1 PICTURE "@E 999,999,999.99"
		
		if _nMoeda == 1
			@nLin,37 PSAY _nCtaOrig2 PICTURE "@E 999,999,999.99"
		Else
			@nLin,37 PSAY _nCtaOrigc PICTURE "@E 999,999,999.99"
		Endif
		
		@nLin,53 PSAY _nCtaMes1 PICTURE "@E 999,999,999.99"
		if _nMoeda == 1
			@nLin,68 PSAY _nCtaMes2 PICTURE "@E 999,999,999.99"
		Else
			@nLin,68 PSAY _nCtaMesc PICTURE "@E 999,999,999.99"
		Endif
		
		@nLin,83  PSAY _nCtaAcm1 PICTURE "@E 999,999,999.99"
		if _nMoeda == 1
			@nLin,98  PSAY _nCtaAcm2 PICTURE "@E 999,999,999.99"
		Else
			@nLin,98  PSAY _nCtaAcmc PICTURE "@E 999,999,999.99"
		Endif
		
		_lImpDad := .t.
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
		_nTotOrig1 += _nCtaOrig1
		_nTotOrig2 += _nCtaOrig2
		_nTotOrig3 += _nCtaOrig3
		_nTotOrigc += _nCtaOrigc
		_nTotOrigu += _nCtaOrigu
		
		_nTotMes1 += _nCtaMes1
		_nTotMes2 += _nCtaMes2
		_nTotMes3 += _nCtaMes3
		_nTotMesc += _nCtaMesc
		_nTotMesu += _nCtaMesu
		
		_nTotAcm1  += _nCtaAcm1
		_nTotAcm2  += _nCtaAcm2
		_nTotAcm3  += _nCtaAcm3
		_nTotAcmc  += _nCtaAcmc
		_nTotAcmu  += _nCtaAcmu
		
		//���������������������������������������������������������������������Ŀ
		//� Finaliza a execucao do relatorio...                                 �
		//�����������������������������������������������������������������������
		
	Enddo
	
	if _nTotOrig1 > 0
		
		@nLin,00  PSAY replicate("-",limite)
		nLin := nLin + 1 // Avanca a linha de impressao
		
		@nLin,22 PSAY _nTotOrig1 PICTURE "@E 999,999,999.99"
		if _nMoeda == 1
			@nLin,37 PSAY _nTotOrig2 PICTURE "@E 999,999,999.99"
		Else
			@nLin,37 PSAY _nTotOrigc PICTURE "@E 999,999,999.99"
		Endif
		
		
		@nLin,53 PSAY _nTotMes1 PICTURE "@E 999,999,999.99"
		if _nMoeda == 1
			@nLin,68 PSAY _nTotMes2 PICTURE "@E 999,999,999.99"
		Else
			@nLin,68 PSAY _nTotMesc PICTURE "@E 999,999,999.99"
		Endif
		
		@nLin,83  PSAY _nTotAcm1 PICTURE "@E 999,999,999.99"
		if _nMoeda == 1
			@nLin,98  PSAY _nTotAcm2 PICTURE "@E 999,999,999.99"
		Else
			@nLin,98  PSAY _nTotAcmc PICTURE "@E 999,999,999.99"
		Endif
		
		nLin := nLin + 1 // Avanca a linha de impressao
		
	Endif
	
	
Endif

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


Static Function CriaPerg(cPerg)

Local _sAlias := Alias()
Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)


// Grupo Ordem Pergunta                          /Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//                                                                              1                                                                      2                                                   3                                              4
//          1     2     3                       4    5    6         7    8   9  0  1    2   3           4            5    6    7    8    9             0   1   2   3   4          5   6   7   8   9        0   1   2   3   4       5   6   7   8      9   0   1   2
AADD(aRegs,{cPerg,"01", "Data Referencia    ?", ".", ".", "mv_ch1", "D", 08, 0, 0, "G", "", "mv_par01", ""         , "" , "" , "" , "" , ""          , "", "", "", "", ""       , "", "", "", "", ""     , "", "", "", "", ""    , "", "", "", ""   , "", "", "", "" })
AADD(aRegs,{cPerg,"02", "Emitir Por         ?", ".", ".", "mv_ch2", "N", 01, 0, 0, "C", "", "mv_par02", "Conta    ", "" , "" , "" , "" , "Bem"       , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", ""   , "", "", "", "" })
AADD(aRegs,{cPerg,"03", "Conta de           ?", ".", ".", "mv_ch3", "C", 20, 0, 0, "G", "", "mv_par03", ""         , "" , "" , "" , "" , ""          , "", "", "", "", ""       , "", "", "", "", ""     , "", "", "", "", ""    , "", "", "", "SI1", "", "", "", "" })
AADD(aRegs,{cPerg,"04", "Conta Ate          ?", ".", ".", "mv_ch4", "C", 20, 0, 0, "G", "", "mv_par04", ""         , "" , "" , "" , "" , ""          , "", "", "", "", ""       , "", "", "", "", ""     , "", "", "", "", ""    , "", "", "", "SI1", "", "", "", "" })
AADD(aRegs,{cPerg,"05", "Bem de             ?", ".", ".", "mv_ch5", "C", 10, 0, 0, "G", "", "mv_par05", ""         , "" , "" , "" , "" , ""          , "", "", "", "", ""       , "", "", "", "", ""     , "", "", "", "", ""    , "", "", "", "SN1", "", "", "", "" })
AADD(aRegs,{cPerg,"06", "Bem Ate            ?", ".", ".", "mv_ch6", "C", 10, 0, 0, "G", "", "mv_par06", ""         , "" , "" , "" , "" , ""          , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", "SN1", "", "", "", "" })
AADD(aRegs,{cPerg,"07", "Tipo               ?", ".", ".", "mv_ch7", "N", 01, 0, 0, "C", "", "mv_par07", "Analitico", "" , "" , "" , "" , "Sintetico" , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", ""   , "", "", "", "" })
AADD(aRegs,{cPerg,"08", "Atualiza Base      ?", ".", ".", "mv_ch8", "N", 01, 0, 0, "C", "", "mv_par08", "Sim      ", "" , "" , "" , "" , "Nao      " , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", ""   , "", "", "", "" })
AADD(aRegs,{cPerg,"09", "Considera Baixas   ?", ".", ".", "mv_ch9", "N", 01, 0, 0, "C", "", "mv_par09", "Sim      ", "" , "" , "" , "" , "Nao      " , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", ""   , "", "", "", "" })
AADD(aRegs,{cPerg,"10", "Moeda 2 (US$)      ?", ".", ".", "mv_chA", "N", 01, 0, 0, "C", "", "mv_par10", "Sistema  ", "" , "" , "" , "" , "Calculado" , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", ""   , "", "", "", "" })


For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

dbSelectArea(_sAlias)

Return nil
