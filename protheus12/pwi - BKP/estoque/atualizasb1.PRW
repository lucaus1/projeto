#INCLUDE "rwmake.ch"
/*
Programa de Ajutes de dados cadastrais de produto  

*/
User Function AtuSB1
Private cArqTrat := "SB1PWA.DBF"
Private cArqTrab := "SB1PWA"

// ROTINA DE TELA DE PARAMETROS
@ 00,00 TO 185,420 DIALOG oDlgMain TITLE "Manutenção de Tabelas "
@ 10,10 SAY "By Potencial Tecnologia "
@ 20,10 SAY "Objetivo: importar tratando dados atualizados em Excell cadastro de Produto"
@ 40,10 SAY "Arquivo "
@ 40,55 Get cArqTrat Valid(ExecBlock("Verarq",.f.,.f.,cArqTrat))

  

@ 80,15 Button "Atualiza  " Size 51,15 ACTION OkProc()                                                               
@ 80,85 Button "Cadastro de Produto " Size 60,15 Action MATA010()
ACTIVATE DIALOG oDlgMain CENTERED
Return	


Static Function OkProc
Close(oDlgMain)       
DbSelectArea(cArqTrab)
ProcRegua(RECCOUNT())
Processa( {|| RunProc()} )
Return
                      
Static Function RunProc()
DbSelectArea(cArqTrab)
// Alert(Alias())
_cindex2 := CriaTrab(nil,.f.)
cFiltro:=""
IndRegua(cArqTrab,_cindex2,"B1_FILIAL+B1_COD",,cFiltro,"Criando Indice Temporario")
  Do While !eof()      
      DbSelectArea("SB1")    
      Campo := (cArqTrab+'->B1_COD')
      DbSeek(xFilial("SB1")+&Campo)
      if reclock("SB1",.f.)
         Campo:= cArqTrab+'->B1_TIPO'
         if !empty(&Campo)
            replace B1_TIPO    with &Campo
         Endif   
         Campo:= cArqTrab+'->B1_GRUPO'
         if !empty(&Campo)
            replace B1_GRUPO   with &Campo
         endif                   
         Campo:= cArqTrab+'->B1_CONTA'
         if !empty(&Campo)
           replace B1_CONTA   with &Campo
         endif                       
         Campo := cArqTrab+'->B1_NALSH'
         if !empty(&Campo)
           replace B1_NALSH   with &Campo
           replace B1_POSIPI  with &Campo
         endif                           
         Campo:= cArqTrab+'->B1_PPIS'
         if !empty(&Campo)
           replace B1_PPIS    with &Campo
         endif                           
         Campo := cArqTrab+'->B1_PCOFINS'
         if !empty(&Campo)
           replace B1_PCOFINS with &Campo
         endif
      Endif   
      Msunlock()
    DbSelectArea(cArqTrab)  
    DbSkip()             
    IncProc()
  Enddo
DbSelectArea("SB1")
fErase(_cindex+".idx")    
fErase(_cindex2+".idx")    
Return


User Function VerArq()
 IF Select(cArqTrab)==0
  DbUseArea(.T.,__cRDD,"\Potencial\"+cArqTraT,cArqTrab,.T.,.F.)              
  // "DBF/CDX"
  if Select(cArqTrab)==0
   Alert("Verificar arquivo a ser tratado")
   Return(.f.)
  Endif
  cFiltro := ""
  _cindex := CriaTrab(nil,.f.)
  IndRegua(cArqTrab,_cindex,"B1_FILIAL+B1_COD",,cFiltro,"Criando Indice Temporario")
 Elseif Select(cArqTrab)<>0         
  cFiltro := ""
  _cindex := CriaTrab(nil,.f.)
  IndRegua(cArqTrab,_cindex,"B1_FILIAL+B1_COD",,cFiltro,"Criando Indice Temporario")
 Endif  
Return(.T.)                                              

