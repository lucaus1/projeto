#INCLUDE "rwmake.ch"
	/*/
   Desenvolvedor: Franciney da Silva Alves
   Data.........: 28/04/2006
   Objetivo.....: Validar saldos contabeis
   *************************************************************************************************************************************
   ** Alterações * Favor Adicionar todas as Alteração Realizadas ***********************************************************************
   *************************************************************************************************************************************
	|Data			 | Programador				| Alteração                                                                       
	 27/03/08        |Gustavo Cunha             | Conversao CTB
	*************************************************************************************************************************************
   ************************************************************************************************************************************
   /*/

user function orcadodp(cconta,decc,atecc,periodo,moeda,ano)
Private cArea  := Alias()
Private nReg   := Recno()
Private nValor := 0
Private cContax:= SIA->IA_CONTA
Private nOrdem := DbSetOrder()
  DbSelectArea("SIA")
  DbSetOrder(1)  // filial + custo + conta + moeda
  Dbgotop()                    
  cContax := cConta
  DbSeek(xFilial("SIA")+cContax)
  Do While AllTrim(ia_conta) == AllTrim(cContax) .and. !eof()
     if AllTrim(IA_CC) < DECC .OR. AllTrim(IA_CC)> ATECC .OR. IA_MOEDA <> MOEDA;
     .OR. AllTrim(IA_ANO) <> AllTrim(ano)
       DbSkip()
       Loop
     Endif  
    Do Case
        Case alltrim(periodo) $ '1' 
          nValor:= SIA->IA_VLORC01 
        Case alltrim(periodo) $ '2'
          nValor:= SIA->IA_VLORC02 
        Case alltrim(periodo) $ '3'
          nValor:= SIA->IA_VLORC03 
        Case alltrim(periodo) $ '4' 
          nValor:= SIA->IA_VLORC04 
        Case alltrim(periodo) $ '5' 
          nValor:= SIA->IA_VLORC05 
        Case alltrim(periodo) $ '6' 
          nValor:= SIA->IA_VLORC06 
        Case alltrim(periodo) $ '7' 
          nValor:= SIA->IA_VLORC07
        Case alltrim(periodo) $ '8' 
          nValor:= SIA->IA_VLORC08
        Case alltrim(periodo) $ '9' 
          nValor:= SIA->IA_VLORC09
        Case alltrim(periodo) == '10' 
          nValor:= SIA->IA_VLORC10
        Case alltrim(periodo) == '11' 
          nValor:= SIA->IA_VLORC11
        Case alltrim(periodo) == '12' 
          nValor:= SIA->IA_VLORC12
    EndCase
    DbSkip()      
  Enddo     
DbSelectArea(cArea)
DbGoto(nReg)
DbSetOrder(nOrdem)  
Return(nValor)

// OrcadoCC(conta,CCcusto,Periodo,Moeda,Dat_Conversao)

