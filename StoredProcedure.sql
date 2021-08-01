use nova_clinica_esmeralda;

DROP PROCEDURE IF EXISTS sp_horarioTecnicoAuxiliarMedico;
DROP PROCEDURE IF EXISTS sp_horarioTecnicoAuxiliarMedico1;
DROP PROCEDURE IF EXISTS sp_horarioTecnicoAuxiliarMedico2;
DROP PROCEDURE IF EXISTS sp_horarioTecnicoAuxiliarMedico3;
DROP PROCEDURE IF EXISTS sp_gerarOrdem;
DROP PROCEDURE IF EXISTS sp_gerarOrdemLoop;
DROP PROCEDURE IF EXISTS sp_gerarOrdemSemCursor;


DELIMITER $$
CREATE PROCEDURE sp_horarioTecnicoAuxiliarMedico(horarioChecar Time)
BEGIN
	select cpf from pessoa where cpf is not null and cpf in 
   (select cpf_tec from tecsaude_possui_horario ts inner join horario h on ts.cod_horario = h.cod_horario
    where h.hora_inicio < horarioChecar  AND h.hora_fim > horarioChecar);
END$$

DELIMITER $$
CREATE PROCEDURE sp_horarioTecnicoAuxiliarMedico1 (horarioChecar Time)
BEGIN
	select cpf_tec from tecsaude_possui_horario ts inner join horario h on ts.cod_horario = h.cod_horario
    where h.hora_inicio < horarioChecar  AND h.hora_fim > horarioChecar;
END$$

DELIMITER $$
CREATE PROCEDURE sp_horarioTecnicoAuxiliarMedico2 (horarioChecar DATETIME)
BEGIN
	DECLARE hora INT;
    set hora = TIME(horarioChecar);
	select cpf_tec, cpf_dentista from tecsaude_possui_horario ts inner join horario h on ts.cod_horario = h.cod_horario inner join med_possui_horario md on md.cod_horario = h.cod_horario
    where h.hora_inicio < hora  AND h.hora_fim > hora;
END$$

DELIMITER $$
CREATE PROCEDURE sp_horarioTecnicoAuxiliarMedico3 (horarioChecar DATETIME)
BEGIN
	DECLARE hora INT;
    set hora = TIME(horarioChecar);
	select cpf_tec from tecsaude_possui_horario ts inner join horario h on ts.cod_horario = h.cod_horario 
    where h.hora_inicio < hora  AND h.hora_fim > hora;
END$$

DELIMITER $$
CREATE PROCEDURE sp_gerarOrdem()
BEGIN
	DECLARE contador INT DEFAULT 0;
    DECLARE quantidadeMinima INT DEFAULT 0;
    DECLARE quantidadeAtual INT DEFAULT 0;
    DECLARE codigoProduto INT DEFAULT 0;
    DECLARE cnpj VARCHAR(200);
    DECLARE descricaoProduto VARCHAR(200); 
    DECLARE total INT;
    DECLARE done BOOLEAN;
    DECLARE curs CURSOR FOR SELECT  P.cod_produto, P.descricao, P.qtd_minima, IP.qtd_atual, F.cnpj_filial  from produto P inner join instancia_produto_estoque as IP
    on P.cod_produto = IP.cod_produto  
    inner join item_produto IPP on P.num_lote = IPP.num_lote
    inner join ordem_compra OP on IPP.cod_ordem_compra = OP.cod_compra
    inner join filial F on OP.cnpj_filial = F.cnpj_filial WHERE IP.qtd_atual < P.qtd_minima;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;  
	OPEN curs;  
	WHILE (contador != 3 or done != true)DO
		FETCH curs INTO codigoProduto, descricaoProduto, quantidadeMinima, quantidadeAtual, cnpj;
        SET total = 0;
        IF quantidadeAtual < quantidadeMinima         
         THEN SET contador = contador + 1;
			  SET total = quantidadeMinima + quantidadeAtual;
              INSERT INTO ordem_compra VALUES(NULL, descricaoProduto,total,'nao', cnpj, CURDATE());
        END IF;        
    END WHILE;
	CLOSE curs;    
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_gerarOrdemLoop()
BEGIN
	DECLARE contador INT DEFAULT 0;
    DECLARE quantidadeMinima INT DEFAULT 0;
    DECLARE quantidadeAtual INT DEFAULT 0;
    DECLARE codigoProduto INT DEFAULT 0;
    DECLARE cnpj VARCHAR(200);
    DECLARE descricaoProduto VARCHAR(200); 
    DECLARE total INT;
    DECLARE done BOOLEAN;
    DECLARE curs CURSOR FOR SELECT  P.cod_produto, P.descricao, P.qtd_minima, IP.qtd_atual, F.cnpj_filial  from produto P inner join instancia_produto_estoque as IP
    on P.cod_produto = IP.cod_produto  
    inner join item_produto IPP on P.num_lote = IPP.num_lote
    inner join ordem_compra OP on IPP.cod_ordem_compra = OP.cod_compra
    inner join filial F on OP.cnpj_filial = F.cnpj_filial WHERE IP.qtd_atual < P.qtd_minima;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;  
	OPEN curs;  
	my_Loop: LOOP
		FETCH curs INTO codigoProduto, descricaoProduto, quantidadeMinima, quantidadeAtual, cnpj;
        SET total = 0;
        IF done THEN LEAVE my_Loop; 
        END IF;
        IF contador = 3 THEN LEAVE my_Loop; 
        END IF;
        IF quantidadeAtual < quantidadeMinima         
         THEN SET contador = contador + 1;
			  SET total = quantidadeMinima + quantidadeAtual;
              INSERT INTO ordem_compra VALUES(NULL, descricaoProduto,total,'nao', cnpj, CURDATE());
        END IF;        
    END LOOP;
	CLOSE curs;    
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE sp_gerarOrdemSemCursor()
BEGIN
	INSERT INTO ordem_compra
        (descricao, total_consolidado, foi_cancelada,
         cnpj_filial, dt_realizada)
    SELECT  P.descricao,
             P.qtd_minima + IP.qtd_atual,
            'nao',
            F.cnpj_filial,
            CURDATE()
            from produto P inner join instancia_produto_estoque as IP
			on P.cod_produto = IP.cod_produto  
			inner join item_produto IPP on P.num_lote = IPP.num_lote
			inner join ordem_compra OP on IPP.cod_ordem_compra = OP.cod_compra
			inner join filial F on OP.cnpj_filial = F.cnpj_filial
			WHERE IP.qtd_atual < P.qtd_minima
			LIMIT 3;
END$$
DELIMITER ;