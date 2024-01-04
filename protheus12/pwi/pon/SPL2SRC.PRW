#include "rwmake.ch"
/*
Programa para:
 Migracao de valores de resultados acumulados da tabela SPL para movimento da folha SPL 2 SRC
por funcionarios, ou Centro de Custo

Autor: Franciney Alves -Potencial Assessoria e Consultoria Ltda
DATA: 05/01/2004 


*/
User Function SPL2SRC
cPerg:="PL2SRC"

Validperg()
DbSelectArea("SRA")
cFilde     :=space(2)
cFilate    :=space(2)
cMatde     :=space(6)
cMatAte    :=space(6)
cMat       :=space(6)  
dDatade    :=Date()
cCCde      :=Space(9)
cCCate     :=Space(9)


Pergunte("PL2SRC",.F.)
if !Pergunte(cPerg,.T.)
  Return Nil
endif
  DbSelectArea("SRA")
  ProcRegua(RECCOUNT())
  Processa( {|| RunProc()} )
Return Nil    
  
Static Function RunProc()
  cFilde     :=mv_par01
  cFilate    :=mv_par02
  cMatde     :=mv_par03
  cMatAte    :=mv_par04
  dDatade    :=mv_par05                                                     
  cCCde      :=mv_par06
  cCCate     :=mv_par07
  DbSelectArea("SRA")
  DbSetOrder(1)                    
  if Empty(cMatde)
   DbGotop()   
  Else
   DbSeek(xFilial("SRA")+cMatde,.T.)
  Endif      

Do While !eof().And.SRA->RA_MAT<=cMatAte
  cMat       :=SRA->RA_MAT
  dData1     :=dDatade

  IF SRA->RA_CC < cCCde .or. SRA->RA_CC > cCCate 
       DbSelectArea("SRA")
       DbSkip()
       Loop  
  Endif 

  DbSelectArea("SPL")
  DbSetOrder(1)                    
  IF Dbseek(Xfilial("SPL")+cMAT+SPL->PL_PD)
   Do While SPL->PL_DATA < dDataDe .and. !eof()
     DbSkip()
   Enddo   
   IF SPL->PL_DATA == dDataDe.and.cMAT == SPL->PL_MAT   
     DbSelectArea("SRC")
     IF DbSeek(xFilial("SRC")+ cMat + SRL->RL_PD) 
       if mv_par08 == 1
        RecLock("SRC")
         Replace  RC_HORAS   with  SPL->PL_HORAS                  
         Replace  RC_VALOR   with  SPL->PL_VALOR
        Msunlock()
       Endif 
     ELSE
       RecLock("SRC",.T.)
       Replace  RC_FILIAL  with  xFilial("SRC")
       Replace  RC_MAT     with  SPL->PL_MAT       
       Replace  RC_PD      with  SPL->PL_PD        
       Replace  RC_TIPO1   with  SPL->PL_TIPO1 
       Replace  RC_TIPO2   with  SPL->PL_TIPO2
       Replace  RC_DATA    with  SPL->PL_DATA        
       Replace  RC_CC      with  SPL->PL_CC       
       Replace  RC_HORAS   with  SPL->PL_HORAS                  
       Replace  RC_VALOR   with  SPL->PL_VALOR
      Msunlock()
     ENDIF      
   ENDIF
  ENDIF
  DbSelectArea("SRA")
  DbSkip()
  IncProc()
Enddo

Return NIL

 Static Function ValidPerg
  Local _sAlias := Alias()
  Local aRegs := {}
  Local i,L
  dbSelectArea("SX1")
  dbSetOrder(1)
  cPerg := PADR(cPerg,6)
  
/*
cFilde     :=mv_par01
cFilate    :=mv_par02
cMatde     :=mv_par03
cMatAte    :=mv_par04
dDatade    :=mv_par05
*/
  // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
  aadd(aRegs,{cPerg,"01","Da Filial          ?"," "," ","mv_ch1","C", 2,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  aadd(aRegs,{cPerg,"02","Ate Filial         ?"," "," ","mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  aadd(aRegs,{cPerg,"03","Da Matricula       ?"," "," ","mv_ch3","C", 6,0,0,"G","","mv_par03","","","","","","","","","","","","","",""})
  aadd(aRegs,{cPerg,"04","Ate Matricula      ?"," "," ","mv_ch4","C", 6,0,0,"G","","mv_par04","","","","","","","","","","","","","",""})
  aadd(aRegs,{cPerg,"05","Da Data            ?"," "," ","mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
  aadd(aRegs,{cPerg,"06","Do centro de Custo ?"," "," ","mv_ch6","C", 9,2,0,"G","","mv_par06","","","","","","","","","","","","","",""})  
  aadd(aRegs,{cPerg,"07","Ate Centro de Custo?"," "," ","mv_ch7","C", 9,2,0,"G","","mv_par07","","","","","","","","","","","","","",""})  
  aadd(aRegs,{cPerg,"08","Sobrepor Valores   ?"," "," ","mv_ch8","N", 1,0,0,"C","","mv_par08","Sim","","","Nao","","","","","","","","","",""})  
  

  
  For i:=1 to Len(aRegs)
     If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For L:=1 to FCount()
           If L <= Len(aRegs[i])
              FieldPut(L,aRegs[i,L])
           Endif
        Next
        MsUnlock()
     Endif
  Next
  dbSelectArea(_sAlias)
Return
