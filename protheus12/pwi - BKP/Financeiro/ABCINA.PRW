#include "rwmake.ch"
#include "TOPCONN.CH"
																																												  /*
   Desenvolvedor: Ellcyo Castro
   Data.........: 10/09/2004 
   Objetivo.....: Relatório ABC de Inadimplência
   *************************************************************************************************************************************
   ** Alterações * Favor Adicionar Todas as Alteração Realizadas ***********************************************************************
   *************************************************************************************************************************************
	|Data			 | Programador				| Alteração
	*************************************************************************************************************************************
	|24/01/2005  | Ellcyo / Gustavo     | Rotina alterada p/ Script SQL - p/ obter melhor performance   
	|31/01/2005  | Ellcyo               | Inclusão de Clausula p/ Listar por vendedor e por Período de Data
	|02/02/2005  | Ellcyo               | Inclusao do Campo SA3->A3_HPAGE : Onde mostra o Nome do Vendedor
   *************************************************************************************************************************************/

User Function ABCINA
	Local cString:="SA1"
  	Local Tamanho:="G"
  	Local wnRel  := "ABCINA"
  	Local cDesc1 := ""
  	Local cDesc2 := ""
  	Local cDesc3 := ""
  
  	Private aReturn     := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 } 
  	Private aLinha      := {}
  	Private aPerg       := {}  
  	Private nLastKey    := 0
  	
  	Private Titulo      :="CURVA ABC DE INADIMPLENCIA"   
  	Private n_Endereco  :="" 
  	Private n_Empresa   :="" 
  	Private n_Separacao := Replicate("-",132)
  	Private n_Situacao  := ""
  	Private n_Quant     := 0.00
  	Private n_Preco     := 0.00
  	Private n_Total     := 0.00
    Private n_Valor     := ""
  	Private NomeProg    := "ABCINA"
  	Private cPerg       := "ABCINA"
  	Private _Filial     := ""
  	Private _Filial2    := ""
	Private aOrd       := {"Nome", "Valor", "Vencimento"}

  	Pergunte(cPerg,.F.)
           
  	wnRel:= SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,,Tamanho)

  	wnrel:="ABCINA" //- Nome Default do relatorio em Disco  
  
  	If nLastKey = 27
   	Return
  	Endif
  
  	SetDefault(aReturn,cString)
  
  	If nLastKey = 27
   	Return
  	Endif

  	RptStatus({|lEnd| ABCINAIMP(@lEnd,wnRel,cString)},titulo)
  	
Return

Static Function ABCINAIMP(lEnd,wnRel,cString)
	Local c_Arq,c_Ind,c_Key
  	Local aStru    := {}                          
  	Local Tamanho  :="G"
  	Local Limite   := 132
  	Local lContinua:= .t.,nTipo, n_Total
  	Local Nomeprog := "ABCINA"              
  	Local cEmp:= SM0->M0_CODIGO
   
	Private aInad := {}
	Private nPos  := 0
	
	SetPrvt("nComp,nNorm,p_negrit_l,p_reset,p_negrit_d")
	p_negrit_l:= "E"              
  	p_reset:= "@"
  	p_negrit_d:= "F"
  	
	nTipo := Iif(aReturn[4]=1,15,18)
  	m_pag := 1
  	li    := 80
  	If mv_par05 = 1
  		Titulo:= "CURVA ABC DE INADIMPLENCIA: - POR CLIENTE"
  	Else
  		Titulo:= "CURVA ABC DE INADIMPLENCIA: - POR VENDEDOR"
  	Endif
  	n_Acumulado:= 0.00
  	n_Atraso:= 0.00
  	n_Titulos:= 0.00
   
  	nNorm:= GetMV("MV_NORM")
	
//***************************************************************************************
// Validação do Cabeçalho do Relatório
	if mv_par01 = "01"
		n_Empresa := "MARCODIESEL IMP. E EXP. LTDA - MATRIZ"
		n_Endereco:= "AV. DJALMA BATISTA, 122 - CHAPADA"
		n_CNPJ    := "04.169.280/0001-17"
	Elseif mv_par01 = "02"
		n_Empresa := "MARCODIESEL IMP. E EXP. LTDA - AV. BRASIL"
		n_Endereco:= "AV. BRASIL, 176 - SANTO ANTONIO" 
		n_CNPJ    := "04.169.280/0002-06"
	Elseif mv_par01 = "03"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - PORTO VELHO"
		n_Endereco:= "AV. CEL JORGE TEIXEIRA 2983 - LIBERDADE" 
		n_CNPJ:= "04.169.280/0003-89"
	Elseif mv_par01 = "04"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - OFICINA"
		n_Endereco:= "AV. DJALMA BATISTA, 122 - FUNDOS - CHAPADA" 
		n_CNPJ:= "04.169.280/0004-60"
	Elseif mv_par01 = "05"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - COSTA E SILVA"
		n_Endereco:= "AV. COSTA E SILVA 764 - A - CRESPO" 
		n_CNPJ:= "04.169.280/0006-21"
	Elseif mv_par01 = "06"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - TORQUATO"
		n_Endereco:= "ESTRADA TORQUATO TAPAJOS 500C - FLORES" 
		n_CNPJ:= "04.169.280/0008-93"
	Elseif mv_par01 = "07"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - MARCOLAR FLORES"
		n_Endereco:= "ESTRADA TORQUATO TAPAJOS 500C - FLORES" 
 		n_CNPJ:= "04.169.280/0009-74"
	Elseif mv_par01 = "08"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - MARCOLAR CACHOEIRINHA"
		n_Endereco:= "RUA PROF MARCIANO ARMAOND 1546 - CACHOEIRINHA" 
		n_CNPJ:= "04.169.280/0010-08"
	Elseif mv_par01 = "09"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - TANCREDO"
		n_Endereco:= "AV. AUTAZ MIRIM 7533 - TANCREDO" 
		n_CNPJ:= "04.169.280/0011-99"
	Elseif mv_par01 = "10"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - INFORMATICA"
		n_Endereco:= "AV. DJALMA BATISTA, 122 - CHAPADA" 
		n_CNPJ:= "04.169.280/0012-70"
	Elseif mv_par01 = "11"
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - BOA VISTA"
		n_Endereco:= "AV. DAS GUIANAS, 1632 - SAO VICENTE" 
		n_CNPJ:= "04.169.280/0013-50"
	Else
		n_Empresa:= "MARCODIESEL IMP. E EXP. LTDA - GERAL"
		n_Endereco:= "AV. DJALMA BATISTA, 122 - CHAPADA" 
		n_CNPJ:= "04.169.280/0001-17"
	EndIf
//*****************************************************************************************************************
//** Final do Procedimento ****************************************************************************************
//*****************************************************************************************************************
   

//***************************************************************************************
// Define Parametros de Filial por Prefixo para consulta no SE1
	Do Case
		Case mv_par01 = "01";  	_Filial:= "A" 
		Case mv_par01 = "02";  	_Filial:= "B" 
		Case mv_par01 = "03";  	_Filial:= "C"                  
		Case mv_par01 = "04";  	_Filial:= "F" 
		Case mv_par01 = "05";  	_Filial:= "G" 
		Case mv_par01 = "06";	_Filial:= "H" 
		Case mv_par01 = "07";	_Filial:= "E" 
		Case mv_par01 = "08";	_Filial:= "D" 
		Case mv_par01 = "09";	_Filial:= "I" 
		Case mv_par01 = "10";	_Filial:= "J" 
		Case mv_par01 = "11";	_Filial:= "L" 
		OtherWise;					_Filial:= " " 
	End Case
	
	Do Case
		Case mv_par02 = "01";  	_Filial2:= "A" 
		Case mv_par02 = "02";  	_Filial2:= "B" 
		Case mv_par02 = "03";  	_Filial2:= "C" 
		Case mv_par02 = "04";  	_Filial2:= "F" 
		Case mv_par02 = "05";  	_Filial2:= "G" 
		Case mv_par02 = "06";	_Filial2:= "H" 
		Case mv_par02 = "07";	_Filial2:= "E"           	
		Case mv_par02 = "08";	_Filial2:= "D" 
		Case mv_par02 = "09";	_Filial2:= "I" 
		Case mv_par02 = "10";	_Filial2:= "J" 
		Case mv_par02 = "11";	_Filial2:= "L" 
		OtherWise;					_Filial2:= "Z" 
	End Case
//*****************************************************************************************************************
//** Final do Procedimento ****************************************************************************************
//*****************************************************************************************************************
/*                                ____
  ||   ||     ||      e||e       e||||\     ||
 |||| ||||   ||||    e|||||e     e||| ||   ||||
 |||| |||||| ||||   e||| |||e    e|||  ||  ||||
 |||| |||| ||||||  e|||||||||e   e|||  ||  ||||
 |||| ||||  ||||| e||||   ||||e  e||| ||   ||||
  ||   ||     ||  e|||     |||e  e||||      ||
 
*/
//***************************************************************************************
// Definição de Paramentro SX1010
// mv_par08 = 1 - Analitico e 2 = Sintetico
// mv_par05 = 1 - Cliente   e 2 = Vendedor
	If mv_par08 = 2
		If mv_par05 = 1
			c_Query1 := " SELECT E1_CLIENTE, A1_NOME, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010 "
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA NOT IN ('01.010.001','01.002.01','01.005.01') AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]'  AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_CLIENTE, A1_NOME "
			If aReturn[8]=1
				c_Query1 += " ORDER BY A1_NOME"
			Else
				c_Query1 += " ORDER BY VALOR DESC"
			Endif
		  	TcQuery c_Query1 New Alias Base01
	

			//Seleciona Titulos em Garantia
			c_Query1 := " SELECT E1_CLIENTE, A1_NOME, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010 "
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA = '01.010.001' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]'  AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_CLIENTE, A1_NOME "
			If aReturn[8]=1
				c_Query1 += " ORDER BY A1_NOME"
			Else
				c_Query1 += " ORDER BY VALOR DESC"
			Endif
		  	TcQuery c_Query1 New Alias qGara


			//Seleciona Titulos de Funcionários
			c_Query1 := " SELECT E1_CLIENTE, A1_NOME, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010 "
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA = '01.005.01' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]'  AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_CLIENTE, A1_NOME "
			If aReturn[8]=1
				c_Query1 += " ORDER BY A1_NOME"
			Else
				c_Query1 += " ORDER BY VALOR DESC"
			Endif
		  	TcQuery c_Query1 New Alias qFunc


			//Seleciona Titulos de Conveniados
			c_Query1 := " SELECT E1_CLIENTE, A1_NOME, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010 "
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA = '01.002.01' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]'  AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_CLIENTE, A1_NOME "
			If aReturn[8]=1
				c_Query1 += " ORDER BY A1_NOME"
			Else
				c_Query1 += " ORDER BY VALOR DESC"
			Endif
		  	TcQuery c_Query1 New Alias qConv


         //Seleciona NCCs
			c_Query1 := " SELECT E1_CLIENTE, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010 "
			c_Query1 += " WHERE E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[D]'  AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_CLIENTE "
			c_Query1 += " ORDER BY VALOR DESC"
		  	TcQuery c_Query1 New Alias qNCC
	   Else
			c_Query1 := " SELECT E1_VEND1, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010"
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND "
			c_Query1 += " E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA NOT IN ('01.010.001','01.002.01','01.005.01') AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]' AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_VEND1 "
			c_Query1 += " ORDER BY VALOR DESC"
		  	TcQuery c_Query1 New Alias Base01
	
			//Selectiona Titulos em Garantia
			c_Query1 := " SELECT E1_VEND1, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010"
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND "
			c_Query1 += " E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA = '01.010.001' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]' AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_VEND1 "
			c_Query1 += " ORDER BY VALOR DESC"
		  	TcQuery c_Query1 New Alias qGara


			//Selectiona Titulos Funcionários
			c_Query1 := " SELECT E1_VEND1, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010 "
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND "
			c_Query1 += " E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA = '01.005.01' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]' AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_VEND1 "
			c_Query1 += " ORDER BY VALOR DESC"
		  	TcQuery c_Query1 New Alias qFunc



			//Selectiona Titulos de Convenios
			c_Query1 := " SELECT E1_VEND1, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010, SA1010"
			c_Query1 += " WHERE E1_CLIENTE = A1_COD AND "
			c_Query1 += " E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND A1_YCONTA = '01.002.01' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]' AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_VEND1 "
			c_Query1 += " ORDER BY VALOR DESC"
		  	TcQuery c_Query1 New Alias qConv


			//Relatório de NCC
			c_Query1 := " SELECT E1_VEND1, COUNT(*) AS TITULOS, SUM(E1_SALDO) AS VALOR, "
			c_Query1 += " MAX(-(Datediff(d, GetDate(), Convert (DateTime, E1_VENCREA)))) AS ATRASO "
			c_Query1 += " FROM SE1010 "
			c_Query1 += " WHERE E1_VENCREA <= '" + (DTOS(Date() - 5)) + "' AND E1_SALDO > 0 AND "
			c_Query1 += " D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND "
			c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[D]' AND "
			c_Query1 += " LEFT(E1_PREFIXO, 1) >= '" + _Filial + "' AND LEFT(E1_PREFIXO, 1) <= '" + _Filial2 + "' AND "
			c_Query1 += " E1_CLIENTE >= '" + mv_par03 + "' AND E1_CLIENTE <= '" + mv_par04 + "' AND "
			c_Query1 += " E1_VENCREA >= '" + DtoS(mv_par06) + "' AND E1_VENCREA <= '" + DtoS(mv_par07) + "' "
			c_Query1 += " GROUP BY E1_VEND1 "
			c_Query1 += " ORDER BY VALOR DESC"
		  	TcQuery c_Query1 New Alias qNCC
	   Endif

		If mv_par05 = 1
			Do While !Base01->(Eof())
				dbSelectArea("Base01")
				aadd(aInad, {E1_CLIENTE, TITULOS, ATRASO, VALOR, 0})
				
				Base01->(dbSkip())
			Enddo
			
			Do While !qNCC->(Eof())
				dbSelectArea("qNCC")
				nPos:= aScan(aInad,{|x| x[1] = E1_CLIENTE})
				
				If nPos <> 0
					aInad[nPos, 5] += -VALOR
				Else
					aadd(aInad, {E1_CLIENTE, TITULOS, ATRASO, 0, -VALOR})
				Endif
		
				qNCC->(dbSkip())
			Enddo
		Else
			Do While !Base01->(Eof())
				dbSelectArea("Base01")
				aadd(aInad, {E1_VEND1, TITULOS, ATRASO, VALOR, 0})
				
				Base01->(dbSkip())
			Enddo
			
			Do While !qNCC->(Eof())
				dbSelectArea("qNCC")
				nPos:= aScan(aInad,{|x| x[1] = E1_VEND1})
				
				If nPos <> 0
					aInad[nPos, 5] += -VALOR
				Else
					aadd(aInad, {E1_VEND1, TITULOS, ATRASO, 0, -VALOR})
				Endif
		
				qNCC->(dbSkip())
			Enddo
		Endif   
	
	   n_TotalGeral:= 0.00
	   n_Credito := 0.00
	   n_Total := 0.00
	   pg:=0

	  	For i:= 1 to Len(aInad)
	   	If lEnd
	      	@Prow()+1,001 PSay OemToAnsi("Cancelado pelo operador")
	        	lContinua := .F.
	        	Exit
	     	Endif
	     
	     	If li > 58
	     	   pg++
	
				// Inicio da Impressao
			  	@0, 000 PSay Chr(18)
			  	@0, 000 PSay "Empresa..: " + n_Empresa
			  	@0, 115 PSay "Pagina.: " + str(pg,8)
			  	@1, 000 PSay "Endereco.: " + n_Endereco
			  	@1, 115 PSay "Emissao: "
			  	@1, 124 PSay Date()
			  	@2, 000 PSay "CNPJ.....: " + n_CNPJ
			  	@2, 115 PSay "Hora...: "
			  	@2, 124 PSay Time()
			  	@3, 050 PSay "Periodo de:"
			  	@3, 062 PSay mv_par06
			  	@3, 072 PSay " a " 
			  	@3, 078 PSay mv_par07 
			  	@4, 028 PSay p_negrit_l + " " + Titulo + " " + p_negrit_d
			  	li:= 5  
			  	@li, 00 PSay n_Separacao
	        	li++
	        	If mv_par05 = 1
	        		@li,00 PSay "CLIENTE   NOME DO CLIENTE                            TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Else
	        		@li,00 PSay "VENDEDOR  NOME DO VENDEDOR                           TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Endif
	//                       000000    99999999999999999999999999999999999999999    99999    99999  999.999.999,99  999.999.999,99  999.999.999,99
	//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	//                       0         1         2         3         4         5         6         7         8         9       100       110
	        	li++
	        	@li,00 PSay n_Separacao
	        	li++
			Endif                                                         
	     	If mv_par05 = 1
		     	@li, 000 PSay aInad[i, 1]
		     	@li, 010 PSay Posicione("SA1", 1, xFilial() + aInad[i, 1], "A1_NOME")
	     	Else
		     	@li, 000 PSay aInad[i, 1]
		     	@li, 010 PSay Posicione("SA3", 1, xFilial("SA3") + aInad[i, 1], "A3_HPAGE")
		   Endif
		   @li, 055 PSay aInad[i, 2]
		   @li, 064 PSay aInad[i, 3]
		   @li, 071 PSay aInad[i, 4] Picture "@E 999,999,999.99" 
		   @li, 087 PSay aInad[i, 5] Picture "@E 999,999,999.99" 
		   @li, 103 PSay aInad[i, 4] + aInad[i, 5] Picture "@E 999,999,999.99" 
		  	li++
	
		   n_TotalGeral += aInad[i, 4]
		   n_Credito += aInad[i, 5]
		   n_Total += aInad[i, 4] + aInad[i, 5]
		Next
	  	@li,00 PSay n_Separacao
	  	li++
	  	@li, 000 PSay "TOTAL GERAL DE INADIMPLENCIA >>>>>>>"
	  	@li, 071 PSay n_TotalGeral Picture "@E 999,999,999.99"
	  	@li, 087 PSay n_Credito Picture "@E 999,999,999.99"
	  	@li, 103 PSay n_Total Picture "@E 999,999,999.99"
	  	li++
	  	li:=80
	

//*************************************************************************************
//Imprime as Garantias
	   n_gTotalGeral:= 0.00
	   n_gCredito := 0.00
	   n_gTotal := 0.00

	  	dbSelectArea("qGara")
	  	dbGotop()
	  	
	  	Do While !Eof()
	   	If lEnd
	      	@Prow()+1,001 PSay OemToAnsi("Cancelado pelo operador")
	        	lContinua := .F.
	        	Exit
	     	Endif
	     
	     	If li > 58
	     	   pg++
	
				// Inicio da Impressao
			  	@0, 000 PSay Chr(18)
			  	@0, 000 PSay "Empresa..: " + n_Empresa
			  	@0, 115 PSay "Pagina.: " + str(pg,8)
			  	@1, 000 PSay "Endereco.: " + n_Endereco
			  	@1, 115 PSay "Emissao: "
			  	@1, 124 PSay Date()
			  	@2, 000 PSay "CNPJ.....: " + n_CNPJ
			  	@2, 115 PSay "Hora...: "
			  	@2, 124 PSay Time()
			  	@3, 050 PSay "Periodo de:"
			  	@3, 062 PSay mv_par06
			  	@3, 072 PSay " a " 
			  	@3, 078 PSay mv_par07 
			  	@4, 028 PSay p_negrit_l + " " + "CURVA ABC DE INADIMPLENCIA - GARANTIAS" + " " + p_negrit_d
			  	li:= 5  
			  	@li, 00 PSay n_Separacao
	        	li++
	        	If mv_par05 = 1
	        		@li,00 PSay "CLIENTE   NOME DO CLIENTE                            TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Else
	        		@li,00 PSay "VENDEDOR  NOME DO VENDEDOR                           TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Endif
	//                       000000    99999999999999999999999999999999999999999    99999    99999  999.999.999,99  999.999.999,99  999.999.999,99
	//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	//                       0         1         2         3         4         5         6         7         8         9       100       110
	        	li++
	        	@li,00 PSay n_Separacao
	        	li++
			Endif                                                         
	     	If mv_par05 = 1
		     	@li, 000 PSay E1_CLIENTE
		     	@li, 010 PSay Posicione("SA1", 1, xFilial() + E1_CLIENTE, "A1_NOME")
	     	Else
		     	@li, 000 PSay E1_VEND1
		     	@li, 010 PSay Posicione("SA3", 1, xFilial("SA3") + E1_VEND1, "A3_HPAGE")
		   Endif

		   @li, 055 PSay TITULOS
		   @li, 064 PSay ATRASO
		   @li, 071 PSay VALOR Picture "@E 999,999,999.99"
		   @li, 087 PSay 0 Picture "@E 999,999,999.99"
		   @li, 103 PSay VALOR Picture "@E 999,999,999.99"
		  	li++
	
		   n_TotalGeral += VALOR
		   n_Credito += 0
		   n_Total += VALOR

		   n_gTotalGeral += VALOR
		   n_gCredito += 0
		   n_gTotal += VALOR
			dbSkip()
		Enddo
	  	@li,00 PSay n_Separacao
	  	li++
	  	@li, 000 PSay "TOTAL GERAL DE GARANTIAS >>>>>>>"
	  	@li, 071 PSay n_gTotalGeral Picture "@E 999,999,999.99"
	  	@li, 087 PSay n_gCredito Picture "@E 999,999,999.99"
	  	@li, 103 PSay n_gTotal Picture "@E 999,999,999.99"
	  	li++
	  	li:=80
//*****************************************************************************************************************
//** Final do Procedimento de Garantias ***************************************************************************
//*****************************************************************************************************************
	


//*************************************************************************************
//Imprime Funcionários

	   n_fTotalGeral:= 0.00
	   n_fCredito := 0.00
	   n_fTotal := 0.00

	  	dbSelectArea("qFunc")
	  	dbGotop()
	  	
	  	Do While !Eof()
	   	If lEnd
	      	@Prow()+1,001 PSay OemToAnsi("Cancelado pelo operador")
	        	lContinua := .F.
	        	Exit
	     	Endif
	     
	     	If li > 58
	     	   pg++
	
				// Inicio da Impressao
			  	@0, 000 PSay Chr(18)
			  	@0, 000 PSay "Empresa..: " + n_Empresa
			  	@0, 115 PSay "Pagina.: " + str(pg,8)
			  	@1, 000 PSay "Endereco.: " + n_Endereco
			  	@1, 115 PSay "Emissao: "
			  	@1, 124 PSay Date()
			  	@2, 000 PSay "CNPJ.....: " + n_CNPJ
			  	@2, 115 PSay "Hora...: "
			  	@2, 124 PSay Time()
			  	@3, 050 PSay "Periodo de:"
			  	@3, 062 PSay mv_par06
			  	@3, 072 PSay " a " 
			  	@3, 078 PSay mv_par07 
			  	@4, 028 PSay p_negrit_l + " " + "CURVA ABC DE INADIMPLENCIA - FUNCIONARIOS" + " " + p_negrit_d
			  	li:= 5  
			  	@li, 00 PSay n_Separacao
	        	li++
	        	If mv_par05 = 1
	        		@li,00 PSay "CLIENTE   NOME DO CLIENTE                            TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Else
	        		@li,00 PSay "VENDEDOR  NOME DO VENDEDOR                           TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Endif
	//                       000000    99999999999999999999999999999999999999999    99999    99999  999.999.999,99  999.999.999,99  999.999.999,99
	//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	//                       0         1         2         3         4         5         6         7         8         9       100       110
	        	li++
	        	@li,00 PSay n_Separacao
	        	li++
			Endif                                                         
	     	If mv_par05 = 1
		     	@li, 000 PSay E1_CLIENTE
		     	@li, 010 PSay Posicione("SA1", 1, xFilial() + E1_CLIENTE, "A1_NOME")
	     	Else
		     	@li, 000 PSay E1_VEND1
		     	@li, 010 PSay Posicione("SA3", 1, xFilial("SA3") + E1_VEND1, "A3_HPAGE")
		   Endif

		   @li, 055 PSay TITULOS
		   @li, 064 PSay ATRASO
		   @li, 071 PSay VALOR Picture "@E 999,999,999.99"
		   @li, 087 PSay 0 Picture "@E 999,999,999.99"
		   @li, 103 PSay VALOR Picture "@E 999,999,999.99"
		  	li++
	
		   n_TotalGeral += VALOR
		   n_Credito += 0
		   n_Total += VALOR

		   n_fTotalGeral += VALOR
		   n_fCredito += 0
		   n_fTotal += VALOR
			dbSkip()
		Enddo
	  	@li,00 PSay n_Separacao
	  	li++
	  	@li, 000 PSay "TOTAL GERAL DE FUNCIONARIOS >>>>>>>"
	  	@li, 071 PSay n_fTotalGeral Picture "@E 999,999,999.99"
	  	@li, 087 PSay n_fCredito Picture "@E 999,999,999.99"
	  	@li, 103 PSay n_fTotal Picture "@E 999,999,999.99"
	  	li:=80
//*****************************************************************************************************************
//** Final do Procedimento de Funcionários ************************************************************************
//*****************************************************************************************************************



//*************************************************************************************
//Imprime Conveniados
	   n_cTotalGeral:= 0.00
	   n_cCredito := 0.00
	   n_cTotal := 0.00

	  	dbSelectArea("qConv")
	  	dbGotop()
	  	
	  	Do While !Eof()
	   	If lEnd
	      	@Prow()+1,001 PSay OemToAnsi("Cancelado pelo operador")
	        	lContinua := .F.
	        	Exit
	     	Endif
	     
	     	If li > 58
	     	   pg++
	
				// Inicio da Impressao
			  	@0, 000 PSay Chr(18)
			  	@0, 000 PSay "Empresa..: " + n_Empresa
			  	@0, 115 PSay "Pagina.: " + str(pg,8)
			  	@1, 000 PSay "Endereco.: " + n_Endereco
			  	@1, 115 PSay "Emissao: "
			  	@1, 124 PSay Date()
			  	@2, 000 PSay "CNPJ.....: " + n_CNPJ
			  	@2, 115 PSay "Hora...: "
			  	@2, 124 PSay Time()
			  	@3, 050 PSay "Periodo de:"
			  	@3, 062 PSay mv_par06
			  	@3, 072 PSay " a " 
			  	@3, 078 PSay mv_par07 
			  	@4, 028 PSay p_negrit_l + " " + "CURVA ABC DE INADIMPLENCIA - CONVENIOS" + " " + p_negrit_d
			  	li:= 5  
			  	@li, 00 PSay n_Separacao
	        	li++
	        	If mv_par05 = 1
	        		@li,00 PSay "CLIENTE   NOME DO CLIENTE                            TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Else
	        		@li,00 PSay "VENDEDOR  NOME DO VENDEDOR                           TITULOS   ATRASO          DEBITO         CREDITO           SALDO"
	        	Endif
	//                       000000    99999999999999999999999999999999999999999    99999    99999  999.999.999,99  999.999.999,99  999.999.999,99
	//                       012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
	//                       0         1         2         3         4         5         6         7         8         9       100       110
	        	li++
	        	@li,00 PSay n_Separacao
	        	li++
			Endif                                                         
	     	If mv_par05 = 1
		     	@li, 000 PSay E1_CLIENTE
		     	@li, 010 PSay Posicione("SA1", 1, xFilial() + E1_CLIENTE, "A1_NOME")
	     	Else
		     	@li, 000 PSay E1_VEND1
		     	@li, 010 PSay Posicione("SA3", 1, xFilial("SA3") + E1_VEND1, "A3_HPAGE")
		   Endif

		   @li, 055 PSay TITULOS
		   @li, 064 PSay ATRASO
		   @li, 071 PSay VALOR Picture "@E 999,999,999.99"
		   @li, 087 PSay 0 Picture "@E 999,999,999.99"
		   @li, 103 PSay VALOR Picture "@E 999,999,999.99"
		  	li++
	
		   n_TotalGeral += VALOR
		   n_Credito += 0
		   n_Total += VALOR

		   n_cTotalGeral += VALOR
		   n_cCredito += 0
		   n_cTotal += VALOR
			dbSkip()
		Enddo
	  	@li,00 PSay n_Separacao
	  	li++
	  	@li, 000 PSay "TOTAL GERAL DE CONVENIADOS >>>>>>>"
	  	@li, 071 PSay n_cTotalGeral Picture "@E 999,999,999.99"
	  	@li, 087 PSay n_cCredito Picture "@E 999,999,999.99"
	  	@li, 103 PSay n_cTotal Picture "@E 999,999,999.99"
	  	li:=80
//*****************************************************************************************************************
//** Final do Procedimento de Conveniados ************************************************************************
//*****************************************************************************************************************



//*************************************************************************************
//Imprime Resumo Geral de Inadimplência

	  	@00, 000 PSay Chr(15) + Chr(18)
	  	@00, 000 PSay "MARCODIESEL IMP. E EXP. LTDA"
      @01, 000 PSay "+" + Replicate("-",78) + "+" 
      @02, 000 PSay "|"    ;    @2, 079 PSay "|"
      @03, 000 PSay "|          R E S U M O    G E R A L    DE    I N A D I M P L E N C I A         |"
      @04, 000 PSay "|"    ;    @4, 079 PSay "|"  
      @05, 000 PSay "+" + Replicate("-",78) + "+" 
      @06, 000 PSay "| DESCRICAO                 |         DEBITO |        CREDITO |          SALDO |"
      @07, 000 PSay "+" + Replicate("-",78) + "+"
      @08, 000 PSay "| 01 - CLIENTES             |"
      @08, 030 PSay n_TotalGeral Picture "@E 999,999,999.99"
      @08, 045 PSay "|"
      @08, 047 PSay n_Credito Picture "@E 999,999,999.99"
      @08, 062 PSay "|"
      @08, 064 PSay n_Total Picture "@E 999,999,999.99"
      @08, 079 PSay "|"
      
      @09, 000 PSay "| 02 - GARANTIAS            |"
      @09, 030 PSay n_gTotalGeral Picture "@E 999,999,999.99"
      @09, 045 PSay "|"
      @09, 047 PSay n_gCredito Picture "@E 999,999,999.99"
      @09, 062 PSay "|"
      @09, 064 PSay n_gTotal Picture "@E 999,999,999.99"
      @09, 079 PSay "|"

      @10, 000 PSay "| 03 - FUNCIONARIOS         |"
      @10, 030 PSay n_fTotalGeral Picture "@E 999,999,999.99"
      @10, 045 PSay "|"
      @10, 047 PSay n_fCredito Picture "@E 999,999,999.99"
      @10, 062 PSay "|"
      @10, 064 PSay n_fTotal Picture "@E 999,999,999.99"
      @10, 079 PSay "|"
      
      @11, 000 PSay "| 02 - CONVENIOS            |"
      @11, 030 PSay n_cTotalGeral Picture "@E 999,999,999.99"
      @11, 045 PSay "|"
      @11, 047 PSay n_cCredito Picture "@E 999,999,999.99"
      @11, 062 PSay "|"
      @11, 064 PSay n_cTotal Picture "@E 999,999,999.99"
      @11, 079 PSay "|"
      
      @12, 000 PSay "|                           |"
      @12, 045 PSay "|"
      @12, 062 PSay "|"
      @12, 079 PSay "|"                 
      
      @13, 000 PSay "|" + Replicate("-",78) + "|"      
      
      @14, 000 PSay "| TOTAL GERAL ------------> |"
      @14, 030 PSay n_TotalGeral + ;
					     n_gTotalGeral + ;
					     n_fTotalGeral + ;
					     n_cTotalGeral  Picture "@E 999,999,999.99"
      
      @14, 045 PSay "|"
      @14, 047 PSay n_Credito  + ;
                    n_gCredito + ;
					     n_fCredito + ;
					     n_cCredito    Picture "@E 999,999,999.99"
      
      
      @14, 062 PSay "|"
      @14, 064 PSay n_Total + ;
                    n_gTotal + ;
                    n_fTotal + ;
                    n_cTotal     Picture "@E 999,999,999.99"
      @14, 079 PSay "|"
      @15, 000 PSay "+" + Replicate("-",78) + "+"
      


/*
         10        20        30        40        50        60        70
01234567890123456789012345678901234567890123456789012345678901234567890123456789 
MARCODIESEL IMP. E EXP. LTDA                                                    01
+------------------------------------------------------------------------------+02
|                                                                              |03
|	        R E S U M O    G E R A L    DE    I N A D I M P L E N C I A         |04
|                                                                              |05
|------------------------------------------------------------------------------|06
| DESCRICAO                 |         DEBITO |        CREDITO |          SALDO |07
|------------------------------------------------------------------------------|08
| 01 - CLIENTES             | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |09
| 02 - GARANTIAS            | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |10
| 03 - FUNCIONARIOS         | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |11
| 04 - CONVENIOS            | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |12
|                           | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |13
|------------------------------------------------------------------------------|14
| TOTAL GERAL ------------> | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |15
+------------------------------------------------------------------------------+16


                                                                               |
*/



	
	
	Else
		c_Query1 := " SELECT E1_NUM, E1_PREFIXO, E1_CLIENTE, A1_NOME, A1_NREDUZ, E1_SALDO, E1_VENCREA, A1_MUN, E1_VEND1, A3_HPAGE "
		c_Query1 += " FROM SE1010, SA1010, SA3010 "
		c_Query1 += " WHERE E1_CLIENTE = A1_COD AND E1_VEND1 *= A3_COD AND "
		c_Query1 += " E1_VENCREA <= '"+ DtoS(dDataBase) +"' - 5 AND E1_SALDO > 0 AND "
		c_Query1 += " SE1010.D_E_L_E_T_ <> '*' AND E1_CLIENTE <> '000001' AND "
		c_Query1 += " SUBSTRING(E1_PREFIXO, 2, 1) LIKE '[VF]'  AND "
		c_Query1 += " LEFT(E1_PREFIXO, 1) >= '"+ _Filial +"' AND LEFT(E1_PREFIXO, 1) <= '"+ _Filial2 +"' AND "
		c_Query1 += " E1_CLIENTE BETWEEN '"+ mv_par03 +"' AND '"+ mv_par04 +"' AND "
		c_Query1 += " E1_VENCREA BETWEEN '"+ DtoS(mv_par06) +"' AND '"+ DtoS(mv_par07) +"' "
		If aReturn[8]= 1
			c_Query1 += " ORDER BY A1_NOME"
		ElseIf aReturn[8]= 2
			c_Query1 += " ORDER BY E1_SALDO DESC"
		Else
			c_Query1 += " ORDER BY E1_VENCREA"
		Endif
	  	TcQuery c_Query1 New Alias qLista

	   n_TotalGeral:= 0.00
	   pg:=0

	  	dbSelectArea("qLista")
	  	dbGotop()
	  	
	  	Do While !Eof()
	   	If lEnd
	      	@Prow()+1,001 PSay OemToAnsi("Cancelado pelo operador")
	        	lContinua := .F.
	        	Exit
	     	Endif
	     
	     	If li > 58
	     	   pg++
	
				// Inicio da Impressao
			  	@0, 000 PSay Chr(18)
			  	@0, 000 PSay "Empresa..: " + n_Empresa
			  	@0, 115 PSay "Pagina.: " + str(pg,8)
			  	@1, 000 PSay "Endereco.: " + n_Endereco
			  	@1, 115 PSay "Emissao: "
			  	@1, 124 PSay Date()
			  	@2, 000 PSay "CNPJ.....: " + n_CNPJ
			  	@2, 115 PSay "Hora...: "
			  	@2, 124 PSay Time()
			  	@3, 050 PSay "Periodo de:"
			  	@3, 062 PSay mv_par06
			  	@3, 072 PSay " a " 
			  	@3, 078 PSay mv_par07 
			  	@4, 028 PSay p_negrit_l + " " + Titulo + " " + p_negrit_d
			  	@5, 000 PSay n_Separacao
        		@6, 000 PSay "NUMERO PFX CODIGO NOME DO CLIENTE          FANTASIA                  VALOR      JUROS  VENCTO  CIDADE          VENDEDOR" 
	//                     000000 AVF 999999 AAAAAAAAAAAAAAAAAAAAAAAA AAAAAAAAAAAAAAAAAAAA 999,999.99 999,999.99 99/99/99 URUCURITUBAAAAA AAAAAAAAAAAAAAAAAAAAAA
	//                     0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
	//                     0         1         2         3         4         5         6         7         8         9       100       110       120       130  
	        	@7, 000 PSay n_Separacao
	        	li := 8 
			Endif                                                         
	  	   @li, 000 PSay E1_NUM
	  	   @li, 007 PSay E1_PREFIXO
	  	   @li, 011 PSay E1_CLIENTE
	  	   @li, 018 PSay Left(A1_NOME, 24)
	  	   @li, 043 PSay A1_NREDUZ
	  	   @li, 064 PSay E1_SALDO Picture "@E 999,999.99"
	  	   @li, 075 PSay 0 Picture "@E 999,999.99"
	  	   @li, 086 PSay StoD(E1_VENCREA)
	  	   @li, 095 PSay A1_MUN
	  	   @li, 111 PSay Left(A3_HPAGE, 20)
		  	li++
	
			dbSkip()
		Enddo

	  	@li,00 PSay n_Separacao
	  	/*
	  	li++
	  	@li, 000 PSay "TOTAL GERAL DE INADIMPLENCIA >>>>>>>"
	  	@li, 071 PSay n_TotalGeral Picture "@E 999,999,999.99"
	  	@li, 087 PSay n_Credito Picture "@E 999,999,999.99"
	  	@li, 103 PSay n_Total Picture "@E 999,999,999.99"
	  	li++
      */

	Endif   

  	@60, 0   PSay n_Separacao
  	@61, 0   PSay "Marcodiesel - Microsiga - Ap6.09 -       <<<<<<<<<<<<<<<<<<<< FINAL DO RELATORIO >>>>>>>>>>>>>>>>>>>>"
  	@62, 0   PSay n_Separacao

  	Set Device to Screen

  	If aReturn[5] = 1
   	Set Printer To
     	Commit
     	Ourspool(wnrel)
  	Endif
  	MS_FLUSH()

	DbCloseAll()

  	OpenFile(cEmp)
Return





/*

01234567890123456789012345678901234567890123456789012345678901234567890123456789 
MARCODIESEL IMP. E EXP. LTDA                                                    01
+------------------------------------------------------------------------------+02
|                                                                              |03
|	        R E S U M O    G E R A L    DE    I N A D I M P L E N C I A         |04
|                                                                              |05
|------------------------------------------------------------------------------|06
| DESCRICAO                 |         DEBITO |        CREDITO |          SALDO |07
|------------------------------------------------------------------------------|08
| 01 - CLIENTES             | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |09
| 02 - GARANTIAS            | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |10
| 03 - FUNCIONARIOS         | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |11
| 04 - CONVENIOS            | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |12
|                           | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |13
|------------------------------------------------------------------------------|14
| TOTAL GERAL ------------> | 999,999,999.99 | 999,999,999.99 | 999,999,999.99 |15
+------------------------------------------------------------------------------+16


                                                                               |
*/


