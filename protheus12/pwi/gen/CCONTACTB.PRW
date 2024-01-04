#include "rwmake.ch" 
User Function cContaDEB         

   Processa({|| RunCont1() },"Processando Mudanca de Contas Debitos ...")

Return
// FALTA ANALISE DOS CAMPOS SI2, CCC, SIC CCC
              
// Exemplo de conta nao existente no novo plano e existente no antigo  2132004             ->  2142004 



User Function cContaDEB         

   Processa({|| RunCont1() },"Processando Mudanca de Contas Debitos ...")

Return


User Function cContaCRED         

   Processa({|| RunCont2() },"Processando Mudanca de Contas Creditos ...")

Return

Static Function RunCont1
   If Msgbox("Confirma Conversao ?","Conversao","YESNO") 
      //****************************
      // Criando Indices Temporários
      //****************************                               
      DbSelectArea("CT2")  // lancamentos contabeis
      cChave:= "CT2_DEBITO"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("CT2",cInd,cChave,,,"Criando indice temporario CT2")      
      dbSelectArea("CT1")                                            
      ProcRegua(RecCount()) // Numero de registros a processar
      SET ORDER TO
      Dbgobottom()
      Do while !Bof()
         If CT1_CLASSE == "1" .OR. EMPTY(CT1_CODANT) 
            dbSkip(-1)
            Loop
         Endif   
         // CT2
         DbSelectArea("CT2")
         Do while .t.
            DbSeek(CT1->CT1_CODANT)
            If Found()
               nreg:= Recno()
               Reclock("CT2",.F.)
               Replace CT2_DEBITO with CT1->CT1_CONTA
               DbUnlock()    
               DbGoto(nreg)
            Else
               Exit
            Endif
         Enddo
        // Proximo registro CT1
        dbSelectArea("CT1")
        dbSkip(-1)
        IncProc()
 
     Enddo                                       

     Retindex("CT2")
   Endif  
   MsgBox("Processo encerrado com sucesso!!","Processamento","INFO")
return

Static Function RunCont2
   If Msgbox("Confirma Conversao contas creditos ?","Conversao","YESNO") 
      //****************************
      // Criando Indices Temporários
      //****************************                               
      DbSelectArea("CT2")  // lancamentos contabeis
      cChave:= "CT2_CREDITO"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("CT2",cInd,cChave,,,"Criando indice temporario CT2")      
      dbSelectArea("CT1")                                            
      ProcRegua(RecCount()) // Numero de registros a processar   
      SET ORDER TO
      DbgoBottom()
      Do while !Bof()
         If CT1_CLASSE == "1".OR. EMPTY(CT1_CODANT) 
            dbSkip(-1)
            Loop
         Endif   
         // CT2
         DbSelectArea("CT2")
         Do while .t.
            DbSeek(CT1->CT1_CODANT)
            If Found()
               nreg:= Recno()
               Reclock("CT2",.F.)
               Replace CT2_CREDITO with CT1->CT1_CONTA
               DbUnlock()  
               DbGoto(nreg)
            Else
               Exit
            Endif
         Enddo
        // Proximo registro CT1
        dbSelectArea("CT1")
        dbSkip(-1)
        IncProc()

     Enddo                                       

     //********************************************
     //Retornando os indices originais do microsiga
     //********************************************
     
     Retindex("CT2")
   Endif  
   MsgBox("Processo encerrado com sucesso!!","Processamento","INFO")
return