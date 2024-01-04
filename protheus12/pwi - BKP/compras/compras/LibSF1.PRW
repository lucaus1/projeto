#INCLUDE "rwmake.ch"
/*
Programa de Ajutes de dados cadastrais de produto  

*/
User Function LibSF1
Private dDataLib := dDatabase

// ROTINA DE TELA DE PARAMETROS
@ 00,00 TO 60,320 DIALOG oDlgMain TITLE "Liberacão de Movimentos para Recontabilizar "
@ 10,10 SAY "Data a Liberar "
@ 10,55 Get dDataLib
@ 10,105 Button "Liberar " Size 51,15 ACTION OkProc()                                                               
ACTIVATE DIALOG oDlgMain CENTERED
Return	


Static Function OkProc
DbSelectArea("SF1")
Set Filter to F1_DTLANC == dDatalib 
AxCadastro("SF1","Cabeçalho de NFE com Filtro")
If msgbox("Confirma a Liberação para dados Filtrados do SF1","Responda","YESNO")
  Do While !Eof()
    RecLock("SF1",.f.)
      Replace F1_DTLANC with CTOD("  ")
    Msunlock()
    DbSelectArea("SF1")
    DbSkip()
  Enddo     
Endif
Set Filter to  
AxCadastro("SF1","Cabeçalho de NFE sem Filtro")
Return

