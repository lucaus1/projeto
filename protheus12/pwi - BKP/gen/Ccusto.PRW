#include "rwmake.ch" 
// FALTA ANALISE DOS CAMPOS SI2, CCC, SIC CCC

User Function CodCc 
   If Msgbox("Confirma Conversao ?","Conversao","YESNO") 
      //****************************
      // Criando Indices Temporários
      //****************************                               
      DbSelectArea("SI2")  // lancamentos contabeis
      cChave:= "I2_CCD"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SI2",cInd,cChave,,,"Criando indice temporario SI2")      
      dbSelectArea("SI3")                                            
      SET ORDER TO
      Dbgotop()
      Do while !Eof()
         If Empty(I3_YCOD)  .OR. ( I3_CUSTO = I3_YCOD )
            dbSkip()
            Loop
         Endif   
         // SI2
         DbSelectArea("SI2")
         Do while .t.
            DbSeek(SI3->I3_YCOD)
            If Found()
               Reclock("SI2",.F.)
               Replace I2_CCD with SI3->I3_CUSTO
               DbUnlock()
            Else
               Exit
            Endif
         Enddo
        // Proximo registro SI3
        dbSelectArea("SI3")
        dbSkip()
     Enddo                                       

      DbSelectArea("SI2")  // lancamentos contabeis
      cChave:= "I2_CCC"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SI2",cInd,cChave,,,"Criando indice temporario SI2")      
      dbSelectArea("SI3")                                            
      SET ORDER TO
      Dbgotop()
      Do while !Eof()
         If Empty(I3_YCOD)  .OR. ( I3_CUSTO = I3_YCOD )
            dbSkip()
            Loop
         Endif   
         // SI2
         DbSelectArea("SI2")
         Do while .t.
            DbSeek(SI3->I3_YCOD)
            If Found()
               Reclock("SI2",.F.)
               Replace I2_CCC with SI3->I3_CUSTO
               DbUnlock()
            Else
               Exit
            Endif
         Enddo
        // Proximo registro SI3
        dbSelectArea("SI3")
        dbSkip()
     Enddo                                       

     //********************************************
     //Retornando os indices originais do microsiga
     //********************************************
     
     Retindex("SI2")
   Endif  
   MsgBox("Processo encerrado com sucesso!!","Processamento","INFO")
return