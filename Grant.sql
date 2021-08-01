use nova_clinica_esmeralda;

CREATE ROLE 'medico', 'tecnico', 'secretaria';

GRANT SELECT,UPDATE ON consulta TO 'medico';

GRANT SELECT ON consulta TO 'secretaria';

GRANT SELECT,UPDATE ON horario TO 'medico', 'tecnico';

GRANT SELECT ON horario TO 'secretaria';

GRANT INSERT, UPDATE, SELECT, DELETE ON tratamento TO 'medico';

GRANT SELECT ON tratamento TO 'secretaria';

GRANT INSERT, UPDATE, SELECT, DELETE ON tipo_tratamento TO 'medico';

GRANT SELECT ON tipo_tratamento TO 'secretaria';

GRANT INSERT, UPDATE, SELECT, DELETE ON procedimento TO 'medico';

GRANT UPDATE, SELECT ON procedimento TO 'tecnico';

GRANT SELECT ON procedimento TO 'secretaria';

GRANT INSERT, UPDATE, SELECT, DELETE ON med_realiza_procedimento TO 'medico';

GRANT INSERT, UPDATE, SELECT, DELETE ON assistido_por TO 'tecnico';

GRANT INSERT, UPDATE, SELECT, DELETE ON agendamento TO 'secretaria';

CREATE USER medico@localhost IDENTIFIED BY '0101';
CREATE USER tecnico@localhost IDENTIFIED BY '0102';
CREATE USER secretaria@localhost IDENTIFIED BY '0103';

GRANT 'medico' TO medico@localhost;

GRANT 'tecnico' TO tecnico@localhost;

GRANT 'secretaria' TO secretaria@localhost;









