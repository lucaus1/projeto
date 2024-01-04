#include "fivewin.ch"    
#include "topconn.ch"
/*
Alteracões:
Data       Tecnico     Descricao
03/07/06   Franciney   Titulos de colunas:
PwBelem - Pw Belem , PwPara - Pw Para , MVerde - Monte Verde

*/


User Function PWPOLS()
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
	Private _TOPwbRs := 0
    Private _TOPwbUs := 0
   	Private _TOPwpRs := 0
    Private _TOPwpUs := 0
   	Private _TOPmvRs := 0
    Private _TOPmvUs := 0
    Private	_SUConRs := 0
    Private	_SUConUs := 0
	Private	_SUAjuRs := 0
	Private	_SUAjuUs := 0
	Private	_SUEliRs := 0
	Private	_SUEliUs := 0
	Private	_SUPwbRs := 0
	Private	_SUPwbUs := 0
	Private	_SUPwpRs := 0
	Private	_SUPwpUs := 0
	Private	_SUPmvRs := 0
	Private	_SUPmvUs := 0
    Private	_EXConRs := 0
    Private	_EXConUs := 0
	Private	_EXAjuRs := 0
	Private	_EXAjuUs := 0
	Private	_EXEliRs := 0
	Private	_EXEliUs := 0
	Private	_EXPwbRs := 0
	Private	_EXPwbUs := 0
	Private	_EXPwpRs := 0
	Private	_EXPwpUs := 0
	Private	_EXPmvRs := 0
	Private	_EXPmvUs := 0
    Private _VldClas := .F.
    Private _Cambio  := 0
    Private _Pagina  := 0
	Private _DataC   := GetMV("MV_DATAOLS") 
	Private qOLS     := ""
	Private _cTotalR1:= 0
	Private _cTotalU1:= 0	
    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PWPOLS"

  	dbSelectArea("SX1")
  	dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data de      ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Data ate     ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Conta de     ?","mv_ch3","C",10,0,1,"G","","mv_par03","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Conta Ate    ?","mv_ch4","C",10,0,1,"G","","mv_par04","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Tx.Fix.Cambio?","mv_ch5","N",14,4,1,"G","","mv_par05","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "06", "Tx.Med.Cambio?","mv_ch6","N",14,4,1,"G","","mv_par06","","","","","","","","","","","","","","",""})
  	 
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
			Replace X1_F3       with aPerg[nA][13]
			Replace X1_DEFENG2  with aPerg[nA][15]
			MsUnlock()
		Endif
	Next

  	if Pergunte(cPerg, .T.)
		//³Executa a rotina de impressao ³
		Processa({ |lEnd| xPrintRel(), OemToAnsi("Gerando o relatório.")}, OemToAnsi("Aguarde..."))
	Endif
	//³Restaura a area anterior ao processamento. !
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
	
	nLinha		:= 3000	// Controla a linha por extenso
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define que a impressao deve ser RETRATO³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	//oPrint:SetPortrait()
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Define que a impressao deve ser PAISAGEM³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SetLandScape()                                                          

		_cQuery1 := " select ZT4_SEQ,ZT4_GRUPO,ZT4_TIPO,ZT4_CLAS "
	    _cQuery1 += " FROM ZT4060  WHERE ZT4060.D_E_L_E_T_<>'*' AND ZT4_GRUPO BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "' "
	    _cQuery1 += " ORDER BY ZT4_CLAS,ZT4_SEQ ASC "
		
		TcQuery _cQuery1 Alias qLGRUPO new

    dbGoTop()
	ProcRegua( 500 )

	_Cambio := MV_PAR05
    _SltClas := qLGRUPO->ZT4_CLAS    
	nContador := 1

	While (!qLGRUPO->(Eof()))
	    _cSeq := qLGRUPO->ZT4_SEQ
	    
	    If Alltrim(qLGRUPO -> ZT4_TIPO) != "T" .and. Alltrim(qLGRUPO -> ZT4_TIPO) != ""
	    
				    _cQuery2 := " SELECT ZT5060.*, (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS AJUSCRE, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS ELIDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS ELICRE,"
			   
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI2070,SI1070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_DEBITO AND SI1070.D_E_L_E_T_<>'*' AND SI2070.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1070,SI2070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_CREDITO AND SI1070.D_E_L_E_T_<>'*' AND SI2070.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB, "
			
					_cQuery2 += " -(SELECT SUM(I1_SALANT) FROM SI1070 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " SI1070.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPWB, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI2080,SI1080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_DEBITO AND SI1080.D_E_L_E_T_<>'*' AND SI2080.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1080,SI2080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_CREDITO AND SI1080.D_E_L_E_T_<>'*' AND SI2080.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP, "
			
					_cQuery2 += " -(SELECT SUM(I1_SALANT) FROM SI1080 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " SI1080.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPWP, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1090,SI2090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_DEBITO AND SI1090.D_E_L_E_T_<>'*' AND SI2090.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1090,SI2090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_CREDITO AND SI1090.D_E_L_E_T_<>'*' AND SI2090.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09'  "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV,  "
			    
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV, "
			
					_cQuery2 += " -(SELECT SUM(I1_SALANT) FROM SI1090 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " SI1090.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPMV "
				 			
					_cQuery2 += " FROM ZT5060 WHERE ZT5060.D_E_L_E_T_<>'*' AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery2 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        SUGrupo := qTGRUPO->ZT5_GRUPO 
                            xVerPag()
                            
                            //CONDICIONAMENTO DA TAXA DO DOLAR
							if Alltrim(qTGRUPO->ZT5_CONTA) < "500000"
								_Cambio := MV_PAR05
							elseif Alltrim(qTGRUPO->ZT5_CONTA) >= "500000" .and. Alltrim(qTGRUPO->ZT5_CONTA) < "699999"
								_Cambio := MV_PAR06
							elseif Alltrim(qTGRUPO->ZT5_CONTA) = "800000"
							    _Cambio := MV_PAR06
							else 
						    _Cambio := 0	
							endif					 	   		
				 	   		//DESCRICAO E CONTA OLS
                           if Alltrim(qLGRUPO -> ZT4_TIPO) == "E" 				 	   
						        oPrint:Say(nLinha,0050, "EX - " + PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       else
								oPrint:Say(nLinha,0050, PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       endif
							oPrint:Say(nLinha,0610, PadR(qTGRUPO->ZT5_CONTA,6), oFont07)
							//MOVIMENTOS CONSOLIDADOS
							oPrint:Say(nLinha,0760, Transform(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE), "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,0960, Transform((((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE))/_Cambio, "@E 999,999,999,999"), oFont07)
							//AJUSTES
							oPrint:Say(nLinha,1160, Transform((qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE), "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,1360, Transform((qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)/_Cambio, "@E 999,999,999,999"), oFont07)
							//ELIMINACOES	
							oPrint:Say(nLinha,1560, Transform((qTGRUPO->ELIDEB-qTGRUPO->ELICRE), "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,1760, Transform((qTGRUPO->ELIDEB-qTGRUPO->ELICRE)/_Cambio, "@E 999,999,999,999"), oFont07)
							//MOIVMENTOS CONTABEIS PWB
							oPrint:Say(nLinha,1960, Transform((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB, "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,2160, Transform(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)/_Cambio, "@E 999,999,999,999"), oFont07)
							//MOVIMENTOS CONTABEIS PWP
							oPrint:Say(nLinha,2360, Transform((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP, "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,2560, Transform(((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)/_Cambio, "@E 999,999,999,999"), oFont07)
							//MOVIMENTOS CONTABEIS PMV
							oPrint:Say(nLinha,2760, Transform((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV, "@E 999,999,999,999"), oFont07)
							oPrint:Say(nLinha,2960, Transform(((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)/_Cambio, "@E 999,999,999,999"), oFont07)
				
							nLinha += 40
                    
                           if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
						 	    _SUConRS +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
						 	    _SUConUS +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE))/_Cambio
						 	    _SUAjuRs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)
						 	    _SUAjuUs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)/_Cambio
						 	    _SUEliRS +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
			                    _SUEliUs +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)/_Cambio
			                    _SUPWBRs +=(qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB
			                    _SUPWBUs +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)/_Cambio
			                    _SUPWPRs +=(qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP
			                    _SUPWPUs +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)/_Cambio
			                    _SUPMVRs +=(qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV
			                    _SUPMVUs +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)/_Cambio
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
						//SUBTOTAL PWB
						oPrint:Say(nLinha,1960, Transform(_SUPWBRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2160, Transform(_SUPWBUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWPAMA
						oPrint:Say(nLinha,2360, Transform(_SUPWPRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2560, Transform(_SUPWPUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PMV
						oPrint:Say(nLinha,2760, Transform(_SUPMVRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2960, Transform(_SUPMVUs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,3180)
	   				    nLinha += 20

				        _SUConRS := 0
				 	    _SUConUS := 0
				 	    _SUAjuRs := 0
				 	    _SUAjuUs := 0
				 	    _SUEliRS := 0
	                    _SUEliUs := 0
	                    _SUPWBRs := 0
	                    _SUPWBUs := 0
	                    _SUPWPRs := 0
	                    _SUPWPUs := 0
	                    _SUPMVRs := 0
	                    _SUPMVUs := 0
	                	
	                endif
   	                qTGRUPO->(dbCloseArea())
   	                
	    Elseif Alltrim(qLGRUPO -> ZT4_TIPO) =='T'
	             
	                _cQuery3 := " SELECT ZT5060.*,ZT1_CONTA, "
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSDEB, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS AJUSCRE, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS ELIDEB,"
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='02' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS ELICRE,"
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI2070,SI1070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_DEBITO AND SI1070.D_E_L_E_T_<>'*' AND SI2070.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWB, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1070,SI2070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_CREDITO AND SI1070.D_E_L_E_T_<>'*' AND SI2070.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWB, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '07' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWB, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '07' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWB, "
	
	                _cQuery3 += " -(SELECT SUM(I1_SALANT) FROM SI1070 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " SI1070.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPWB, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI2080,SI1080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_DEBITO AND SI1080.D_E_L_E_T_<>'*' AND SI2080.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWP, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1080,SI2080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_CREDITO AND SI1080.D_E_L_E_T_<>'*' AND SI2080.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWP, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '08' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWP,  "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '08' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWP, "
	
	                _cQuery3 += " -(SELECT SUM(I1_SALANT) FROM SI1080 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " SI1080.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPWP, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1090,SI2090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_DEBITO AND SI1090.D_E_L_E_T_<>'*' AND SI2090.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"') AS SLDDPMV, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1090,SI2090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_CREDITO AND SI1090.D_E_L_E_T_<>'*' AND SI2090.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPMV, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '09' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPMV, "
	    
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '09' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='02' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPMV, "
	
	                _cQuery3 += " -(SELECT SUM(I1_SALANT) FROM SI1090 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " SI1090.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SAPMV  "
	                
	                _cQuery3 += " FROM ZT5060,ZT1060 WHERE ZT5_CONTA=ZT1_CTASUP AND ZT5_GRUPO='"+ qLGRUPO->ZT4_GRUPO + "' "
					
					TcQuery _cQuery3 Alias qTGRUPO new
							
				    While (!qTGRUPO->(Eof()))
				 	        TOGrupo := qTGRUPO->ZT5_GRUPO 
                            xVerPag()
                                   	                   
                            //CONDICIONAMENTO DA TAXA DO DOLAR
							if Alltrim(qTGRUPO->ZT5_CONTA) < "500000"
								_Cambio := MV_PAR05
							elseif Alltrim(qTGRUPO->ZT5_CONTA) >= "500000" .and. Alltrim(qTGRUPO->ZT5_CONTA) < "699999"
								_Cambio := MV_PAR06
							elseif Alltrim(qTGRUPO->ZT5_CONTA) = "800000"
							    _Cambio := MV_PAR06
							else 
						    _Cambio := 0	
							endif					 	   		
					 	    _TOConRS +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
					 	    _TOConUS +=((((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)+((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)+((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)+(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)+(qTGRUPO->ELIDEB-qTGRUPO->ELICRE))/_Cambio)
					 	    _TOAjuRs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)
					 	    _TOAjuUs +=(qTGRUPO->AJUSDEB - qTGRUPO->AJUSCRE)/_Cambio
					 	    _TOEliRS +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)
		                    _TOEliUs +=(qTGRUPO->ELIDEB-qTGRUPO->ELICRE)/_Cambio
		                    _TOPWBRs +=((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)
		                    _TOPWBUs +=(((qTGRUPO->SLDDPWB - qTGRUPO->SLDCPWB)+(qTGRUPO->AJUDPWB - qTGRUPO->AJUCPWB) + qTGRUPO->SAPWB)/_Cambio)
		                    _TOPWPRs +=((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)
		                    _TOPWPUs +=(((qTGRUPO->SLDDPWP - qTGRUPO->SLDCPWP)+(qTGRUPO->AJUDPWP - qTGRUPO->AJUCPWP) + qTGRUPO->SAPWP)/_Cambio)
		                    _TOPMVRs +=((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)
		                    _TOPMVUs +=(((qTGRUPO->SLDDPMV - qTGRUPO->SLDCPMV)+(qTGRUPO->AJUDPMV - qTGRUPO->AJUCPMV) + qTGRUPO->SAPMV)/_Cambio)
		                    
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
						//SUBTOTAL PWB
						oPrint:Say(nLinha,1960, Transform(_TOPWBRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2160, Transform(_TOPWBUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWP
						oPrint:Say(nLinha,2360, Transform(_TOPWPRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2560, Transform(_TOPWPUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PMV
						oPrint:Say(nLinha,2760, Transform(_TOPMVRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2960, Transform(_TOPMVUs, "@E 999,999,999,999"), oFont07)
						nLinha += 40
						oPrint:Line(nLinha,050,nLinha,3180)
	   				    nLinha += 20
				        _TOConRS := 0
				 	    _TOConUS := 0
				 	    _TOAjuRs := 0
				 	    _TOAjuUs := 0
				 	    _TOEliRS := 0
	                    _TOEliUs := 0
	                    _TOPWBRs := 0
	                    _TOPWBUs := 0
	                    _TOPWPRs := 0
	                    _TOPWPUs := 0
	                    _TOPMVRs := 0
	                    _TOPMVUs := 0
	             	    
	             	    qTGRUPO->(dbCloseArea())

	    Endif
		qLGRUPO->(dbSkip())
        IncProc()         

        if Alltrim(_SltClas) != Alltrim(qLGRUPO->ZT4_CLAS)
		  	_Pagina := _Pagina + 1
			_SltClas := qLGRUPO->ZT4_CLAS
	      	if _Pagina <= 13
		      	oPrint:EndPage()
			  	nLinha:= 600   
			  	oPrint:StartPage()
			  	xCabec()
		  	Endif
	    Endif
    End	
   	qLGRUPO->(dbCloseArea())
	oPrint:Preview()
Return

Static Function xCabec()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Imprime o cabecalho da empresa. !³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	oPrint:SayBitmap(050,100,cFileLogo,1050,260)
	oPrint:Say(050,050,AllTrim( "Precious Woods Para and Subsidiaries" ),oFont08)
	oPrint:Say(090,050,AllTrim( "Balance Sheet" ), oFont07) 
	oPrint:Say(050,2850,AllTrim( "Tx.Cambio Final: R$" ), oFont07)
	oPrint:Say(090,2850,AllTrim( "Tx.Cambio Medio: R$" ), oFont07)
	oPrint:Say(050,3090,Transform(MV_PAR05,"@E 999,999.9999"), oFont07)
	oPrint:Say(090,3090,Transform(MV_PAR06,"@E 999,999.9999"), oFont07)
	oPrint:Say(120,050,AllTrim( "As of"+" "+SUBSTR(DTOS(MV_PAR02),7,2)+" "+CMONTH(MV_PAR02)+" "+SUBSTR(DTOS(MV_PAR02),1,4) ), oFont07)
	oPrint:Say(120,2970,AllTrim("Pagina:"), oFont07)
	oPrint:Say(120,3175,AllTrim(Transform(_Pagina,"@E 999,999")), oFont07)
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

	oPrint:Say(250,2150, "PW Belem", oFont07)
	oPrint:Line(275,1960,275,2330)
	oPrint:Say(290,1980, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2020, "BRL", oFont07)
	oPrint:Say(290,2180, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2220, "USD", oFont07)
	oPrint:Line(345,1960,345,2330)

	oPrint:Say(250,2520, "PW Para", oFont07)
	oPrint:Line(275,2360,275,2730)
	oPrint:Say(290,2380, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2420, "BRL", oFont07)
	oPrint:Say(290,2580, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2620, "USD", oFont07)
	oPrint:Line(345,2360,345,2730)

	oPrint:Say(250,2900, "Monte Verde", oFont07)
	oPrint:Line(275,2760,275,3130)
	oPrint:Say(290,2780, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,2820, "BRL", oFont07)
	oPrint:Say(290,2980, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,3020, "USD", oFont07)
	oPrint:Line(345,2760,345,3130)
	
	nLinha := 380
	
Return


Static Function xVerPag()

	If	nLinha >= 2200 
		_Pagina := _Pagina + 1
        oPrint:EndPage()
		nLinha:= 600   
		oPrint:StartPage()
		xCabec()
	EndIf      

Return