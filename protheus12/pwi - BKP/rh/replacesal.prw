#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO7     � Autor � AP6 IDE            � Data �  23/01/07   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function apensal


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Private cString := "SRA"

dbSelectArea("SRA")
dbSetOrder(1)
Alert("Rotina desabilitada por Franciney - Potencial - 3184-0863 ")
/*                   
use salario.dbf alias "Salario"  
DbSelectArea("Salario")
Do While !eof()
   // Alert("Mat + Salario "+MAT+STR(SALARIO))
   DbSelectArea("SRA")
   if DbSeek("01"+Salario->MAT)
     Reclock("SRA",.f.)
      Replace RA_SALARIO WITH Salario->Salario
      Replace RA_ANTEAUM WITH Salario->Salario
     MsUnlock()  
   endif
   DbSelectArea("Salario")
   Dbskip()
Enddo
*/
Return
