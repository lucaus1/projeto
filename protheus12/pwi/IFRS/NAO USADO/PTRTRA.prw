#include "fivewin.ch"    
#include "topconn.ch"


User Function PTRTRA()
	Private	lEnd := .f.
	Private _cQuery := ""
	Private _cGrupo :=""
	Private _cSuper :=""
	Private _STConRs := 0
    Private _STConUs := 0
	Private _STAjuRs := 0
    Private _STAjuUs := 0
	Private _STEliRs := 0
    Private _STEliUs := 0
	Private _STPwaRs := 0
    Private _STPwaUs := 0
   	Private _STMadRs := 0
    Private _STMadUs := 0
   	Private _STCilRs := 0
    Private _STCilUs := 0
    Private _Cambio  := 0
    Private _Pagina  := 1
	Private _DataC   := GetMV("MV_DATAOLS") 
	Private qOLS     := ""
	Private nLastKey    := 0	
    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PTRTRA"

  	dbSelectArea("SX1")
  	dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data de      ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Data ate     ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Conta de     ?","mv_ch3","C",20,0,1,"G","","mv_par03","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Conta Ate    ?","mv_ch4","C",20,0,1,"G","","mv_par04","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Tx.Cambio    ?","mv_ch5","N",14,2,1,"G","","mv_par05","","","","","","","","","","","","","","",""})
 
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
			MsUnlock()
		Endif
	Next

  	if Pergunte(cPerg, .T.)
		//³Executa a rotina de impressao ³
		Processa({ |lEnd| xPrintRel(), OemToAnsi("Gerando o relatório.")}, OemToAnsi("Aguarde..."))
	Endif

	//³Restaura a area anterior ao processamento. !³
//	RestArea(aAreaZT1)
Return

Static Function xPrintRel()
	oPrint		:= TMSPrinter():New(OemToAnsi("Relatorio de OLS"))
	oBrush		:= TBrush():New(,4)
	oPen		:= TPen():New(0,5,CLR_BLACK)
	cFileLogo	:= GetSrvProfString("Startpath","") + "LOGORECH02" + ".BMP"
	oFont06		:= TFont():New("Arial",06,06,,.F.,,,,.T.,.F.)
	oFont07		:= TFont():New("Arial",07,07,,.F.,,,,.T.,.F.)
	oFont07n	:= TFont():New("Arial",07,07,,.T.,,,,.T.,.F.)
	oFont08		:= TFont():New("Arial",08,08,,.F.,,,,.T.,.F.)
	oFont08n	:= TFont():New("Arial",08,08,,.T.,,,,.T.,.F.)
	oFont09		:= TFont():New("Arial",09,09,,.F.,,,,.T.,.F.)
	oFont10		:= TFont():New("Arial",10,10,,.F.,,,,.T.,.F.)
	oFont10n	:= TFont():New("Arial",10,10,,.T.,,,,.T.,.F.)
	oFont11		:= TFont():New("Arial",11,11,,.F.,,,,.T.,.F.)
	oFont12		:= TFont():New("Arial",12,12,,.T.,,,,.T.,.F.)
	oFont12n	:= TFont():New("Arial",12,12,,.F.,,,,.T.,.F.)
	oFont13		:= TFont():New("Arial",13,13,,.T.,,,,.T.,.F.)
	oFont14		:= TFont():New("Arial",14,14,,.T.,,,,.T.,.F.)
	oFont15		:= TFont():New("Arial",15,15,,.T.,,,,.T.,.F.)
	oFont18		:= TFont():New("Arial",18,18,,.T.,,,,.T.,.T.)
	oFont16		:= TFont():New("Arial",16,16,,.T.,,,,.T.,.F.)
	oFont20		:= TFont():New("Arial",20,20,,.F.,,,,.T.,.F.)
	oFont22		:= TFont():New("Arial",22,22,,.T.,,,,.T.,.F.)
	
	lFlag       := .t.	// Controla a impressao do fornecedor
	nLinha		:= 3000	// Controla a linha por extenso
	nLinFim		:= 0		// Linha final para montar a caixa dos itens
	lPrintDesTab:= .f.	// Imprime a Descricao da tabela (a cada nova pagina)
	cRepres		:= Space(80)
/*	
	_nQtdReg	:= 0		// Numero de registros para intruir a regua
	_nValMerc 	:= 0		// Valor das mercadorias
	_nValIPI	:= 0		// Valor do I.P.I.
	_nValDesc	:= 0		// Valor de Desconto
	_nTotAcr	:= 0		// Valor total de acrescimo
	_nTotSeg	:= 0		// Valor de Seguro
	_nTotFre	:= 0		// Valor de Frete
	_nTotIcmsRet:= 0		// Valor do ICMS Retido
	*/
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define que a impressao deve ser RETRATO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oPrint:SetPortrait()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define que a impressao deve ser PAISAGEM³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SetLandScape()
	_cQuery := " SELECT ZT1_CONTA,ZT1_DESC,ZT1_CTASUP,ZT1_TIPO, "
	
    _cQuery += " (SELECT SUM(I2_VALOR) FROM SI2010,SI1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " I1_CODIGO=I2_DEBITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
    _cQuery += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
    _cQuery += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "

    _cQuery += " (SELECT SUM(I2_VALOR) FROM SI1010,SI2010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " I1_CODIGO=I2_CREDITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
    _cQuery += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
    _cQuery += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') SLDCPWA, "

    _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01'  "
    _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "

    _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01'  "
    _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "

    _cQuery += " -(SELECT SUM(I1_SALANT) FROM SI1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " SI1010.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPWA, "

    _cQuery += " (SELECT SUM(I2_VALOR) FROM SI2040,SI1040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " I1_CODIGO=I2_DEBITO AND SI1040.D_E_L_E_T_<>'*' AND SI2040.D_E_L_E_T_<>'*' AND "
    _cQuery += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
    _cQuery += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "

    _cQuery += " (SELECT SUM(I2_VALOR) FROM SI1040,SI2040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " I1_CODIGO=I2_CREDITO AND SI1040.D_E_L_E_T_<>'*' AND SI2040.D_E_L_E_T_<>'*' AND "
    _cQuery += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
    _cQuery += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "

    _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
    _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD, "

    _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
    _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "

    _cQuery += " -(SELECT SUM(I1_SALANT) FROM SI1040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " SI1040.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAMAD, "

    _cQuery += " (SELECT SUM(I2_VALOR) FROM SI2020,SI1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " I1_CODIGO=I2_DEBITO AND SI1020.D_E_L_E_T_<>'*' AND SI2020.D_E_L_E_T_<>'*' AND "
    _cQuery += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
    _cQuery += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "

    _cQuery += " (SELECT SUM(I2_VALOR) FROM SI1020,SI2020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " I1_CODIGO=I2_CREDITO AND SI1020.D_E_L_E_T_<>'*' AND SI2020.D_E_L_E_T_<>'*' AND "
    _cQuery += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
    _cQuery += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "

    _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02' "
    _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL, "
    
    _cQuery += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
    _cQuery += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL, "

    _cQuery += " -(SELECT SUM(I1_SALANT) FROM SI1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
    _cQuery += " SI1020.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SACIL "
    
    _cQuery += " FROM ZT1060 WHERE ZT1_TIPO='A' AND ZT1_CONTA BETWEEN '"+ Alltrim(MV_PAR03) +"' AND '"+ Alltrim(MV_PAR04) +"' AND "
    _cQuery += " ZT1060.D_E_L_E_T_<>'*' ORDER BY ZT1_CTASUP,ZT1_CONTA "

	TcQuery _cQuery Alias qOLS new
		
	nContador := 1
	
	ProcRegua( 500 )
	_Cambio := MV_PAR05
	While (!qOLS->(Eof()))
		
		xVerPag()
		
		If	( lFlag )
			lFlag := .f.
		EndIf                                            
		
		If	( lPrintDesTab )
		EndIf

		//DESCRICAO E CONTA OLS
		oPrint:Say(nLinha,0050, PadR(qOLS->ZT1_DESC,50), oFont07)
		oPrint:Say(nLinha,0610, PadR(qOLS->ZT1_CONTA,6), oFont07)

		//IFRS
			oPrint:Say(nLinha,0760, Transform(((qOLS->SLDDPWA - qOLS->SLDCPWA)+(qOLS->AJUDPWA - qOLS->AJUCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+(qOLS->AJUDCIL - qOLS->AJUCCIL) + qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD)+(qOLS->AJUDMAD - qOLS->AJUCMAD) + qOLS->SAMAD), "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,0960, PadR(Transform((((qOLS->SLDDPWA - qOLS->SLDCPWA)+(qOLS->AJUDPWA - qOLS->AJUCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+(qOLS->AJUDCIL - qOLS->AJUCCIL) + qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD)+(qOLS->AJUDMAD - qOLS->AJUCMAD) + qOLS->SAMAD))/_Cambio, "@E 999,999,999"), 14), oFont07)
			_STConRs += ((qOLS->SLDDPWA - qOLS->SLDCPWA)+(qOLS->AJUDPWA - qOLS->AJUCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+(qOLS->AJUDCIL - qOLS->AJUCCIL) + qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD)+(qOLS->AJUDMAD - qOLS->AJUCMAD) + qOLS->SAMAD)
			_STConUs += (((qOLS->SLDDPWA - qOLS->SLDCPWA)+(qOLS->AJUDPWA - qOLS->AJUCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+(qOLS->AJUDCIL - qOLS->AJUCCIL) + qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD)+(qOLS->AJUDMAD - qOLS->AJUCMAD) + qOLS->SAMAD))/_Cambio
		//AJUSTES 
			oPrint:Say(nLinha,1160, Transform((qOLS->AJUDPWA - qOLS->AJUCPWA)+(qOLS->AJUDMAD - qOLS->AJUCMAD)+(qOLS->AJUDCIL - qOLS->AJUCCIL), "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,1360, Transform(((qOLS->AJUDPWA - qOLS->AJUCPWA)+(qOLS->AJUDMAD - qOLS->AJUCMAD)+(qOLS->AJUDCIL - qOLS->AJUCCIL))/_Cambio, "@E 999,999,999"), oFont07)
			_STAjuRs += (qOLS->AJUDPWA - qOLS->AJUCPWA)+(qOLS->AJUDMAD - qOLS->AJUCMAD)+(qOLS->AJUDCIL - qOLS->AJUCCIL)
		    _STAjuUs += ((qOLS->AJUDPWA - qOLS->AJUCPWA)+(qOLS->AJUDMAD - qOLS->AJUCMAD)+(qOLS->AJUDCIL - qOLS->AJUCCIL))/_Cambio
		//CONSOLIDADO LOCAL
			oPrint:Say(nLinha,1560, Transform(((qOLS->SLDDPWA - qOLS->SLDCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+ qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD) + qOLS->SAMAD), "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,1760, Transform((((qOLS->SLDDPWA - qOLS->SLDCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+ qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD) + qOLS->SAMAD))/_Cambio, "@E 999,999,999"), oFont07)
			_STEliRs += ((qOLS->SLDDPWA - qOLS->SLDCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+ qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD) + qOLS->SAMAD)
		    _STEliUs += (((qOLS->SLDDPWA - qOLS->SLDCPWA) + qOLS->SAPWA)+((qOLS->SLDDCIL - qOLS->SLDCCIL)+ qOLS->SACIL)+((qOLS->SLDDMAD - qOLS->SLDCMAD) + qOLS->SAMAD))/_Cambio
	    //MOIVMENTOS CONTABEIS PWA
			oPrint:Say(nLinha,1960, Transform((qOLS->SLDDPWA - qOLS->SLDCPWA)+ qOLS->SAPWA, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,2160, Transform(((qOLS->SLDDPWA - qOLS->SLDCPWA)+ qOLS->SAPWA)/_Cambio, "@E 999,999,999"), oFont07)
			_STPwaRs += (qOLS->SLDDPWA - qOLS->SLDCPWA)+ qOLS->SAPWA
		    _STPwaUs += ((qOLS->SLDDPWA - qOLS->SLDCPWA)+ qOLS->SAPWA)/_Cambio
		//MOVIMENTOS CONTABEIS MADAMA	
			oPrint:Say(nLinha,2360, Transform((qOLS->SLDDMAD - qOLS->SLDCMAD) + qOLS->SAMAD, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,2560, Transform(((qOLS->SLDDMAD - qOLS->SLDCMAD) + qOLS->SAMAD)/_Cambio, "@E 999,999,999"), oFont07)
		   	_STMadRs += (qOLS->SLDDMAD - qOLS->SLDCMAD)+ qOLS->SAMAD
		    _STMadUs += (qOLS->SLDDMAD - qOLS->SLDCMAD)+ qOLS->SAMAD/_Cambio
		//MOVIMENTOS CONTABEIS CIL		
			oPrint:Say(nLinha,2760, Transform((qOLS->SLDDCIL - qOLS->SLDCCIL)+ qOLS->SACIL, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,2960, Transform(((qOLS->SLDDCIL - qOLS->SLDCCIL)+ qOLS->SACIL)/_Cambio, "@E 999,999,999"), oFont07)
		   	_STCilRs += (qOLS->SLDDCIL - qOLS->SLDCCIL) + qOLS->SACIL
  		    _STCilUs += ((qOLS->SLDDCIL - qOLS->SLDCCIL) + qOLS->SACIL)/_Cambio

		nLinha += 40
	    
	   _cGrupo := qOLS->ZT1_CTASUP	    

		IncProc()
		qOLS->(dbSkip())
       //SUBTOTAIS DO RELATORIO
	   if _cGrupo != qOLS->ZT1_CTASUP
            oPrint:Line(nLinha,050,nLinha,3180)
		    nLinha += 20			
			//TEXTO
			oPrint:Say(nLinha,0050, PadR(Posicione("ZT1",1,xFilial()+_cGrupo,"ZT1_DESC"),50), oFont07)
			oPrint:Say(nLinha,0610, PadR(_cGrupo,6), oFont07)  
			//SUBTOTAL CONSOLIDADAS
			oPrint:Say(nLinha,0760, Transform(_STConRs, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,0960, Transform(_STConUs, "@E 999,999,999"), oFont07)
            //SUBTOTAL AJUSTES
			oPrint:Say(nLinha,1160, Transform(_STAjuRs, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,1360, Transform(_STAjuUs, "@E 999,999,999"), oFont07)            
	        //SUBTOTAL ELIMINACOES
			oPrint:Say(nLinha,1560, Transform(_STEliRs, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,1760, Transform(_STEliUs, "@E 999,999,999"), oFont07)
			//SUBTOTAL PWA
			oPrint:Say(nLinha,1960, Transform(_STPwaRs, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,2160, Transform(_STPwaUs, "@E 999,999,999"), oFont07)
			//SUBTOTAL MADAMA
			oPrint:Say(nLinha,2360, Transform(_STMadRs, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,2560, Transform(_STMadUs, "@E 999,999,999"), oFont07)
			//SUBTOTAL CIL
			oPrint:Say(nLinha,2760, Transform(_STCilRs, "@E 999,999,999"), oFont07)
			oPrint:Say(nLinha,2960, Transform(_STCilUs, "@E 999,999,999"), oFont07)
          
            nLinha += 40								  
			oPrint:Line(nLinha,050,nLinha,3180)
          
          
          _cGrupo := qOLS->ZT1_CTASUP  		  
  		   
  		    _STConRs := 0
		    _STConUs := 0
			_STAjuRs := 0
		    _STAjuUs := 0
			_STEliRs := 0
		    _STEliUs := 0
			_STPwaRs := 0
		    _STPwaUs := 0
		   	_STMadRs := 0
		    _STMadUs := 0
		   	_STCilRs := 0
		    _STCilUs := 0
		
  		  nLinha  += 40
	   endif
	End	
	xClose()
	oPrint:Line(nLinha,0100,nLinha,2300)
	nLinha += 10
	xVerPag()
	
	//xRodape()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime em Video, e finaliza a impressao. !³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	oPrint:Preview()
Return


Static Function xCabec()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o cabecalho da empresa. !³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SayBitmap(050,100,cFileLogo,1050,260)
	oPrint:Say(050,050,AllTrim( "Precious Woods Amazon and Subsidiaries" ),oFont08)
	oPrint:Say(090,050,AllTrim( "Transformation Report" ), oFont07)
	oPrint:Say(090,2970,AllTrim( "Tx.Cambio: R$" ), oFont07)
	oPrint:Say(090,3090,Transform(MV_PAR05,"@E 999,999.9999"), oFont07)
	oPrint:Say(120,050,AllTrim( "As of"+" "+SUBSTR(DTOS(MV_PAR02),7,2)+" "+CMONTH(MV_PAR02)+" "+SUBSTR(DTOS(MV_PAR02),1,4) ), oFont07)
	oPrint:Say(120,2970,AllTrim("Pagina:"), oFont07)
	oPrint:Say(120,3050,AllTrim(Transform(_Pagina,"@E 999,999")), oFont07)
	oPrint:Line(150,050,150,3180)

	
	oPrint:Say(320,050, "Description", oFont07)
	oPrint:Say(320,610, "MembCode", oFont07)
	
	oPrint:Say(250,0900, "IFRS", oFont07)
	oPrint:Line(275,760,275,1130)
	oPrint:Say(290,0780, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,0820, "BRL", oFont07)
	oPrint:Say(290,0980, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1020, "USD", oFont07)
	oPrint:Line(345,760,345,1130)

	oPrint:Say(250,1300, "Adjustment", oFont07)
	oPrint:Line(275,1160,275,1530)
	oPrint:Say(290,1180, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1220, "BRL", oFont07)
	oPrint:Say(290,1380, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1420, "USD", oFont07)
	oPrint:Line(345,1160,345,1530)

	oPrint:Say(250,1700, "Local Consolidated", oFont07)
	oPrint:Line(275,1560,275,1930)
	oPrint:Say(290,1580, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1620, "BRL", oFont07)
	oPrint:Say(290,1780, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1820, "USD", oFont07)
	oPrint:Line(345,1560,345,1930)

	oPrint:Say(250,2150, "MIL", oFont07)
	oPrint:Line(275,1960,275,2330)
	oPrint:Say(290,1980, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2020, "BRL", oFont07)
	oPrint:Say(290,2180, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2220, "USD", oFont07)
	oPrint:Line(345,1960,345,2330)

	oPrint:Say(250,2520, "Madama", oFont07)
	oPrint:Line(275,2360,275,2730)
	oPrint:Say(290,2380, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2420, "BRL", oFont07)
	oPrint:Say(290,2580, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2620, "USD", oFont07)
	oPrint:Line(345,2360,345,2730)

	oPrint:Say(250,2900, "CIL", oFont07)
	oPrint:Line(275,2760,275,3130)
	oPrint:Say(290,2780, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2820, "BRL", oFont07)
	oPrint:Say(290,2980, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,3020, "USD", oFont07)
	oPrint:Line(345,2760,345,3130)
	
	nLinha := 380
	
Return

/*
   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30
   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   |   | 
________________________________________________________________________________________________________________________
*/
/*
Static Function xRodape()
	//oPrint:Line(3100,0100,3100,2300)
	//oPrint:Say(3120,1050,AllTrim("POTENCIAL"),oFont16)
	//oPrint:Line(3200,0100,3200,2390)
Return
*/

Static Function xVerPag()
	If	( nLinha >= 2000 )
		
		If	( ! lFlag )
			_Pagina := _Pagina + 1
			//xRodape()
			oPrint:EndPage()
			nLinha:= 600
		Else
			nLinha:= 800
		EndIf
		
		oPrint:StartPage()
		xCabec()
		
		lPrintDesTab := .t.
	EndIf      
Return

Static Function xClose()
	qOLS->(dbCloseArea())
Return