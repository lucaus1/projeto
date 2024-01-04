#include "rwmake.ch" 

User Function CodFor 

   If Msgbox("Confirma Conversao ?","Conversao","YESNO") 
   
      //****************************
      // Criando Indices Temporários
      //****************************                               
      DbSelectArea("SA5")                      
      cChave:= "A5_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SA5",cInd,cChave,,,"Criando indice temporario SA5")
         
      DbSelectArea("SC1")                      
      cChave:= "C1_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SC1",cInd,cChave,,,"Criando indice temporario SC1")
      
      DbSelectArea("SC7")                      
      cChave:= "C7_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SC7",cInd,cChave,,,"Criando indice temporario SC7")
       
      DbSelectArea("SC8")                      
      cChave:= "C8_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SC8",cInd,cChave,,,"Criando indice temporario SC8")
      
      DbSelectArea("SCE")                      
      cChave:= "CE_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SCE",cInd,cChave,,,"Criando indice temporario SCE")
      
      DbSelectArea("SD1")                      
      cChave:= "D1_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SD1",cInd,cChave,,,"Criando indice temporario SD1")

      DbSelectArea("SD7")                      
      cChave:= "D7_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SD7",cInd,cChave,,,"Criando indice temporario SD7")
      
      DbSelectArea("SE2")                      
      cChave:= "E2_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SE2",cInd,cChave,,,"Criando indice temporario SE2")
      
      DbSelectArea("SEF")                      
      cChave:= "EF_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SEF",cInd,cChave,,,"Criando indice temporario SEF")
      
      DbSelectArea("SF1")                      
      cChave:= "F1_FORNECE"
      cInd  := CriaTrab(nil,.F.)
      IndRegua("SF1",cInd,cChave,,,"Criando indice temporario SF1")

      
      dbSelectArea("SA2")                                            
      SET ORDER TO
      Dbgotop()
   
      Do while !Eof()
         If Empty(A2_YCOD)  .OR. ( A2_COD = A2_YCOD )
            dbSkip()
            Loop
         Endif   
         //
         // SA5
         //
         DbSelectArea("SA5")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SA5",.F.)
               Replace A5_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo                
         //
         // SAD
         //
         DbSelectArea("SAD")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SAD",.F.)
               Replace AD_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo                
         //
         // SC1
         //
         DbSelectArea("SC1")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SC1",.F.)
               Replace C1_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo                
         //
         // SC7
         //
         DbSelectArea("SC7")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SC7",.F.)
               Replace C7_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo           
         //
         // SC8
         //
         DbSelectArea("SC8")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SC8",.F.)
               Replace C8_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo           
         //
         // SCE
         //
         DbSelectArea("SCE")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SCE",.F.)
               Replace CE_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo           
         //
         // SD1
         //
         DbSelectArea("SD1")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SD1",.F.)
               Replace D1_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo                               
         //
         // SD7
         //
         DbSelectArea("SD7")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SD7",.F.)
               Replace D7_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo           
         //
         // SE2
         //
         DbSelectArea("SE2")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SE2",.F.)
               Replace E2_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo           
         //
         // SEF
         //
         DbSelectArea("SEF")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SEF",.F.)
               Replace EF_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo           
         //
         // SF1
         //
         DbSelectArea("SF1")
         Do while .t.
            DbSeek(SA2->A2_COD)
            If Found()
               Reclock("SF1",.F.)
               Replace F1_FORNECE with SA2->A2_YCOD
               DbUnlock()
            Else
               Exit
            Endif
         Enddo                               
        //
        // Proximo registro SA2
        //
        dbSelectArea("SA2")
        dbSkip()
     Enddo                                       
     //********************************************
     //Retornando os indices originais do microsiga
     //********************************************
     Retindex("SA5")
     Retindex("SAD")
     Retindex("SC1")
     Retindex("SC7")
     Retindex("SC8")
     Retindex("SCE")
     Retindex("SD1")
     Retindex("SD7")
     Retindex("SE2")
     Retindex("SEF")
     Retindex("SF1")
     //
     // Atualizando novo codigo no SA2
     //
     dbSelectArea("SA2")
     Dbgotop()
     Do while !Eof()
        If Empty(A2_YCOD)
           dbSkip()
           Loop 
        Endif   
        Reclock("SA2",.F.)
        Replace SA2->A2_COD With SA2->A2_YCOD
        DbUnlock()
        dbSkip()
     Enddo   
     
   Endif  
   MsgBox("Processo encerrado com sucesso!!","Processamento","INFO")
return