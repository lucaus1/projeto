#include "fivewin.ch"    
#include "topconn.ch"

User Function PWATRA()
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
    Private _VldClas := .F.
    Private _Cambio  := 0
    Private _Pagina  := 0
	Private _DataC   := GetMV("MV_DATAOLS") 
	Private _cValZero:= .F.
	Private _cTotalR1:= 0
	Private _cTotalU1:= 0	
    //  .--------------------------------.
    // | Definição de Grupos de Perguntas |
    //  "--------------------------------"
  	Private aPerg := {}
  	Private cPerg := "PWATRA"

  	dbSelectArea("SX1")
  	dbSetOrder(1)

  	//- Defindo grupo de perguntas 
  	aadd(aPerg,{cPerg, "01", "Data de      ?","mv_ch1","D",08,0,1,"G","","mv_par01","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "02", "Data ate     ?","mv_ch2","D",08,0,1,"G","","mv_par02","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "03", "Conta de     ?","mv_ch3","C",10,0,1,"G","","mv_par03","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "04", "Conta Ate    ?","mv_ch4","C",10,0,1,"G","","mv_par04","","ZT1","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "05", "Tx.Fix.Cambio?","mv_ch5","N",14,4,1,"G","","mv_par05","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "06", "Tx.Med.Cambio?","mv_ch6","N",14,4,1,"G","","mv_par06","","","","","","","","","","","","","","",""})
  	aadd(aPerg,{cPerg, "07", "Imp.Val.Zero ?","mv_ch7","N",1,0,1, "C","","mv_par07","Sim","","","Não","","","","","","","","","","",""})
  	 
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
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS AJUSCRE, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTADEB) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS ELIDEB, "
			
					_cQuery2 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(ZT2_CTACRE) AND ZT2_DATA "
					_cQuery2 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS ELICRE,"
			   
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI2010,SI1010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_DEBITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
			
					_cQuery2 += " (SELECT SUM(I2_VALOR) FROM SI1010,SI2010 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " I1_CODIGO=I2_CREDITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
					_cQuery2 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
					_cQuery2 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' " 
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "
			
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
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD, "
			
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "
			
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
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL,  "
			    
					_cQuery2 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT5060.ZT5_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
					_cQuery2 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL, "
			
					_cQuery2 += " -(SELECT SUM(I1_SALANT) FROM SI1020 WHERE LTRIM(ZT5060.ZT5_CONTA)=LTRIM(I1_CTAOLS) AND "
					_cQuery2 += " SI1020.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SACIL "
				 			
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

							//VERIFICACAO DE ITENS ZERADOS
							_cValZero := ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)
							if  _cValZero > -0.1 .and. _cValZero < 0.1 .and. mv_par07 == 2
								qTGRUPO->(dbSkip())
								loop
							Endif
							
							
				 	   		//DESCRICAO E CONTA OLS
                           if Alltrim(qLGRUPO -> ZT4_TIPO) == "E" 				 	   
						        oPrint:Say(nLinha,0050, "EX - " + PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       else
								oPrint:Say(nLinha,0050, PadR(qTGRUPO->ZT5_DESC,50), oFont06)
					       endif
							oPrint:Say(nLinha,0610, PadR(qTGRUPO->ZT5_CONTA,6), oFont07)
						//IFRS
							oPrint:Say(nLinha,0760, Transform(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD), "@E 999,999,999"), oFont07)
							oPrint:Say(nLinha,0960, PadR(Transform((((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD))/_Cambio, "@E 999,999,999"), 14), oFont07)
						//AJUSTES 
							oPrint:Say(nLinha,1160, Transform((qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL), "@E 999,999,999"), oFont07)
							oPrint:Say(nLinha,1360, Transform(((qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL))/_Cambio, "@E 999,999,999"), oFont07)
						//CONSOLIDADO LOCAL
							oPrint:Say(nLinha,1560, Transform(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD), "@E 999,999,999"), oFont07)
							oPrint:Say(nLinha,1760, Transform((((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD))/_Cambio, "@E 999,999,999"), oFont07)
					    //MOIVMENTOS CONTABEIS PWA
							oPrint:Say(nLinha,1960, Transform((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+ qTGRUPO->SAPWA, "@E 999,999,999"), oFont07)
							oPrint:Say(nLinha,2160, Transform(((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+ qTGRUPO->SAPWA)/_Cambio, "@E 999,999,999"), oFont07)
						//MOVIMENTOS CONTABEIS MADAMA	
							oPrint:Say(nLinha,2360, Transform((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD, "@E 999,999,999"), oFont07)
							oPrint:Say(nLinha,2560, Transform(((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD)/_Cambio, "@E 999,999,999"), oFont07)
						//MOVIMENTOS CONTABEIS CIL		
							oPrint:Say(nLinha,2760, Transform((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL, "@E 999,999,999"), oFont07)
							oPrint:Say(nLinha,2960, Transform(((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL)/_Cambio, "@E 999,999,999"), oFont07)
							nLinha += 40
                    
                           if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
	   							_SUConRs += ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)
								_SUConUs += (((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD))/_Cambio
								_SUAjuRs += (qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)
							    _SUAjuUs += ((qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL))/_Cambio
								_SUEliRs += ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD)
							    _SUEliUs += (((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD))/_Cambio
								_SUPwaRs += (qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+ qTGRUPO->SAPWA
							    _SUPwaUs += ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+ qTGRUPO->SAPWA)/_Cambio
							   	_SUMadRs += (qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+ qTGRUPO->SAMAD
							    _SUMadUs += (qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+ qTGRUPO->SAMAD/_Cambio
							   	_SUCilRs += (qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL) + qTGRUPO->SACIL
					  		    _SUCilUs += ((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL) + qTGRUPO->SACIL)/_Cambio
	                       endif
	                            
					        qTGRUPO->(dbSkip())
				    End	
                    
                    if Alltrim(qLGRUPO -> ZT4_TIPO) != "E" 				 	   
	             		oPrint:Line(nLinha,050,nLinha,3180)
						nLinha += 20
 
 						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+SUGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(SUGrupo,6), oFont07)
						//SUBTOTAL IFRS
						oPrint:Say(nLinha,0760, Transform(_SUConRs, "@E 999,999,999"), oFont07)
						oPrint:Say(nLinha,0960, Transform(_SUConUs, "@E 999,999,999"), oFont07)
			            //SUBTOTAL AJUSTES
						oPrint:Say(nLinha,1160, Transform(_SUAjuRs, "@E 999,999,999"), oFont07)
						oPrint:Say(nLinha,1360, Transform(_SUAjuUs, "@E 999,999,999"), oFont07)            
				        //SUBTOTAL BR GAAP
						oPrint:Say(nLinha,1560, Transform(_SUEliRs, "@E 999,999,999"), oFont07)
						oPrint:Say(nLinha,1760, Transform(_SUEliUs, "@E 999,999,999"), oFont07)
						//SUBTOTAL PWA
						oPrint:Say(nLinha,1960, Transform(_SUPwaRs, "@E 999,999,999"), oFont07)
						oPrint:Say(nLinha,2160, Transform(_SUPwaUs, "@E 999,999,999"), oFont07)
						//SUBTOTAL MADAMA
						oPrint:Say(nLinha,2360, Transform(_SUMadRs, "@E 999,999,999"), oFont07)
						oPrint:Say(nLinha,2560, Transform(_SUMadUs, "@E 999,999,999"), oFont07)
						//SUBTOTAL CIL
						oPrint:Say(nLinha,2760, Transform(_SUCilRs, "@E 999,999,999"), oFont07)
						oPrint:Say(nLinha,2960, Transform(_SUCilUs, "@E 999,999,999"), oFont07)
						nLinha += 40

						oPrint:Line(nLinha,050,nLinha,3180)
	   				    nLinha += 20

				        _SUConRS := 0
				 	    _SUConUS := 0
				 	    _SUAjuRs := 0
				 	    _SUAjuUs := 0
				 	    _SUEliRS := 0
	                    _SUEliUs := 0
	                    _SUPWARs := 0
	                    _SUPWAUs := 0
	                    _SUMADRs := 0
	                    _SUMADUs := 0
	                    _SUCILRs := 0
	                    _SUCILUs := 0
  
  	                Endif
   	                qTGRUPO->(dbCloseArea())
   	                
	    Elseif Alltrim(qLGRUPO -> ZT4_TIPO) =='T'
	             
	                _cQuery3 := " SELECT ZT5060.*,ZT1_CONTA, "
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS AJUSDEB, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='A' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS AJUSCRE, "
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTADEB AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTADEB<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTADEB) AS ELIDEB,"
	
	                _cQuery3 += " (SELECT SUM(ZT2_CTAVAL) FROM ZT2060 WHERE ZT1060.ZT1_CONTA=ZT2_CTACRE AND ZT2_DATA "
	                _cQuery3 += " BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT2_TIPO='B' AND ZT2_FILIAL='01' AND ZT2060.ZT2_CTACRE<>'' AND ZT2060.D_E_L_E_T_<>'*' GROUP BY ZT2_CTACRE) AS ELICRE,"
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI2010,SI1010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_DEBITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDDPWA, "
	
	                _cQuery3 += " (SELECT SUM(I2_VALOR) FROM SI1010,SI2010 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " I1_CODIGO=I2_CREDITO AND SI1010.D_E_L_E_T_<>'*' AND SI2010.D_E_L_E_T_<>'*' AND "
	                _cQuery3 += " I2_FILIAL='01' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A' AND  "
	                _cQuery3 += " I2_DATA BETWEEN '" + _DataC + "' AND '"+DTOS(MV_PAR02)+"')AS SLDCPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_DEBITO) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDPWA, "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '01' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCPWA, "
	
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
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDMAD,  "
	
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '04' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCMAD, "
	
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
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_DEBITO) AS AJUDCIL, "
	    
	                _cQuery3 += " (SELECT SUM(ZT3_VALOR) FROM ZT3060 WHERE LTRIM(ZT1060.ZT1_CONTA) = LTRIM(ZT3_CREDIT) AND ZT3_EMPRES = '02' "
	                _cQuery3 += " AND ZT3_DATA BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"' AND ZT3_FILIAL='01' AND ZT3060.D_E_L_E_T_<>'*' GROUP BY ZT3_CREDIT) AS AJUCCIL, "
	
	                _cQuery3 += " -(SELECT SUM(I1_SALANT) FROM SI1020 WHERE LTRIM(ZT1060.ZT1_CONTA)=LTRIM(I1_CTAOLS) AND "
	                _cQuery3 += " SI1020.D_E_L_E_T_<>'*' AND I1_FILIAL='01' AND I1_NIVEL='5' AND I1_CLASSE='A')AS SACIL  "
	                
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

							//VERIFICACAO DE ITENS ZERADOS
							_cValZero := ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)
							if  _cValZero > -0.1 .and. _cValZero < 0.1 .and. mv_par07 == 2
								qTGRUPO->(dbSkip())
								loop
							Endif   								 
   													
   							_TOConRs += ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD)
							_TOConUs += (((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+(qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL) + qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD) + qTGRUPO->SAMAD))/_Cambio
							_TOAjuRs += (qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL)
						    _TOAjuUs += ((qTGRUPO->AJUDPWA - qTGRUPO->AJUCPWA)+(qTGRUPO->AJUDMAD - qTGRUPO->AJUCMAD)+(qTGRUPO->AJUDCIL - qTGRUPO->AJUCCIL))/_Cambio
							_TOEliRs += ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD)
						    _TOEliUs += (((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA) + qTGRUPO->SAPWA)+((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL)+ qTGRUPO->SACIL)+((qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD) + qTGRUPO->SAMAD))/_Cambio
							_TOPwaRs += (qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+ qTGRUPO->SAPWA
						    _TOPwaUs += ((qTGRUPO->SLDDPWA - qTGRUPO->SLDCPWA)+ qTGRUPO->SAPWA)/_Cambio
						   	_TOMadRs += (qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+ qTGRUPO->SAMAD
						    _TOMadUs += (qTGRUPO->SLDDMAD - qTGRUPO->SLDCMAD)+ qTGRUPO->SAMAD/_Cambio
						   	_TOCilRs += (qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL) + qTGRUPO->SACIL
				  		    _TOCilUs += ((qTGRUPO->SLDDCIL - qTGRUPO->SLDCCIL) + qTGRUPO->SACIL)/_Cambio
				  		    
					        qTGRUPO->(dbSkip())
				    
				    End	

	             		If Alltrim(_cSeq)!="292800"
	    	         		oPrint:Line(nLinha,050,nLinha,3180)
							nLinha += 20                       
						Endif

						//TEXTO
						oPrint:Say(nLinha,0050, _cSeq + " - " + PadR (Posicione("ZT1",1,xFilial()+TOGrupo,"ZT1_DESC"),50), oFont06)
						oPrint:Say(nLinha,0610, PadR(TOGrupo,6), oFont07)
						//SUBTOTAL IFRS
						oPrint:Say(nLinha,0740, Transform(_TOConRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,0940, Transform(_TOConUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL AJUSTES
						oPrint:Say(nLinha,1140, Transform(_TOAjuRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,1340, Transform(_TOAjuUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL BR GAAP
						oPrint:Say(nLinha,1540, Transform(_TOEliRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,1740, Transform(_TOEliUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWB
						oPrint:Say(nLinha,1940, Transform(_TOPWARs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2140, Transform(_TOPWAUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PWP
						oPrint:Say(nLinha,2340, Transform(_TOMADRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2540, Transform(_TOMADUs, "@E 999,999,999,999"), oFont07)
						//SUBTOTAL PMV
						oPrint:Say(nLinha,2740, Transform(_TOCILRs, "@E 999,999,999,999"), oFont07)
						oPrint:Say(nLinha,2940, Transform(_TOCILUs, "@E 999,999,999,999"), oFont07)

						nLinha += 40
	             		If Alltrim(_cSeq)!="292800"
		             		oPrint:Line(nLinha,050,nLinha,3180)
							nLinha += 20                       
						Endif

				        _TOConRS := 0
				 	    _TOConUS := 0
				 	    _TOAjuRs := 0
				 	    _TOAjuUs := 0
				 	    _TOEliRS := 0
	                    _TOEliUs := 0
	                    _TOPWARs := 0
	                    _TOPWAUs := 0
	                    _TOMADRs := 0
	                    _TOMADUs := 0
	                    _TOCILRs := 0
	                    _TOCILUs := 0
 
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
	oPrint:Say(050,050,AllTrim( "Precious Woods Amazon and Subsidiaries" ),oFont08)
	oPrint:Say(090,050,AllTrim( "Transformation Report" ), oFont07) 
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

	oPrint:Say(250,1700, "BR GAAP", oFont07)
	oPrint:Line(275,1560,275,1930)
	oPrint:Say(290,1580, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1620, "BRL", oFont07)
	oPrint:Say(290,1780, CMONTH(MV_PAR02)+"  "+SUBSTR(DTOS(MV_PAR02),1,4), oFont07)
	oPrint:Say(320,1820, "USD", oFont07)
	oPrint:Line(345,1560,345,1930)

	oPrint:Say(250,2150, "Mil", oFont07)
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

	If	nLinha >= 2200 
		_Pagina := _Pagina + 1
        oPrint:EndPage()
		nLinha:= 600   
		oPrint:StartPage()
		xCabec()
	EndIf      

Return