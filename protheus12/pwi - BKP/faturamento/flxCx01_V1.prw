#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 04/09/01

User Function flxCx011()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("CAREA,NORD,NREC,NORDSE5,CSTRING,CDESC1")
SetPrvt("CDESC2,CDESC3,TAMANHO,ARETURN,AORD,NOMEPROG")
SetPrvt("ALINHA,NLASTKEY,TITULO,CABEC1,CABEC2,CCANCEL")
SetPrvt("CPERG,M_PAG,WNREL,CBANCO,CAGENCIA,CCONTA")
SetPrvt("DDATADE,DDATAATE,NSLDINI,NENTRADAS,NSAIDAS,NSALDO")
SetPrvt("NLIN,CPERIODO,NQUANT,CDOC,DDATA,NV_ENT")
SetPrvt("NV_SAI,NCOUNT,CHISTOR,CBENEF,NCOLINI")

/*

Função : flxCx011
Autor  : Elmo Ferreira Teixeira
Data   : 13/01/2004

*/

cArea := Alias()
nOrd  := IndexOrd()
nRec  := Recno()

dbSelectArea("SE5")        // Movimento Bancário
nOrdSE5 := IndexOrd()
dbSetOrder(1)
dbSelectArea("SE8")        // Saldos Bancários
nOrdSE8 := IndexOrd()
dbSetOrder(1)

cString:="SE5"
cDesc1 := OemToAnsi("Este programa tem como objetivo listar o Extrato Bancario  de")
cDesc2 := OemToAnsi("determinado periodo, de acordo com os parametros informados  ")
cDesc3 := OemToAnsi("pelo usuario.                                                ")
tamanho:="G"
aReturn:= { "Zebrado", 1,"Financeiro", 1, 2, 1, "",1 }
aOrd   := {}
nomeprog:= "FlxCx01"
aLinha  := { }
nLastKey := 0

titulo      :="Fluxo de Caixa"

//                       1         2         3         4         5         6         7         8         9         0         1         2         3  
//             0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
cabec1      :="DATA     HISTORICO                                  FAVORECIDO                      CHEQUE                NATUREZA" + space(34)
cabec2      :=""
//             99/99/99 xxxxxXXXXXxxxxxXXXXXxxxxxXXXXXxxxxxXXXXXxxxxxXXXXX xxxxxXXXXXxxxxxXXXXX 9999999999 9,999,999.99 9,999,999.99 9,999,999.99

nColIni := 151

cCancel     := "***** CANCELADO PELO OPERADOR *****"

cPerg       := "FLXCX1"

m_pag := 1  //Variavel que acumula numero da pagina


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Fornecedor + Loja                     ³
//³ mv_par02            // Fatura                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

// Ex.: aPerg[1] := {Pergunta,Tipo,Tamanho,Valor_Padrao,Get/Consulta,aConsulta,cF3}
aPerg := {}
Aadd(aPerg,{"Banco 1          ?","C",18,space(18),"G",,"BCX"})
Aadd(aPerg,{"Banco 2          ?","C",18,space(18),"G",,"BCX"})
Aadd(aPerg,{"Banco 3          ?","C",18,space(18),"G",,"BCX"})
Aadd(aPerg,{"Banco 4          ?","C",18,space(18),"G",,"BCX"})
Aadd(aPerg,{"Data De          ?","D",08,space(08),"G",,})
Aadd(aPerg,{"Data Ate         ?","D",08,space(08),"G",,})
Aadd(aPerg,{"Da Natureza      ?","C",10,space(10),"G",,"SED"})
Aadd(aPerg,{"Ate a Natureza   ?","C",10,"ZZZZZZZZZZ","G",,"SED"})
Aadd(aPerg,{"Descric.Natureza ?","N",01," ","C", {"Portugues","Ingles","","",""},})

AjustaSX1(aPerg)

wnrel:="FlxCaixa"           //Nome Default do relatorio em Disco
wnrel:= SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.f.,tamanho)

Pergunte(cPerg,.f.)

If nLastKey == 27
    Set Filter To
    Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
    Set Filter To
    Return
Endif

cBanco1   := mv_par01    // Banco 1
cBanco2   := mv_par02    // Banco 2
cBanco3   := mv_par03    // Banco 3
cBanco4   := mv_par04    // Banco 4
dDataDe   := mv_par05    // Da Data
dDataAte  := mv_par06    // Da Data
cNgDe     := mv_par07    // Da Data
cNgAte    := mv_par08    // Da Data
nDescNG   := mv_par09    // Descrição da Natureza (1=Portugues ; 2=Ingles)

cCond_P   := GetMV("MV_CNDFLXP")
cCond_R   := GetMV("MV_CNDFLXR")

RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 04/09/01 ==>    RptStatus({|| Execute(RptDetail) })

dbSelectArea("SE5")
dbSetOrder(nOrdSE5)
dbSelectArea("SE8")
dbSetOrder(nOrdSE8)

dbSelectArea(cArea)
dbSetOrder(nOrd)
dbGoto(nRec)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³RptDetail ³ Autor ³ Elmo Ferreira Teixeira³ Data ³ 13.01.04 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Impressao do corpo do relatorio                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/  
Static Function RptDetail()

dbSelectArea("SA6")
dbSetOrder(1)

aBancos := {cBanco1,cBanco2,cBanco3,cBanco4}

aPag    := array(1,len(aBancos)+1)
aRec    := array(1,len(aBancos)+1)
aSaldo  := {}
nNumBco := iif(empty(cBanco2),1,iif(empty(cBanco3),2,iif(empty(cBanco4),3,4)))

For i:=1 to nNumBco //len(aBancos)
	aadd(aSaldo, 0) 
Next

For i:=1 to nNumBco  //len(aBancos)
	cBanco := aBancos[i]
	dbSeek(xFilial('SA6') + cBanco)
	cabec1 := cabec1 + "  " + LEFT(sa6->a6_nreduz ,17)
Next

dbSelectArea("SE5")
dbSeek(xFilial('SE5') + dtos(dDataDe),.t.)

nItem := 1

aDescPag := {}                
aDescRec := {}

aadd(aDescPag , "")
aadd(aDescRec , "")

While !eof() .and. e5_data <= dDataAte

	// Filtrando Natureza de Gastos...

	If e5_naturez < cNgDe .or. e5_naturez > cNgAte
	   dbSkip()
	   Loop
	Endif
	
	// Buscando Natureza
	SED->(dbSeek(xFilial("SED") + se5->e5_naturez))

	cDescNG := iif(nDescNG==1, SED->ED_DESCRIC,SED->ED_DESC2)  	// aqui ! troque a palavra E2_DESCING
																	// pelo nome do campo que armazena a 
																	// descrição da natureza em inglês !

//Data := e5_data

//While !eof() .and. e5_data == dData

  If e5_recpag='P' .and. &(cCond_P)
	
	lGrava := .f.
	nItem := len(aPag)

	// Banco 1
	If e5_banco + e5_agencia + e5_conta == aBancos[1]
		aPag[nItem][1] := iif(e5_tipodoc="CH" .and. e5_situaca="C",-1,1) * e5_valor
		aDescPag[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
		lGrava := .t.
	Else
		aPag[nItem][1] := 0
	Endif

	// Banco 2
	If e5_banco + e5_agencia + e5_conta == aBancos[2]
		aPag[nItem][2] := iif(e5_tipodoc="CH" .and. e5_situaca="C",-1,1) * e5_valor
		aDescPag[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
		lGrava := .t.
	Else
		aPag[nItem][2] := 0
	Endif

	// Banco 3
	If e5_banco + e5_agencia + e5_conta == aBancos[3]
		aPag[nItem][3] := iif(e5_tipodoc="CH" .and. e5_situaca="C",-1,1) * e5_valor
		aDescPag[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
		lGrava := .t.
	Else
		aPag[nItem][3] := 0
	Endif

	// Banco 4
	If e5_banco + e5_agencia + e5_conta == aBancos[4]
		aPag[nItem][4] := iif(e5_tipodoc="CH" .and. e5_situaca="C",-1,1) * e5_valor
		aDescPag[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
		lGrava := .t.
	Else
		aPag[nItem][4] := 0
	Endif

	If lGrava                
		aadd(aDescPag , "")
		aadd(aPag , {0,0,0,0})
	Endif
  Else
     If  &(cCond_R)

		// Recebimentos
        	
		lGrava := .f.
		nItem := len(aRec)

		// Banco 1
		If e5_banco + e5_agencia + e5_conta == aBancos[1]
			aRec[nItem][1] := e5_valor
			aDescRec[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
			lGrava := .t.
		Else
			aRec[nItem][1] := 0
		Endif

		// Banco 2
		If e5_banco + e5_agencia + e5_conta == aBancos[2]
			aRec[nItem][2] := e5_valor
			aDescRec[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
			lGrava := .t.
		Else
			aRec[nItem][2] := 0
		Endif
    	
		// Banco 3
		If e5_banco + e5_agencia + e5_conta == aBancos[3]
			aRec[nItem][3] := e5_valor
			aDescRec[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
			lGrava := .t.
		Else
			aRec[nItem][3] := 0
		Endif

		// Banco 4
		If e5_banco + e5_agencia + e5_conta == aBancos[4]
			aRec[nItem][4] := e5_valor
			aDescRec[nItem] := dtoc(e5_data) + " " + left(e5_histor,40) + " / " + e5_benef + iif(!empty(e5_numcheq)," (CH." + e5_numcheq + ")",space(21)) + iif(!empty(e5_naturez)," - " + "NG:" + e5_naturez+"-"+cDescNG,space(47))
			lGrava := .t.
		Else
			aRec[nItem][4] := 0
		Endif

		If lGrava
			aadd(aDescRec , "")
			aadd(aRec , {0,0,0,0})
		Endif
	Endif
  Endif
  
  dbSkip()

//	End
	
End

nLin := 99
nLin := Cabec(Titulo,Cabec1,Cabec2,nomeprog,tamanho)
nLin := nLin+1

nCol := nColIni

@ nLin, 000 PSAY "Saldos Iniciais"
nI_TotSld := 0

For i:=1 to nNumBco  //len(aBancos)
	cBanco := aBancos[i]
	dbSeek(xFilial('SA6') + cBanco)
	dbSelectArea("SE8")
	xData := dDataDe-1
	dbSeek(xFilial('SE8')+cBanco+dtos(xData),.t.)
	
	nSaldo := 0
	
	If eof()
	   While .t.
	      xData := xData - 1
	      dbSeek(xFilial('SE8')+cBanco+dtos(xData),.t.)
	      If !eof()
	         Exit
	      Endif
	   End
	Endif
	
	If !eof()
	   nSaldo := se8->e8_salatua
	Endif

	@ nLin,nCol PSAY trans(nSaldo , "@e 999,999,999.99")
	nI_TotSld += nSaldo
	nCol += 17
	aSaldo[i] := nSaldo
Next       

nLin := nLin + 1
@ nLin, 000    PSAY "Saldo Inicial Total --> "
@ nLin,nColIni PSAY trans(nI_TotSld , "@e 999,999,999.99")

aTotPag := {0,0,0,0}
aTotRec := {0,0,0,0}

// Recebimentos

nLin := nLin + 2

@ nLin, 000 PSAY "Recebimentos"

nLin := nLin + 2

nItens := len(aRec) //iif(len(aRec)>len(aPag),len(aRec),len(aPag))

SetRegua(nItens) //Ajusta numero de elementos da regua de relatorios

For i:=1 to nItens-1

   If nLin>56
      nLin := Cabec(Titulo,Cabec1,Cabec2,nomeprog,tamanho)
//      nLin := nLin+1
//     @ nLin,117 PSAY trans(nSaldo , "@e 9,999,999.99")
      nLin := nLin+1
   Endif

	@ nLin,000 PSAY aDescRec[i]  // trans(nSaldo , "@e 999,999,999.99")

	nCol := nColIni

	For w:=1 to nNumBco  //4
//      @ nLin,000 PSAY e5_data
//      @ nLin,009 PSAY cHistor
//      @ nLin,060 PSAY cBenef
//      @ nLin,081 PSAY cDoc
//      @ nLin,092 PSAY iif(nV_Ent > 0,trans(nV_Ent,"@e 9,999,999.99")," ")
//      @ nLin,106 PSAY iif(nV_Sai > 0,trans(nV_Sai,"@e 9,999,999.99")," ")
//      nEntradas := nEntradas + nV_Ent
//      nSaidas   := nSaidas   + nV_Sai
//      nSaldo    := nSaldo    + (nV_Ent - nV_Sai)
		@ nLin,nCol PSAY trans(aRec[i][w] , "@e 999,999,999.99")
		nCol += 17
		aTotRec[w] += aRec[i][w]
	Next

	nLin := nLin + 1
   IncRegua() //Incrementa a posicao da regua de relatorios
End

nLin := nLin + 1
nCol := nColIni

@ nLin, 000 PSAY "Totais --> "
nTotR := 0

For w:=1 to nNumBco  //len(aTotRec)
	@ nLin,nCol PSAY trans(aTotRec[w] , "@e 999,999,999.99")
	nCol += 17
	nTotR += aTotRec[w]
Next

nLin := nLin + 1
@ nLin, 000    PSAY "Total Recebimento  --> "
@ nLin,nColIni PSAY trans(nTotR , "@e 999,999,999.99")


// Pagamentos

nLin := nLin + 3

@ nLin, 000 PSAY "Pagamentos"

nLin := nLin + 2

nItens := len(aPag) //iif(len(aRec)>len(aPag),len(aRec),len(aPag))

SetRegua(nItens) //Ajusta numero de elementos da regua de relatorios

For i:=1 to nItens

   If nLin>56
      nLin := Cabec(Titulo,Cabec1,Cabec2,nomeprog,tamanho)
//      nLin := nLin+1
//     @ nLin,117 PSAY trans(nSaldo , "@e 9,999,999.99")
      nLin := nLin+1
   Endif

	@ nLin,000 PSAY aDescPag[i]  // trans(nSaldo , "@e 999,999,999.99")

	nCol := nColIni

	For w:=1 to nNumBco  //4
//      @ nLin,000 PSAY e5_data
//      @ nLin,009 PSAY cHistor
//      @ nLin,060 PSAY cBenef
//      @ nLin,081 PSAY cDoc
//      @ nLin,092 PSAY iif(nV_Ent > 0,trans(nV_Ent,"@e 9,999,999.99")," ")
//      @ nLin,106 PSAY iif(nV_Sai > 0,trans(nV_Sai,"@e 9,999,999.99")," ")
//      nEntradas := nEntradas + nV_Ent
//      nSaidas   := nSaidas   + nV_Sai
//      nSaldo    := nSaldo    + (nV_Ent - nV_Sai)
		@ nLin,nCol PSAY trans(aPag[i][w] , "@e 999,999,999.99")
		nCol += 17                                              
		aTotPag[w] += aPag[i][w]
	Next

	nLin := nLin + 1
   IncRegua() //Incrementa a posicao da regua de relatorios
End

nLin := nLin + 1
nCol := nColIni
nTotP := 0

@ nLin, 000 PSAY "Totais --> "

For w:=1 to nNumBco  //len(aTotPag)
	@ nLin,nCol PSAY trans(aTotPag[w] , "@e 999,999,999.99")
	nTotP  += aTotPag[w]
	nCol += 17
Next

nLin := nLin + 1
@ nLin, 000    PSAY "Total Pagamentos  --> "
@ nLin,nColIni PSAY trans(nTotP , "@e 999,999,999.99")

//nLin := nLin + 2
//@ nLin,00 PSAY __prtThinLine()

//nLin := nLin+3


nLin := nLin + 2
@ nLin,00 PSAY __prtThinLine()
nLin := nLin + 3

@ nLin, 000 PSAY "Saldos Finais"

nCol := nColIni
nTotSld := 0

For i:=1 to nNumBco  //len(aTotPag)

	If nLin>56
		nLin := Cabec(Titulo,Cabec1,Cabec2,nomeprog,tamanho)
		nLin := nLin+1
	Endif

	@ nLin,nCol PSAY trans(aSaldo[i] - aTotPag[i] + aTotRec[i] , "@e 999,999,999.99")
	nTotSld += (aSaldo[i] - aTotPag[i] + aTotRec[i])
	nCol += 17
//   IncRegua() //Incrementa a posicao da regua de relatorios
Next

nLin := nLin + 1
@ nLin, 000    PSAY "Saldo Total --> "
@ nLin,nColIni PSAY trans(nTotSld , "@e 999,999,999.99")

//Roda(0,"","M")

//Set Filter To
If aReturn[5] == 1
    Set Printer To
    Commit
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return



Static Function AjustaSx1(aPerg)

cAlias:=Alias()

// Ex.: aPerg[1] := {Pergunta,Tipo,Tamanho,Valor_Padrao,Get/Consulta,aConsulta,cF3}


For i:=1 to len(aPerg)
   dbSelectArea("SX1")
   cSeq := strzero(i,2)
   If !dbSeek(cPerg+cSeq)
	While !RecLock("SX1",.T.); End
	Replace X1_GRUPO   	with cPerg
       Replace X1_ORDEM        with cSeq
        Replace X1_PERGUNT      with aPerg[i][1]
        Replace X1_VARIAVL      with "mv_ch"+str(i,1)
        Replace X1_TIPO         with aPerg[i][2]
        Replace X1_TAMANHO      with aPerg[i][3]
        Replace X1_GSC          with aPerg[i][5]
        Replace X1_VAR01        with "mv_par"+cSeq
        Replace X1_CNT01        With aPerg[i][4]
        If aPerg[i][5] == "C"
           Replace X1_PRESEL with 1
           Replace X1_DEF01     With aPerg[i][6][1]
           Replace X1_DEF02     With aPerg[i][6][2]
           Replace X1_DEF03     With aPerg[i][6][3]
           Replace X1_DEF04     With aPerg[i][6][4]
           Replace X1_DEF05     With aPerg[i][6][5]
        Endif
        If Valtype(aPerg[i][7]) ="C"
	        Replace X1_F3          with aPerg[i][7]
        Endif
        MsUnlock()
   EndIf
Next

dbSelectArea(cAlias)
Return
