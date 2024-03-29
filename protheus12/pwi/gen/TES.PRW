
//#include "eecrdm.ch"
#include "rwmake.CH"
#include "font.CH"

//**********************************
// Reestruturação do cadastro de TES
//**********************************
User Function CodTES
  If Msgbox("Confirma Conversao ?","Conversao","YESNO")
     Recodifica()
  Endif
return                      

Static Procedure Recodifica
  
  //
  //-> SC6 - Itens dos pedidos de venda
  DbSelectArea("SC6")                      
  cChave:= "C6_TES"
  cInd  := CriaTrab(nil,.F.)
  IndRegua("SC6",cInd,cChave,,,"Criando indice temporario")

  //
  //-> SC7 - Pedidos de compras
  DbSelectArea("SC7")
  cChave:= "C7_TES"
  cInd  := CriaTrab(nil,.F.)
  IndRegua("SC7",cInd,cChave,,,"Criando indice temporario")

  //
  //-> SC8 - Cotacoes
  DbSelectArea("SC8")
  cChave:= "C8_TES"
  cInd  := CriaTrab(nil,.F.)
  IndRegua("SC8",cInd,cChave,,,"Criando indice temporario")

  //
  //-> SD1 - Itens da NF de entrada
  DbSelectArea("SD1")
  cChave:= "D1_TES"
  cInd  := CriaTrab(nil,.F.)
  IndRegua("SD1",cInd,cChave,,,"Criando indice temporario")
  
  //
  //-> SD2 - Itens de venda NF 
  DbSelectArea("SD2")
  cChave:= "D2_TES"
  cInd  := CriaTrab(nil,.F.)
  IndRegua("SD2",cInd,cChave,,,"Criando indice temporario")

  //************************
  // Inicio do Processamento
  //************************
  dbSelectArea("SF4")
  SET ORDER TO
  Dbgotop()
  i:= 0
  Do while !EOF()
     If Empty(F4_YTES) .or. ( F4_CODIGO = F4_YTES )
        dbSkip()
        Loop
     Endif 
     //
     //-> SC6 - Itens dos pedidos de venda
     DbSelectArea("SC6")                      
     Do while .t.
        DbSeek(SF4->F4_CODIGO)
        If Found()
           Reclock("SC6",.F.)
           Replace C6_TES with SF4->F4_YTES 
           DbUnlock()
        Else
           Exit
        Endif
     Enddo                
    
     //
     //-> SC7 - Pedidos de compras
     DbSelectArea("SC7")
     Do while .t.
        DbSeek(SF4->F4_CODIGO)
        If Found()
           Reclock("SC7",.F.)
           Replace C7_TES with SF4->F4_YTES 
           DbUnlock()
        Else
           Exit
        Endif
     Enddo                
     
     //
     //-> SC8 - Cotacoes
     DbSelectArea("SC8")
     Do while .t.
        DbSeek(SF4->F4_CODIGO)
        If Found()
           Reclock("SC8",.F.)
           Replace C8_TES with SF4->F4_YTES 
           DbUnlock()
        Else
           Exit
        Endif
     Enddo                
     
     //
     //-> SD1 - Itens da NF de entrada
     DbSelectArea("SD1")
     Do while .t.
        DbSeek(SF4->F4_CODIGO)
        If Found()
           Reclock("SD1",.F.)
           Replace D1_TES with SF4->F4_YTES 
           DbUnlock()
        Else
           Exit
        Endif
     Enddo                
     
     //
     //-> SD2 - Itens de venda NF 
     DbSelectArea("SD2")
     Do while .t.
        DbSeek(SF4->F4_CODIGO)
        If Found()
           Reclock("SD2",.F.)
           Replace D2_TES with SF4->F4_YTES 
           DbUnlock()
        Else
           Exit
        Endif
     Enddo                
     
     DbSelectArea("SF4")
     dbSkip() 
  Enddo
  Retindex("SC6")
  Retindex("SC7")
  Retindex("SC8")
  Retindex("SD1")
  Retindex("SD2")
  
  //****************************
  // Atualizando cadastro de TES
  //****************************
  dbSelectArea("SF4")
  Dbgotop()
  Do while !Eof()
     If Empty(F4_YTES) 
        dbSkip()
        Loop
     Endif   
     Reclock("SF4",.F.)
     Replace F4_CODIGO With F4_YTES
     dbSkip()
  Enddo   
  MsgBox("Processo encerrado com sucesso!!","Processamento","INFO")
return