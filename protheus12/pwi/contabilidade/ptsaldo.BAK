#include "rwmake.ch"
	/*/
   Desenvolvedor: Franciney da Silva Alves
   Data.........: 28/04/2006
   Objetivo.....: Validar saldos contabeis
   *************************************************************************************************************************************
   ** Alterações * Favor Adicionar todas as Alteração Realizadas ***********************************************************************
   *************************************************************************************************************************************
	|Data			 | Programador				| Alteração
	*************************************************************************************************************************************
   ************************************************************************************************************************************
   /*/

USER FUNCTION PTSALDO()
	Private nRet := 0
	nRet := Saldo( paramixb[1],month(ddatabase),1,year(dDatabase))	
	if (nRet > 0 .and. SI1->I1_NORMAL == "D" ) .or. (nRet < 0 .and. SI1->I1_NORMAL == "C")
	  ALERT(" CONTA COM SALDO INVERSO A SUA NATUREZA ")
	Endif  
	
Return(nRet)