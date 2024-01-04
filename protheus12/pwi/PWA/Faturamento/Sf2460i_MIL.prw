#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/05/01

User Function Sf2460i()        // incluido pelo assistente de conversao do AP5 IDE em 19/05/01
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
	//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
	//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
	//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SetPrvt("_CALIAS,_CRECNO,CFO,CRECSD2,MDOC,MSER")
	SetPrvt("CRECSF2,MPROD,MNPED,MITEM,NCHAPA,NUMP")
	SetPrvt("VALPARC,NUMPED,DTEMISSAO,MOEDA,TAXA,TIPOCLI")
	
	// adaptacoes para mil : Franciney Alves
	_calias:= Alias()
	_crecno:= recno()
	nOrdSC5 := 0
	nOrdSc6 := 0
	 // COMPLEMENTO DE DADOS DA NOTA  -> SELO FISCAL E PLACA DO VEICULO
	 @0,0 TO 380,520 DIALOG oDlg5 TITLE "Dados Complementares da Nota Fiscal"
	 // @10,10 BITMAP SIZE 110,40 FILE "F:\SIGAADV\WINADS\RDDEMO.BMP"
	 @60,5 TO 165,255
	 @075,010 Say " Este programa tem como objetivo complementar "
	 @085,010 Say " os seguintes dados da nota fiscal de saida   "
	 @095,010 Say " Placa  da  Cavalo e da Carreta               "
	 @105,010 Say " e Numero e Serie do Selo  Fiscal             "
	 @172,120 BMPBUTTON TYPE 5 ACTION Pergunte("DADCNF    ",.T.)  // busca pergunta no SX1
	 @172,160 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 19/05/01 ==>  @172,160 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
	 @172,190 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
	 ACTIVATE DIALOG oDlg5
	  
Return()        // incluido pelo assistente de conversao do AP5 IDE em 19/05/01

// Substituido pelo assistente de conversao do AP5 IDE em 19/05/01 ==> Function OkProc
Static Function OkProc()
	Close(oDlg5)
	Pergunte("DADCNF    ",.F.)
	
	Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 19/05/01 ==> Processa( {|| Execute(RunProc) } )
Return NIL

// Substituido pelo assistente de conversao do AP5 IDE em 19/05/01 ==> Function RunProc
Static Function RunProc()
	_calias:=Alias()
	_crecno:=recno()
	
	Pergunte("DADCNF    ",.F.)
	dbSelectArea('SF2')
	  if Reclock("SF2",.f.)//rlock()
		if !empty(mv_par01).and.!empty(mv_par02)
			replace F2_PLACACV with mv_par01
			replace F2_ESTCV   with mv_par02
			replace F2_PLACACT with mv_par03
			replace F2_ESTCT   with mv_par04
			
		Endif
		// condicao par trocar a placa do veiculo em branco
		if mv_par05==1
			replace F2_PLACACV with mv_par01
			replace F2_ESTCV   with mv_par02
			replace F2_PLACACT with mv_par03
			replace F2_ESTCT   with mv_par04
		endif
		if !empty(mv_par06).and.!empty(mv_par07)
			replace F2_NUSELOF with mv_par06
			replace F2_SERIESF with mv_par07
		endif
		if !empty(mv_par08).and.!empty(mv_par09)
			REPLACE F2_DATASNF WITH mv_par08
			REPLACE F2_HORASNF WITH mv_par09
		endif
		if !empty(mv_par10) // Numero de Containers
			REPLACE f2_ncontai WITH mv_par10+mv_par11+mv_par12
		endif
		msUnlock()
	  endif
	
	dbSelectArea("SC6")
	nOrdSc6 := indexord()
	DbSetOrder(4)
	DbSeek(xFilial("SC6")+SF2->F2_DOC+SF2->F2_SERIE)
	
	IF FOUND()
	
	  NumPed:=SC6->C6_NUM
	  
	  dbSelectArea("SC5")
	  nOrdSC5 := Indexord()
	  DbSetOrder(1)
	  DbSeek(xFilial("SC5")+NumPed)
	  TAXA:= 0.000
	                                          `
	  IF FOUND()
	    DtEmissao := DATE()
	    MOEDA:=0
        TIPOCLI:=Alltrim(SC5->C5_TIPOCLI)
	    DtEmissao:=SC5->C5_EMISSAO
        MOEDA:=SC5->C5_MOEDA
	    
	    dbSelectArea("SM2")
	    DbSetOrder(1)
	    DbSeek(DtEmissao)
	    TAXA:= 0.000
	
	    IF FOUND()
	       DO CASE
	          CASE TIPOCLI=='X'
                TAXA:=SM2->M2_MOEDA3
	       ENDCASE
	    ELSE
	      TAXA:=0
	    ENDIF  

          dbSelectArea("SF2")	      
	      if Reclock("SF2",.f.)
	         REPLACE F2_TXCAMB WITH TAXA
	         REPLACE F2_INVOICE WITH MV_PAR13
	         
	         msUnlock()
	      ENDIF
	  
	  ENDIF

	Endif

	IF MV_PAR13!=""
		dbSelectArea("SE1")
		dbSetOrder(1)
		dbGoTop()   
    	dbSeek(xFilial("SE1")+SF2->F2_SERIE+SF2->F2_DOC)
		While !Eof()
			If SE1->E1_SERIE = SF2->F2_SERIE .and. SE1->E1_NUM = SF2->F2_DOC
				Reclock("SE1",.f.)
				REPLACE E1_INVOICE WITH MV_PAR13
				msUnlock()
			Endif
			dbSkip()
		enddo
    Endif
	

	
	dbSelectArea("SC5")
	dbSetOrder(nOrdSC5)
	
	dbSelectArea("SC6")
	dbSetOrder(nOrdSC6)
	
	dbSelectArea(_calias)
	dbGoto(_crecno)
	
Return