#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �NOVO2     � Autor � AP6 IDE            � Data �  29/04/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ST_REL_SER

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cDesc1         := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2         := "de acordo com os parametros informados pelo usuario."
Local cDesc3         := "Relatorio de Estoque Madeira Serrada"
Local cPict          := ""
Local titulo       := "Relatorio de Estoque Madeira Serrada"
Local nLin         := 80

Local Cabec1       := "cabec1"
Local Cabec2       := "cabec2"
Local imprime      := .T.
Private aOrd             := {"Lote/Pacote","Produto","Especie+Produto"}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "ST_REL_SER" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo            := 15
Private aReturn          := { "Zebrado", 1, "Administracao", 1, 2, 1, "", 1}
Private nLastKey        := 0
Private cPerg       := "Z06"
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "ST_REL_SER" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "Z06"

dbSelectArea("Z06")
dbSetOrder(1)

ValidPerg()

pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  29/04/12   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem

dbSelectArea(cString)

//���������������������������������������������������������������������Ŀ
//� Tratamento das ordens. A ordem selecionada pelo usuario esta contida�
//� na posicao 8 do array aReturn. E um numero que indica a opcao sele- �
//� cionada na mesma ordem em que foi definida no array aOrd. Portanto, �
//� basta selecionar a ordem do indice ideal para a ordem selecionada   �
//� pelo usuario, ou criar um indice temporario para uma que nao exista.�
//� Por exemplo:                                                        �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem < 5                                                       �
//�     dbSetOrder(nOrdem)                                              �
//� Else                                                                �
//�     cInd := CriaTrab(NIL,.F.)                                       �
//�     IndRegua(cString,cInd,"??_FILIAL+??_ESPEC",,,"Selec.Registros") �
//� Endif                                                               �
//�����������������������������������������������������������������������

nOrdem := aReturn[8]
If nOrdem == 1
	dbSetOrder(3)
ElseIf nOrdem == 2
	dbSetOrder(5)
Else
	dbSetOrder(6)
Endif


//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� O tratamento dos parametros deve ser feito dentro da logica do seu  �
//� relatorio. Geralmente a chave principal e a filial (isto vale prin- �
//� cipalmente se o arquivo for um arquivo padrao). Posiciona-se o pri- �
//� meiro registro pela filial + pela chave secundaria (codigo por exem �
//� plo), e processa enquanto estes valores estiverem dentro dos parame �
//� tros definidos. Suponha por exemplo o uso de dois parametros:       �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//� Assim o processamento ocorrera enquanto o codigo do registro posicio�
//� nado for menor ou igual ao parametro mv_par02, que indica o codigo  �
//� limite para o processamento. Caso existam outros parametros a serem �
//� checados, isto deve ser feito dentro da estrutura de la�o (WHILE):  �
//�                                                                     �
//� mv_par01 -> Indica o codigo inicial a processar                     �
//� mv_par02 -> Indica o codigo final a processar                       �
//� mv_par03 -> Considera qual estado?                                  �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.) // Posiciona no 1o.reg. satisfatorio �
//� While !EOF() .And. xFilial() == A1_FILIAL .And. A1_COD <= mv_par02  �
//�                                                                     �
//�     If A1_EST <> mv_par03                                           �
//�         dbSkip()                                                    �
//�         Loop                                                        �
//�     Endif                                                           �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Note que o descrito acima deve ser tratado de acordo com as ordens  �
//� definidas. Para cada ordem, o indice muda. Portanto a condicao deve �
//� ser tratada de acordo com a ordem selecionada. Um modo de fazer isto�
//� pode ser como a seguir:                                             �
//�                                                                     �
//� nOrdem := aReturn[8]                                                �
//� If nOrdem == 1                                                      �
//�     dbSetOrder(1)                                                   �
//�     cCond := "A1_COD <= mv_par02"                                   �
//� ElseIf nOrdem == 2                                                  �
//�     dbSetOrder(2)                                                   �
//�     cCond := "A1_NOME <= mv_par02"                                  �
//� ElseIf nOrdem == 3                                                  �
//�     dbSetOrder(3)                                                   �
//�     cCond := "A1_CGC <= mv_par02"                                   �
//� Endif                                                               �
//�                                                                     �
//� dbSeek(xFilial()+mv_par01,.T.)                                      �
//� While !EOF() .And. &cCond                                           �
//�                                                                     �
//�����������������������������������������������������������������������

dbGoTop()
While !EOF()
	
	//���������������������������������������������������������������������Ŀ
	//� Verifica o cancelamento pelo usuario...                             �
	//�����������������������������������������������������������������������
	
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
	
	//���������������������������������������������������������������������Ŀ
	//� Impressao do cabecalho do relatorio. . .                            �
	//�����������������������������������������������������������������������
	
	If nLin > 65 // Salto de P�gina. Neste caso o formulario tem 55 linhas...
		Cabec1 := " Lote /     Data da   Codigo do                  Descricao do Produto                             Detalhe                                Comprim.    Quant. Volume  Situacao  |      Secagem        |    Dados de Baixa    |"
		Cabec2 := " Pacote     Entrada    Produto                (Tipo x Bitola x Especie)                   Ar.     (Tipo)            Cert. Emb. Cla. Sc.   (Un)       Pecas   (m3)             |  Data      Estufa   |  Data      Destino   |"
		//         0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
		//         0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 9
	Endif
	
	If Z06_LOTE < MV_PAR01 .OR. Z06_LOTE > MV_PAR02
		dbSkip() // Avanca o ponteiro do registro no arquivo
		loop
	EndIf
	If Z06_PROD < MV_PAR03 .OR. Z06_PROD > MV_PAR04
		dbSkip() // Avanca o ponteiro do registro no arquivo
		loop
	EndIf
	If Z06_LOCAL < MV_PAR05 .OR. Z06_LOCAL > MV_PAR06
		dbSkip() // Avanca o ponteiro do registro no arquivo
		loop
	EndIf
	If MV_PAR07<>3
		If MV_PAR07==1 .AND. Z06_SECAGE<>"A"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		EndIf
		If MV_PAR07==2 .AND. Z06_SECAGE<>"K"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		EndIf
	EndIf
	If MV_PAR08<>5
		If MV_PAR08==1 .AND. Z06_QUAL<>"1"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		ElseIf MV_PAR08==2 .AND. Z06_QUAL<>"2"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		ElseIf MV_PAR08==3 .AND. Z06_QUAL<>"3"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		ElseIf MV_PAR08==4 .AND. Z06_QUAL<>"A"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		EndIf
	EndIf
	If MV_PAR08<>4
		If MV_PAR09==1 .AND. Z06_BAIXA<>"ES"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		ElseIf MV_PAR09==2 .AND. Z06_BAIXA<>"LB"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		ElseIf MV_PAR09==3 .AND. Z06_BAIXA<>"BX"
			dbSkip() // Avanca o ponteiro do registro no arquivo
			loop
		EndIf
	EndIf
	
	// Coloque aqui a logica da impressao do seu programa...
	// Utilize PSAY para saida na impressora. Por exemplo:
	// @nLin,00 PSAY SA1->A1_COD
	@nLin,00 PSAY Z06->Z06_LOTE
	@nLin,10 PSAY POSICIONE("Z05",1,xFilial("Z05")+Z06->Z06_CONTR,"Z05_DATA")
	@nLin,22 PSAY LEFT(TRIM(Z06->Z06_PROD),9)
	@nLin,33 PSAY LEFT(POSICIONE("SB1",1,xFilial("SB1")+Z06->Z06_PROD,"B1_DESC"),57)
	@nLin,90 PSAY Z06->Z06_LOCAL
	@nLin,94 PSAY Z06->Z06_TIPO
	@nLin,117 PSAY IIF(Z06->Z06_CERT=="1","Sim","Nao")
	@nLin,122 PSAY IIF(Z06->Z06_EMB=="1","Sim","Nao")
	@nLin,127 PSAY IIF(Z06->Z06_QUAL=="1","1a.",IIF(Z06->Z06_QUAL=="2","2a.",IIF(Z06->Z06_QUAL=="3","3a.","Apv")))
	@nLin,132 PSAY IIF(Z06->Z06_SECAGE=="A","AD","KD")
	@nLin,137 PSAY LEFT(TRIM(Z06->Z06_COMPR),8)
	@nLin,149 PSAY TRANSFORM(Z06->Z06_PECAS,"@E 99,999")
	@nLin,155 PSAY TRANSFORM(Z06->Z06_VOLUME,"@E 999.999")
	@nLin,164 PSAY IIF(Z06->Z06_BAIXA="LB","Liberar",IIF(Z06->Z06_BAIXA="ES","Estoque","Baixado"))
	@nLin,174 PSAY Z06->Z06_DTSEC
	@nLin,185 PSAY POSICIONE("Z09",1,xFilial("Z09")+Z06->Z06_DOCSC,"Z09_ESTUFA")
	@nLin,197 PSAY Z06->Z06_DTBX
	@nLin,208 PSAY IIF(Z06->Z06_DESTBX="C","Cliente",IIF(Z06->Z06_DESTBX="I","Industria",IIF(Z06->Z06_DESTBX="R","Reprocesso",IIF(Z06->Z06_DESTBX="V","inventario",IIF(Z06->Z06_DESTBX="D","Diversos","")))))
	
	nLin := nLin + 1 // Avanca a linha de impressao
	
	dbSelectArea("Z06")
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return


// Cria SX1
Static Function ValidPerg()
_sAlias := Alias()
DBSelectArea("SX1")
DBSetOrder(1)
cPerg := PADR(cPerg,10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs,{cPerg,"01","Lote/Pacote de?","","","mv_ch1","C",9,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Lote/Pacote ate?","","","mv_ch2","C",9,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Produto de?","","","mv_ch3","C",15,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"04","Produto ate?","","","mv_ch4","C",15,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SB1",""})
aAdd(aRegs,{cPerg,"05","Local de?","","","mv_ch5","C",2,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"06","Local ate?","","","mv_ch6","C",2,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"07","Secagem?","","","mv_ch7","C",1,0,0,"C","","MV_PAR07","AD","AD","AD","","","KD","KD","KD","","","Todos...","Todos...","Todos...","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"08","Qualidade?","","","mv_ch8","C",1,0,0,"C","","MV_PAR08","1A.","1A.","1A.","","","2A.","2A.","2A.","","","3A.","3A.","3A.","","","APV","APV","APV","","","Todos...","Todos...","Todos...","","",""})
aAdd(aRegs,{cPerg,"09","Situacao?","","","mv_ch9","C",1,0,0,"C","","MV_PAR09","Estoque","Estoque","Estoque","","","A Liberar","A Liberar","A Liberar","","","Baixado","Baixado","Baixado","","","Todos...","Todos...","Todos...","","","","","","","",""})

//aAdd(aRegs,{cPerg,"04","Produto ate?","","","mv_ch4","C",3,0,0,"G","EXISTCPO('SF5')","","","","","","","","","","","","","","","","","","","","","","","","","","SF5",""})
//aAdd(aRegs,{cPerg,"05","Local de?","","","mv_ch5","C",1,0,0,"C","","mv_par03","Volume","Volume","Volume","","","Pacotes","Pacotes","Pacotes","","","Pecas","Pecas","Pecas","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If ! DBSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to Max(39, Len(aRegs[i])) //fCount()
			FieldPut(j,aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next

DBSkip()

do while x1_grupo == cPerg
	RecLock("SX1", .F.)
	DBDelete()
	DBSkip()
Enddo

DBSelectArea(_sAlias)

Return
