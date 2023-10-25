/*EX 1*/

DELIMITER //
CREATE TRIGGER InsereCliente AFTER INSERT ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Novo cliente inserido em ', NOW()));
END;
//
DELIMITER ;

/*EX 2*/

DELIMITER //
CREATE TRIGGER TentativaCliente BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem) VALUES (CONCAT('Tentativa de exclusão por meio do cliente ', OLD.nome, ' em ', NOW()));
END;
//
DELIMITER ;

/*EX 3*/

DELIMITER $$

CREATE TRIGGER NovoNome
AFTER UPDATE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO Auditoria (mensagem)
    VALUES (CONCAT('Nome antigo: ', OLD.nome, ' - Novo nome: ', NEW.nome, ' - Data e hora da atualização: ', NOW()));
END;
$$

DELIMITER ;
 
/*EX 4*/

CREATE TRIGGER `NomeNaoVazio` BEFORE UPDATE ON `Clientes` FOR EACH ROW
BEGIN
    IF NEW.nome = '' OR NEW.nome IS NULL THEN
        INSERT INTO `Auditoria` (mensagem) VALUES ('Erro ao atualizar nome do cliente. O nome não pode ser vazio ou NULL.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro ao atualizar nome do cliente. O nome não pode ser vazio ou NULL.';
    END IF;
END;


/* EX 5*/

CREATE TRIGGER `atualiza_estoque` AFTER INSERT ON `Pedidos`
FOR EACH ROW
BEGIN

  UPDATE `Produtos`
  SET `estoque` = `estoque` - `NEW`.`quantidade`
  WHERE `id` = `NEW`.`produto_id`;

  IF `NEW`.`quantidade` > `Produtos`.`estoque` THEN
    INSERT INTO `Auditoria` (mensagem)
    VALUES ('Estoque baixo para o produto ' + CAST(`NEW`.`produto_id` AS VARCHAR(255)) + '. Estoque atual: ' + CAST(`Produtos`.`estoque` AS VARCHAR(255)));
  END IF;

END;

