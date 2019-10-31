use proyectoBD;

call continuarMontaje(10,@m,@v); -- auto no procesado

call continuarMontaje(1,@m,@v);
call continuarMontaje(2,@m,@v);

select @m, @v;

select * from automovilxestacion where idLineaDeMontaje = 1;
select idLineaDeMontaje, idTarea, ocupado from estacionDeTrabajo  where idLineaDeMontaje = 1  order by idTarea;
