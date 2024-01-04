#INCLUDE "rwmake.ch"
#include 'Ap5Mail.ch'
#Include "Topconn.ch"
#Include "TbiConn.ch"

User Function EmailTEXTO(Empresa,Filial)
// Alert("Executando GQREENTR")
// APOS ENTRADA DA NOTA FISCAL
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
  Local cFiles     := ""
  Local cNumPed    := ""                           
  Local cFiles     := ""
  Local nI         := 1
  Local cMensagem  := ''
  Local cMsg1      := ''   // Referente ao cabeçalho 
  Local cMsg2      := ''   // Referente aos itens dos titulos a receber 
  Local cMsg3      := ''   // Referente aos itens do pedido 
  Local cCorpo     := ''   // Referente aos itens do Contas a Pagar   
  Local cTos
  Local cAnexos   := "CTAREC"
  Local cAssunto  := ""
  Local cDesCC    := "Sem Especificacao de CC "
  Local cPath     := "\pedidos\"        && esta pasta aqui tem que estar abaixo do root path
                                        && exemplo: o meu root path aqui é Protheus8\Protheus_data
                                        && a pasta "\Com\" está abaixo dentro do protheus_data.

  Private cRecebe:= "diretoria@potencial.inf.br" 
  Private lEnviado  := .T.
  Private lConectou := .T.
  Private lDisConectou := .T.
  Private lRet := .F.
  Private nTotal := nTotCliente := nTotFornecedor := ntotalpedido := ntotalpagar :=  0
  Private cEmailGrpFin := "analista.financeiro@potencial.inf.br"
  Private cEmailGrpFat := "analista.suporte@potencial.inf.br"
  Private cEmailGrpMat := "analista.materiais@potencial.inf.br"
  Private cEmailGrpRh  := "analista.rh@potencial.inf.br"
  Private cServidor  := 'mail.potencial.inf.br' // GETMV("MV_RELSERV")    
  Private cConta     := 'workflow@potencial.inf.br' //GETMV("MV_RELACNT")
  Private cEnvia     := 'workflow@potencial.inf.br'
  Private cChave     := 'workflow007' //GETMV("MV_RELPSW")
  Private cCopia     := 'suporte@potencial.inf.br'
  Public nEntradas := 0
  Public nBaixas := 0
  Public nVendas := 0

  
  Public COBS1,COBS2,COBS3
  cCopia    := 'diretoria@potencial.inf.br;reinaldo.magalhaes@potencial.inf.br;coordenacao@potencial.inf.br'	

  cAnexosdbf := cPath + cAnexos +".dbf"     && chamei esta função de outra função,o conteúdo dele é
                                          && somente o nome do arquivo, ex: teste.txt

  cAnexosxls := cPath + cAnexos +".xls"  
  cfiles := cAnexosxls 
   
    
  aEmpresas := {}
  Do Case
  Case Alltrim(GetEnvServer())== "WORKFLOW01" .OR. Alltrim(GetEnvServer())== "WORKFLOW"
    wfPrepENV("01","01")
  Case Alltrim(GetEnvServer())== "WORKFLOW02"
    wfPrepENV("02","01")
  Case Alltrim(GetEnvServer())== "WORKFLOW03"
     wfPrepENV("03","01")  
  Otherwise 
    wfPrepENV("01","01")
     
  EndCase  
    
    
  COBS1 := COBS2 := COBS3 :=  SPACE(30)  
  RpcSetType(3)                      
  
  Do Case   
        Case ALLTRIM(SM0->M0_NOME) $ "SENPE/MINDESIGN/AMAR COSMETICOS"                                                                         
		  cRecebe   := 'contabilidade@senpe.com.br;diretoria@senpe.com.br'
		  emailcompras := 'compras@senpe.com.br'
        Case LEFT(SM0->M0_NOME,3) $ "ACL/THI/PT /DK /GRA/G.A/D.G/E.D/TDG/ONO"                          
   			 cRecebe   := 'onordestao@potencial.inf.br'                                               	
   			 cEmailGrpRh := cEmailGrpRh+";katiana@onordestao.com.br;grace@onordestao.com.br"
        Case LEFT(SM0->M0_NOME,11) == "ARRODRIGUEZ"   
   			 cRecebe   := 'antonio@arrodriguez.com.br;cpd@arrodriguez.com.br'                                               	
   			 cEmailGrpFat := cEmailGrpFat+';logistica@arrodriguez.com.br; balcao2@arrodriguez.com.br;antonio@arrodriguez.com.br'
   			 cEmailGrpFin := cEmailGrpFIN+';antonio@arrodriguez.com.br;financeiro@arrodriguez;jeanette@arrodriguez.com.br '
   			 cEmailGrpRh  := cEmailGrpRh+';secretaria@arrodriguez.com.br; rh1@arrodriguez.com.br;antonio@arrodriguez.com.br'
   			 
   			 /*
   			 AR RODRIGUEZ :  
cEmailGrpFIN : = 'antonio@arrodriguez.com.br , financeiro@arrodriguez, jeanette@arrodriguez.com.br '
PEDIDOS DE VENDAS EM ABERTO : logistica@arrodriguez.com.br; balcao2@arrodriguez.com.br;antonio@arrodriguez.com.br
TODOS DO RH : secretaria@arrodriguez.com.br; rh1@arrodriguez.com.br;antonio@arrodriguez.com.br
*/

   			 
        Case LEFT(SM0->M0_NOME,9) == "LANAPLAST"                                                        
	         // cRecebe   := 'diretoria@potencial.inf.br'                                               	
   			 cRecebe   := 'anapaula@lanaplast.com;diretoria@lanaplast.com'                                               	
        Case LEFT(SM0->M0_NOME,9) $ "FINO CORTE" .OR. "FINO CORTE" $ SM0->M0_NOME 
   			cRecebe   := 'diretoria@potencial.inf.br;paulojacob@casadacarnesouza.com.br'                                               	
        Case LEFT(SM0->M0_NOME,9) $ "FRIGORIFICO RIO MAR" .OR. "RIO MAR" $ SM0->M0_NOME 
   			cRecebe   := 'diretoria@potencial.inf.br' 
        Case LEFT(SM0->M0_NOMECOM,3) == "MIL" .OR.LEFT(SM0->M0_NOMECOM,3) == "BK ".OR. LEFT(SM0->M0_NOMECOM,3) == "CAR"
		    cRecebe   :=  'diretoria@potencial.inf.br,nestor.techera@preciouswoods.com.br,bruno.rodrigues@preciouswoods.com.br'   
   			emailcompras := 'eli.gomes@preciouswoods.com.br'  
   			cEmailGrpMat += ';marcos.leitao@preciouswoods.com.br'
   			
   	    OtherWise 
	        cRecebe := 'diretoria@potencial.inf.br'
	  EndCase 

  //  Contas a Receber 	
    
    
		cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Contas a Receber Vencidos 30 dias e a Vencer 7 dias ' 
		cMsg1 := 'O Arquivo em Anexo XLS para ser aberto em Excell caso queira tratamento especifico. '
		// cMsg1 += ' The File attached can be open in excel to management the data.'
		// cMsg1 += ' Em caso de saldos elevados procurem o contador para informar o saldo correto da contas a receber e posteriormente solicitar suporte tecnico para acompanhar na conciliação do Registros."

        // Query 
      	cQuery := " SELECT E1_NUM, E1_PARCELA, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, E1_EMISSAO, E1_VENCREA, CAST(E1_VALOR AS DECIMAL(17,2)) AS VALOR, CAST(E1_SALDO AS DECIMAL(17,2))AS SALDO, E1_PORTADO, A6_AGENCIA, E1_CONTA "
    	cQuery += " FROM "+RetSqlName("SE1")+" A "
    	cQuery += " INNER JOIN "+RetSqlName("SA1")+" B ON E1_CLIENTE = A1_COD AND E1_LOJA = A1_LOJA AND B.D_E_L_E_T_ = ' ' "
    	cQuery += " LEFT JOIN "+RetSqlName("SA6")+" C WITH(NOLOCK) ON A6_COD = E1_PORTADO AND A6_NUMCON = E1_CONTA AND C.D_E_L_E_T_ = ' ' "
    	cQuery += " WHERE A.D_E_L_E_T_ = '' "
		 //   cQuery += "      AND  E1_VENCREA >= CONVERT(CHAR(8), GETDATE()-1, 112) AND E1_VENCREA <= CONVERT(CHAR(8), GETDATE()+1, 112)" 
	    cQuery += "      AND  E1_VENCREA > = "+DTOS(dDataBase-30)+" AND E1_VENCREA <= "+DTOS(dDataBase+2)
	    cQuery += "      AND E1_BAIXA =  ' ' "
		//    cQuery += " ORDER BY E1_VALOR DESC "
	    cQuery += " ORDER BY A1_NOME "
    
    	TcQuery cQuery New Alias qAtu
   		 // OPEN QUERY cQuery ALIAS "qAtu" //  [ [NOCHANGE] ]

  
		DbSelectArea("qAtu")    
		// Copy to &cAnexosdbf  VIA "DBFCDXADS"
		// __COPYFILE(cAnexosdbf,cAnexosxls)

		cMsg2 := ""    
		DbSelectArea("qAtu")
		DbGotop()
		If Eof()
			cMsg2  := "Sem Movimento "
		    cfiles := ""

		Else
		  cfiles := cAnexosxls 
		Endif
		cCliente := Alltrim(qAtu->A1_COD)
		cLoja    := Alltrim(qAtu->A1_LOJA)
		cNmCliente := qAtu->A1_NOME 

		Do While !EOF()
         Do While cCliente == Alltrim(qAtu->A1_COD).and.!eof()
     	  cMsg2 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	  cMsg2 +="<TBODY><TR>
		  cMsg2 +="<TD width=300 align=left> "+qAtu->E1_NUM+"-"+qAtu->E1_PARCELA
  		  cMsg2 +="<TD width=600 align=left> "+qAtu->A1_COD+" - "+qAtu->A1_LOJA+" - "+Alltrim(qAtu->A1_NREDUZ)
  		  cMsg2 +="<TD width=200 align=left> "+DTOC(STOD(qAtu->E1_EMISSAO))
  		  cMsg2 +="<TD width=200 align=left> "+DTOC(STOD(qAtu->E1_VENCREA))
  		  cMsg2 +="<TD width=100 align=left> "+STR((dDatabase-STOD(qAtu->E1_VENCREA)))  		  
  		  cMsg2 +="<TD width=300 align=right > "+Transform((qAtu->VALOR/1000),"@E 9,999.99") 
  		  cMsg2 +="<TD width=300 align=right > "+Transform((qAtu->SALDO/1000),"@E 9,999.99") 
  		  cMsg2 +="</TR></TBODY></TABLE>
          nTotal  += qAtu->SALDO         
          nTotCliente += qAtu->SALDO         
            Dbskip()
         Enddo 
            
         
         // Total Cliente 
		  cMsg2 +="<TD width=475 align=right > Total Cliente: "+cCliente+"-"+cNmCliente+" - "+Transform((nTotCliente/1000) ,"@E 99,999.99") 
		  cMsg2 +="</TR>
		  cMsg2 +="<TD width=475 align=right > CNPJ/CPF: "+POSICIONE("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CGC")  
          cCliente := Alltrim(qAtu->A1_COD)
          cLoja    := Alltrim(qAtu->A1_LOJA)

          cNmCliente := Alltrim(qAtu->A1_NOME)
          nTotCliente := 0

		Enddo 
        
		cMsg1 :="<HTML>
		cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Titulos a Receber  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	cMsg1 +="<TBODY><TR>
		cMsg1 +="<TD width=300 align=left> Dados do Titutlo:"
  		cMsg1 +="<TD width=600 align=left> Dados Cliente "
  		cMsg1 +="<TD width=200 align=left> Emissao "
  		cMsg1 +="<TD width=200 align=left> Vencimento "
  		cMsg1 +="<TD width=100 align=left> Dias Atraso "
  		cMsg1 +="<TD width=300 align=left> Valor /1000  "
  		cMsg1 +="<TD width=300 align=left> Saldo /1000  "
  		cMsg1 +="</TR></TBODY></TABLE>
		cMsg1 += cMsg2         
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Total </B></CENTER></FONT></TD>
		cMsg1 +="<TD width=475 align=right > "+Transform(nTotal ,"@E 9,999,999.99") 
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão: coordenacao@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="</HTML>"              
		
		
		DbSelectArea("Qatu")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
  				SEND MAIL FROM cEnvia;
				TO cRecebe;
				Cc cCopia+";"+cEmailGrpFin;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif
	
	// Pedido de Vendas em Aberto      

	cAnexosdbf := cPath + "Pedidos"+".dbf"                
	cAnexosxls := cPath + "Pedidos"+".xls"  
    cfiles := cAnexosxls 
	
	  cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Pedidos de Vendas em Abertos '+STR(Year(dDataBase)) 
	  cMsg1 := 'SUGESTÃO: Use o Pedido de Vendas para controle de suas principais vendas assim gerenciando sua demanda. Aos Clientes que possuem produção podem acompanhar as OP se estão sendo geradas pelos Pedidos evitando produção Soltas e Avulsas.' 
	  // cMsg1 += 'O Arquivo em Anexo DBF pode ser utilizado para importação para outros aplicativos Acess ou BI e XLS para ser aberto em Excell caso queira tratamento especifico. '
	  // cMsg1 += 'The Files attached can be open in excel to management the data '

		cQuery := " SELECT C6_NUM, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, C6_ENTREG,C6_PRODUTO, C6_DESCRI, C6_NUMOP,  CAST((C6_VALOR/1000) AS DECIMAL(19,5)) AS VALOR "
    	cQuery += " FROM "+RetSqlName("SC6")+" A "
    	cQuery += " INNER JOIN "+RetSqlName("SA1")+" B ON C6_CLI = A1_COD AND C6_LOJA = A1_LOJA AND B.D_E_L_E_T_ = ' ' "
    	// cQuery += " LEFT JOIN "+RetSqlName("SA6")+" C WITH(NOLOCK) ON A6_COD = E1_PORTADO AND A6_NUMCON = E1_CONTA AND C.D_E_L_E_T_ = ' ' "
    	cQuery += " WHERE A.D_E_L_E_T_ = '' "
		 //   cQuery += "      AND  E1_VENCREA >= CONVERT(CHAR(8), GETDATE()-1, 112) AND E1_VENCREA <= CONVERT(CHAR(8), GETDATE()+1, 112)" 
	    cQuery += "      AND  C6_ENTREG > = "+DTOS(ctod("01/01/"+STR(YEAR(dDataBase))))+" AND C6_ENTREG <= "+DTOS(dDataBase)
	    cQuery += "      AND C6_DATFAT =  ' ' "
		//    cQuery += " ORDER BY E1_VALOR DESC "
	    cQuery += " ORDER BY A1_NOME "
    
    	TcQuery cQuery New Alias Pedidos
   		 // OPEN QUERY cQuery ALIAS "qAtu" //  [ [NOCHANGE] ]

  
		DbSelectArea("Pedidos")    

		Copy to &cAnexosdbf VIA "DBFCDXADS"   
		__COPYFILE(cAnexosdbf,cAnexosxls)
		
		cMsg3 := ""
		DbSelectArea("Pedidos")    
		DbGotop()
		If Eof()
			cMsg3 := "Sem Movimento "
		Endif
		cCliente := Alltrim(Pedidos->A1_COD)
		cLoja    := Alltrim(Pedidos->A1_LOJA)
		cNmCliente := Pedidos->A1_NOME 

		Do While !EOF()
         Do While cCliente == Alltrim(Pedidos->A1_COD).and.!eof()
     	  cMsg3 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	  cMsg3 +="<TBODY><TR>
		  cMsg3 +="<TD width=300 align=left> "+Pedidos->C6_NUM
  		  cMsg3 +="<TD width=600 align=left> "+Pedidos->A1_COD+" - "+Pedidos->A1_LOJA+" - "+Pedidos->A1_NREDUZ
  		  cMsg3 +="<TD width=200 align=left> "+DTOC(STOD(Pedidos->C6_ENTREG))
  		  cMsg3 +="<TD width=200 align=left> "+Pedidos->C6_PRODUTO 
  		  cMsg3 +="<TD width=600 align=left> "+Pedidos->C6_Descri  		  
  		  cMsg3 +="<TD width=300 align=left> "+Pedidos->C6_NUMOP  		  
  		  cMsg3 +="<TD width=300 align=right > "+Transform(Pedidos->VALOR,"@E 9,999,999.99999") 
  		  cMsg3 +="</TR></TBODY></TABLE>
          nTotalPedido  += Pedidos->VALOR          
          nTotCliente += Pedidos->VALOR          
            Dbskip()
         Enddo 
            
         
         // Total Cliente 
		  cMsg3 +="<TD width=475 align=right > Total Cliente: "+cCliente+"-"+cNmCliente+" - "+Transform(nTotCliente ,"@E 99,999,999.99") 
		  cMsg3 +="</TR>
		  cMsg3 +="<TD width=475 align=right > CNPJ/CPF: "+POSICIONE("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1_CGC")  
          cCliente := Alltrim(Pedidos->A1_COD)
          cLoja    := Alltrim(Pedidos->A1_LOJA)

          cNmCliente := Pedidos->A1_NOME                                 
          nTotCliente := 0

		Enddo 

		cMsg1 +="<HTML>
		cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Pedidos de Vendas em Aberto  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	cMsg1 +="<TBODY><TR>
		cMsg1 +="<TD width=300 align=left> Numero do Pedido :"
  		cMsg1 +="<TD width=600 align=left> Dados Cliente "
  		cMsg1 +="<TD width=200 align=left> Emissao "
  		cMsg1 +="<TD width=200 align=left> Produto   "
  		cMsg1 +="<TD width=600 align=left> Descricao  "
  		cMsg1 +="<TD width=300 align=left> Numero OP  "
  		cMsg1 +="<TD width=300 align=left> Valor/1000   "
  		cMsg1 +="</TR></TBODY></TABLE>
		cMsg1 += cMsg3         
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Total </B></CENTER></FONT></TD>
		cMsg1 +="<TD width=475 align=right > "+Transform(nTotalPedido ,"@E 9,999,999.99") 
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão: coordenacao@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 += "</HTML>"              
		
		DbSelectArea("Pedidos")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
  				SEND MAIL FROM cEnvia;
				TO cRecebe;
				Cc cCopia+";"+cEmailGrpFat;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif
	


//  Funcionarios com mais de 45 dias de férias vencidas 

  // contas a pagar proxima semana
	cAnexosdbf := cPath +"FUNFER"+".dbf"                
	cAnexosxls:= cPath +"FUNFER"+".xls"
    cfiles := cAnexosxls 
    cMsg1 := " "
    

    
		cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Funcionários com 45 dias ou mais de férias vencidas ' 
		cMsg1 := 'O Arquivo em Anexo XLS para ser aberto em Excell caso queira tratamento especifico. '
		cMsg1 += 'The File attached can be open in excel to management the data '

        // Query 
        // FILIAL, CENTRO DE CUSTO,  MATRICULA, NOME, SEXO, NOME FUNCAO, DIAS FERIAS VENCIDAS, SALARIO, DATA ADMISSAO, DATA BASE FERIAS 
		cQuery := " SELECT RA_FILIAL, RA_CC, RA_MAT, RA_NOME, RA_SEXO, RJ_DESC, RF_DFERVAT, RF_DFERAAT, CAST(RA_SALARIO AS DECIMAL(14,2)) AS SALARIO, RA_ADMISSA, RF_DATABAS "
    	cQuery += " FROM "+RetSqlName("SRA")+' A '
    	cQuery += " LEFT JOIN "+RetSqlName("SRJ")+" B ON RA_CODFUNC = RJ_FUNCAO AND B.D_E_L_E_T_ = ' ' "
    	cQuery += " LEFT JOIN "+RetSqlName("SRF")+" C ON RA_MAT  = RF_MAT AND RA_FILIAL = RF_FILIAL  AND C.D_E_L_E_T_ = ' ' "
    	// cQuery += " LEFT JOIN "+RetSqlName("SA6")+" C WITH(NOLOCK) ON A6_COD = E1_PORTADO AND A6_NUMCON = E1_CONTA AND C.D_E_L_E_T_ = ' ' "
    	cQuery += " WHERE  RA_SITFOLH <> 'D' AND  RF_DFERVAT > = 30 AND RF_DFERAAT  > = 15 "
	    cQuery += " ORDER BY RA_MAT"                              
	    
	    // AND  RF_DFERVAT = 30 AND RF_DFERAAT  > = 15                                       
	    // AND RA_FILIAL = RJ_FILIAL AND RA_FILIAL = RF_FILIAL 
    
    	TcQuery cQuery New Alias cFunFer  
   		 
  
		DbSelectArea("cFunFer")    

		Copy to &cAnexosdbf VIA "DBFCDXADS"
		__COPYFILE(cAnexosdbf,cAnexosxls)
		cCorpo := " "
		DbSelectArea("cFunFer")    
		DbGotop()
		If Eof()
			cCorpo := "Sem Movimento "
		Endif
		cFuncionario := Alltrim(cFunFer->RA_MAT)
		cNmFuncionario := LEFT(cFunFer->RA_NOME,30) 

		Do While !EOF()
         
         Do While cFuncionario == Alltrim(cFunFer->RA_MAT).and.!eof()
     	  cCorpo +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	  cCorpo +="<TBODY><TR>
		  cCorpo +="<TD width=300 align=left> "+cFunFer->RA_FILIAL +"-"+cFunFer->RA_CC
  		  cCorpo +="<TD width=1200 align=left> "+cFunFer->RA_MAT+" - "+cFunFer->RA_NOME+" - "+cFunFer->RA_SEXO
  		  cCorpo +="<TD width=600 align=left> "+cFunFer->RJ_DESC 
  		  cCorpo +="<TD width=400 align=left> "+str((cFunFer->RF_DFERVAT+cFunFer->RF_DFERAAT))
  		  cCorpo +="<TD width=300 align=right > "+Transform(cFunFer->SALARIO ,"@E 99,999.99") 
  		  cCorpo +="<TD width=300 align=right > "+DTOC(STOD(cFunFer->RA_ADMISSA))
  		  cCorpo +="<TD width=600 align=right > "+DTOC(STOD(cFunFer->RF_DATABAS))
  		  cCorpo +="</TR></TBODY></TABLE>
  		  
            Dbskip()
         Enddo 
            
         
          DbSelectArea("cFunFer")    
		
          cFuncionario := Alltrim(cFunFer->RA_MAT)

          cNmFuncionario := cFunFer->RA_NOME                                 
          nTotFuncionario := 0

		Enddo 

		cMsg1 +="<HTML>
		cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Funcionários >= 45 dias de férias vencidas   </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	cMsg1 +="<TBODY><TR>
		cMsg1 +="<TD width=300 align=left> Dados Filial e CCusto:"
  		cMsg1 +="<TD width=1200 align=left> Dados Funcionario  "
  		cMsg1 +="<TD width=600 align=left> Funcao "
  		cMsg1 +="<TD width=200 align=left> Dias Fer Vencidas "
  		cMsg1 +="<TD width=300 align=left> Salario  "
  		cMsg1 +="<TD width=300 align=left> Admissao   "
		cMsg1 +="<TD width=600 align=left> Data Base Ferias  "
  		cMsg1 +="</TR></TBODY></TABLE>
		cMsg1 += cCorpo         
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão e Melhorias: suporte@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	
		cMsg1 += "</HTML>"              
		
		DbSelectArea("cFunFer")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
  				SEND MAIL FROM cEnvia;
				TO cRecebe+";"+cEmailGrpRh;             
				Cc cCopia;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif


	
	// Funcionarios com férias a vencer mais de 30 dias 


  // contas a pagar proxima semana
	cAnexosdbf := cPath +"CTAPAG"+".dbf"                
	cAnexosxls:= cPath +"CTAPAG"+".xls"
    cfiles := cAnexosxls 

    
		cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Contas a Pagar nos próximos 7 dias' 
		cMsg1 := 'O Arquivo em Anexo XLS para ser aberto em Excell caso queira tratamento especifico. '
		cMsg1 += 'The File attached can be open in excel to management the data '

        // Query 
      
		cQuery := " SELECT E2_NUM, E2_PARCELA, A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, E2_EMISSAO, E2_VENCREA, CAST(E2_VALOR AS DECIMAL(14,2)) AS VALOR, CAST(E2_SALDO AS DECIMAL(14,2))AS SALDO "
    	cQuery += " FROM "+RetSqlName("SE2")+' A,'+RetSqlName("SA2")+' B'
    	cQuery += " WHERE A.D_E_L_E_T_ = '' AND E2_FORNECE = A2_COD AND E2_LOJA = A2_LOJA "
    	cQuery += " AND  E2_VENCREA > = "+DTOS(dDataBase+1)+" AND E2_VENCREA <= "+DTOS(dDataBase+5)
	    cQuery += " AND E2_BAIXA =  ' ' "
	    cQuery += " ORDER BY E2_VENCREA"
    
    	TcQuery cQuery New Alias cApagar 
   		 
  
		DbSelectArea("cApagar")    

		Copy to &cAnexosdbf VIA "DBFCDXADS"
		__COPYFILE(cAnexosdbf,cAnexosxls)
		cCorpo := " "		
		DbSelectArea("cApagar")    
		DbGotop()
		If Eof()
			cCorpo := "Sem Movimento "
		Endif
		cFornecedor := Alltrim(cApagar->A2_COD)
		cLoja    := Alltrim(cApagar->A2_LOJA)
		cNmFornecedor := LEFT(cApagar->A2_NOME,30) 

		Do While !EOF()
         
         Do While cFornecedor  == Alltrim(cApagar->A2_COD).and.!eof()
     	  cCorpo +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	  cCorpo +="<TBODY><TR>
		  cCorpo +="<TD width=300 align=left> "+cApagar->E2_NUM+"-"+cApagar->E2_PARCELA
  		  cCorpo +="<TD width=600 align=left> "+cApagar->A2_COD+" - "+cApagar->A2_LOJA+" - "+cApagar->A2_NREDUZ
  		  cCorpo +="<TD width=200 align=left> "+DTOC(STOD(cApagar->E2_EMISSAO))
  		  cCorpo +="<TD width=200 align=left> "+DTOC(STOD(cApagar->E2_VENCREA))
  		  cCorpo +="<TD width=300 align=right > "+Transform(cApagar->VALOR,"@E 99,999.99") 
  		  cCorpo +="<TD width=300 align=right > "+Transform(cApagar->SALDO,"@E 99,999.99") 
  		  cCorpo +="</TR></TBODY></TABLE>
  		  
          nTotalPagar  += cApagar->SALDO         
          nTotFornecedor += cApagar->SALDO         
            Dbskip()
         Enddo 
            
         
         // Total Fornecedor 
		   cCorpo +="<TD width=475 align=right > Total Fornecedor : "+cFornecedor +"-"+cNmFornecedor+" - "+Transform(nTotFornecedor,"@E 9,999,999.99") 
		   cCorpo +="</TR>
		   cCorpo +="<TD width=475 align=right > CNPJ/CPF: "+POSICIONE("SA2",1,xFilial("SA2")+cFornecedor+cLoja,"A2_CGC")  
          DbSelectArea("cApagar")    
		
          cFornecedor:= Alltrim(cApagar->A2_COD)
          cLoja    := Alltrim(cApagar->A2_LOJA)

          cNmFornecedor := cApagar->A2_NOME                                 
          nTotFornecedor := 0

		Enddo 

		cMsg1 +="<HTML>
		cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Titulos a Pagar   </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	cMsg1 +="<TBODY><TR>
		cMsg1 +="<TD width=300 align=left> Dados do Titutlo:"
  		cMsg1 +="<TD width=600 align=left> Dados Forncedor "
  		cMsg1 +="<TD width=200 align=left> Emissao "
  		cMsg1 +="<TD width=200 align=left> Vencimento "
  		cMsg1 +="<TD width=300 align=left> Valor   "
  		cMsg1 +="<TD width=300 align=left> Saldo   "
  		cMsg1 +="</TR></TBODY></TABLE>
		cMsg1 += cCorpo         
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Total </B></CENTER></FONT></TD>
		cMsg1 +="<TD width=475 align=right > "+Transform(nTotalPagar ,"@E 9,999,999.99") 
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão: coordenacao@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	
		cMsg1 += "</HTML>"              
		
		DbSelectArea("cApagar")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
  				SEND MAIL FROM cEnvia;
				TO cRecebe;
				Cc cCopia+";"+cEmailGrpFin;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif


	
// Produtos em Estoque com Custo Medio e Total Compras e Total Saidas e Vendas 

	cAnexosdbf := cPath + "Estoques"+".dbf"                
	cAnexosxls := cPath + "Estoques"+".xls"  
    cfiles := cAnexosxls 
	
	  cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Estoque Produtos Novos Inseridos em '+STRZERO(YEAR(dDataBase),4)+' sem Mat Consumo ' 
	  cMsg1 := 'O Arquivo com extensao XLS para ser aberto em Excell caso queira tratamento especifico. '
	  cMsg1 += 'The Files attached can be open in excel to management the data '
		cQuery := " SELECT DISTINCT B2_FILIAL, B2_COD, B1_DESC, B1_TIPO, B1_UM, B1_POSIPI,B1_DTREFP1, B2_LOCAL, B2_USAI, B2_SALPEDI, CAST(B2_CM1 AS DECIMAL(14,2)) AS CUSTO, CAST(B1_PRV1 AS DECIMAL(14,2)) AS PRCVENDA, CAST(SUM(B2_QATU) AS DECIMAL(14,2)) AS QATUAL, 0 AS ENTRADAS, 0 AS BAIXAS, 0 AS VENDAS "
    	cQuery += " FROM "+RetSqlName("SB2")+" A "
    	cQuery += " INNER JOIN "+RetSqlName("SB1")+" B ON B2_COD = B1_COD AND B.D_E_L_E_T_ = ' '  AND B1_TIPO <> 'MC' AND SUBSTRING(B.B1_DTREFP1,1,4)>='"+ALLTRIM(STR(YEAR(dDataBase)))+"'  " 
    	cQuery += " WHERE A.D_E_L_E_T_ = '' AND A.B2_QATU > 0  AND B1_PRV1 <> 0 AND B1_POSIPI <> ' ' "
		cQuery += " GROUP BY B2_FILIAL, B2_COD, B1_DESC, B1_TIPO, B1_UM, B1_POSIPI,B1_DTREFP1,B2_LOCAL, B2_USAI, B2_SALPEDI, B2_CM1, B1_PRV1"
	    cQuery += " ORDER BY PRCVENDA DESC, QATUAL DESC, B2_COD,B2_FILIAL,B1_TIPO "


/*

    	cQuery += " LEFT JOIN "+RetSqlName("SD1")+" C ON B2_COD = D1_COD AND C.D_E_L_E_T_ = ' ' AND ( RTRIM(C.D1_CF) = '1101' OR RTRIM(C.D1_CF) ='1102' ) AND SUBSTRING(C.D1_DTDIGIT,1,4)='"+ALLTRIM(STR(YEAR(dDataBase)))+"'  " 
    	cQuery += " LEFT JOIN "+RetSqlName("SD3")+" D ON B2_COD = D3_COD AND D.D3_CF = 'RE0' AND D.D_E_L_E_T_ = ' ' AND SUBSTRING(D.D3_EMISSAO,1,4)='"+ALLTRIM(STR(YEAR(dDataBase)))+"'  " 
    	cQuery += " LEFT JOIN "+RetSqlName("SD2")+" E ON B2_COD = D2_COD AND E.D_E_L_E_T_ = ' ' AND SUBSTRING(E.D2_EMISSAO,1,4)='"+ALLTRIM(STR(YEAR(dDataBase)))+"'  " 


*/

        dbUseArea( .T., "TOPCONN", TcGenQry(,,CHANGEQUERY(cQuery)), "Estoque", .T., .F. )
    	// TcQuery cQuery New Alias Estoque 
   		 // OPEN QUERY cQuery ALIAS "qAtu" //  [ [NOCHANGE] ]

	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
			    SEND MAIL FROM cEnvia;
				TO "franciney@potencial.inf.br";
				SUBJECT "Query Estoque ";
				BODY cQuery

				DISCONNECT SMTP SERVER Result lDisConectou
		
        Endif

  
		DbSelectArea("Estoque")    

		
		cMsg3 := ""
		DbSelectArea("Estoque")    
		DbGotop()
		If Eof()
			cMsg3 := "Sem Movimento "
		Endif
		cProduto := Alltrim(Estoque->B2_COD)
		cNmProduto := Estoque->B1_DESC

		Do While !EOF()

         Do While cProduto == Alltrim(Estoque->B2_COD).and.!eof()
          
          nEntradas := TotalEntradas(Estoque->B2_FILIAL,Estoque->B2_COD)
          nBaixas := TotalBaixas(Estoque->B2_FILIAL,Estoque->B2_COD)
          nVendas := TotalVendas(Estoque->B2_FILIAL,Estoque->B2_COD)
          // Reclock("Estoque",.F.)
          // Estoque->Entradas := nEntradas 
          // Estoque->Baixas := nBaixas 
          // Estoque->Vendas := nVendas 
          // UNLOCK 
          
   		  DbSelectArea("Estoque")    
          cMsg3 +='<TR>'
    	  cMsg3 +="<TD width=300 align=left> "+Estoque->B2_FILIAL
    	  cMsg3 +="<TD width=300 align=left> "+Estoque->B2_COD
  		  cMsg3 +="<TD width=1200 align=left> "+ALLTRIM(Estoque->B1_DESC)
  		  cMsg3 +="<TD width=200 align=left> "+Estoque->B1_TIPO
  		  cMsg3 +="<TD width=300 align=left> "+Estoque->B1_UM 
  		  cMsg3 +="<TD width=600 align=left> "+Estoque->B1_POSIPI   		  
  		  cMsg3 +="<TD width=600 align=left> "+Dtoc(STOD(Estoque->B1_DTREFP1))
  		  cMsg3 +="<TD width=600 align=left> "+Estoque->B2_LOCAL 
  		  cMsg3 +="<TD width=600 align=right > "+Transform(Estoque->QATUAL,"@E 99,999.99999")
  		  cMsg3 +="<TD width=600 align=right > "+Transform(Estoque->CUSTO,"@E 99,999.99999") 
  		  cMsg3 +="<TD width=600 align=right > "+Transform(Estoque->PRCVENDA,"@E 99,999.9999") 
  		  cMsg3 +="<TD width=600 align=right > "+Transform(nEntradas,"@E 99,999.99") 
   		  cMsg3 +="<TD width=600 align=right > "+Transform(Estoque->BAIXAS,"@E 99,999.999") 
  		  cMsg3 +="<TD width=600 align=right > "+Transform(Estoque->VENDAS,"@E 99,999.999")   		  
  		  cMsg3 +="<TD width=600 align=right > "+IF(Estoque->PRCVENDA <= Estoque->CUSTO," Erro Preco de Venda! ","")    		  
  		  
  		  cMsg3 +="</TR>
  		  
   		  DbSelectArea("Estoque")    
           
            Dbskip()
         Enddo 
            
   		  DbSelectArea("Estoque")    
         
          cProduto := Alltrim(Estoque->B2_COD)
 		  cNmProduto := Estoque->B1_DESC
          

		Enddo 
 		DbSelectArea("Estoque")    

		Copy to &cAnexosdbf VIA "DBFCDXADS"   
		__COPYFILE(cAnexosdbf,cAnexosxls)


		cMsg1 +="<HTML>
		// cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Estoque x Custos x Preço Venda x Mov Entradas e Saidas Sem Mat Consumo </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 += ' <table width="100%" border="1" cellspacing="0" cellpadding="5">'
		cMsg1 += ' <caption><h2>' +" Estoque Produtos Novos " +'</h2></caption>'
		cMsg1 += ' <tr>'    
        cMsg1 += ' <th scope="col">Filial </th>'
        cMsg1 += ' <th scope="col">Cod Produto</th>'
        cMsg1 += ' <th scope="col">Desc Produto</th>'
        cMsg1 += ' <th scope="col">Tipo </th>'
        cMsg1 += ' <th scope="col">UM </th>'
        cMsg1 += ' <th scope="col">NCM </th>'
        cMsg1 += ' <th scope="col">Data Cad </th>'
        cMsg1 += ' <th scope="col">Local </th>'
 //       cMsg1 += ' <th scope="col">Ultima Saida </th>'
        cMsg1 += ' <th scope="col">Saldo </th>'  
        cMsg1 += ' <th scope="col">Vlr Custo </th>'  
        cMsg1 += ' <th scope="col">Prc Venda </th>'  
        cMsg1 += ' <th scope="col">QT Entradas  </th>'
        cMsg1 += ' <th scope="col">QT Baixas SD3 </th>'  
        cMsg1 += ' <th scope="col">QT Vendas </th>'  
        cMsg1 += ' <th scope="col">Obervação Preço x Custo </th>'  
        
        cMsg1 += ' </tr>'  		
		cMsg1 += cMsg3         
		cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão: coordenacao@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 += "</HTML>"              
		
		DbSelectArea("Estoque")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
			    
  				SEND MAIL FROM cEnvia;
				TO cRecebe;
				Cc cCopia+";"+cEmailGrpMat;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			    
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif
	

	
	
	// Medias de Pedidos Colocados x Pedidos Atendidos 
	
    // Produtos Em Estoque com Totais Compras e Totais Saidas e Vendas 
    
    // Funcionarios com Data 1a Experiencia a Vencer
    

  // contas a pagar proxima semana
	cAnexosdbf := cPath +"FUNEXP1"+".dbf"                
	cAnexosxls:= cPath +"FUNEXP1"+".xls"
    cfiles := cAnexosxls 
    cMsg1 := " "
    
    
		cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Funcionários Vencendo 1o Periodo de Experiência  ' 
		cMsg1 := 'O Arquivo em Anexo XLS para ser aberto em Excell caso queira tratamento especifico. '
		cMsg1 += 'The File attached can be open in excel to management the data '

        // Query 
        // FILIAL, CENTRO DE CUSTO,  MATRICULA, NOME, SEXO, NOME FUNCAO, DIAS FERIAS VENCIDAS, SALARIO, DATA ADMISSAO, DATA BASE FERIAS 
		// Para 1° Experiência
		cQuery := " SELECT RA_FILIAL,RA_CC,RA_MAT,RA_NOME,RA_SEXO,RA_ADMISSA,RJ_DESC,RA_SALARIO, DATEDIFF(DAY, CURRENT_TIMESTAMP, RA_VCTOEXP) AS EXPIRA_EM, "
		cQuery += " SUBSTRING(RA_VCTOEXP,7,8)+'/'+SUBSTRING(RA_VCTOEXP,5,2)+'/'+SUBSTRING(RA_VCTOEXP,1,4) AS DTFIMCT,   "
		cQuery += " SUBSTRING(RA_ADMISSA,7,8)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADMISSA      "
		cQuery += " FROM "+RetSqlName("SRA")+" SRA "
    	cQuery += " LEFT JOIN "+RetSqlName("SRJ")+" SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SRA.D_E_L_E_T_='' AND SRA.RA_SITFOLH<>'D' "
		cQuery += " AND DATEDIFF(D, CURRENT_TIMESTAMP, RA_VCTOEXP) IN (7, 6, 5, 4, 3, 2, 1) "
		cQuery += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "

    	TcQuery cQuery New Alias cFunExp1  
		DbSelectArea("cFunExp1")    

		Copy to &cAnexosdbf VIA "DBFCDXADS"
		__COPYFILE(cAnexosdbf,cAnexosxls)
		cCorpo := " "
		DbSelectArea("cFunExp1")    
		DbGotop()
		If Eof()
			cCorpo := "Sem Movimento "
		Endif
		cFuncionario := Alltrim(cFunExp1->RA_MAT)
		cNmFuncionario := LEFT(cFunExp1->RA_NOME,30) 

		Do While !EOF()
         
         Do While cFuncionario == Alltrim(cFunExp1->RA_MAT).and.!eof()
     	  cCorpo +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	  cCorpo +="<TBODY><TR>
		  cCorpo +="<TD width=300 align=left> "+cFunExp1->RA_FILIAL +"-"+cFunExp1->RA_CC
  		  cCorpo +="<TD width=1200 align=left> "+cFunExp1->RA_MAT+" - "+cFunExp1->RA_NOME+" - "+cFunExp1->RA_SEXO
  		  cCorpo +="<TD width=600 align=left> "+cFunExp1->RJ_DESC 
  		  cCorpo +="<TD width=400 align=left> "+str((cFunExp1->EXPIRA_EM))
  		  cCorpo +="<TD width=300 align=right > "+Transform(cFunExp1->RA_SALARIO ,"@E 99,999.99") 
  		  cCorpo +="<TD width=300 align=right > "+DTOC(STOD(cFunExp1->RA_ADMISSA))
  		  cCorpo +="<TD width=600 align=right > "+DTOC(STOD(cFunExp1->DTFIMCT))
  		  cCorpo +="</TR></TBODY></TABLE>
  		  
            Dbskip()
         Enddo 
            
         
          DbSelectArea("cFunExp1")    
		
          cFuncionario := Alltrim(cFunExp1->RA_MAT)

          cNmFuncionario := cFunExp1->RA_NOME                                 
          nTotFuncionario := 0

		Enddo 

		cMsg1 +="<HTML>
		cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Funcionários Vencendo 1o Periodo de Experiência   </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	cMsg1 +="<TBODY><TR>
		cMsg1 +="<TD width=300 align=left> Dados Filial e CCusto:"
  		cMsg1 +="<TD width=1200 align=left> Dados Funcionario  "
  		cMsg1 +="<TD width=600 align=left> Funcao "
  		cMsg1 +="<TD width=200 align=left> Dias a Vencer "
  		cMsg1 +="<TD width=300 align=left> Salario  "
  		cMsg1 +="<TD width=300 align=left> Admissao   "
		cMsg1 +="<TD width=600 align=left> Data Fim 1o Periodo  "
  		cMsg1 +="</TR></TBODY></TABLE>
		cMsg1 += cCorpo         
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão e Melhorias: suporte@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	
		cMsg1 += "</HTML>"              
		
		DbSelectArea("cFunExp1")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
  				SEND MAIL FROM cEnvia;
				TO cRecebe+";"+cEmailGrpRh;             
				Cc cCopia;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif

// Funcionarios Vencimento 2o Periodo

	cAnexosdbf := cPath +"FUNEXP2"+".dbf"                
	cAnexosxls:= cPath +"FUNEXP2"+".xls"
    cfiles := cAnexosxls 
    cMsg1 := " "
    
    
		cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Funcionários Vencendo 2o Periodo de Experiência  ' 
		cMsg1 := 'O Arquivo em Anexo XLS para ser aberto em Excell caso queira tratamento especifico. '
		cMsg1 += 'The File attached can be open in excel to management the data '

        // Query 
        // FILIAL, CENTRO DE CUSTO,  MATRICULA, NOME, SEXO, NOME FUNCAO, DIAS FERIAS VENCIDAS, SALARIO, DATA ADMISSAO, DATA BASE FERIAS 
		// Para 2° Experiência

		cQuery := " SELECT RA_FILIAL,RA_CC,RA_MAT,RA_NOME, RA_SEXO,RA_ADMISSA, RJ_DESC, RA_SALARIO, DATEDIFF(DAY, CURRENT_TIMESTAMP, RA_VCTEXP2) AS EXPIRA_EM, "
        cQuery += " SUBSTRING(RA_VCTEXP2,7,8)+'/'+SUBSTRING(RA_VCTEXP2,5,2)+'/'+SUBSTRING(RA_VCTEXP2,1,4) AS DTFIMCT,   "
        cQuery += " SUBSTRING(RA_ADMISSA,7,8)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADMISSA      "
        cQuery += " FROM "+RetSqlName("SRA")+" SRA "
    	cQuery += " LEFT JOIN "+RetSqlName("SRJ")+" SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SRA.D_E_L_E_T_='' AND RA_SITFOLH<>'D' "
		cQuery += " AND DATEDIFF(D, CURRENT_TIMESTAMP, RA_VCTEXP2) IN (7, 6, 5, 4, 3, 2, 1) "
		cQuery += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "

    	TcQuery cQuery New Alias cFunExp2  
		DbSelectArea("cFunExp2")    

		Copy to &cAnexosdbf VIA "DBFCDXADS"
		__COPYFILE(cAnexosdbf,cAnexosxls)
		cCorpo := " "
		DbSelectArea("cFunExp2")    
		DbGotop()
		If Eof()
			cCorpo := "Sem Movimento "
		Endif
		cFuncionario := Alltrim(cFunExp2->RA_MAT)
		cNmFuncionario := LEFT(cFunExp2->RA_NOME,30) 

		Do While !EOF()
         
         Do While cFuncionario == Alltrim(cFunExp2->RA_MAT).and.!eof()
     	  cCorpo +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	  cCorpo +="<TBODY><TR>
		  cCorpo +="<TD width=300 align=left> "+cFunExp2->RA_FILIAL +"-"+cFunExp2->RA_CC
  		  cCorpo +="<TD width=1200 align=left> "+cFunExp2->RA_MAT+" - "+cFunExp2->RA_NOME+" - "+cFunExp2->RA_SEXO
  		  cCorpo +="<TD width=600 align=left> "+cFunExp2->RJ_DESC 
  		  cCorpo +="<TD width=400 align=left> "+str((cFunExp2->EXPIRA_EM))
  		  cCorpo +="<TD width=300 align=right > "+Transform(cFunExp2->RA_SALARIO ,"@E 99,999.99") 
  		  cCorpo +="<TD width=300 align=right > "+DTOC(STOD(cFunExp2->RA_ADMISSA))
  		  cCorpo +="<TD width=600 align=right > "+cFunExp2->DTFIMCT
  		  cCorpo +="</TR></TBODY></TABLE>
  		  
            Dbskip()
         Enddo 
            
         
          DbSelectArea("cFunExp2")    
		
          cFuncionario := Alltrim(cFunExp2->RA_MAT)

          cNmFuncionario := cFunExp2->RA_NOME                                 
          nTotFuncionario := 0

		Enddo 

		cMsg1 +="<HTML>
		cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Funcionários Vencendo 2o Periodo de Experiência   </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	cMsg1 +="<TBODY><TR>
		cMsg1 +="<TD width=300 align=left> Dados Filial e CCusto:"
  		cMsg1 +="<TD width=1200 align=left> Dados Funcionario  "
  		cMsg1 +="<TD width=600 align=left> Funcao "
  		cMsg1 +="<TD width=200 align=left> Dias a Vencer  "
  		cMsg1 +="<TD width=300 align=left> Salario  "
  		cMsg1 +="<TD width=300 align=left> Admissao   "
		cMsg1 +="<TD width=600 align=left> Data Venc 2o P Exp "
  		cMsg1 +="</TR></TBODY></TABLE>
		cMsg1 += cCorpo         
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão e Melhorias: suporte@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	
		cMsg1 += "</HTML>"              
		
		DbSelectArea("cFunExp2")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
  				SEND MAIL FROM cEnvia;
				TO cRecebe+";"+cEmailGrpRh;             
				Cc cCopia;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif

// Aniversariantes do Mes 


	cAnexosdbf := cPath +"FUNANIVMES"+".dbf"                
	cAnexosxls:= cPath +"FUNANIVMES"+".xls"
    cfiles := cAnexosxls 
    cMsg1 := " "
    
    
		cAssunto := LEFT(SM0->M0_NOMECOM,15)+' Funcionários Aniversariantes do Mes - Dê Parabens  ' 
		cMsg1 := ' Relação dos Aniversariantes, dê parabens aos seus colaboradores.'
		cMsg1 += 'O Arquivo em Anexo XLS para ser aberto em Excell caso queira tratamento especifico. '
		cMsg1 += 'The File attached can be open in excel to management the data '

        // Query 
        // FILIAL, CENTRO DE CUSTO,  MATRICULA, NOME, SEXO, NOME, ,MES ADMISSAO, EXAME MEDICO, FUNCAO, SALARIO, MES ANIV, DATA ADMISSAO, DATA BASE FERIAS 

		cQuery := " SELECT RA_FILIAL,RA_CC,RA_MAT,RA_NOME, RA_SEXO,RA_ADMISSA,RA_NASC,RA_EXAMEDI, RJ_DESC, RA_SALARIO,  DATENAME(month,RA_NASC) AS MesAniv, "
        cQuery += " SUBSTRING(RA_ADMISSA,7,8)+'/'+SUBSTRING(RA_ADMISSA,5,2)+'/'+SUBSTRING(RA_ADMISSA,1,4) AS DTADMISSA      "
        cQuery += " FROM "+RetSqlName("SRA")+" SRA "
    	cQuery += " LEFT JOIN "+RetSqlName("SRJ")+" SRJ ON RA_CODFUNC = RJ_FUNCAO AND SRJ.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE SRA.D_E_L_E_T_='' AND RA_SITFOLH<>'D' "
		cQuery += " AND DATENAME(month, CURRENT_TIMESTAMP) = DATENAME(month,RA_NASC)"
		cQuery += " ORDER BY SRA.RA_FILIAL,SRA.RA_MAT "

    	TcQuery cQuery New Alias cFunAnivM  
		DbSelectArea("cFunAnivM")    

		Copy to &cAnexosdbf VIA "DBFCDXADS"
		__COPYFILE(cAnexosdbf,cAnexosxls)
		cCorpo := " "
		DbSelectArea("cFunAnivM")    
		DbGotop()
		If Eof()
			cCorpo := "Sem Movimento "
		Endif
		cFuncionario := Alltrim(cFunAnivM->RA_MAT)
		cNmFuncionario := LEFT(cFunAnivM->RA_NOME,30) 

		Do While !EOF()
         
         Do While cFuncionario == Alltrim(cFunAnivM->RA_MAT).and.!eof()
     	  cCorpo +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	  cCorpo +="<TBODY><TR>
		  cCorpo +="<TD width=300 align=left> "+cFunAnivM->RA_FILIAL +"-"+cFunAnivM->RA_CC
  		  cCorpo +="<TD width=1200 align=left> "+cFunAnivM->RA_MAT+" - "+cFunAnivM->RA_NOME+" - "+cFunAnivM->RA_SEXO
  		  cCorpo +="<TD width=600 align=left> "+cFunAnivM->RJ_DESC 
  		  cCorpo +="<TD width=400 align=left> "+cFunAnivM->MesAniv 
  		  cCorpo +="<TD width=400 align=left> "+LEFT(DTOC(STOD(cFunAnivM->RA_NASC)),5) 
  		  cCorpo +="<TD width=300 align=right > "+Transform(cFunAnivM->RA_SALARIO ,"@E 99,999.99") 
  		  cCorpo +="<TD width=300 align=right > "+DTOC(STOD(cFunAnivM->RA_ADMISSA))
  		  cCorpo +="<TD width=600 align=right > "+DTOC(STOD(cFunAnivM->RA_EXAMEDI))
  		  cCorpo +="</TR></TBODY></TABLE>
  		  
            Dbskip()
         Enddo 
            
         
          DbSelectArea("cFunAnivM")    
		
          cFuncionario := Alltrim(cFunAnivM->RA_MAT)

          cNmFuncionario := cFunAnivM->RA_NOME                                 
          nTotFuncionario := 0

		Enddo 

		cMsg1 +="<HTML>
		cMsg1 +="<HEAD>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B>Empresa/Company: "+SM0->M0_NOMECOM+" </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
		cMsg1 +="</TBODY></TABLE><BR>
		cMsg1 +="<TR>
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> Relação de Férias no Mês  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
 	 	cMsg1 +="<TBODY><TR>
		cMsg1 +="<TD width=300 align=left> Dados Filial e CCusto:"
  		cMsg1 +="<TD width=1200 align=left> Dados Funcionario  "
  		cMsg1 +="<TD width=600 align=left> Funcao "
  		cMsg1 +="<TD width=200 align=left> Mes Aniversario  "
  		cMsg1 +="<TD width=200 align=left> Data Nascimento  "
  		cMsg1 +="<TD width=300 align=left> Salario  "
  		cMsg1 +="<TD width=300 align=left> Admissao   "
		cMsg1 +="<TD width=600 align=left> Data Venc Ex Medico "
  		cMsg1 +="</TR></TBODY></TABLE>
		cMsg1 += cCorpo         
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
		cMsg1 +="<TABLE border=1 borderColor=#0066cc borderColorLight=#0066cc width=1000 height=29>
		cMsg1 +="<TBODY><TR bgColor=#0066cc>
		cMsg1 +="<TD colSpan=5><FONT color=#ffffff face='Courier New'><CENTER><B> By Potencial Tecnologia Ltda - Sugestão e Melhorias: suporte@potencial.inf.br ou (92) 3635-8936  </B></CENTER></FONT></TD>
		cMsg1 +="</TR>
	  	cMsg1 +="</TR></TBODY></TABLE>                 
	  	
		cMsg1 += "</HTML>"              
		
		DbSelectArea("cFunAnivM")
		DbCloseArea()
		
	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		
		
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
  				SEND MAIL FROM cEnvia;
				TO cRecebe+";"+cEmailGrpRh;             
				Cc cCopia;
				SUBJECT cAssunto;
				BODY cMsg1; 
 	            ATTACHMENT cfiles;
				RESULT lEnviado
			 
			
			 If lEnviado
				 // Alert("Envio de E-Mail com sucesso!")
			 Else
				cMensagem := ""
				 GET MAIL ERROR cMensagem
				 // Alert(cMensagem)
			 Endif
			
			
			DISCONNECT SMTP SERVER Result lDisConectou
			
			If lDisConectou
				// Alert("Desconectado com servidor de E-Mail - " + cServer)

			Endif
		Else
		   	Get MAIL ERROR cErro
			MsgAlert(cErro, "Erro durante o envio")
			Alert("Erro de conexao com servidor de e-mail "+cServidor)
		Endif

	
return 



Static Function TotalEntradas(cPTFilial,cPTProduto)
nEntradas := 0
cQuery := " SELECT D1_COD,SUM(D1_QUANT) TOTAL FROM "+RetSqlName("SD1")+" "
cQuery += " WHERE D1_COD = '"+cPTProduto+"' AND D1_FILIAL = '"+cPTFilial+"'  AND D_E_L_E_T_ = '' "
// cQuery += " AND ( RTRIM(D1_CF) = '1101' OR RTRIM(D1_CF) ='1102' )"
cQuery += " AND SUBSTRING(D1_DTDIGIT,1,4)='"+Alltrim(STR(YEAR(dDataBase)))+"'  " 
cQuery += " GROUP BY D1_COD "
TcQuery cQuery New Alias qEntradas

DbSelectArea("qEntradas")    
DbGotop()
If Eof()
  nEntradas := 0
  /*
  	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
			    SEND MAIL FROM cEnvia;
				TO "franciney@potencial.inf.br";
				SUBJECT "Query Entradas Total zero  ";
				BODY cQuery
				DISCONNECT SMTP SERVER Result lDisConectou
        Endif
  */
Else 
  nEntradas := qEntradas->TOTAL                    

Endif
DbSelectArea("qEntradas")    
DbCloseArea("qEntradas") 

Return(nEntradas) 

Static Function TotalBaixas(cPTFilial,cPTProduto)
nBaixas:= 0
cQuery := " SELECT D3_COD,SUM(D3_QUANT) TOTAL FROM "+RetSqlName("SD3")+" "
cQuery += " WHERE D3_COD = '"+cPTProduto+"' AND D3_FILIAL = '"+cPTFilial+"'  AND D_E_L_E_T_ = '' "
// cQuery += " AND ( RTRIM(D1_CF) = '1101' OR RTRIM(D1_CF) ='1102' )"
cQuery += " AND SUBSTRING(D3_EMISSAO,1,4)='"+Alltrim(STR(YEAR(dDataBase)))+"'  " 
cQuery += " GROUP BY D3_COD "
TcQuery cQuery New Alias qBaixas 

DbSelectArea("qBaixas")    
DbGotop()
If Eof()
  nBaixas := 0
  /*
  	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
			    SEND MAIL FROM cEnvia;
				TO "franciney@potencial.inf.br";
				SUBJECT "Query Baixas Total zero  ";
				BODY cQuery
				DISCONNECT SMTP SERVER Result lDisConectou
        Endif
  */
Else 
  nBaixas:= qBaixas->TOTAL                    
Endif
DbSelectArea("qBaixas")    
DbCloseArea("qBaixas") 
Return(nBaixas) 


Static Function TotalVendas(cPTFilial,cPTProduto)
nVendas := 0
cQuery := " SELECT D2_COD,SUM(D2_QUANT) TOTAL FROM "+RetSqlName("SD2")+" "
cQuery += " WHERE D2_COD = '"+cPTProduto+"' AND D2_FILIAL = '"+cPTFilial+"'  AND D_E_L_E_T_ = '' "
// cQuery += " AND ( RTRIM(D2_CF) = '5101' OR RTRIM(D2_CF) ='5102' )"
cQuery += " AND SUBSTRING(D2_EMISSAO,1,4)='"+Alltrim(STR(YEAR(dDataBase)))+"'  " 
cQuery += " GROUP BY D2_COD "
TcQuery cQuery New Alias qVendas
DbSelectArea("qVendas")    
DbGotop()
If Eof()
  nVendas := 0
  /*
  	    CONNECT SMTP SERVER cServidor ACCOUNT cConta PASSWORD cChave RESULT lConectou
		MAILAUTh(cConta,cChave) //caso servidor de email precisar de autenticação utilizar esta função
		If lConectou
			  //  Alert("Conectado com servidor de E-Mail - " + cServidor)
			    SEND MAIL FROM cEnvia;
				TO "franciney@potencial.inf.br";
				SUBJECT "Query Vendas Total zero  ";
				BODY cQuery
				DISCONNECT SMTP SERVER Result lDisConectou
        Endif
  */
Else 
  nVendas := qVendas->TOTAL                    
Endif
DbSelectArea("qVendas")    
DbCloseArea("qVendas") 
Return(nVendas) 



/*







*/




/*

cNomXLS := __RelDir + "Relacao.xls"

Copy To &cNomXLS VIA "DBFCDXADS"
__COPYFILE(cNomXLS,cFile+".xls")

If File(cNomXLS)
     DELETE FILE cNomXLS
Endif

XLS->(dbCloseArea())

Return



Postado Por: HSQUESADA 
Data Postagem: Tuesday, July 29, 2008 at 11:08 

Renato,
       a ideia é essa, porem como utilizo o ctree (DTC) quando uso o comando copy to ele faz a copia perfeitamente porem ao tentar abrir o excel, o mesmo abre cheio de caracteres invalidos.
       Ao postar a duvida, lendo o forum achei Copy To &cNomXLS VIA "DBFCDXADS, onde o VIA "DBFCDXADS, solucionou, acabei postando ja com a forma correta
mesmo assim obrigado!! 


Exemplo - RAZÃO ANALITICO CONTABIL - BASE CTREE.:
dbSelectArea("TRB")
Set Filter To
_cArquivo := __RELDIR+"RAZAO ANALITICO.XLS"
Copy to &_cArquivo VIA "DBFCDXADS"
dbCloseArea("TRB")
FErase(cArqTrab+GetDBExtension())
FErase(cArqTrab+OrdBagExt())

dbselectArea("CT2")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Carrega o Excel com o Arquivo Criado              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cPath      := AllTrim(GetTempPath())
CpyS2T( _cArquivo , cPath, .T. )
     
If ! ApOleClient( aspassimplesMsExcelaspassimples )
     MsgStop( "MsExcel nao instalado" )
     Return
EndIf
     
oExcelApp := MsExcel():New()
oExcelApp:WorkBooks:Open( cPath+"RAZAO ANALITICO.XLS" ) // Abre uma planilha
oExcelApp:SetVisible(.T.)
*/



