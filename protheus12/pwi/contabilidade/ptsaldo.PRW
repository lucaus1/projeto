#include "rwmake.ch"
	/*/
   Desenvolvedor: Franciney da Silva Alves
   Data.........: 28/04/2006
   Objetivo.....: Validar saldos contabeis
   *************************************************************************************************************************************
   ** Altera��es * Favor Adicionar todas as Altera��o Realizadas ***********************************************************************
   *************************************************************************************************************************************
	|Data			 | Programador				| Altera��o                                                                       
	 27/03/08        |Gustavo Cunha             | Conversao CTB
	*************************************************************************************************************************************
   ************************************************************************************************************************************
   /*/

USER FUNCTION PTSALDO()
	Private nRet := 0
	nRet := Saldo( paramixb[1],month(ddatabase),1,year(dDatabase))	
	if (nRet > 0 .and. CT1->CT1_NORMAL == "1" ) .or. (nRet < 0 .and. CT1->CT1_NORMAL == "2")
	  ALERT(" CONTA COM SALDO INVERSO A SUA NATUREZA ")
	Endif  
	
Return(nRet)