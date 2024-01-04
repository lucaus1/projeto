#Include "RwMake.ch"
#Include "topconn.ch"        


/*
Desenvolvedor: Ellcyo Castro
Data.........: 20/11/2006
Objetivo.....: Relatório Analítico de Contas a Receber
*************************************************************************************************************************************
** Alterações * Favor Adicionar Todas as Alteração Realizadas ***********************************************************************
*************************************************************************************************************************************
|Data			 | Programador				| Alteração
*************************************************************************************************************************************
|            |                      |
*************************************************************************************************************************************/

User Function PTRELF01()
	Local cString := "SA1"
	Local Tamanho := "G"
	Local wnRel   := "PTRELF"
	Local cDesc1  := ""
	Local cDesc2  := ""
	Local cDesc3  := ""
	
	Private aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
	Private aLinha      := {}
	Private aPerg       := {}
	Private nLastKey    := 0
	
	Private _cEndereco  := ""
	Private _cEmpresa   := ""
	Private _cSeparacao := Replicate("-",202)
	Private _cSituacao  := ""
	Private _cQuery     := ""
	
	Private _cFilial     := ""
	Private _cFilial2    := ""
	
	Private Titulo      := "POSICAO DE TITULOS A RECEBER"
	Private NomeProg    := "PTRELF"
	Private cPerg       := "PTRELF"
	Private aOrd        := {}
	
	//- Defindo grupo de perguntas
	dbSelectArea("SX1")
	dbSetOrder(1)
	//- Defindo grupo de perguntas
	aAdd(aPerg, {cPerg, "01", "Data Inicial ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
	aAdd(aPerg, {cPerg, "02", "Data Final   ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
	aAdd(aPerg, {cPerg, "03", "Cliente de   ?","mv_ch3","C",06,0,1,"G","","mv_par03","","SA1","","","","","","","","","","","","",""})
	aAdd(aPerg, {cPerg, "04", "Cliente Ate  ?","mv_ch4","C",06,0,1,"G","","mv_par04","","SA1","","","","","","","","","","","","",""})
	aAdd(aPerg, {cPerg, "05", "Tipo         ?","mv_ch5","N",01,0,1,"C","","mv_par05","Analitico","","","","","Sintetico","","","","","","","","",""})
	
	//- Gravando grupo de perguntas
	For nA:= 1 To Len(aPerg)
		If !(dbSeek(cPerg+aPerg[nA,2]))
			RecLock("SX1",.t.)
			Replace X1_GRUPO    with aPerg[nA][1]
			Replace X1_ORDEM    with aPerg[nA][2]
			Replace X1_PERGUNT  with aPerg[nA][3]
			Replace X1_PERSPA   with aPerg[nA][3]
			Replace X1_PERENG   with aPerg[nA][3]
			Replace X1_VARIAVL  with aPerg[nA][4]
			Replace X1_TIPO     with aPerg[nA][5]
			Replace X1_TAMANHO  with aPerg[nA][6]
			Replace X1_GSC      with aPerg[nA][9]
			Replace X1_DECIMAL  with aPerg[nA][7]
			Replace X1_PRESEL   with aPerg[nA][8]
			Replace X1_DEF01    with aPerg[nA][12]
			Replace X1_DEF02    with aPerg[nA][15]
			Replace X1_DEFSPA1  with aPerg[nA][12]
			Replace X1_DEFSPA2  with aPerg[nA][15]
			Replace X1_DEFENG1  with aPerg[nA][12]
			Replace X1_DEFENG2  with aPerg[nA][15]
			Replace X1_F3       with aPerg[nA][13]
			MsUnlock()
		Endif
	Next
	
	Pergunte(cPerg,.F.)
	
	wnRel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)
	
	wnrel := "PTRELF" //- Nome Default do relatorio em Disco
	
	If nLastKey = 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey = 27
		Return
	Endif
	
	RptStatus({|lEnd| PTRELFIMP(@lEnd,wnRel,cString)},titulo)
Return


Static Function PTRELFIMP(lEnd,wnRel,cString)
	Local c_Arq, c_Ind, c_Key
	Local aStru    := {}
	Local Tamanho  := "G"
	Local Limite   := 132
	Local lContinua:= .t.,nTipo, n_Total
	Local Nomeprog := "PTRELF"               
	
	lFlag = .F. 
	
	SetPrvt("nComp,nNorm,p_negrit_l,p_reset,p_negrit_d")
	p_negrit_l:= "E"
	p_reset:= "@"
	p_negrit_d:= "F"
	
	nTipo := Iif(aReturn[4]=1,15,18)
	m_pag := 1
	li    := 80
	If mv_par05 = 1
		Titulo:= "POSICAO DOS TITULOS A RECEBER - POR CLIENTE - ANALITICO"
	Else
		Titulo:= "POSICAO DOS TITULOS A RECEBER - POR CLIENTE - SINTETICO"
	Endif
	
	
	nNorm:= GetMV("MV_NORM")
	
	//***************************************************************************************
	// Validação do Cabeçalho do Relatório
	_cEmpresa  := SM0->M0_NOMECOM
	_cEndereco := SM0->M0_ENDCOB
	_cCNPJ     := SM0->M0_CGC
	//*****************************************************************************************************************
	//** Final do Procedimento ****************************************************************************************
	//*****************************************************************************************************************

	_cQuery := "SELECT COUNT(*) QUANT "
	_cQuery += "FROM SE1010, SA1010 "
	_cQuery += "WHERE E1_CLIENTE = A1_COD AND E1_SALDO > 0 AND "
	_cQuery += "SE1010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "E1_CLIENTE BETWEEN '" + AllTrim(mv_par03) + "' AND '" + AllTrim(mv_par04) + "' AND "
	_cQuery += "E1_VENCREA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
	TcQuery _cQuery New Alias qQTD

	
	_cQuery := "SELECT A1_COD, A1_LOJA, A1_NOME, SE1010.* "
	_cQuery += "FROM SE1010, SA1010 "
	_cQuery += "WHERE E1_CLIENTE = A1_COD AND E1_SALDO > 0 AND "
	_cQuery += "SE1010.D_E_L_E_T_ <> '*' AND "
	_cQuery += "E1_CLIENTE BETWEEN '" + AllTrim(mv_par03) + "' AND '" + AllTrim(mv_par04) + "' AND "
	_cQuery += "E1_VENCREA BETWEEN '" + DtoS(mv_par01) + "' AND '" + DtoS(mv_par02) + "' "
	_cQuery += "ORDER BY A1_NOME, E1_VENCREA DESC, E1_PREFIXO, E1_NUM "
	TcQuery _cQuery New Alias qSE1
	
	
	
	
	_nPg := 0
	_cGrupo := ""
	_nVal01 := 0
	_nVal02 := 0
	_nVal03 := 0
	_nVal04 := 0
	_nVal05 := 0
	
	_nTot01 := 0
	_nTot02 := 0
	_nTot03 := 0
	_nTot04 := 0
	_nTot05 := 0
	
	_nAtraso := 0
	aVetor := {}
	aPrazo := {}
	
	aAdd(aPrazo, {"    30", 0, 0, 0})
	aAdd(aPrazo, {"    60", 0, 0, 0})
	aAdd(aPrazo, {"    90", 0, 0, 0})
	aAdd(aPrazo, {"   180", 0, 0, 0})
	aAdd(aPrazo, {">  180", 0, 0, 0})
	
	_nCount := 0
	
	dbSelectArea("qSE1")
	SetRegua(qQTD->QUANT)
	dbGotop()
	
	Do While !Eof()
		If lEnd
			@Prow()+1,001 PSay OemToAnsi("Cancelado pelo operador")
			lContinua := .F.
			Exit
		Endif
		
		If li > 58
			_nPg++
			
			// Inicio da Impressao
			@0, 000 PSay Chr(18)
			//@0, 000 PSay aValImp(132)
			@0, 000 PSay "Empresa..: " + _cEmpresa
			@0, 175 PSay "Pagina.:         " + str(_nPg, 8)
			@1, 000 PSay "Endereco.: " + _cEndereco
			@1, 175 PSay "Emissao: "
			@1, 194 PSay Date()
			@2, 000 PSay "CNPJ.....: " + _cCNPJ
			@2, 175 PSay "Hora...: "
			@2, 194 PSay Time()
			@3, 100 PSay "Periodo de:"     
			@3, 112 PSay mv_par01
			@3, 122 PSay " a "
			@3, 128 PSay mv_par02
			@4, 088 PSay "Posicao dos Titulos a Receber - Por Cliente - Analitico"
			@5, 000 PSay _cSeparacao
			
			@6, 000 PSay "Codigo-Lj-Nome do Cliente   Prf-Numero   TP Natureza  Data de   Vencto    Vencto    Banco Valor Original |      Titulos Vencidos       |Titulos a Vencer| Num     Vlr.juros ou  Dias   Historico"
			@7, 000 PSay "                            Parcela                   Emissao   Titulo    Real                           |Valor Nominal Valor Corrigido|  Valor Nominal | Banco    permanencia  Atraso "
			//            000000 01 99999999999999999 AAA-000000-A NF 111111    99/99/99  99/99/99  99/99/99    999 999.999.999,99  99.999.999,99   99.999.999,99   999.999.999,99  999   999.999.999,99   00000 AAAAAAAAAAAAAAAAAAAA
			//            01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
			//            0         1         2         3         4         5         6         7         8         9       100       110       120       130       140       150       160       170       180       190       200
			@8, 000 PSay _cSeparacao                                                                                                                                                                                                 
			li := 9
		Endif
		
		@li, 000 PSay PadR(qSE1->A1_COD, 6) + "-"
		@li, 007 PSay qSE1->A1_LOJA + "-"
		@li, 010 PSay PadR(qSE1->A1_NOME, 17)
		@li, 028 PSay qSE1->E1_PREFIXO + "-" + qSE1->E1_NUM + "-" + qSE1->E1_PARCELA
		@li, 041 PSay qSE1->E1_TIPO
		@li, 044 PSay qSE1->E1_NATUREZ
		@li, 054 PSay DtoC(StoD(qSE1->E1_EMISSAO))
		@li, 064 PSay DtoC(StoD(qSE1->E1_VENCTO))
		@li, 074 PSay DtoC(StoD(qSE1->E1_VENCREA))
		@li, 086 PSay qSE1->E1_PORTADO
		@li, 090 PSay Transform(qSE1->E1_VALOR, "@E 999,999,999.99")
		_nVal01 += qSE1->E1_VALOR
		
		If Date() > StoD(qSE1->E1_VENCREA)
			lFlag := .T.
			_nAtraso := Date() - StoD(qSE1->E1_VENCREA) 
		Else
			lFlag := .F.
			_nAtraso := 0
		EndIf

		If lFlag
			@li, 106 PSay Transform(qSE1->E1_SALDO, "@E 99,999,999.99")
			@li, 122 PSay Transform(qSE1->E1_SALDO + (qSE1->E1_MULTA + qSE1->E1_JUROS + qSE1->E1_CORREC), "@E 99,999,999.99")
			@li, 140 PSay "              "
			_nVal02 += qSE1->E1_SALDO
			_nVal03 += qSE1->E1_SALDO + (qSE1->E1_MULTA + qSE1->E1_JUROS + qSE1->E1_CORREC)
			
			_nPos := 0
			_nPos := aScan(aVetor, {|x| x[1] == _nAtraso })
			
			if _nPos != 0
				aVetor[_nPos, 2] += qSE1->E1_VALOR		
				aVetor[_nPos, 3] += qSE1->E1_SALDO		
				aVetor[_nPos, 4] += qSE1->E1_SALDO + (qSE1->E1_MULTA + qSE1->E1_JUROS + qSE1->E1_CORREC)		
			else
				aAdd(aVetor, {_nAtraso, qSE1->E1_VALOR, qSE1->E1_SALDO, qSE1->E1_SALDO + (qSE1->E1_MULTA + qSE1->E1_JUROS + qSE1->E1_CORREC)})
			EndIf 
		Else
			@li, 106 PSay "             "
			@li, 122 PSay "             "
			@li, 140 PSay Transform(qSE1->E1_SALDO, "@E 99,999,999.99")
			_nVal04 += qSE1->E1_SALDO
		EndIf
		
		@li, 154 PSay PadR(qSE1->E1_NUMBCO, 3)
		@li, 160 PSay Transform(qSE1->E1_MULTA + qSE1->E1_JUROS + qSE1->E1_CORREC, "@E 999,999,999.99")
		
		If lFlag
			@li, 177 PSay Transform(Date() - StoD(qSE1->E1_VENCREA), "@E 99999")
		Else
			@li, 177 PSay ""
		Endif
		
		@li, 183 PSay PadR(qSE1->E1_HIST, 20)
		
		_cGrupo := qSE1->A1_COD
		
		
		li++
		_nCount++
		
		
		IncRegua()
		dbSkip()
		
		If _cGrupo != qSE1->A1_COD
			@li, 0   PSay _cSeparacao
			li++
			@li, 0  PSay Posicione("SA1",1,xFilial()+_cGrupo,"A1_NOME")
			@li, 54 PSay "Loja - " + Posicione("SA1",1,xFilial()+_cGrupo,"A1_LOJA") 
			
			_nVal05 := _nVal03 + _nVal04
			
			@li, 090 PSay Transform(_nVal01, "@E 999,999,999.99")
			@li, 106 PSay Transform(_nVal02, "@E  99,999,999.99")
			@li, 122 PSay Transform(_nVal03, "@E  99,999,999.99")
			@li, 140 PSay Transform(_nVal04, "@E 999,999,999.99")
			@li, 188 PSay Transform(_nVal05, "@E 999,999,999.99")

			_nTot01 += _nVal01
			_nTot02 += _nVal02
			_nTot03 += _nVal03
			_nTot04 += _nVal04
			_nTot05 += _nVal05

			li++
			@li, 0   PSay _cSeparacao
			li++
			li++
			_cGrupo := qSE1->A1_COD
			_nVal01 := 0
			_nVal02 := 0
			_nVal03 := 0
			_nVal04 := 0
			_nVal05 := 0
		EndIf	
	Enddo
	@li, 0  PSay "T O T A L   G E R A L  ----> ("+ Str(_nCount) +" MOVIMENTACOES)"
	@li, 090 PSay Transform(_nTot01, "@E 999,999,999.99")
	@li, 106 PSay Transform(_nTot02, "@E  99,999,999.99")
	@li, 122 PSay Transform(_nTot03, "@E  99,999,999.99")
	@li, 140 PSay Transform(_nTot04, "@E 999,999,999.99")
	@li, 188 PSay Transform(_nTot05, "@E 999,999,999.99")
	
	
	
	_nTotV01 := 0
	_nTotV02 := 0
	_nTotV03 := 0
	
	aSort(aVetor,,,{|y,x| y[1] < x[1] })
	
	For i := 1 To Len(aVetor)
		if aVetor[i, 1] < 31
			aPrazo[1, 2] += aVetor[i, 2]
			aPrazo[1, 3] += aVetor[i, 3]
			aPrazo[1, 4] += aVetor[i, 4]
		elseIf aVetor[i, 1] < 61
			aPrazo[2, 2] += aVetor[i, 2]
			aPrazo[2, 3] += aVetor[i, 3]
			aPrazo[2, 4] += aVetor[i, 4]
		elseIf aVetor[i, 1] < 91
			aPrazo[3, 2] += aVetor[i, 2]
			aPrazo[3, 3] += aVetor[i, 3]
			aPrazo[3, 4] += aVetor[i, 4]
		elseIf aVetor[i, 1] < 181
			aPrazo[4, 2] += aVetor[i, 2]
			aPrazo[4, 3] += aVetor[i, 3]
			aPrazo[4, 4] += aVetor[i, 4]
		else
			aPrazo[5, 2] += aVetor[i, 2]
			aPrazo[5, 3] += aVetor[i, 3]
			aPrazo[5, 4] += aVetor[i, 4]
		Endif
	Next
	
	li := 80
	For i := 1 to Len(aPrazo)
		If li > 58
			@li, 070 PSay "+------------------------------------------------------------------------+ -> Continua >>"

			_nPg++


			// Inicio da Impressao
			@0, 000 PSay Chr(18)
			//@0, 000 PSay aValImp(132)
			@0, 000 PSay "Empresa..: " + _cEmpresa
			@0, 175 PSay "Pagina.:         " + str(_nPg, 8)
			@1, 000 PSay "Endereco.: " + _cEndereco
			@1, 175 PSay "Emissao: "
			@1, 194 PSay Date()
			@2, 000 PSay "CNPJ.....: " + _cCNPJ
			@2, 175 PSay "Hora...: "
			@2, 194 PSay Time()
			@3, 090 PSay "Periodo de:"     
			@3, 102 PSay mv_par01
			@3, 112 PSay " a "
			@3, 118 PSay mv_par02
			@4, 000 PSay _cSeparacao
			@6, 070 PSay "+------------------------------------------------------------------------+"
			@7, 070 PSay "|                      R E S U M O   D E   A T R A S O S                 |"
			@8, 070 PSay "+------------------------------------------------------------------------+"
			@9, 070 PSay "|   DIAS   |   VALOR ORIGINAL   |   VALOR NOMINAL  |   VALOR CORRIGIDO   |"
			@10,070 PSay "+----------+--------------------+------------------+---------------------+"
			li := 11
		Endif


		@li, 070 PSay "|  "+ aPrazo[i, 1] +"  |     "+ Transform(aPrazo[i, 2], "@E 999,999,999.99") +" |   "+ Transform(aPrazo[i, 3], "@E 999,999,999.99") +" |      "+ Transform(aPrazo[i, 4], "@E 999,999,999.99") +" |"
		_nTotV01 += aPrazo[i, 2]
		_nTotV02 += aPrazo[i, 3]
		_nTotV03 += aPrazo[i, 4]
		li++
	Next
	@li, 070 PSay "+----------+--------------------+------------------+---------------------+" ; li++
	@li, 070 PSay "| TOTAL -->|     "+ Transform(_nTotV01, "@E 999,999,999.99") +" |   "+ Transform(_nTotV02, "@E 999,999,999.99") +" |      "+ Transform(_nTotV03, "@E 999,999,999.99") +" |" ; li++
	@li, 070 PSay "+------------------------------------------------------------------------+"
	
	
	Set Device to Screen
	
	If aReturn[5] = 1
		Set Printer To
		Commit
		Ourspool(wnrel)
	Endif
	MS_FLUSH()
	
	qSE1->(dbCloseArea())
	qQTD->(dbCloseArea())

Return


/*
+------------------------------------------------------------------------+
|                      R E S U M O   D E   A T R A S O S                 |
+------------------------------------------------------------------------+
|   DIAS   |   VALOR ORIGINAL   |   VALOR NOMINAL  |   VALOR CORRIGIDO   |
+----------+--------------------+------------------+---------------------+
|  000000  |     999,999,999.99 |   999,999,999.99 |      999,999,999,99 |
|  000000  |     999,999,999.99 |   999,999,999.99 |      999,999,999,99 |
|  000000  |     999,999,999.99 |   999,999,999.99 |      999,999,999,99 |
+----------+--------------------+------------------+---------------------+
| TOTAL -->|     999,999,999.99 |   999,999,999.99 |      999,999,999.99 |
+------------------------------------------------------------------------+
*/

