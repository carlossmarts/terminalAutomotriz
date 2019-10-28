-- test abm insumo e insumoXproveedor

use proyectoBD;
call altaInsumo(1,'pintura',@msj,@val);
call altaInsumo(2,'vidrio',@msj,@val);
call modificarCodigoInsumo(1,3,@msj,@val);
call modificarDescripcionInsumo(3,'focos',@msj,@val);
call bajaInsumo(2,@msj,@val);

call traerInsumos;
select * from insumo;
select * from proveedor;
select @msj, @val;



call altaInsumoXproveedor(1,'12-345679-0',123,@m,@v);
select * from insumoXproveedor;
select @m, @v;