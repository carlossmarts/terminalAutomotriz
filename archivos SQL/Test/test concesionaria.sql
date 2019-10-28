
use proyectoBD;

call altaConcesionaria('27408932187',@msj,@val);
call altaConcesionaria('20409845678',@msj,@val);
call modificarconcesionaria('27408932187','27408932181',@msj,@val); 
call modificarconcesionaria('27408932185','27408932181',@msj,@val); 
call bajaConcesionaria('27408932181',@msj,@val);
call altaConcesionaria('27408932181',@msj,@val);


select * from concesionaria;
select @msj, @val;