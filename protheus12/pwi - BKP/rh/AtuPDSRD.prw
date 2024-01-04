#include "rwmake.ch"
User Function AtuPDSRD     
cPerg := "PWI001"
criaperg(cPerg)

IF pergunte(cPerg,.t.)              
    _cAnoRef := mv_par01
    _cMesRef := mv_par02
   	Processa( {|| RunProc() } )

Endif

Return nil

Static Function RunProc()
   Alert("Processando transf de verbas da Tabela SRD")
	// _cTabfech := "RC"+_cCodEmp+substr(_cAnoRef,3,2)+_cMesRef
   DbSelectArea("SRD")  
   DbSetOrder(1)         
	Replace rd_pd with "106" for rd_pd='032' // PAGAMENTO ADIANTAMEN
	Replace rd_pd with "452" for rd_pd='008' //	FALTAS e/ou ATRASOS 
	Replace rd_pd with "453" for rd_pd='493' //	SUSPENSAO	
	replace rd_pd with "117" for rd_pd='115' // PERICULOSIDADE
	replace rd_pd with '115' for rd_pd='005' // SALARIO FAMILIA 
	replace rd_pd with "509" for rd_pd='401' // DIF IR FERIAS
	replace rd_pd with "401" for rd_pd='018' // ADIANTAMENTO QUINZEN	
	replace rd_pd with "457" for rd_pd='118' // FARMACIA        em SRD e SRK
	replace rd_pd with "207" for rd_pd='120' // HS.EXTRAS 50%	
	replace rd_pd with "206" for rd_pd='121' // HS.EXTRAS 100%	DIURNA
	replace rd_pd with "120" for rd_pd='162' // INSALUB.MAXIMA	
	replace rd_pd with "463" for rd_pd='119' // ADIANT.DIVERSOS	e SRK
	replace rd_pd with "119" for rd_pd='116' // INSALUBRIDADE	em SRD 
	replace rd_pd with "202" for rd_pd='124' // ADIC.NOTURNO	P         
	replace rd_pd with "217" for rd_pd='173' // HS.EXT.NOT.75% NOTURNA	   
	replace rd_pd with "235" for rd_pd='140' // HS.EXT.NOT.100% NOTURNA
	replace rd_pd with "413" for rd_pd='377' // FALTA E\OU ATRASOS
	replace rd_pd with "464" for rd_pd='355' // EMP CONSIGNADO/FOLHA	2		D16	464        -> em SRK,SRD    
	replace rd_pd with "465" for rd_pd='163' // EXAME LAB	2		D14	465  em SRK, SRD        
	replace rd_pd with "466" for rd_pd='149' //	DESC.PAGTO.INDEVIDO	2		D10	466  - em SRK, SRD
	replace rd_pd with "467" for rd_pd='211' //	ADIANT.P/COMPRAS	2		D17	467  - em SRD
	replace rd_pd with "468" for rd_pd='198' //	LIG.TELEF.PARTICULAR	2		D10	468 - em SRD
    replace rd_pd with "469" for rd_pd='226' //	DESP MEDICA/CONSUL/U	2		D14	469 - em SRD
	replace rd_pd with "470" for rd_pd='356' //	DESC SESI /ATRASO	2		D12	470 - em SRD
	replace rd_pd with "471" for rd_pd='282' //	MENSALIDADE/SESI	2		D04	471 - em SRD
	replace rd_pd with "472" for rd_pd='264' //	MENS.SIND.MARINHEIRO	2		D05	472 - JA EM SRD
	replace rd_pd with "473" for rd_pd='248' //	ETAPA	2		D10	473           - JA EM SRD
	replace rd_pd with "436" for rd_pd='146' //	CONT.ASSOCIATIVA SIN	2	1,500	D05	436 - JA EM SRD
	replace rd_pd with "323" for rd_pd='262' //	GRATIF.CHEFIA MAQ.	1		P04	323
	replace rd_pd with "262" for rd_pd='131' //	GRATIFICACAO	1	100,000	P05	262 - ja em SRD
	replace rd_pd with "285" for rd_pd='151' //	BONUS	1		P05	285
	replace rd_pd with "112" for rd_pd='001' //	HORAS NORMAIS	1	100,000	P01	112
	replace rd_pd with "288" for rd_pd='358' //	REEMB DESC EMPREST CONSIG	1		P11	288
	replace rd_pd with "474" for rd_pd='219' //	TX.ADMIN.EMPRESTIMO	2		D10	474
	replace rd_pd with "190" for rd_pd='221' //	PRO-LABORE	1	100,000	P07	190
	replace rd_pd with "243" for rd_pd='144' //	31o.Dia	1		P01	243
	replace rd_pd with "475" for rd_pd='239' //	DESP.C/OTICA	2		D02	475
	replace rd_pd with "244" for rd_pd='138' //	REEMBOLSO DESC.INDEV	1		P13	244   
	replace rd_pd with "204" for rd_pd='136' //	ESTORNO DE FALTAS	1	100,000	P01	204
	replace rd_pd with "476" for rd_pd='148' //	DESC.MAT.N/DEVOLV	2		D10	476
	replace rd_pd with "464" for rd_pd='357' //	DESC EMPREST CONSIG	2		D13	464
	replace rd_pd with "121" for rd_pd='016' //	SALARIO MATERNIDADE	1	100,000	P06	121      
	replace rd_pd with "408" for rd_pd='020' //	ARREDONDAMENTO	2	100,000	D10	408
    replace rd_pd with "417" for rd_pd='003' // I.N.S.S.	2	100,000	D03	417
	replace rd_pd with "419" for rd_pd='004' //	I.R.R.F.	2	100,000	D07	419
	replace rd_pd with "108" for rd_pd='094' //	13O. SALARIO PARC	1			108
	replace rd_pd with "280" for rd_pd='194' //	PREMIO PRODUCAO	1		P05	280
	replace rd_pd with "116" for rd_pd='122' //	DSR S/H.EXT/ADC.NOT	1	100,000	P02	116
	replace rd_pd with "131" for rd_pd='037' // ABONO DE FERIAS	1	100,000	F01	131
    replace rd_pd with "434" for rd_pd='129' //	PENSAO ALIMENTICIA FERIAS	2	100,000		434
	replace rd_pd with "129" for rd_pd='039' //	FERIAS NO MES	1	100,000	F01	129
	replace rd_pd with "129" for rd_pd='042' // FERIAS PAGAS NO MES	1	100,000	F01	129
	replace rd_pd with "430" for rd_pd='130' //	IRRF PARTIC.LUCROS	2			430
	replace rd_pd with "130" for rd_pd='040' //	FERIAS NO PROXIMO ME	1	100,000	F01	130
	replace rd_pd with "145" for rd_pd='043' //	DIF. FERIAS PAGAS NO	1	100,000	F01	145
	replace rd_pd with "163" for rd_pd='045' //	13o SAL.RESCISAO	1	100,000	R02	163
	replace rd_pd with "136" for rd_pd='050' //	1/3 ABONO DE FERIAS	1	100,000	F01	136
	replace rd_pd with "151" for rd_pd='053' // DIF. DE ABONO DE FER	1		F01	151
	replace rd_pd with "107" for rd_pd='009' //	1a PARCELA 13o SALAR	1	100,000	P09	107
	replace rd_pd with "143" for rd_pd='022' //	FERIAS INDENIZADAS	1	100,000	R01	143
	replace rd_pd with "243" for rd_pd='144' //	31o.Dia	1		P01	243
	replace rd_pd with "144" for rd_pd='023' //	FERIAS PROPORCIONAIS	1	100,000	R01	144
	replace rd_pd with "160" for rd_pd='056' //	AVISO PREV.INDENIZ.	1	100,000	P05	160
	replace rd_pd with "170" for rd_pd='057' //	1/3 DE FERIAS RESCIS	1	100,000	R01	170
	replace rd_pd with "164" for rd_pd='065' //	13o SALARIO INDENIZA	1		R02	164
	replace rd_pd with "477" for rd_pd='360' // DIF EMP CONSIG FOLHA	2		D13	477
	replace rd_pd with "463" for rd_pd='368' //	P.CONTAS-ALEXANDRE LIMA	2			463
	replace rd_pd with "463" for rd_pd='369' //	P.CONTAS-ALIOMAR FARIAS	2			463
	replace rd_pd with "463" for rd_pd='370' //	P.CONTAS-DJAN CARLOS	2			463
	replace rd_pd with "463" for rd_pd='371' //	P.CONTAS-ADERSON TAVARES	2			463
	replace rd_pd with "463" for rd_pd='372' //	P.CONTAS-GERSON ANDRADE	2			463
	replace rd_pd with "463" for rd_pd='373' //	P.CONTAS-MARIA ILZA	2			463
	replace rd_pd with "463" for rd_pd='374' //	P.CONTAS-RENATO SANTOS	2			463
	replace rd_pd with "463" for rd_pd='375' //	P.CONTAS-RONALDO LAMARAO	2			463
	replace rd_pd with "463" for rd_pd='376' //	P.CONTAS-PEDRO ANDRADE	2			463
	replace rd_pd with "422" for rd_pd='147' //	CONT.ASSISTENCIAL ME	2	1,000	D05	422
	replace rd_pd with "275" for rd_pd='250' //	VALE CRECHE	1		P05	275
	replace rd_pd with "276" for rd_pd='247' //	ETAPA	1		P05	276
	replace rd_pd with "281" for rd_pd='141' //	ADIC.NOT.S/HS.EXT.NO	1	20,000	P03	281
	replace rd_pd with "283" for rd_pd='184' //	IND.LEI 6.708 (Multa Dissidio)	1		P05	283
	replace rd_pd with "319" for rd_pd='246' //	REP.REMUN.MARITIMO	1		P05	319
	replace rd_pd with "320" for rd_pd='249' //	ADIC.PERIC.MARITIMO	1		P03	320
	replace rd_pd with "321" for rd_pd='259' //	H.EXT.MARIT.60%	1	100,000	P02	321
	replace rd_pd with "322" for rd_pd='260' //	GRATIF.PRATICAGEM	1		P04	322	
	replace rd_pd with "325" for rd_pd='266' //	ADIC.NOT.MARITIMO	1		P03	325
	replace rd_pd with "105" for rd_pd='284' //	GRATIFICACAO QUINQUE	1		P04	105
	replace rd_pd with "119" for rd_pd='142' //	DIF. INSALUBRIDADE	1		P05	119
	replace rd_pd with "329" for rd_pd='139' //	HS.EXT.NOTUR.50%	1	150,000	P02	329

// em 26/06.07
    replace rd_pd with "447" for rd_pd='007' //	DESC. DSR	2	100,000	D10	447
    replace rd_pd with "447" for rd_pd='487' //	DESC. DSR	2	100,000	D10	447
    replace rd_pd with "327" for rd_pd='367' //	REEMB LABORATORIO	1		P17	327
    replace rd_pd with "328" for rd_pd='378' //	REEMBOLSO SESI	1		P05	328
    replace rd_pd with "330" for rd_pd='230' //	H.EXT.50%-TELEFON	1	150,000		330
    replace rd_pd with "230" for rd_pd='035' //	DIFERENCA SALARIAL	1	100,000	P01	230
    replace rd_pd with "331" for rd_pd='351' //	HS BANC 75%	1	175,000	P02	331
    replace rd_pd with "332" for rd_pd='352' //	HS BANCO 100%	1	200,000	P02	332
    replace rd_pd with "333" for rd_pd='238' //	ADIC.SOBREAVISO	1		P03	333
//    replace rd_pd with "
// 134	HS.EXT.50% IN ITINER	1	150,000	P02	-> sem movimento !!
    replace rd_pd with "134" for rd_pd='068' //	1/3 FERIAS NO MES	1		F01	134
    replace rd_pd with "135" for rd_pd='069' //	1/3 FERIAS NO PROXIM	1		F01	135
    replace rd_pd with "148" for rd_pd='071' //	DIF. 1/3 FERIAS MS	1		F01	148
    replace rd_pd with "147" for rd_pd='079' //	DIF. 1/3 FER. PAGAS	1		F01	147
    replace rd_pd with "146" for rd_pd='155' //	DIF. S/ FER MS	1		F01	146
    replace rd_pd with "155" for rd_pd='080' //	DIF. OUTROS ADIC FER	1		F01	155
    replace rd_pd with "158" for rd_pd='153' //	ARRED NAS FERIAS	1		P05	158
    replace rd_pd with "181" for rd_pd='133' //	IND.ART.479	1		P05	181
    replace rd_pd with "133" for rd_pd='154' //	MEDIA DE FERIAS MSEG	1		F01	133
    replace rd_pd with "110" for rd_pd='110' // 201	DIF.13O.SAL	1			110
    replace rd_pd with "334" for rd_pd='287' //	LICENCA S/REMUNERACA	2		D10	334
    replace rd_pd with "335" for rd_pd='296' //	H.EXTRA 75%- TELEFONISTA	1	175,000	P02	335
    replace rd_pd with "117" for rd_pd='132' //	DIF.PERICUL.RESC	1		P05	117
    replace rd_pd with "132" for rd_pd='125' //	MEDIA DE FERIAS	1	100,000	F01	132
    replace rd_pd with "153" for rd_pd='126' //	DIF.MEDIA FERIAS	1		F01	153
    replace rd_pd with "241" for rd_pd='127' //	MEDIA 13o SALARIO	1	100,000		241
    replace rd_pd with "336" for rd_pd='152' //	AUXILIO FUNERAL	1		D08	336
    replace rd_pd with "152" for rd_pd='277' //	DIF. 1/3 ABONO PECUN	1		P08	152
    replace rd_pd with "126" for rd_pd='297' //	SALDO DE SALARIO	1	100,000	P01	126
    replace rd_pd with "139" for rd_pd='298' //	MEDIA SOBRE HORAS	1	100,000	F01	139
    replace rd_pd with "140" for rd_pd='299' //	MEDIA SOBRE HORAS MS	1		F01	140
    replace rd_pd with "154" for rd_pd='302' //	DIF MED HOR MES SEG	1		F01	154
    replace rd_pd with "275" for rd_pd='253' //	DIF VALE CRECHE	1		P05	275
    replace rd_pd with "253" for rd_pd='304' //	MEDIA FER PROP RESC	1	100,000	F01	253
    replace rd_pd with "254" for rd_pd='305' //	MEDIA FERIAS VENCIDAS RESCISAO	1	100,000	F01	254
    replace rd_pd with "256" for rd_pd='306' //	MEDIA AVISO PREVIO RESCISAO	1	100,000	F09	256
    replace rd_pd with "432" for rd_pd='311' //	DIF.VALE RANCHO	1			432
    replace rd_pd with "311" for rd_pd='307' //	MEDIA 13O. SALARIO RESCISAO	1	100,000	N05	311
    replace rd_pd with "262" for rd_pd='255' //	DIF.GRATIFICACAO	1		P05	262
    replace rd_pd with "257" for rd_pd='309' //	MEDIA 13O. SALARIO SOBRE AVISO	1	100,000	N05	257
    replace rd_pd with "109" for rd_pd='312' // ARREND 13O SALARIO	1	100,000	P10	109
    replace rd_pd with "125" for rd_pd='350' //	INSUF DE SALDO	1		P05	125             - so tinha uma ocorrencia!
    replace rd_pd with "183" for rd_pd='382' //	ARRED EMP CONS FOLHA	1	100,000	P13	183
    replace rd_pd with "423" for rd_pd='010' // I.N.S.S. DE 13o SALA	2	100,000	D03	423
    replace rd_pd with "421" for rd_pd='011' //	CONTRIBUICAO SINDICA	2	100,000	D05	421
    replace rd_pd with "415" for rd_pd='012' //	PENSAO ALIMENTICIA J	2	100,000	D06	415
    replace rd_pd with "420" for rd_pd='028' //	I.R.R.F. FERIAS	2		D07	420
    replace rd_pd with "440" for rd_pd='033' //	ADIANTAMENTOS 13o SA	2	100,000	D11	440
    replace rd_pd with "522" for rd_pd='405' //	LIQ PG RESC ANTER	2		R03	522
    replace rd_pd with "405" for rd_pd='034' //	ADIANTAMENTOS 13O	2	100,000		405
    replace rd_pd with "425" for rd_pd='041' //	ADIANT.CONF.REC.FERI	2	100,000	F02	425
    replace rd_pd with "424" for rd_pd='046' //	I.R.R.F. 13o SALARIO	2	100,000	D07	424
    replace rd_pd with "439" for rd_pd='048' //	ADIANTAMENTOS 13o SA	2	100,000		439
    replace rd_pd with "418" for rd_pd='074' //	I.N.S.S. FERIAS	2		D03	418
    replace rd_pd with "438" for rd_pd='383' //	ARRED EMP CONS FOLHA	2	100,000	D15	438
    replace rd_pd with "433" for rd_pd='403' //	FERIAS PAGA MES ANTE	2	100,000	D18	433
    replace rd_pd with "427" for rd_pd='404' //	2A. PARC. 13O. RESC	2			427
    replace rd_pd with "402" for rd_pd='491' //	ARRED ADIANTAMENTO	2	100,000	D01	402
    replace rd_pd with "428" for rd_pd='492' //	LIQ PAGO RESCISAO	2	100,000	R03	428

// iniciado em 03/07/2007 e relacionamento das verbas x LPs
    replace rd_pd with "181" for rd_pd='177' //	MULTA ART.477 p.8 CL	1		P05	181    
    replace rd_pd with "212" for rd_pd='178' //	IND.ESTAB.PROVISORIA	1		P05	212

    replace rd_pd with "755" for rd_pd='747' //	DED INSS 13 SAL	3	100,000		755
    replace rd_pd with "747" for rd_pd='701' //	% INSS EMPRESA	3	100,000	B01	747
    replace rd_pd with "748" for rd_pd='702' //	% TERCEIROS	3	100,000	B01	748
    replace rd_pd with "703" for rd_pd='710' //	SAL CT ATE LIM FOL	3	100,000		703
    replace rd_pd with "704" for rd_pd='711' //	SAL CT ACIMA LIM FOL	3	100,000		704
    replace rd_pd with "709" for rd_pd='712' //	SAL CT ATE LIM 13	3	100,000		709
    replace rd_pd with "710" for rd_pd='713' //	SAL CT ACIMA LIM 13	3	100,000		710
    replace rd_pd with "707" for rd_pd='714' //	BASE FGTS	3	100,000		707
    replace rd_pd with "888" for rd_pd='715' //	BASE FGTS RES DISP	3	100,000		888
    replace rd_pd with "722" for rd_pd='716' //	BASE FGTS 13 SAL	3	100,000		722
    replace rd_pd with "889" for rd_pd='717' //	BASE FGTS 13 RES DIS	3	100,000		889
    replace rd_pd with "702" for rd_pd='722' //	BASE IR ADTO SAL(DF)	3	100,000		702
    replace rd_pd with "915" for rd_pd='723' //	BASE IR FER OUT PERI	3	100,000		915
    replace rd_pd with "713" for rd_pd='799' //	LIQUIDO A RECEBER	3		D09	713
    replace rd_pd with "701" for rd_pd='725' //	BASE IR ADTO SAL	3	100,000		701
    replace rd_pd with "705" for rd_pd='726' //	BASE IR SALARIO	3	100,000		705
    replace rd_pd with "706" for rd_pd='727' //	BASE IR FERIAS	3	100,000		706
    replace rd_pd with "712" for rd_pd='728' //	BASE IR 13	3	100,000		712
    replace rd_pd with "714" for rd_pd='729' //	BASE PENSAO ALIM FOL	3	100,000		714
    replace rd_pd with "720" for rd_pd='730' //	DIF BASE IR FER	3	100,000		720
    replace rd_pd with "715" for rd_pd='740' //	DED DEP IR FOL	3	100,000		715
    replace rd_pd with "716" for rd_pd='741' //	DED DEP IR FER	3	100,000		716
    replace rd_pd with "718" for rd_pd='742' //	DED DEP IR 13 SAL	3	100,000		718
    replace rd_pd with "212" for rd_pd='178' // CORREÇÃO:178	IND.ESTAB.PROVISORIA	1		P05	212
    replace rd_pd with "232" for rd_pd='200' //	PIS REND/ABONO	1			232
    replace rd_pd with "337" for rd_pd='059' //	DIF. SALARIO FAMILIA	1	100,000	P06	337
    replace rd_pd with "717" for rd_pd='743' //	DED DEP DIF FERIAS	3	100,000		717
    replace rd_pd with "753" for rd_pd='745' //	DED INSS FOL	3	100,000		753
    replace rd_pd with "725" for rd_pd='754' //	FGTS DEPOSITADO RESC	3	100,000		725
    replace rd_pd with "754" for rd_pd='746' //	DED INSS FER	3	100,000		754
    replace rd_pd with "708" for rd_pd='750' //	FGTS	3	100,000	B02	708
    replace rd_pd with "723" for rd_pd='751' //	FGTS 13 SAL	3	100,000		723
    replace rd_pd with "726" for rd_pd='752' //	FGTS QUITACAO	3	100,000		726
    replace rd_pd with "724" for rd_pd='755' //	FGTS MES ANTERIOR	3	100,000		724
    replace rd_pd with "727" for rd_pd='756' //	FGTS ARTIGO 22 (40%)	3	100,000		727
    replace rd_pd with "832" for rd_pd='760' //	C.S. 0.5% REM FOL	3	0,500	B02	832
    replace rd_pd with "833" for rd_pd='761' //	C.S. 0.5% REM 13 SAL	3	0,500		833
    replace rd_pd with "829" for rd_pd='762' //	C.S. 0.5% REM RES	3	0,500		829
    replace rd_pd with "830" for rd_pd='763' //	C.S. 0.5% REM 13 RES	3	0,500		830
    replace rd_pd with "831" for rd_pd='764' //	C.S. 10% SALDO FGTS	3			831
    replace rd_pd with "918" for rd_pd='780' //	SALARIO DO MES	3			918
    replace rd_pd with "713" for rd_pd='799' //	LIQUIDO A RECEBER	3		D09	713
    replace rd_pd with "624" for rd_pd='825' //	HORAS EFETIVAS TRABALHADAS	3	100,000		624    
    
    
	Alert("Fim da Atualização dos CC em SRD")	
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
AADD(aRegs,{cPerg,"01", "Ano  Referencia    ?", ".", ".", "mv_ch1", "C", 04, 0, 0, "G", "", "mv_par01", ""         , "" , "" , "" , "" , ""          , "", "", "", "", ""       , "", "", "", "", ""     , "", "", "", "", ""    , "", "", "", ""   , "", "", "", "" })
AADD(aRegs,{cPerg,"02", "Mes referencia     ?", ".", ".", "mv_ch2", "C", 02, 0, 0, "G", "", "mv_par02", ""         , "" , "" , "" , "" , "   "       , "", "", "", "", "       ", "", "", "", "", "    " , "", "", "", "", "    ", "", "", "", ""   , "", "", "", "" })

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


