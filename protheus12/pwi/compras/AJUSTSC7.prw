#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO3     º Autor ³ AP6 IDE            º Data ³  15/03/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function AJUSTSC7

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


Private cString := "SC7"        
PRIVATE nNumIni:= 019865

ALERT("EXECUTANDO FUNCAO AJUSTSC7")

dbSelectArea("SC7")
dbSetOrder(1)
DbSeek(xFilial("SC7")+"X99970",.T.) 
Do While !EOF()        
   if SC7->C7_EMISSAO < CTOD("01/03/2016") .OR. SC7->C7_NUM < "999999" 
        dbskip()
        Loop
   Endif
   
   Alert("Pedido :"+SC7->C7_NUM) 
   cPedido := SC7->C7_NUM      
   nReg:= Recno()
   Do While cPedido == SC7->C7_NUM .AND. !EOF()                 
      cItem := SC7->C7_ITEM 
      cSequen := SC7->C7_SEQUEN 
      nReg:= Recno()
   
     if SC7->C7_EMISSAO >= CTOD("01/03/2016").AND. SC7->C7_NUM > "999999" 
      if !DbSeek(xFilial("SC7")+STRZERO(nNumini,6)+cItem+cSequen)  
       dbGoto(nReg)
       RecLock("SC7",.f.)              
         C7_NUMCOT := C7_NUM 
         C7_NUM :=  STRZERO(nNumini,6) 
       MsUnlock()
       dbGoto(nReg+1) 
       Loop      
      Else
       Alert("Chave ja encontrada:"+ xFilial("SC7")+STRZERO(nNumini,6)+cItem+cSequen)
       nNumIni++                
       dbSkip()
       Loop
      ENDIF 
     Endif 
     Dbskip()             
   Enddo
   DbSkip()

Enddo
ALERT("FIM DA EXECUCAO AJUSTSC7")
Return
