1.

DELIMITER $$
CREATE procedure alineaA()
BEGIN
	START transaction ;
	BEGIN
    DECLARE done BOOLEAN default 0;
    DECLARE id_cliente INT;
    
    DECLARE cur1 CURSOR FOR 
		SELECT C.numero from cliente AS C
        INNER JOIN venda ON C.numero=V.cliente
        WHERE V.total > 60 AND DATEDIFF(Now(),V.data) < 3000;
        
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
        
        OPEN cur1;
			read_loop : LOOP
				FETCH cur1 INTO id_cliente;
                IF done then 
					LEAVE read_loop;
				END IF;
                INSERT INTO clientecupões(cliente, nrcupao, tipo, desconto) 
                values (id_cliente,15, "Promoção Especial", '15');
			END LOOP;
		CLOSE cur1;
		COMMIT;
		END;
END
$$