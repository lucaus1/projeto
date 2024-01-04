#Include "TopConn.ch"   
#INCLUDE "RWMAKE.CH"    
#INCLUDE "JPEG.CH"
#include "VKEY.CH"   
/*/


/*/

User Function CalcM3G
@ 140,178 To 600,600 Dialog oWindow Title PADC("Calculo Cubagem         By Potencial Tecnologia Ltda - Suporte-> 3184-0863 - 8143-8417 - 8128-4129 ",200)
@ 001,001 JPEG SIZE 70,180 FILE "\SIGAADV\preciouswoods.jpg"

@ 010,080 SAY "Pe x"
@ 010,140 GET nPwX PICTURE "@E 999.99 " SIZE 45,12 object onPex 

@ 025,080 SAY "SOLICITANTE:"
@ 025,140 GET cSolicitante PICTURE "@!"  object oSolicitante

@ 025,200 SAY "Centro de Custo "
@ 025,260 GET cCentroCusto PICTURE "@!" object oCentroCusto;
          VALID ExecBlock("Pesqmaco",.f.,.f.,{"xFilial('SI3')+cCentroCusto","SI3",1,"Centro de Custo nao Cadastrado!","","","",oWindow})  F3 "SI3"

@ 025,300 GET cNomeCC PICTURE "@!" Object oNomeCC

@ 040,080 SAY "Comprador "
@ 040,140 GET cComprador PICTURE "@!" object oComprador ;
          VALID ExecBlock("Pesqmaco",.f.,.f.,{"xFilial('SY1')+cComprador","SY1",1,"Comprador nao Cadastrado!","","","",oWindow})  F3 "SY1" SIZE 45,12
          
@ 040,190 GET cNomeComprad PICTURE "@!" object oNomeComprad

oNumCotacao:disable()
oSolicitante:disable()
oCentroCusto:disable()
oNomeCC:disable()
// oComprador:disable()
oNomeComprad:disable()

SetKey(VK_F4   ,{ || fsalva()})                  
SetKey(VK_F5   ,{ || DescProd()})     
SetKey(VK_F6   ,{ || fotoprod() })     
SetKey(VK_F7   ,{ || infGerCmp() })     
SetKey(VK_F8   ,{ || AnalCotacao() })     
cLinFuncoes := "  F4-Salvar Cotação         "
cLinFuncoes += "  F5-Descrição Produto     "
cLinFuncoes += "  F6-Foto do Produto       "
cLinFuncoes += "  F7-Inf.Gerenciais Compras  "
cLinFuncoes += "  F8-Analisa Cotação       "