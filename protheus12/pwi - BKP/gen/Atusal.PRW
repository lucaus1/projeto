#include "rwmake.ch" 
// FALTA ANALISE DOS CAMPOS SI2, CCC, SIC CCC

User Function Atusal

   @ 96,42 TO 323,505 DIALOG oDlg1 TITLE "Rotina de Atualizacao de Salario "
   @ 8,10 TO 84,222
   @ 23,14 SAY "Este programa Atualiza Salario e CBO "
   @ 91,106 BMPBUTTON TYPE 3 ACTION OkProc()   
   @ 91,136 BMPBUTTON TYPE 1 ACTION OkProc()
//   @ 91,166 BMPBUTTON TYPE 5 ACTION Pergunte(cPerg,.T.)
   @ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
ACTIVATE DIALOG oDlg1
   
   
Return  

Static Function OkProc() 

Processa( { || Processa() },"Atualizando !!!" )

Return

Static Function Processa   
   If Msgbox("Confirma Atualizacao Salario e CBO ?","Atualizar","YESNO") 
      //****************************
      // Criando Indices Temporários
      //****************************                               
      DbSelectArea("SRA")  // Cadastro de funcionarios
      DbSetOrder(1)
      ProcRegua(RecCount())
      Dbgotop()
      DbSeek(xFilial()+"001558")
      Do while !Eof()
         IncProc()
         If RA_SITFOLH=="D" 
            dbSkip()
            Loop
         Endif   
         // SRJ - CADASTRO DE FUNCAO
         DbSelectArea("SRJ")
         DbSetOrder(1)
         IF DbSeek(xFilial()+SRA->RA_CODFUNC)
               DbSelectArea("SRA")
               Reclock("SRA",.F.)
               Replace RA_CBO with SRJ->RJ_CBO
               IF SRJ->RJ_SALARIO # 0
                 Replace RA_SALARIO with SRJ->RJ_SALARIO
               ENDIF  
               DbUnlock()
         Endif
         DbSelectArea("SRA")
         dbSkip()
     Enddo                                       
   Endif  
   MsgBox("Processo encerrado com sucesso!!","Processamento","INFO")
return