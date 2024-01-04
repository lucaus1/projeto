#include "rwmake.ch"

User Function sigagpe
 if UPPER(ALLTRIM(GetEnvServer()))<>"PRECIOUSWOODS-RH".AND.UPPER(ALLTRIM(GetEnvServer()))<>"FOLHA-DIR"
    Alert("Dia 13/11/2008 Novo ambiente de 2008 em Diante -> PRECIOUSWOODS-RH"+CHR(13)+;
  		"Evite lançar dados em outros ambientes !!")    
 Endif
Return