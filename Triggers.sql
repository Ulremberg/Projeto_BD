use nova_clinica_esmeralda;
drop TRIGGER IF EXISTS tg_calcularIdadePaciente;
drop TRIGGER IF EXISTS tg_atualizarQtdProduto ;

DELIMITER $$
CREATE TRIGGER tg_atualizarQtdProduto 
BEFORE UPDATE ON produto
FOR EACH ROW
BEGIN
	DECLARE qtd INT DEFAULT 50;
	UPDATE instancia_produto_estoque set qtd_atual = (qtd_atual + qtd)
    WHERE (instancia_produto_estoque.cod_produto = new.cod_produto); 

END; $$

DELIMITER $$
CREATE TRIGGER tg_calcularIdadePaciente 
BEFORE INSERT ON paciente
FOR EACH ROW
BEGIN	
    DECLARE aniver DATE;
    DECLARE cpf_paciente1 int;
    SELECT new.cpf_paciente INTO cpf_paciente1;
    SELECT pessoa.data_Nascimento into aniver FROM pessoa WHERE cpf = cpf_paciente1;    
	SET new.idade = TIMESTAMPDIFF(YEAR, aniver, NOW());     
END; $$


