use proyectoBD;
drop procedure if exists procesarPedido;
DELIMITER $$
CREATE PROCEDURE `procesarPedido`(
	in _codigoPedido int,
    out _msjRetorno varchar(45),
    out _valorRetorno int
    )
BEGIN
	-- variable para el handler del cursor
		DECLARE finished INTEGER DEFAULT 0; 
	-- modelo de auto, se usa al crear auto
		DECLARE modelo INTEGER DEFAULT 0;
	-- total de autos de un modelo, se usa en el loop adentro del cursor
		DECLARE total INTEGER DEFAULT 0; 
	-- indice del loop que genera varios autos de un modelo
		DECLARE x INTEGER DEFAULT 0; 
		
		-- declaramos cursor para detalles de pedido
		DECLARE cursorAuto 
			CURSOR FOR 
			select idModelo, cantidad from detallePedido where idPedido=_codigoPedido;
				-- selecciona todos los detalles del pedido X
	 
		-- declaramos el handler de not found
		DECLARE CONTINUE HANDLER 
			FOR NOT FOUND SET finished = 1;
	
    set @existeAuto = (select count(*) from automovil where idPedido = _codigoPedido);
    
    if @existeAuto <> 0 then
		select -1 into _valorRetorno;
        select 'error, el pedido ya fue procesado' into _msjRetorno;
	else
		OPEN cursorAuto;
		crearAuto: LOOP
			FETCH cursorAuto INTO modelo, total;
			
		   /* IF cursorAuto = NULL then
			set _valorRetorno = 1;
			select 'Problemas' into _msjRetorno;
			end if;
			*/
			
			IF finished = 0 THEN 
				SET x= 0;
				select 0 into _valorRetorno;
                select 'pedido Procesado' into _msjRetorno;
				crearVariosAutos: LOOP
				-- Este loop es para generar todos los autos de cada detalle
					-- aca creamos los autos nuevos con la data del pedido
					insert into automovil (idModelo, idPedido) values (modelo, _codigoPedido);
					Set x = x + 1;
					IF (x <> total) then
					Iterate crearVariosAutos;
					END IF;
				Leave crearVariosAutos;
				END LOOP crearVariosAutos;
			else  
				LEAVE crearAuto;
			END IF;

		END LOOP crearAuto;
		CLOSE cursorAuto;
	end if;
END$$
DELIMITER ;
