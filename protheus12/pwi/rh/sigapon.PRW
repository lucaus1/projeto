#include "rwmake.ch"

User Function sigapon
 if UPPER(ALLTRIM(GetEnvServer()))<>"PRECIOUSWOODS-RH"
    Alert("Dia 13/11/2008 Novo ambiente de 2008 em Diante -> PRECIOUSWOODS-RH"+CHR(13)+;
  		"Evite lançar dados em outros ambientes !!")    
 Endif
Return