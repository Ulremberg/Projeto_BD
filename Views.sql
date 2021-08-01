use nova_clinica_esmeralda;
	
DELIMITER $$
CREATE VIEW vw_resumidoTratamento AS
SELECT T.cpf_paciente, M.cpf_dentista, T.id_tratamento,T.status_tratamento,Po.tipo_procedimento
FROM tratamento T, paciente P, medico_dentista M, procedimento Po
WHERE 
	T.cpf_paciente = P.cpf_paciente AND	
    M.cpf_dentista = Po.cpf_dentista AND
    Po.id_tratamento = T.id_tratamento AND
    T.data_inicio > '2018-01-01' AND
    T.data_inicio < '2018-06-01';
END $$
DELIMITER ; 

DELIMITER $$
CREATE VIEW vw_GeralProdutosCir AS
SELECT PMC.cod_procedimento, Po.cpf_dentista, F.cnpj_filial, ITS.tipo
FROM medico_dentista M, procedimento Po, pedido_material_cir PMC,
tratamento T, filial F, ordem_compra OC, item_produto IP, item_solicitado ITS
WHERE 
	PMC.cod_procedimento = Po.cod_procedimento AND	
    M.cpf_dentista = Po.cpf_dentista AND
    Po.id_tratamento = T.id_tratamento AND
    OC.cod_compra = IP.cod_ordem_compra AND
    F.cnpj_filial = OC.cnpj_filial AND
    PMC.codigo_pedido_material_cir = ITS.codigo_pedido_material_cir AND
    PMC.data_pedido > '2018-01-01' AND
    PMC.data_pedido < '2018-08-01';
END $$
DELIMITER ; 



DELIMITER $$
CREATE VIEW StatusProcedimentosMedico AS
SELECT MP.`cod_procedimento`, MP.`cpf_dentista`, P.`status_procedimento`, P.`tipo_procedimento`
FROM (`med_realiza_procedimento` MP , `procedimento` P)
INNER JOIN `med_realiza_procedimento`
ON (MP.`cod_procedimento` = P.`cod_procedimento`)
AND (MP.`cpf_dentista` = P.`cpf_dentista`);
END
DELIMITER; $$

CREATE PROCEDURE sp_Tratamento (IN `data1` date, IN `data2` date)
BEGIN
SELECT T.cpf_paciente, M.cpf_dentista, T.id_tratamento,T.status_tratamento,Po.tipo_procedimento
FROM tratamento T, paciente P, medico_dentista M, procedimento Po
WHERE 
	T.cpf_paciente = P.cpf_paciente AND	
    M.cpf_dentista = Po.cpf_dentista AND
    Po.id_tratamento = T.id_tratamento AND
    T.data_inicio > `data1` AND
    T.data_inicio < `data2`;
END $$


DELIMITER $$
CREATE PROCEDURE sp_ProdutosCir (IN `data1` date)
BEGIN
SELECT PMC.cod_procedimento, Po.cod_procedimento, Po.cpf_dentista, M.cpf_dentista
FROM medico_dentista M, procedimento Po, pedido_material_cir PMC
WHERE 
	PMC.cod_procedimento = Po.cod_procedimento AND	
    M.cpf_dentista = Po.cpf_dentista AND
    Po.data_inicio = `data1`;
END $$


DELIMITER $$
CREATE VIEW IdadePacientes AS
SELECT P.nome, P.`data_Nascimento`, 
          Cast(NOW() as date) as Hoje, 
          TIMESTAMPDIFF(YEAR, P.`data_Nascimento`, NOW()) as idade
     FROM paciente Pa 
    INNER JOIN `pessoa` P ON (Pa.`cpf_paciente` = P.`cpf`);
	
END
DELIMITER; $$