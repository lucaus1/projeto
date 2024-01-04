#INCLUDE "rwmake.ch"
User Function MTA241I()
LOCAL aAreaAnt:= GETAREA()
// aCusto := PegaCMAtu(SD3->D3_COD,SD3->D3_LOCAL)
// aCusto := GravaCusD3(aCusto)
// B2AtucomD3(aCusto,,,,,.T.)

ALERT("PONTO DE ENTRADA MTA241I em validacao")
Alert("Valor de cDocumento: "+cDocumento)
DbSelectArea("SD3")
nOrdem:= INDEXORD()
DbSetOrder(2)
if DBSEEK( xFilial("SD3")+cDocumento) .and. SD3->D3_ESTORNO <> "S"
 // alert("Existecpo: "+cDocumento)
    cDocumento := "A"+RIGHT( cDocumento, 8 )
    lExiste := DBSEEK( xFilial("SD3")+cDocumento)
  Do while lExiste
   cPrefixo := cValToChar(ASC("A")+1)
   cDocumento := cPrefixo+RIGHT( cDocumento, 8 )   
   lExiste := DBSEEK( xFilial("SD3")+cDocumento)
  enddo
  alert("Novo numero : "+cDocumento)
endif 
DbSetOrder(nOrdem)
RESTAREA(aAreaAnt) 
Return(.t.)
