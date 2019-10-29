/*					INDICES
-----------------------------------------------------------------------*/
/*14) Teniendo en cuenta las consultas anteriores construir algún índice que pueda
facilitar la lectura de los datos.*/

use proyectoBD;

CREATE INDEX index_idModelo ON automovil (idModelo); 
CREATE INDEX index_idPedidoModelo ON automovil (idPedido, idModelo);

select * from automovil use index (index_idModelo)
    ORDER BY (idModelo);
    
select * from automovil use index (index_idPedidoModelo)
	WHERE idPedido=1 AND idModelo=1;
    
CREATE INDEX index_idModelo ON lineaDeMontaje (idModelo);
    
select * from lineaDeMontaje  use index (index_idModelo)
	WHERE idModelo=1;
    
CREATE INDEX index_fechaCuit ON pedido (fechaHora, cuitConcesionaria);

select * from pedido use index (index_fechaCuit)
	WHERE fechaHora = '2019-10-28 22:08:57' order by cuitConcesionaria;