/*					INDICES
-----------------------------------------------------------------------*/
/*14) Teniendo en cuenta las consultas anteriores construir algún índice que pueda
facilitar la lectura de los datos.*/

use proyectoBD;

/* REPORTE 11 */

CREATE INDEX index_idPedido ON automovil (idPedido); 
CREATE INDEX index_fechaPedido ON automovil (idPedido, fechaTerminado);
CREATE INDEX index_hora ON automovilxestacion (horaIngreso);

/* REPORTE 12 */

CREATE INDEX index_idLineaDeMontaje ON insumoXestacion (idLineaDeMontaje); 
CREATE INDEX index_codigoLineaDeMontaje ON insumoXestacion (codigoInsumo, idLineaDeMontaje);