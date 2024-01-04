#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MS520VLD     � Autor � AP6 IDE            � Data �  29/08/13   ���
�������������������������������������������������������������������������͹��
���Descricao � ponto de entrada antes da exclusao da nota fiscal          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP11                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MS520VLD
/*
Ponto:     Antes da chamada da fun��o de exclus�o da Nota Fiscal (SF2)
Retorno Esperado:     .T. ou .F. Sendo que .T. continua o processo de exclus�o e .F. aborta.
*/

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Private cRetorno:= .T.
Private cNota := SF2->F2_DOC 
Private cSerie := SF2->F2_SERIE 
Private cCliente := SF2->F2_CLIENTE
                              
// Alert("Em fase de Valida��o MS520VLD para exclus�o de Nota: "+SF2->F2_DOC) 
dbSelectArea("SE1")
dbSetOrder(1)    // Prefixo + Numero + Parcela + Tipo
If DbSeek(xFilial("SE1")+cSerie+cNota )
   if SE1->E1_CLIENTE == cCliente 
     RecLock("SE1",.F.) 
       Replace E1_SITUACA WITH "0" 
     MsUnlock()  
   Endif
Endif

Return(cRetorno) 

