# foxydb

https://foxydb.wordpress.com/

Librería de conexión a Servidores de Bases de Datos desde Visual Fox Pro (VFP)
FoxyDB
¿Que es FoxyDb?

Es una librería Gratis (OpenSource) para Visual Fox Pro 9.0 sp2 que nos permite conectarnos a servidores de Bases de Datos como Mysql, MariaDB, FireBird de forma transparente para el Programador, en el futuro PostgreSQL, Sql Server, (¿y por qué no otros más?), con solo cambiar una simple propiedad de la librería funcionara de forma transparente con cualquier servidor de datos, ajustando posiblemente algunas instrucciones SQL propias de cada servidor, que no son un estándar SQL y los parámetros de conexión a los diferentes servidores.

¿Que hace FoxyDb?

FoxyDB nos crea una Capa de Acceso a los datos lo cual agiliza el desarrollo , ya no tenemos que programar el acceso a los datos, si no solo conectarnos, consultarlos y actualizarlos desde simples funciones ya programadas para ello, es decir con FoxyDb le dices adiós a Buffering, Multilocks on, SqlEject, Transactions, Commit, Rollback, tableupdate, tablerevert, Requery, SqlSetProp y otras funciones mas que ya no tienes que preocuparte de programar, porque realmente FoxyDb encapsula todas las funciones nativas de VFP para que el desarrollo de acceso a datos sea mas practico y sencillo, es decir deja que FoxyDB realice el trabajo duro de acceso a los datos y preocúpate solo por el desarrollo de tu aplicación.

¿Como funciona FoxyDB?

A diferencia de muchas librerías que hay, FoxyDB es Gratis (OpenSource), se puede usar desde la linea de comando de VFP, por lo que no tienes que ejecutar tu formulario para realizar pruebas, es la ÚNICA que administra los cursores devueltos por las consultas así como las transacciones tanto en los cursores en memoria como en el servidor de base de datos, es decir que los cursores serán tratados como si fueran simples tablas DBF, en los que puedes Insertar, Modificar y Eliminar registros con instrucciones que ya conoces de VFP y FoxyDb generara las instrucciones SQL necesarias para enviar al servidor de base de datos, usando la potencia nativa del servidor de base de datos así como el control total en el desarrollo, a diferencia de usar vistas remotas, Cursor Adapter o cursores Actualizables.

Un ejemplo clásico es abrir una tabla, lo que normalmente tendrías que hacer es enviar un “Select * from usuarios”por medio de SqlExec al cual le debes enviar el manejador (handle) de la conexión al servidor, la instrucción SQL y el nombre del cursor a devolver, a demás de verificar si estas conectado al servidor, no es nada del otro mundo, pero si con una función mas sencilla de FoxyDB el resultado sera el mismo y mas rápido usando oDb.Use(“usuarios”) FoxyDb devolverá un cursor llamado “usuarios”, verificara si estas conectado al servidor y si no lo estas te conectara o intentara conectarte, te avisara de algún problema, cosa que el SqlExec tienes que programar todo para que te notifique el error con Aerror(), a demás de conectarte al servidor.

Ahora si quieres realizar modificaciones la cosa se complica un poco, aplicar buffering al cursor devuelto y usar funciones para saber el estado del cursor, o usar otras instrucciones para crear variables en memoria como SCATTER, sea cual sea el método deberás usas varias funciones, es decir si realizaste cambios luego debes preparar las instrucciones SQL necesarias para actualizar los datos al servidor, y no olvidarte de preparar las transacciones en el servidor.

Con FoxyDb están sencillo que solo tienes que aplicar buffering al cursor pero por medio de la función oDb.CursorEdit(“usuarios”) y listo ya podrás insertar, modificar o eliminar registros y puedes saber si hay cambios con otra sencilla función oDB.CursorChanges(“usuarios”) que devolverá TRUE o FALSE, si hay cambios, entonces enviar los datos al servidor con la función oDb.Update(“usuarios”) este se encargara de revisar y generar los comandos SQL como INSERT, UPDATE o DELETE y enviar solo los campos que realmente se modificaron, a demás de preparar las transacciones correspondientes tanto en los cursores como en el servidor, olvídate de las fecha vacías y caracteres raros (como la Ñ) que otras librerías deben convertir para enviar.

Para finalizar solo debes confirmar los cambios, con un simple oDb.Commit() o deshacer los cambios con oDb.RollBack(), cualquier elegido se aplican o cancelas los cambios así como las transacciones.

Esto ahorra líneas de código, tiempo en depuración, errores, dolores de cabeza y sobre todo morir en el intento de usar un servidor de Base de Datos con Visual Fox Pro, es mejor invierte el tiempo en el desarrollo del programa y no en el acceso a los datos

¿Como se usa FoxyDb?

Tan sencillo como crear un Objeto en Vfp a la clase FoxyDb.prg desde la línea de comando así:

oDb = NEWOBJECT(“FoxyDb”,“FoxyDb.prg”)

Donde “oDb ” puede ser cualquier nombre de variable (publica no recomendable), propiedad de formulario, del _screen, y solo tener cuidado en la ruta donde tengamos el archivo foxydb.prg, ahora ya tenemos en memoria la librería lista para trabajar por ti en el acceso a los datos, ejemplo de obtener la versión de la librería FoxyDb.

? oDb.version
