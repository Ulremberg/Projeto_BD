SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

CREATE SCHEMA IF NOT EXISTS `nova_clinica_esmeralda` DEFAULT CHARACTER SET utf8 ;
USE `nova_clinica_esmeralda` ;

 CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`pessoa` (
  `cpf` INT(11) NOT NULL,
  `rg` INT(11) NOT NULL,
  `nome` VARCHAR(200) NOT NULL,
  `data_Nascimento` DATE NOT NULL,
  `sexo` SET('masculino','feminino') NOT NULL,
  `tipo_sanguineo`SET('A+','A-','B+','B-','AB+','AB-','O+','O-') NOT NULL,
  `num_rua` VARCHAR(200) NULL DEFAULT NULL,
  `apto` VARCHAR(10) NULL DEFAULT NULL,
  `cep` VARCHAR(9) NULL DEFAULT NULL,
  `email` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`cpf`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`filial` (
`cnpj_filial` INT(14) NOT NULL,
	`edificio` VARCHAR(200) NOT NULL,
	`numero` INT(11) NOT NULL,
	`data_abertura` DATE NOT NULL,
	`cep` VARCHAR(9) NOT NULL,
	`telefone` VARCHAR(45) NOT NULL,
	`e-mail` VARCHAR(200) NOT NULL,
	PRIMARY KEY (`cnpj_filial`))  
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`ordem_compra`(
	`cod_compra` INT(11) NOT NULL AUTO_INCREMENT,
    `descricao` VARCHAR(200) NOT NULL,
    `total_consolidado` DECIMAL NOT NULL,
    `foi_cancelada` SET('sim','nao'),
    `cnpj_filial` INT(14) NOT NULL,
    `dt_realizada` DATE NOT NULL,
    PRIMARY KEY(`cod_compra`),
    FOREIGN KEY(`cnpj_filial`)
    REFERENCES `nova_clinica_esmeralda`. `filial` (`cnpj_filial`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`item_produto`(
	`num_lote` INT(11) NOT NULL AUTO_INCREMENT,
    `cod_ordem_compra`INT(11) NOT NULL,
    `qtd_solicitada` INT(11) NOT NULL,
    PRIMARY KEY(`num_lote`),
   FOREIGN KEY(`cod_ordem_compra`)
   REFERENCES `nova_clinica_esmeralda`. `ordem_compra` (`cod_compra`)
   ON DELETE NO ACTION
   ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`tipo_produto`(
	`cod_tipo_produto` INT(11) NOT NULL AUTO_INCREMENT,
    `descricao` VARCHAR(200) NOT NULL,
    PRIMARY KEY (`cod_tipo_produto`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`produto`(
	`cod_produto`INT(11) NOT NULL AUTO_INCREMENT,
    `codigo_barra`INT(11) NOT NULL,
    `descricao`VARCHAR(200) NOT NULL,
    `fabricante` VARCHAR(200) NOT NULL,
    `valor_unitario`DECIMAL NOT NULL,
    `tipo_unidade` VARCHAR(200) NOT NULL,
    `qtd_minima` INT(11) NOT NULL,
    `num_lote` INT(11) NOT NULL, 
    `cod_tipo_produto`INT(11) NOT NULL,
    PRIMARY KEY(`cod_produto`),
    FOREIGN KEY(`num_lote`)
    REFERENCES `nova_clinica_esmeralda`. `item_produto` (`num_lote`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY(`cod_tipo_produto`)
    REFERENCES `nova_clinica_esmeralda`. `tipo_produto` (`cod_tipo_produto`)
	ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;
    
CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`instancia_produto_estoque`(
	`id_instancia`INT(11) NOT NULL AUTO_INCREMENT,
    `data_fabricacao`DATE NOT NULL,
    `qtd_atual`INT(11) NOT NULL,
    `data_validade` DATE NOT NULL,
    `cod_produto`INT(11) NOT NULL,    
    PRIMARY KEY(`id_instancia`),
    FOREIGN KEY(`cod_produto`)
    REFERENCES `nova_clinica_esmeralda`. `produto` (`cod_produto`)    
	ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;    

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`paciente`(
  `cpf_paciente` INT(11) NOT NULL,
  `em_tratamento` SET('sim','nao') NOT NULL,
  `idade` SMALLINT(10) DEFAULT NULL,
  PRIMARY KEY(`cpf_paciente`),  
  FOREIGN KEY (`cpf_paciente`)
  REFERENCES `nova_clinica_esmeralda`.`pessoa` (`cpf`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`medico_dentista` (
  `cpf_dentista` INT(11) NOT NULL,
  `num_carteira_trab` INT(11) NOT NULL,
 `dt_admissao` DATE NULL DEFAULT NULL,
 `cfo` VARCHAR(500) NULL DEFAULT NULL,
 `especialidade` VARCHAR(500) NULL DEFAULT NULL,
	PRIMARY KEY(cpf_dentista),
    FOREIGN KEY (`cpf_dentista`)
    REFERENCES `nova_clinica_esmeralda`.`pessoa` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`secretaria` (
  `cpf_secretaria` INT(11) NOT NULL,
  `num_carteira_trab` INT(11) NOT NULL,
 `dt_admissao` DATE NULL DEFAULT NULL,
	PRIMARY KEY(cpf_secretaria),
    FOREIGN KEY (`cpf_secretaria`)
    REFERENCES `nova_clinica_esmeralda`.`pessoa` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`tec_saude_bucal`(
	`cpf_tec` INT(11) NOT NULL,
    `num_carteira_trab` INT(11) NOT NULL,
	`dt_admissao` DATE NULL DEFAULT NULL,
    `diploma_ens_medio` VARCHAR(200) NOT NULL,
    `dt_diploma` DATE NOT NULL,
	PRIMARY KEY(cpf_tec),
    FOREIGN KEY (`cpf_tec`)
    REFERENCES `nova_clinica_esmeralda`.`pessoa` (`cpf`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`consulta` (
 `cpf_paciente` INT(11) NOT NULL,
  `cpf_dentista` INT(11) NOT NULL,
  `data_consulta` DATE NOT NULL,
  PRIMARY KEY (`cpf_paciente`, `cpf_dentista`,`data_consulta`),
  UNIQUE KEY `cpf_paciente`(`cpf_paciente`,`cpf_dentista`),
  INDEX `fk_consultas_has_pacientes_pacientes1_idx` (`cpf_paciente` ASC) ,
  INDEX `fk_consultas_has_dentistas_dentistas1_idx` (`cpf_dentista` ASC) ,
  CONSTRAINT `fk_consultas_has_pacientes_pacientes1`
    FOREIGN KEY (`cpf_paciente`)
    REFERENCES `nova_clinica_esmeralda`.`paciente` (`cpf_paciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_consultas_has_dentistas_dentistas1`
    FOREIGN KEY (`cpf_dentista`)
    REFERENCES `nova_clinica_esmeralda`.`medico_dentista` (`cpf_dentista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`horario`(
	`cod_horario` INT(20) NOT NULL,
    `hora_inicio` TIME NOT NULL,
    `hora_fim` TIME NOT NULL,
    `descrição` VARCHAR(200) NOT NULL,
    PRIMARY KEY(`cod_horario`),
    UNIQUE INDEX `inicio` (`hora_inicio`),
    UNIQUE INDEX `fim` (`hora_fim`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`tecsaude_possui_horario`(
	`cpf_tec` INT(11) NOT NULL,
    `cod_horario` INT(20) NOT NULL,
    PRIMARY KEY (`cpf_tec`, `cod_horario`),
  INDEX `fk_tecsaude_has_cpftec_cpftec1_idx` (`cpf_tec` ASC) ,
  INDEX `fk_tecsaude_has_horarios_horarios1_idx` (`cod_horario` ASC) ,
  CONSTRAINT `fk_tecsaude_has_cpftec_cpftec1` 
    FOREIGN KEY (`cpf_tec`)
    REFERENCES `nova_clinica_esmeralda`.`tec_saude_bucal` (`cpf_tec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tecsaude_has_horarios_horarios1`
    FOREIGN KEY (`cod_horario`)
    REFERENCES `nova_clinica_esmeralda`.`horario` (`cod_horario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`agendamento` (
  `cpf_secretaria` INT(11) NOT NULL,
  `cpf_paciente` INT(11) NOT NULL, 
  `cpf_dentista` INT(11) NOT NULL,
  `data_agendamento` DATETIME NOT NULL,
  `hora_agendamento` TIME NOT NULL, 
  `status_agendamento`SET('confirmado','aguardando') NOT NULL,
  PRIMARY KEY (`cpf_secretaria`,`cpf_paciente`,`cpf_dentista`,`data_agendamento`,`hora_agendamento`),   
    FOREIGN KEY (`cpf_secretaria`)
    REFERENCES `nova_clinica_esmeralda`.`secretaria` (`cpf_secretaria`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`cpf_paciente`)
    REFERENCES `nova_clinica_esmeralda`.`paciente` (`cpf_paciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`cpf_dentista`)
    REFERENCES `nova_clinica_esmeralda`.`medico_dentista` (`cpf_dentista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`tipo_tratamento` (
  `cod_tratamento` INT(11) NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (`cod_tratamento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`tratamento` (
  `id_tratamento` INT(11) NOT NULL AUTO_INCREMENT,
  `status_tratamento`SET('autorizado','em_analise') NOT NULL,
  `observacao` VARCHAR(200) NOT NULL,
  `motivo` VARCHAR(200) NOT NULL,
  `data_inicio` DATE NULL DEFAULT NULL,
  `data_final` DATE NULL DEFAULT NULL,
  `cpf_paciente` INT(11) NOT NULL, 
  `cpf_dentista` INT(11) NOT NULL,
  `cod_tratamento` INT(6) NOT NULL,
  PRIMARY KEY (`id_tratamento`),
   FOREIGN KEY (`cod_tratamento`)
    REFERENCES `nova_clinica_esmeralda`.`tipo_tratamento` (`cod_tratamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   FOREIGN KEY (`cpf_paciente`)
    REFERENCES `nova_clinica_esmeralda`.`paciente` (`cpf_paciente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`cpf_dentista`)
    REFERENCES `nova_clinica_esmeralda`.`medico_dentista` (`cpf_dentista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`procedimento` (
  `cod_procedimento` INT(11) NOT NULL AUTO_INCREMENT,
  `status_procedimento`SET('autorizado','em_analise') NOT NULL,
  `tipo_procedimento` SET('normal','cirurgico') NOT NULL,
  `data_procedimento` DATE NULL DEFAULT NULL,
  `cpf_tecnico` INT(11) NOT NULL, 
  `cpf_dentista` INT(11) NOT NULL,
  `id_tratamento` INT(11) NOT NULL,
  PRIMARY KEY (`cod_procedimento`),
   FOREIGN KEY (`id_tratamento`)
    REFERENCES `nova_clinica_esmeralda`.`tratamento` (`id_tratamento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
   FOREIGN KEY (`cpf_tecnico`)
    REFERENCES `nova_clinica_esmeralda`.`tec_saude_bucal` (`cpf_tec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`cpf_dentista`)
    REFERENCES `nova_clinica_esmeralda`.`medico_dentista` (`cpf_dentista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`pedido_material_cir` (
  `codigo_pedido_material_cir` INT(11) NOT NULL AUTO_INCREMENT,
  `status_pedido`SET('autorizado','em_analise') NOT NULL, 
  `data_pedido` DATE NULL DEFAULT NULL,
  `cod_procedimento`INT(11) NOT NULL,
  PRIMARY KEY (`codigo_pedido_material_cir`),
   FOREIGN KEY (`cod_procedimento`)
    REFERENCES `nova_clinica_esmeralda`.`procedimento` (`cod_procedimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`item_solicitado` (
  `cod_produto`INT(11) NOT NULL, 
  `codigo_pedido_material_cir` INT(11) NOT NULL,
  `quantidade` INT(11) NOT NULL,
  `tipo` VARCHAR(200) NOT NULL,    
    PRIMARY KEY(`cod_produto`, `codigo_pedido_material_cir`),
    FOREIGN KEY(`cod_produto`)
    REFERENCES `nova_clinica_esmeralda`. `produto` (`cod_produto`),
    FOREIGN KEY(`codigo_pedido_material_cir`)
    REFERENCES `nova_clinica_esmeralda`. `pedido_material_cir` (`codigo_pedido_material_cir`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`med_realiza_procedimento` (  
  `cpf_dentista` INT(11) NOT NULL,
  `cod_procedimento` INT(11) NOT NULL,
  PRIMARY KEY (`cpf_dentista`,`cod_procedimento`),    
    FOREIGN KEY (`cpf_dentista`)
    REFERENCES `nova_clinica_esmeralda`.`medico_dentista` (`cpf_dentista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`cod_procedimento`)
    REFERENCES `nova_clinica_esmeralda`.`procedimento` (`cod_procedimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`assistido_por` (  
  `cpf_tec` INT(11) NOT NULL,
  `cod_procedimento` INT(11) NOT NULL,
  PRIMARY KEY (`cpf_tec`,`cod_procedimento`),    
    FOREIGN KEY (`cpf_tec`)
    REFERENCES `nova_clinica_esmeralda`.`tec_saude_bucal` (`cpf_tec`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    FOREIGN KEY (`cod_procedimento`)
    REFERENCES `nova_clinica_esmeralda`.`procedimento` (`cod_procedimento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

CREATE TABLE IF NOT EXISTS `nova_clinica_esmeralda`.`med_possui_horario` (  
  `cpf_dentista` INT(11) NOT NULL,
  `cod_horario` INT(20) NOT NULL,
  PRIMARY KEY (`cpf_dentista`, `cod_horario`),
  INDEX `fk_dentista_has_cpfdentista_cpfdentista1_idx` (`cpf_dentista` ASC) ,
  INDEX `fk_tecsaude_has_horarios_horarios2_idx` (`cod_horario` ASC) ,
  CONSTRAINT `fk_dentista_has_cpfdentista_cpfdentista1` 
    FOREIGN KEY (`cpf_dentista`)
    REFERENCES `nova_clinica_esmeralda`.`medico_dentista` (`cpf_dentista`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tecsaude_has_horarios_horarios2`
    FOREIGN KEY (`cod_horario`)
    REFERENCES `nova_clinica_esmeralda`.`horario` (`cod_horario`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
