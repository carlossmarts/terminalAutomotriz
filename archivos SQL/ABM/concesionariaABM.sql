    -- ABM concesionaria
use proyectoBD;

/* ----------------------------------------------------------------------
					ABM concesionaria
-----------------------------------------------------------------------*/

-- existe concesionaria
drop function if exists existeConcesionaria;
delimiter //
CREATE function existeConcesionaria(
	_cuit varchar(15))
    returns int
begin
	set @retorno = (select count(*) from concesionaria c where c.cuit= _cuit);
    return @retorno;
end
//
delimiter ;

-- verificar eliminado
drop function if exists concesionariaEliminado;
delimiter //
CREATE function concesionariaEliminado(
	_cuit varchar(15))
    returns int
begin
	set @eliminado = (select eliminado from concesionaria where cuit= _cuit);
    return @eliminado;
end
//
delimiter ;

-- Traer Lista de concesionarias
drop procedure if exists traerConcesionarias;
delimiter //
CREATE PROCEDURE traerConcesionarias()
BEGIN
    select cuit from concesionaria where eliminado =0;
END 
//
delimiter ;

-- Agregar concesionaria
drop procedure if exists altaConcesionaria;
delimiter //
CREATE PROCEDURE altaConcesionaria(
	in _cuit varchar(15),
    out _msjRetorno varchar (45),
    out _valorRetorno int)
BEGIN
    -- si no existe lo agrego
	if existeConcesionaria(_cuit) <> 0 and concesionariaEliminado(_cuit) = 0 then
		select -1 into _valorRetorno;
        select 'error, ya existe concesionaria' into _msjRetorno;
	else
		if concesionariaEliminado (_cuit) = 1 then
			update concesionaria set eliminado = 0 where cuit = _cuit;
            update concesionaria set fechaEliminado = null where cuit = _cuit;
			select 0 into _valorRetorno;
            select 'concecionaria agregada nuevamente' into _msjRetorno;
		else
			insert into concesionaria(cuit) values (_cuit);
			select 0 into _valorRetorno;
            select 'concecionaria agregada' into _msjRetorno;
		end if;
	end if;
END 
//
delimiter ;


-- Eliminar concesionaria
drop procedure if exists bajaConcesionaria;
delimiter //
CREATE PROCEDURE bajaConcesionaria(
	in _cuit varchar(15),
	out _msjRetorno varchar(45),
    out _valorRetorno int)
BEGIN
	-- no eliminar si existen pedidos pendientes que correspondan a esa concesionaria
    set @existePedido = (select count(*) from pedido where cuitConcesionaria = _cuit and eliminado = 0);
    if concesionariaEliminado(_cuit) = 1 then
			select 'error, ya se encuentra eliminada' into _msjRetorno;
			select -1 into _valorRetorno;
	else 
		if @existePedido <> 0 then 
			select 'error, pedidos pendientes' into _msjRetorno;
			select -2 into _valorRetorno;
		else
			update concesionaria set eliminado = 1 where cuit= _cuit; 
			update concesionaria set fechaEliminado = (select now()) where cuit= _cuit;
            select 'error, pedidos pendientes' into _msjRetorno;
			select 0 into _valorRetorno;
		end if;
    end if;
END 
//
delimiter ;

-- Modificar concesionaria cuit
drop procedure if exists modificarConcesionaria;
delimiter //
CREATE PROCEDURE modificarconcesionaria(
	in _cuit varchar(15),
    in _nuevoCuit varchar(15),
    out _msjRetorno varchar (45),
    out _valorRetorno int)
BEGIN
	if existeConcesionaria(_cuit) = 0 then				-- verificar que no exista un concesionaria con el codigo que quiero asignar	
			select -3 into _valorRetorno;
            select 'error, no existe concesionaria con ese codigo' into _msjRetorno;
    else        
		if concesionariaEliminado(_cuit) <> 0 then				-- verificar que el concesionaria que quiero modificar no esté eliminado 
			select 'error, concesionaria eliminado' into _msjRetorno;
			select -1 into _valorRetorno;
			else
			if existeConcesionaria(_nuevoCuit) <> 0 then				-- verificar que no exista un concesionaria con el codigo que quiero asignar	
				select -1 into _valorRetorno;
				select 'error, ya existe concesionaria con ese codigo' into _msjRetorno;
			else
				update concesionaria set cuit= _nuevoCuit where cuit= _cuit;
				select 0 into _valorRetorno;
				select 'concesionaria modificada' into _msjRetorno;
			end if;
         end if;   
    end if;
END 
//
delimiter ;