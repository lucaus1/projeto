USER FUNCTION MTA650I
  /*
  ExecBlock:                  MTA650I	
	Ponto:	Após gravar o arquivo SC2 (Ordens de Produção) na inclusão de uma Ordem de Produção.
	Observações:	Utilizado para atualizações adicionais no SC2 (Ordens de produção) após inclusão de uma OP.
	Retorno Esperado:	Nenhum.

para uso da rotina via validaçoes: 
D3_YESPESS :=  SC2->C2_YESPESS
D3_YLARGUR :=  SC2->C2_YLARGUR 
D3_YCOMPRI :=  SC2->C2_YCOMPRI 

  
  */
  // ALERT("ponde de entrada para completar dados de OPs com dimensoes do pedido")
  // Alert("alias posicionado"+alias())
  Alert("Ponto de Entrada MTA650I - para Gerar dados para OP Tabela SC2 "+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+SC2->C2_PRODUTO)      
  // Alert("posicao da SC6 "+SC6->C6_NUM+SC6->C6_ITEM+SC6->C6_NUMOP+SC6->C6_ITEMOP)     
  
  // SC6->C6_NUMOP
  // SC6->C6_ITEMOP 
  // SC6->C6_NUM
  // SC6->C6_ITEM 
  
  DbSelectArea("SC2")
  Reclock("SC2",.F.)            
    Replace C2_YLARGUR WITH SC6->C6_YLARGUR
    Replace C2_YESPESS WITH SC6->C6_YESPESS
    Replace C2_YCOMPRI WITH SC6->C6_YCOMPRI 
  Msunlock()  
   
   

RETURN