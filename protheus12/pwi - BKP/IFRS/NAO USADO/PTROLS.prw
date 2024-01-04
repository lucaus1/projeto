#include "fivewin.ch"    
#include "topconn.ch"


User Function PTROLS()
	Private	lEnd := .f.
	Private _cQuery  := ""
	Private _cGrupoS :=""
	Private _cGrupoT :=""
	Private _cGrupoF :=""
	Private _cSuper  :=""
	Private _cTot    :=""
    Private _TOConRs := 0
    Private _TOConUs := 0
	Private _TOAjuRs := 0
    Private _TOAjuUs := 0
	Private _TOEliRs := 0
    Private _TOEliUs := 0
	Private _TOPwaRs := 0
    Private _TOPwaUs := 0
   	Private _TOMadRs := 0
    Private _TOMadUs := 0
   	Private _TOCilRs := 0
    Private _TOCilUs := 0
    Private	_SUConRs := 0
    Private	_SUConUs := 0
	Private	_SUAjuRs := 0
	Private	_SUAjuUs := 0
	Private	_SUEliRs := 0
	Private	_SUEliUs := 0
	Private	_SUPwaRs := 0
	Private	_SUPwaUs := 0
	Private	_SUMadRs := 0
	Private	_SUMadUs := 0
	Private	_SUCilRs := 0
	Private	_SUCilUs := 0
    Private	_EXConRs := 0
    Private	_EXConUs := 0
	Private	_EXAjuRs := 0
	Private	_EXAjuUs := 0
	Private	_EXEliRs := 0
	Private	_EXEliUs := 0
	Private	_EXPwaRs := 0
	Private	_EXPwaUs := 0
	Private	_EXMadRs := 0
	Private	_EXMadUs := 0
	Private	_EXCilRs := 0
	Private	_EXCilUs := 0

    Private _Cambio  := 0
    Private _Pagina  := 1
	Private _DataC   := GetMV("MV_DATAOLS") 
	Private qOLS     := ""
	Private _cTotalR1:= 0
	Private _cTotalU1:= 0	
    //  .--------------------------------.
    // | Defini��o de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PTROLS"

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
		//�Executa a rotina de impressao �
		Processa({ |lEnd| xPrintRel(), OemToAnsi("Gerando o relat�rio.")}, OemToAnsi("Aguarde..."))
	Endif
	//�Restaura a area anterior ao processamento. !�
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
	
	//���������������������������������������Ŀ
	//�Define que a impressao deve ser RETRATO�
	//�����������������������������������������
	//oPrint:SetPortrait()
	
	//���������������������������������������Ŀ
	//�Define que a impressao deve ser PAISAGEM�
	//�����������������������������������������
	oPrint:SetLandScape()


		_cQuery1 := " select ZT4_SEQ,ZT4_GRUPO,ZT4_TIPO "
	    _cQuery1 += " FROM ZT4060  WHERE ZT4060.D_E_L_E_T_<>'*' AND ZT4_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	    _cQuery1 += " ORDER BY ZT4_SEQ ASC "
		
		TcQuery _cQuery1 Alias qLGRUPO new
		
	nContador := 1
	
	ProcRegua( 500 )
	_Cambio := MV_PAR05


	While (!qLGRUPO->(Eof()))
	    _cSeq := qLGRUPO->ZT4_SEQ
	    
		xVerPag()
		
		If	( lFlag )
			lFlag := .f.
		EndIf                                            
		
		If	( lPrintDesTab )
		EndIf
	
	    If Alltrim(qLGRUPO -> ZT4_TIPO) != "T" .and. Alltrim(qLGRUPO -> ZT4_TIPO) != ""
	    
				    _cQuery2 := " SELECT ZT5060.*, (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSCRE, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS ELIDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS ELICRE,"
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI2010,SI1010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_DEBITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1010,SI2010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_CREDITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "
			
					_cQuery2 += " -(SELECT SUM(I1_SALANT) FROM SI1010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " SI1010.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPWA, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI2040,SI1040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_DEBITO AND SI1040.D_E_L_E_T_<>'*' AND SI2040.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1040,SI2040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_CREDITO AND SI1040.D_E_L_E_T_<>'*' AND SI2040.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "
			
					_cQuery2 += " -(SELECT SUM(I1_SALANT) FROM SI1040 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " SI1040.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAMAD, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI2020,SI1020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_DEBITO AND SI1020.D_E_L_E_T_<>'*' AND SI2020.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1020,SI2020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_CREDITO AND SI1020.D_E_L_E_T_<>'*' AND SI2020.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02'  "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL,  "
			    
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL, "
			
					_cQuery2 += " -(SELECT SUM(I1_SALANT) FROM SI1020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " SI1020.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SACIL "
							
					_cQuery2 += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery2 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        SUGrupo := qTGRUPO->ZT5_GRUPO 
				 	   		
				 	   		//DESCRICAO E CONTA OLS
                           if Alltrim(qLGRUPO -> ZT4_TIPO) == "E" 				 	   
						        oPrint:Say(nLinha,0050, "EX - " + PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       else
								oPrint:Say(nLinha,0050, PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       endif
							oPrint:Say(nLinha,0610, PadR(qTGRUPO->ZT5_CONTA,6), oFont07)
							//MOVIMENTOS CONSOLIDADOS
							oPrint:Say(nLinha,0760, Transform(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE), "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,0960, Transform((((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE))/_Cambio, "@E 999,999,999,999"), oFont07)
							//AJUSTES
							oPrint:Say(nLinha,1160, Transform((qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE), "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,1360, Transform((qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)/_Cambio, "@E 999,999,999,999"), oFont07)
							//ELIMINACOES	
							oPrint:Say(nLinha,1560, Transform((qTGRUPO->ELIDEB-qTGRUPO->ELICRE), "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,1760, Transform((qTGRUPO->ELIDEB-qTGRUPO->ELICRE)/_Cambio, "@E 999,999,999,999"), oFont07)
							//MOIVMENTOS CONTABEIS PWA
							oPrint:Say(nLinha,1960, Transform((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA, "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,2160, Transform(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)/_Cambio, "@E 999,999,999,999"), oFont07)
							//MOVIMENTOS CONTABEIS MADAMA
							oPrint:Say(nLinha,2360, Transform((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD, "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,2560, Transform(((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)/_Cambio, "@E 999,999,999,999"), oFont07)
							//MOVIMENTOS CONTABEIS CIL
							oPrint:Say(nLinha,2760, Transform((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL, "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,2960, Transform(((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)/_Cambio, "@E 999,999,999,999"), oFont07)
				
							nLinha += 40
                           if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
						 	    _SUConRS +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
						 	    _SUConUS +=(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE))/_Cambio
						 	    _SUAjuRs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)
						 	    _SUAjuUs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)/_Cambio
						 	    _SUEliRS +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
			                    _SUEliUs +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)/_Cambio
			                    _SUPwaRs +=(qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA
			                    _SUPwaUs +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)/_Cambio
			                    _SUMadRs +=(qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD
			                    _SUMadUs +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)/_Cambio
			                    _SUCilRs +=(qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL
			                    _SUCilUs +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)/_Cambio
	                       endif
	                            
					        qTGRUPO->(dbSkip())
				    End	
                    
                    if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
	             		oPrint:Line(nLinha,050,nLinha,3180)
						nLinha += 20
						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(SUGrupo,6), oFont07)
						//SUBTOTAL CONSOLIDADAS
						oPrint:Say(nLinha,0760, Transform(_SUConRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,0960, Transform(_SUConUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL AJUSTES
						oPrint:Say(nLinha,1160, Transform(_SUAjuRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,1360, Transform(_SUAjuUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL ELIMINACOES
						oPrint:Say(nLinha,1560, Transform(_SUEliRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,1760, Transform(_SUEliUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWA
						oPrint:Say(nLinha,1960, Transform(_SUPwaRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2160, Transform(_SUPwaUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL MADAMA
						oPrint:Say(nLinha,2360, Transform(_SUMadRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2560, Transform(_SUMadUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL CIL
						oPrint:Say(nLinha,2760, Transform(_SUCilRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2960, Transform(_SUCilUs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,3180)
	   				    nLinha += 20

				        _SUConRS := 0
				 	    _SUConUS := 0
				 	    _SUAjuRs := 0
				 	    _SUAjuUs := 0
				 	    _SUEliRS := 0
	                    _SUEliUs := 0
	                    _SUPwaRs := 0
	                    _SUPwaUs := 0
	                    _SUMadRs := 0
	                    _SUMadUs := 0
	                    _SUCilRs := 0
	                    _SUCilUs := 0
	                endif
   	                qTGRUPO->(dbCloseArea())
   	                
	    Elseif Alltrim(qLGRUPO -> ZT4_TIPO) =='T'
	             
	                _cQuery3 := " SELECT ZT5060.*,ZT1_CONTA, "
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSDEB, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSCRE, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS ELIDEB,"
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS ELICRE,"
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI2010,SI1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_DEBITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1010,SI2010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_CREDITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "
	
	                _cQuery3 += " -(SELECT SUM(I1_SALANT) FROM SI1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " SI1010.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPWA, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI2040,SI1040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_DEBITO AND SI1040.D_E_L_E_T_<>'*' AND SI2040.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDMAD, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1040,SI2040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_CREDITO AND SI1040.D_E_L_E_T_<>'*' AND SI2040.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCMAD, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '04' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD,  "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "
	
	                _cQuery3 += " -(SELECT SUM(I1_SALANT) FROM SI1040 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " SI1040.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAMAD, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI2020,SI1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_DEBITO AND SI1020.D_E_L_E_T_<>'*' AND SI2020.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDCIL, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1020,SI2020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_CREDITO AND SI1020.D_E_L_E_T_<>'*' AND SI2020.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCCIL, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '02' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL, "
	    
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL, "
	
	                _cQuery3 += " -(SELECT SUM(I1_SALANT) FROM SI1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " SI1020.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SACIL  "
	                _cQuery3 += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery3 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))

				 	        TOGrupo := qTGRUPO->ZT5_GRUPO 

					 	    _TOConRS +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
					 	    _TOConUS +=((((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE))/_Cambio)
					 	    _TOAjuRs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)
					 	    _TOAjuUs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)/_Cambio
					 	    _TOEliRS +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
		                    _TOEliUs +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)/_Cambio
		                    _TOPwaRs +=((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)
		                    _TOPwaUs +=(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)/_Cambio)
		                    _TOMadRs +=((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)
		                    _TOMadUs +=(((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)/_Cambio)
		                    _TOCilRs +=((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)
		                    _TOCilUs +=(((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)/_Cambio)
		                    
					        qTGRUPO->(dbSkip())
				    
				    
				    
				    End	
	             		oPrint:Line(nLinha,050,nLinha,3180)
						nLinha += 20
						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(TOGrupo,6), oFont07)
						//SUBTOTAL CONSOLIDADAS
						oPrint:Say(nLinha,0760, Transform(_TOConRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,0960, Transform(_TOConUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL AJUSTES
						oPrint:Say(nLinha,1160, Transform(_TOAjuRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,1360, Transform(_TOAjuUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL ELIMINACOES
						oPrint:Say(nLinha,1560, Transform(_TOEliRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,1760, Transform(_TOEliUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWA
						oPrint:Say(nLinha,1960, Transform(_TOPwaRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2160, Transform(_TOPwaUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL MADAMA
						oPrint:Say(nLinha,2360, Transform(_TOMadRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2560, Transform(_TOMadUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL CIL
						oPrint:Say(nLinha,2760, Transform(_TOCilRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2960, Transform(_TOCilUs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,3180)
	   				    nLinha += 20
				        _TOConRS := 0
				 	    _TOConUS := 0
				 	    _TOAjuRs := 0
				 	    _TOAjuUs := 0
				 	    _TOEliRS := 0
	                    _TOEliUs := 0
	                    _TOPwaRs := 0
	                    _TOPwaUs := 0
	                    _TOMadRs := 0
	                    _TOMadUs := 0
	                    _TOCilRs := 0
	                    _TOCilUs := 0
	             	    
	             	    qTGRUPO->(dbCloseArea())
	             
	    Endif
		
		qLGRUPO->(dbSkip())
    End	
   	qLGRUPO->(dbCloseArea())


	// MEMORIA DE CALCULO

	xVerPag()
	
	//xRodape()
	//���������������������������������������������
	//�Imprime em Video, e finaliza a impressao. !�
	//���������������������������������������������

	oPrint:Preview()
Return


Static Function xCabec()
	//���������������������������������Ŀ
	//�Imprime o cabecalho da empresa. !�
	//�����������������������������������
	oPrint:SayBitmap(050,100,cFileLogo,1050,260)
	oPrint:Say(050,050,AllTrim( "Precious Woods Amazon and Subsidiaries" ),oFont08)
	oPrint:Say(090,050,AllTrim( "Balance Sheet" ), oFont07)
	oPrint:Say(090,2970,AllTrim( "Tx.Cambio: R$" ), oFont07)
	oPrint:Say(090,3090,Transform(MV_PAR05,"@E 999,999.9999"), oFont07)
	oPrint:Say(120,050,AllTrim( "As of"+" "+SUBSTR(DTOS(MV_PAR02),7,2)+" "+CMONTH(MV_PAR02)+" "+SUBSTR(DTOS(MV_PAR02),1,4) ), oFont07)
	oPrint:Say(120,2970,AllTrim("Pagina:"), oFont07)
	oPrint:Say(120,3050,AllTrim(Transform(_Pagina,"@E 999,999")), oFont07)
	oPrint:Line(150,050,150,3180)
	
	oPrint:Say(320,050, "Description", oFont07)
	oPrint:Say(320,610, "MembCode", oFont07)
	
	oPrint:Say(250,0900, "Consolidated", oFont07)
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

	oPrint:Say(250,1700, "Elimination", oFont07)
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
Return