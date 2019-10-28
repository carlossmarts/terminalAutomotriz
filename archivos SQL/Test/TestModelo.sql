-- test abm modelo
use proyectoBD;
call altaModelo('Fiat',@msj,@val);
call altaModelo('Ford',@msj,@val);
call modificarModelo('Fiat','Mercedes Benz',@msj,@val);
call bajaModelo('Ford',@msj,@val);

call traerModelos();
select * from modelo;
select @msj, @val;