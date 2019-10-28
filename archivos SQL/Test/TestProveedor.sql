-- carga de datos de prueba
use proyectoBD;
-- abm proveedor
call altaProveedor('12-345679-0', 'pintureria', @msj, @val);
call modificarCuitProveedor('12-345679-0','123',@msj,@val);
call modificarNombreProveedor('12-345679-0','carlos',@msj,@val);
call modificarNombreProveedor('123','carlos',@msj,@val);
call bajaProveedor('asd',@msj,@val);
call bajaProveedor('123',@msj,@val);
call bajaProveedor('12-345679-0',@msj,@val);
select @msj, @val;
select * from proveedor;
call traerProveedores;

