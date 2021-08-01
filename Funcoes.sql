use nova_clinica_esmeralda;

DROP FUNCTION IF EXISTS fn_ttQtdProduto;
DROP FUNCTION IF EXISTS fn_quantidadeProduto;

DELIMITER $$
CREATE FUNCTION fn_quantidadeProduto (codigoPro int) RETURNS int
BEGIN
    	DECLARE quantidade int;
		SELECT qtd_atual INTO quantidade
		FROM instancia_produto_estoque IPE
        WHERE codigoPro = IPE.cod_produto;         
		return quantidade;
END; $$


DELIMITER $$
CREATE FUNCTION fn_attQtdProduto (codigo int, quantidade int) RETURNS boolean

BEGIN
	DECLARE realizado boolean default true;
  IF ( SELECT NOT EXISTS ( SELECT * FROM produto
	WHERE produto.cod_produto = codigo))
    THEN
    SET realizado = false;
	return realizado;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'O produto não existe';		
  END IF;
  UPDATE instancia_produto_estoque SET qtd_atual = qtd_atual + quantidade
  WHERE instancia_produto_estoque.cod_produto = codigo; 
  return realizado;
END$$
