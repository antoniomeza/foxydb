**************************************************
*!* Librería: FoxyDb_class.prg
*!* Autor: Antonio Meza Pérez
*!* Date: 01/08/2014 01:35:08 AM
*!* Licencia: MIT
*!* Descripción: Librería de Acceso a Servidores de Bases de Datos para VFP 9 Sp 2
*!* Descripción: Soporta Mysql 5.6, MariaDb 10, FireBird 2.5
*!* ------------------------------------------------------------------------------------

*!* ------------------------------------------------------------------------------------
*!* Ejemplo de Uso desde línea de Comandos
*!* Public oDb
*!* oDb = NEWOBJECT("foxydb_class","foxydb_class.prg")
*!* ? oDb.Version
*!* ------------------------------------------------------------------------------------

*!* ------------------------------------------------------------------------------------
*!* Historial de revisiones 
*!* Ver. 0.10 Rev. 01.08.2014 Beta
	*** DbVfp 5.33 ahora nombrado FoxyDb 0.10
	*** Modificando Funciones de FoxyDb, re-nombrando de español a ingles
*!* Ver. 0.20 Rev. 03.08.2014 Beta
	*** Agregando Propiedades y Funciones para diferentes servidores de bases de datos
*!* Ver. 0.40 Rev. 03.09.2014 Beta
	*** Agregando conexión a FireBird
*!* Ver. 0.50 Rev. 18.09.2014 Beta
	*** Agregando Transacciones de FireBird
*!* Ver. 0.60 Rev. 30.09.2014 Beta
	*** Organizando valores de Funciones retornados
	*** Organizando valores de Errores retornados
*!* Ver. 0.70 Rev. 03.10.2014 Beta
	*** Mejorando Mensajes de Error
	*** Agregando Modo Depuración (paso a paso)
*!* Ver. 0.75 Rev. 03.10.2014 Beta
	*** Nuevo método TEST, para realizar pruebas
	*** Nuevos métodos y propiedades para traducción de mensajes en inglés y español
*!* Ver. 0.80 Rev. 05.10.2014 Beta
	*** Funciones y Propiedades mejoradas y reescritas
*!* Ver. 0.85 Rev. 07.10.2014 Beta
	*** Código Documentado y organizado
*!* Ver. 0.90 Rev. 10.10.2014 Beta
	*** Revisión de transacciones de FireBird Exitosas
	*** Revisión de transacciones con Mysql y MariaDB Exitosas
	*** Revisión de Consultas, modificaciones, insertado y borrado de registros Exitosa
*!* Ver. 0.91 Rev. 11.10.2014 Beta
	*** Se crea el Blog de FoxyDB para documentar la librería.
	*** Se agrega documentación Inicial
*!* Ver. 0.92 Rev. 12.10.2014 Beta
	*** Blog, se documenta Indice de Propiedades y Funciones
*!* Ver. 0.93 Rev. 13.10.2014 Beta
	*** Se reorganiza diseño del Blog
*!* Ver. 0.95 Rev. 16.10.2014 Beta
	*** Nueva Función: .UUID() para generar un Identificador Único Universal en MySql, MariaDb y FireBird
	*** Nueva Función: .ENGINE_VERSION() para devolver la versión del Servidor MySql, MariaDb y FireBird
*!* Ver. 0.96 Rev. 20.10.2014 Estable
	*** Se revisa Ortografía del Código Documentado
*!* Ver. 0.99 Rev. 24.10.2014 Estable
	*** Se compila con Existo la librería
	*** Se agrupan Funciones
*!* Ver. 1.00 Rev. 25.10.2014 Estable
	*** Se libera FoxyDB 1.0 Estable
	*** Cumpleaños de mi Hermano Adán Meza
*!* Ver. 1.01 Rev. 27.10.2014 Estable
    *** Nueva Propiedad .handle_Shared para Reconectar una conexión compartida, ya que si por error o falla
    *** Se pierde la Conexión Compartida al intentar reconectar realmente marcaria error porque las propiedades
    *** de Conexión no fueron definidas y no tiene asignada la Conexión Compartida
    *** Se ajustó Procedimiento .Connect() para hacer uso de la nueva propiedad y ahora solo permite valor Lógico
    *** Se eliminó el valor Numérico, que ahora se tomara de la propiedad .handle_Shared
*!* Ver. 1.02 Rev. 29.10.2014 Estable
	*** Se corrigen nombres de variables locales mal escritas (reportado por Hernán Canon)
*!* Ver. 1.03 Rev. 29.10.2014 Estable
	*** Se ajusta función .Sql() ya que no finalizaba en todos los casos el Commit de la transacción de solo lectura.
	*** Además para que se desconecte del servidor según los parámetros de conexión.
*!* Ver. 1.04 Rev. 29.10.2014 Estable
	*** Se ajusta la Función .Disconnetc() para evitar por error una desconexión cuando hay una transacción Activa.
*!* Ver. 1.05 Rev. 30.10.2014 Estable
	*** Se agregan propiedades nuevas para el manejo del servidor de base de datos SqlLite (por Hernán Canon)
*!* Ver. 1.06 Rev. 30.10.2014 Estable
	*** Se agrega nueva propiedad .handle_Parameters para adicionar parámetros adicionales a la función 
	*** .Connection() o .Connect() para cualquier motor de base de datos
	*** Se ajusta función .Connection() para recibir parámetros adicionales
	*** Se eliminan valores predeterminados en la función .Connection()
*!* Ver. 1.07 Rev. 01.11.2014 Estable
	*** Se agrega nueva función .Cancel que permite deshacer una transacción activa aplicando un RollBack
*!* Ver. 1.08 Rev. 02.11.2014 Estable
	*** Se corrigen algunos valores devueltos y documentación interna de la librería
	*** Se ajustan la función .GetTableNameInSql() para eliminar codigos Chr(13) y poder obtener nombre de la tabla
	*** Se ajusta funcion .Query() para evitar que el nombre de la tabla este vacio
*!* Ver. 1.09 Rev. 03.11.2014 Estable
	*** Se libera FoxyDb 1.10 estable
	*** Se libera nuevo Motor SqlLite (Beta)
	*** Se preparan funciones para el servidor SqlLite en fase Beta
	*** Mysql, MariaDb y FireBird no son afectados en esta Versión.
*!* Ver. 1.10 Rev. 15.11.2014 Estable
	*** Se libera FoxyDb 1.10 estable
	*** Se agrega nueva propiedades .mysql_Compatibility para usar FoxyDb con versiones anteriores a la 5.6 de Mysql
	*** Se ajusta la función .Sql() para la Compatibilidad con versiones anteriores a la 5.6 de Mysql.
*!* Ver. 1.11 Rev. 16.01.2015 Estable
	*** Se libera FoxyDb 1.11 estable
	*** Se Corrige la función .Cancel que devolvía siempre Verdadero (.t.)
	*** Se agrega nueva función .Begin que permite Iniciar una transacción manual
*!* Ver. 1.12 Rev. 21.01.2015 Estable
	*** Se aplica un ALLTRIM() a los campos Carácter para que no se guarden espacios en blanco en el servidor.
	*** Se modificó la función COMMAND que se encarga de generar las instrucciones SQL.
*!* Ver. 1.13 Rev. 20.02.2015 Estable
	*** Se amplían los campos la tabla temporal DBCURSOR de 50 caracteres a 100 caracteres para poder usar nombres de tablas
	*** y cursores más largos
*!* Ver. 1.14 Rev. 25.02.2015 Estable
	*** Se personaliza el manejo de Campos DATE y DATETIME por Motor de Base de datos, para guardar Fechas Vacías ver propiedades
	*** Nuevas .mysql_Empty_Date, mariaDb_Empty_Date, fireBird_Empty_Date, etc. y se ajustó función .Command() para los nuevas propiedades
*!* Ver. 1.15 Rev. 24.03.2015 Estable
	*** Bug Reportado por Francisco en la función .SQL() cuando se usa compatibilidad con Mysql
*!* Ver. 1.16 Rev. 25.03.2015 Estable
	*** Bug en la función Connection() que devolvía siempre 1 o -1, se ajusto para devolver el valor retornado
	*** por la función .Connect() en la propiedad .error_Code
*!* Ver. 1.17 Rev. 26.03.2015 Estable
	*** Bug en la función .Errors() que no devolvía los errores ODBC de sentencias SQL mal escritas
	*** Se agrega nueva propiedad .error_OdbcInSql = .f. para determinar si hubo un error devuelto por la función .SQL()
	*** Se modifica la función .Sql() y la función .Errors() para corregir el Bug.
*!* Ver. 1.18 Rev. 11.04.2015 Estable
	*** Bug en la función .GetTableNameInSql() que no devolvía el nombre de la tabla contenido en una instrucción SELECT
	*** cuando la cadena contenía caracteres de retorno. tab, chr(13) etc.
*!* Ver. 1.19 Rev. 14.04.2015 Estable
	*** Bug en la función .Code() nos permite enviar un valor inicial para el código consecutivo, sin embargo retornaba 
	*** el valor inicial enviado aun cuando ya existía un registro, es decir no incrementaba, se corrigió el error.
*!* Ver. 1.20 Rev. 15.04.2015 Estable
	*** Nuevo parámetro __defaultValueChange en la función .Code() nos permite remplazar el valor consecutivo actual 
	*** muy útil cuando deseamos corregir o iniciar un correlativo.
*!* Ver. 1.21 Rev. 26.04.2015 Estable
	*** Bug en la función .Command() que solo validaba los campos de tipo Fecha en Sentencia Update, se agregó validación 
	*** en sentencia Insert
	*** Se mejoró la rutina para validar el tipo de Campo ya que se usaba Vartype() y ahora se usa AFIELDS lo que asegura
	*** que el tipo de Campo a Validar es correcto
*!* Ver. 1.22 Rev. 27.05.2015 Estable
	*** Nueva propiedad .error_ODBC para obtener el código de error ODBC devuelto
	*** Se ajustó la función .Sql() para obtener el código de error
	*** Se ajustó la función .Errors() para mostrar el código de error
*!* Ver. 1.23 Rev. 28.05.2015 Estable
	*** Bug reportado por Francisco en la función .New() que tomaba el Alias() actual cuando debe ser el nombre
	*** del cursor que se pasó como parámetro.
*!* ------------------------------------------------------------------------------------
*!* Ver 2.0 Rev. 01/06/2015 Estable
	*** Nueva Version
*!* Ver 2.01 Rev. 02/07/2015 Estable
	*** Bug reportado por Francisco en la función .DB() que no encontraba la funcion .Return() la cual se 
	*** se camnio por .POST(), se ajustanron demas funciones que aun usaban .Return() por .Post()
*!* Ver 2.02 Rev. 07/07/2015 Estable
	*** Bug en la función .Connected() que retorna siempre .t. cuando se usar la propiedad .handle_Reconnection = .t.
	*** se elimino la accion de reconectar desde la función .Connected()
	*** Se ajusto la funcion .SQL() para que realice la reconexion dependiendo de la propiedad .handle_Reconnection
*!* Ver 2.03 Rev. 08/07/2015 Estable
	*** Bug reportado por Francisco en la función .CODE() no genera correctamente el comando SQL para enviar 
	*** al servidor, por problema de alcance de la variable _commandSql que ya se definio como LOCAL
*!* Ver 2.04 Rev. 09/07/2015 Estable
	*** Bug No se reconecta al iniciar una transaccion .Begin(), o al intentar enviar un .Update()
	*** se ajusto funcion .Begin() para que se reconecte si la propiedad handle_Reconnection = .t.
*!* ------------------------------------------------------------------------------------		
DEFINE CLASS foxydb_clase AS custom

	* Constantes
		#define true 	.t.
		#define false 	.f.
		
	* Propiedades
		* Librería
			version					= "2.0"			&& Versión de la Librería
			review					= "30/05/2015"	&& Fecha de la última revisión
			stable					= true			&& Versión Estable
			debug					= false			&& Depurar mostrando paso a paso lo que hace la librería
			language				= "es"			&& es = Español, us = ingles
			application_Name		= "FoxyDb"		&& Nombre de la Aplicación
		* Motores de Bases de Datos	y Versiones Recomendadas
			mySql					= 1				&& Mysql 5.6 o posterior
			mariaDb					= 2				&& MariaDb 10.0 o posterior
			fireBird				= 3				&& Firebird 2.5 o posterior
			postgreSql				= 4				&&
			sqlServer				= 5				&&
			sqlLite					= 6				&& SqlLite 3 o posterior
			engine					= this.mySql	&& Motor de Base de Datos por defecto
		* Drivers ODBC, Puertos y Parámetros Predeterminados
			* Mysql
				driver_Mysql_51  	= "{MySQL ODBC 5.1 Driver}"
				driver_Mysql_351 	= "{MySQL ODBC 3.51 Driver}"
				port_Mysql			= "3306"
				mysql_Compatibility = false			&& Compatibilidad con versión mysql 5.5 o menor
				mysql_Empty_Date	= "0000-00-00"	&& Para guardar Fechas vacías
			* MariaDb
				driver_MariaDb		= "{MariaDB ODBC 1.0 Driver}"
				port_MariaDb		= "3306"
				mariaDb_Empty_Date	= "0000-00-00"	&& Para guardar Fechas vacías
			* FireBird
				driver_FireBird		= "{Firebird/InterBase(r) driver};"
				port_FireBird		= "3050"
				fireBird_Empty_Date	= null	&& Para guardar Fechas vacías
			* Postgresql
				driver_Postgresql	= "{PostgreSQL ODBC Driver(ANSI)}"
				port_Postgresql		= "5432"
			* SqlServer
				driver_SqlServer	= ""
				port_SqlServer		= ""
			* SqlLite
				driver_SqlLite		= "SQLite3 ODBC Driver"
				sqlLite_TimeOut 	= "1000"
				sqlLite_NoTXN		= "0"
				sqlLite_LongNames	= "0"
				sqlLite_SyncPragma  = "NORMAL"
				sqlLite_StepAPI     = "0"
		* Conexión
			handle					= 0				&& Manejador de Conexión al Servidor Devuelto por SQLCONNECT o SQLSTRINGCONNECT
			handle_Shared			= 0				&& Manejador de Conexión Compartido para usar en sesiones privadas de datos.
			handle_Reconnection		= false			&& Si se intenta reconectar al servidor
			handle_Network			= true			&& Si mantiene permanente la conexión
			handle_Verify			= false			&& Si Verifica el estado de la conexión al servidor
			handle_Transaction		= 0				&& Si existe una Transacción Activa
													&& 0 No hay transacción
													&& 1 Transacción Solo Lectura
													&& 2 Transacción Lectura y Escritura Local y Remota
													&& 3 Transacción Lectura y Escritura Remota
			handle_Transaction_Mode_Select_MySql		=	"READ ONLY"									&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_MySql		=	"ISOLATION LEVEL READ COMMITTED"			&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Transaction_Mode_Select_MariaDb		=	"READ ONLY"									&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_MariaDb		=	"ISOLATION LEVEL READ COMMITTED"			&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Transaction_Mode_Select_FireBird		=	"READ ONLY SNAPSHOT WAIT"					&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_FireBird		=	"READ WRITE READ COMMITTED WAIT"			&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Transaction_Mode_Select_PostgreSql	=	""			&& inicializar SET TRANSACTION en SELECT
			handle_Transaction_Mode_Update_PostgreSql	=	""			&& inicializar SET TRANSACTION en INSERT / UPDATE / DELETE
			handle_Driver			= ""			&& Driver Odbc
			handle_Server			= ""			&& Ip del servidor
			handle_User				= ""			&& Usuario del Servidor
			handle_Password			= ""			&& Password del servidor
			handle_Database 		= ""			&& Base de datos del servidor
			handle_Port				= ""			&& Puerto del Servidor
			handle_Parameters		= ""			&& Agregar parámetros adicionales a la Conexión del servidor
			DIMENSION handle_cursor[1]				&& Array con los nombres de los cursores devuelto por AUSED()
		* ID (Identificadores de Registro)
			id_last					= 0				&& Numero del Ultimo Id Registrado después de un Insert Into
			id_Active				= false			&& Si se solicita recuperar el Ultimo ID Insertado
			id_Code					= 0				&& Numero de código único generado por la función .CODE()
			id_name					= "id"			&& Nombre del Campo ID Autoincremental Primary Key
		* Errores
			error_Show				= false			&& Mostrar Errores SQL devueltos por Aerror()
			error_Title				= "SQL Error"	&& Titulo a mostrar en el messagebox de Errores
			error_Code				= 0				&& Numero de Error devuelto por el procedimiento
			error_Procedure			= ""			&& Nombre del procedimiento que devolvió el Error
			error_value				= ""			&& Valor retornado por el procedimiento que notifico el error
			error_Cursor			= ""			&& Nombre del Cursor 
			error_table				= ""			&& Nombre de la Tabla 
			error_Post				= ""			&& Mensaje de Error
			error_Id				= 0				&& Código de Error que se genera al obtener el Ultimo ID Insertado
			DIMENSION error_Array[10]				&& Array devuelto por Aerror()
			error_OdbcInSql			= false			&& Si hay un error ODBC en la Función .Sql()
			error_Odbc				= 0				&& Código de Error ODBC
		* Sql
			sql_Update				= ""			&& Contiene la última instrucción SQL enviada al servidor por .Update()
			sql_Send				= ""			&& Contiene la última instrucción SQL enviada al servidor por .Sql()
			sql_Records 			= 0				&& Cantidad de Registros afectados por SQLEXEC es decir
													&& devueltos por un Select, o actualizados por un Update, Delete
			sql_Command				= ""			&& Instrucción SQL generada con la función .Command()
			sql_CommandType			= 0				&& Saber qué tipo de Comando SQL se generó, 0 Nada, 1 Update, 2 Delete, 3 Insert
		* Cursores
			DIMENSION cursor_Array[1]				&& Almacena la cantidad y nombres de los Cursores en Memoria
			* DBCursor 								&& Alias del cursor creado para administrar los cursores en memoria

	* Funciones (Ordenadas por Grupos)
		* Conexión
			* Connect					Permite Conectarse a un servidor de base de datos o usar una conexión compartida
			* Connected					Saber si está Conectado al Servidor de base de datos y reconectar (opcional)
			* Connection				Conectar al Servidor con parámetros
			* Disconnect				Permite Desconectarse del Servidor de Base de datos
			* Reconnection				Permite Reconectarse al servidor

		* Cursores
			* Query						Abrir cursor por medio de una consulta SQL al servidor
			* Use						Abrir Cursor en memoria
			* New						Abrir Cursor vació listo para Editar
			* Changes					Saber si hay Cambios en todos los cursores
			* Close						Cerrar todos los cursores abiertos
			* CursorChanges				Saber si hay Cambios en un Cursor
			* CursorClose				Cerrar un cursor abierto
			* CursorCount				Devuelve la Cantidad de Cursores abiertos y Array con Nombres
			* CursorEdit				Hacer Cursor editable (Aplica Buffering 5)
			* CursorOpen				Verificar si el Cursor está Abierto
			* Refresh					Actualizar (Refrescar) los datos del Cursor
			* DbCursor					Crea un Cursor temporal para administrar los cursores creados con Use(), Query() y New()
			
		* Base de datos
			* Sql						Enviar Comando Sql por medio de SqlExec al servidor de base de datos
			* Db						Cambiar Base de datos del Servidor
			* TableFields				Devuelve Cursor con Campos (estructura) de Tabla de la base de datos
			* Tables					Devuelve Cursor con listado de Tablas de la base de datos
			* TablesGoTop				Aplicar un Go Top a los cursores abiertos en memoria
			* Engine_Version			Devuelve la Versión del Servidor de Base de datos
			* Command					Obtener el comando SQL del registro actual del cursor según los cambios hechos.
			* Update					Genera y Envía instrucciones Sql (Insert / Update / Delete) al servidor según los cambios hechos al cursor			

		* Transacciones
			* Begin						Iniciar una transacción
			* Commit					Aplica una transacción
			* RollBack					Cancelar una transacción
			* Undo						Deshacer Cambios en todos los Cursores (tableRevert) y aplicar RollBack a la transacción

		* Identificadores
			* Id						Obtener el Ultimo ID al insertar un Registro Nuevo, el valor se obtiene en la propiedad id_Last
			* Code						Obtener Código Único (Correlativo)
			* UUID						Generar valor UUID (Identificador Universal único)

		* Librería
			* DbTableName				Devuelve el nombre de la tabla asociada a un cursor
			* Message					Mostrar Mensajes de la librería (Útil para Depurar o ver la ultima acción)
			* Post						Control de Mensajes internos de la Liberia, según el procedimiento enviado
			* Errors					Control de mensajes de Errores SQL (devueltos por Aerror)
			* GetNameInString			Obtener Nombre de Tabla (T) o Nombre de Cursor (C) dentro de la cadena de caracteres
			* GetTableNameInSql			Obtener Nombre de Tabla dentro del comando Sql (solo en Select)
			* Test						Para Realizar pruebas con la librería en diferentes servidores y probar diferentes configuraciones
			* TextMessage				Convertir Códigos de Error de la librería en Texto y traducirlos en diferentes idiomas
			* End						Cerrar Transacción con RollBack, Cerrar todos los cursores, conexión al servidor y finalizar la librería

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Init
				* Iniciar la Libreria
			ENDPROC 
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Test
				* Configurar para Pruebas
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Connected
				LPARAMETERS __handleVerify as Boolean
				LOCAL __handleNotReconnected, __handleNotConnected, __handleConnected, __handleConnectedVerified, ;
					  __handleReConnected, __commandSql, __cursorNameTemp
				* Connected
					* Saber si está Conectado al Servidor de base de datos
					* Para Reconectar de forma automática revise la propiedad .handle_Reconnection
				* Parámetros
					* __handleVerify, Verificar si realmente se está Conectado al servidor
				* Valor devuelto 
					* true (Verdadero) Conectado
					* false (Falso) No Conectado
				* Error devuelto
					__handleNotReconnected		= -2							&& No Reconectado
					__handleNotConnected		= -1							&& No Conectado
					__handleConnected			= 1								&& Conectado (sin verificar)
					__handleConnectedVerified	= 2								&& Conectado y Verificado
					__handleReConnected			= 3								&& Reconectado
					__commandSql				= ""							&& Instrucción SQL para Verificar la conexión
					__cursorNameTemp			= "__foxyDB_CursorVerify__"		&& Nombre del Cursor Temporal para verificar conexión
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__handleVerify) <> "L"
						__handleVerify = false
					ENDIF
				* Verificar si esta Conectado	
					IF this.handle > 0
						IF __handleVerify
							* Comando Sql
								DO CASE
									CASE this.engine = this.mysql
										__commandSql = "SELECT NOW()"
									CASE this.engine = this.mariaDb
										__commandSql = "SELECT NOW()"
									CASE this.engine = this.fireBird
										__commandSql = "SELECT CURRENT_DATE FROM RDB$DATABASE"
									CASE this.engine = this.postgreSql
										__commandSql = "current_timestamp;"
									CASE this.engine = this.sqlServer
								ENDCASE
							* Ejecutar Comando Sql
								IF this.Sql(__commandSql,__cursorNameTemp)
									USE IN (__cursorNameTemp)		&& Cerrar Cursor Temporal
									RETURN this.Post(PROGRAM(),__handleConnectedVerified,true)
								ELSE
									this.handle = 0
								ENDIF
						ELSE
							RETURN this.Post(PROGRAM(),__handleConnected,true)
						ENDIF
					ELSE
						RETURN this.Post(PROGRAM(),__handleNotConnected,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Reconnection
				LOCAL __handleNotReconnected, __handleConnected, __handleReConnected
				* Reconnection
					* Permite Reconectarse al servidor
				* Parámetros
					* No Requerido
				* Valor devuelto 
					* true (Verdadero) Reconectado
					* false (Falso) No Reconectado
				* Error devuelto
					__handleNotReconnected		= -1			&& No Reconectado
					__handleConnected			= 0				&& Ya Estaba Conectado
					__handleReConnected			= 1				&& Reconectado
				* Reconectar
					IF this.Connect()
						DO CASE
							CASE this.error_Code = __handleConnected
								RETURN this.Post(PROGRAM(),__handleConnected,true)
							CASE this.error_Code = __handleReConnected
								RETURN this.Post(PROGRAM(),__handleReConnected,true)
						ENDCASE
					ELSE
						RETURN this.Errors(PROGRAM(),__handleNotReconnected,false)
					ENDIF
			ENDPROC 
	*** --------------------------------------------------------------------------------------------
	
	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Errors
				LPARAMETERS __procedureName as Character, __errorNumber as Integer, __returnValue as Variant
				* _Error
					* Control de mensajes de Errores SQL (devueltos por Aerror)
				* Parámetros
					* __procedureName, Nombre del procedimiento que envía el error
					* __errorNumber,  Numero de error
					* __returnValue, Valor que será Retornado por el procedimiento, numérico, lógico, carácter, etc.
				* Asignar valores a las propiedades Error
					this.TextMessage(__procedureName,__errorNumber,__returnValue)
				* Mostrar Errores SQL
					IF this.error_Show
						IF NOT this.error_OdbcInSql
							* Capturar el Error ODBC
							AERROR(this.error_array)
						ENDIF
						IF VARTYPE(this.error_array) = "N"
							MESSAGEBOX( ;
								__procedureName + CHR(13) ;
								 + CHR(13) + "ERROR: " + + ALLTRIM(STR(__errorNumber));
								 + CHR(13) + this.error_post + CHR(13) ;
								 + CHR(13) + "ERROR ODBC: " + ALLTRIM(STR(this.error_array[1])) ;
								 + CHR(13) + this.error_array[2] ;
								 + CHR(13) ;
								 + CHR(13) + this.error_array[3] ;
								 + CHR(13) ;
								 + CHR(13) + "Codigo de Error: " + ALLTRIM(STR(this.error_array[5])) ;
								 ,(0+48),this.application_name + " " + this.error_title ;
							)
						ENDIF
					ENDIF
					this.error_OdbcInSql = false
				* Retornar Valor
					RETURN __returnValue
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Post
				LPARAMETERS __procedureName as Character, __errorNumber as Integer, __returnValue as Variant
				* Post
					* Control de Mensajes internos de la Librería, según el procedimiento enviado
				* Parámetros
					* __procedureName, Nombre del procedimiento que envía el error
					* __errorNumber,  Numero de error
					* __returnValue, Valor que será Retornado por el procedimiento
				* Asignar valores a las propiedades Error
					this.TextMessage(__procedureName,__errorNumber,__returnValue)
				* Mostrar Mensajes de la Librería
					IF this.debug
						this.Message()
					ENDIF
				RETURN __returnValue
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Message
				LOCAL __title, __Icon, __returnValueString
				* Message
					* Mostrar Mensajes de la librería (Útil para Depurar o ver la última acción)
					__Icon = 32
				* Preparar Mensaje
					* Icono
						DO CASE
							CASE this.error_code < 0
								__Icon = 16
							CASE this.error_code = 0
								__Icon = 48
							CASE this.error_code > 0
								__Icon = 64
						ENDCASE
					* Valor Devuelto
						DO case
							CASE VARTYPE(this.error_Value) = "L"
								__returnValueString = IIF(this.error_Value,"Verdadero","Falso")
							CASE VARTYPE(this.error_Value) = "N"
								__returnValueString = ALLTRIM(STR(this.error_Value))
							CASE VARTYPE(this.error_Value) = "C"
								__returnValueString = this.error_Value
						ENDCASE
				* Mostrar Mensaje
					DO CASE
						CASE this.language = "es"
							__title = "Mensaje"
							MESSAGEBOX( ;
								this.error_procedure + CHR(13) ;
								 + CHR(13) + "Valor Retornado: " + __returnValueString ;
								 + CHR(13) + "Número de Error: " + ALLTRIM(STR(this.error_code)) ;
								 + CHR(13) + "Mensaje de Error: " + CHR(13) + this.error_post ;
								 ,(0 + __Icon),this.application_name + "-" + __title;
							)
						CASE this.language = "us"
							__title = "Message"
							MESSAGEBOX( ;
								this.error_procedure + CHR(13) ;
								 + CHR(13) + "Return Value: " + __returnValueString ;
								 + CHR(13) + "Error Number: " + ALLTRIM(STR(this.error_code)) ;
								 + CHR(13) + "Error Message: " + CHR(13) + this.error_post ;
								 ,(0 + __Icon),this.application_name + "-" + __title;
							)
					ENDCASE
			ENDPROC
	*** --------------------------------------------------------------------------------------------			

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Connection
				LPARAMETERS __driver as Character, __server as Character, __user as Character, __password as Character, __dataBase as Character, __port as Character
				LOCAL __handleNotConnected, __handleConnected
				* Connection
					* Conectar al Servidor con parámetros
				* Validar Parámetros
					* __driver		Driver Odbc
					* __server		Ip del servidor
					* __user		Usuario del Servidor
					* __password	Password del servidor
					* __database 	Base de datos del servidor
					* __port		Puerto del Servidor
				* Valor devuelto 
					* true (Verdadero) Conectado
					* false (Falso) No Conectado
				* Error Devuelto
					__handleNotConnected	= -1		&& No Conectado
					__handleConnected		= 1			&& Conectado
				* Validar Parámetros
					* Driver ODBC
						IF VARTYPE(__driver) <> "C"
							__driver = ""
						ENDIF
					* Servidor
						IF VARTYPE(__server) <> "C"
							__server = ""
						ENDIF
					* Usuario
						IF VARTYPE(__user) <> "C"
							__user = ""
						ENDIF
					* Password
						IF VARTYPE(__password) <> "C"
							__password = ""
						ENDIF
					* Base de Datos
						IF VARTYPE(__dataBase) <> "C"
							__dataBase = ""
						ENDIF
					* Puerto del servidor
						IF VARTYPE(__port) <> "C"
							__port = ""
						ENDIF
				* Asignar Propiedades
					this.handle_Driver		= __driver 
					this.handle_Server		= __server
					this.handle_User		= __user
					this.handle_Password	= __password
					this.handle_DataBase 	= __dataBase
					this.handle_Port		= __port
				* Conectar
					IF this.Connect()
						RETURN this.Post(PROGRAM(),this.error_Code,true)
					ELSE
						RETURN this.Post(PROGRAM(),this.error_Code,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Connect
				LPARAMETERS __handleShare as Boolean
				LOCAL __handleNotConnected, __handleAlreadyConnected, __handleConneted, __handleStringConnect, __shareConnection
				* Connect
					* Permite Conectarse a un servidor de base de datos o usar una conexión compartida
				* Parámetros
					* __handleShare, Si se comparte la conexión
				* Valor devuelto 
					* true (Verdadero) Conectado
					* false (Falso) No Conectado
				* Error devuelto
					__handleNotConnected			= -1		&& No se puedo conectar al servidor
					__handleAlreadyConnected		= 0			&& Ya está conectado
					__handleConneted				= 1			&& Se ha Conectado correctamente
					__handleStringConnect			= ""		&& Cadena de Conexión al servidor
				* Validar Parámetros
					IF VARTYPE(__handleShare) <> "L"
						__handleShare = false
					ENDIF
				* Verificar si está Conectado
					IF this.handle > 0
						RETURN this.Post(PROGRAM(),__handleAlreadyConnected,true)
					ENDIF
				* Usar Conexión Compartida
					IF this.handle_Shared > 0
						this.handle = SQLCONNECT(this.handle_Shared)			&& Conectar usando Conexión Compartida
					ELSE
						* Parámetros de Configuración antes de Conectar
					        SQLSETPROP(0, 'ConnectTimeOut', 15)					&& Tiempo de espera en conectar
					        SQLSETPROP(0,"DispLogin",3) 						&& No mostrar dialogo de Conexión ODBC al Servidor
						* Conectar
							DO CASE
								CASE this.engine = this.mySql
									__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
														  + "SERVER=" 	+ this.handle_Server	+ ";"	;
														  + "UID=" 		+ this.handle_User		+ ";"	;
														  + "PWD=" 		+ this.handle_Password 	+ ";"	;
														  + "DATABASE="	+ this.handle_Database	+ ";"	;
														  + "PORT=" 	+ this.handle_Port 		+ ";"	;
  														  + this.handle_Parameters
								CASE this.engine = this.mariaDb
									__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
														  + "SERVER=" 	+ this.handle_Server	+ ";"	;
														  + "UID=" 		+ this.handle_User		+ ";"	;
														  + "PWD=" 		+ this.handle_Password 	+ ";"	;
														  + "DATABASE="	+ this.handle_Database	+ ";"	;
														  + "PORT=" 	+ this.handle_Port 		+ ";"	;
														  + this.handle_Parameters
								CASE this.engine = this.fireBird
									__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
														  + "SERVER=" 	+ this.handle_Server	+ ":" + this.handle_Port + ";"	;
														  + "UID=" 		+ this.handle_User		+ ";"	;
														  + "PWD=" 		+ this.handle_Password 	+ ";"	;
														  + "DATABASE="	+ this.handle_Database	+ ";"	;
														  + this.handle_Parameters
								CASE this.engine = this.postgreSql
									__handleStringConnect = "DRIVER=" 	+ this.handle_Driver 	+ ";"	;
														  + "SERVER=" 	+ this.handle_Server	+ ";"	;
														  + "PORT=" 	+ this.handle_Port 		+ ";"	;
														  + "DATABASE="	+ this.handle_Database	+ ";"	;
														  + "UID=" 		+ this.handle_User		+ ";"	;
														  + "PWD=" 		+ this.handle_Password 	+ ";"	;
														  + this.handle_Parameters
								CASE this.engine = this.sqlServer
								CASE this.engine = this.sqlLite
									__handleStringConnect = "DRIVER=" 		+ this.handle_Driver 		+ ";"	;
														  + "DATABASE="		+ this.handle_Database		+ ";"   ;
														  + "UID=" 			+ this.handle_User			+ ";"	;
														  + "PWD=" 			+ this.handle_Password 		+ ";"	;
														  + "LongNames="	+ this.sqlLite_LongNames 	+ ";"	;
														  + "TimeOut"		+ this.sqlLite_TimeOut 		+ ";"	;
														  + "NoTXN"			+ this.sqlLite_NoTXN		+ ";"	;
														  + "SyncPragma" + this.sqlLite_SyncPragma		+ ";"	;
														  + "sqlLite_StepAPI" + this.sqlLite_StepAPI	+ ";"	;
														  + handle_Parameters
							ENDCASE
						* Conectar
							this.handle = SQLSTRINGCONNECT(__handleStringConnect, __handleShare)
					ENDIF
				* Verificar y Preparar Conexión actual
					IF this.handle > 0
						* Habilitar Buffering
							SET MULTILOCKS ON
						* Habilitar Transacciones Manuales en VFP
							SQLSETPROP(this.handle, 'Transactions', 2)
						* Aplicar Rollback al desconectar
							SQLSETPROP(this.handle, 'DisconnectRollback', true)
						* Mostrar Errores sql nativos
							SQLSETPROP(this.handle, 'DispWarnings', false)
						* Conjuntos de resultado retornados sincrónicamente 
	 						SQLSETPROP(this.handle, 'Asynchronous', false)
						* SQLEXEC retorna los resultados en una sola vez
							SQLSETPROP(this.handle, 'BatchMode', true)
						* Tiempo en minutos para que una conexión no usada se desactive (0 = nunca)
					        SQLSETPROP(this.handle, 'IdleTimeout', 0)
						* Tamaño del paquete de datos usado por la conexión (4096)
							SQLSETPROP(this.handle, 'PacketSize', 4096)
						* El tiempo de espera, en segundos, antes de retornar un error general
							SQLSETPROP(this.handle, 'QueryTimeOut', 0)
						* El tiempo, en milisegundos, hasta que VFP verifique que la instrucción SQL se completó
							SQLSETPROP(this.handle, 'WaitTime', 100)
						* Listo Conectado
							RETURN this.Post(PROGRAM(),__handleConneted,true)
					ELSE
						RETURN this.Errors(PROGRAM(),__handleNotConnected,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------			
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Disconnect
				LOCAL __handleTransaction, __handleDisconnected, __handleNotConnect, __handleValue, __transactionNotStarted
				* Disconnect
					* Permite Desconectarse del Servidor de Base de datos
				* Parámetro
					* No requerido
				* Valor devuelto 
					* true (Verdadero) Desconectado
					* false (Falso) No se Desconecto
				* Error devuelto
					__handleTransaction			= -1		&& Hay Transacción Activa, no se puede desconectar
					__handleDisconnected		= 1			&& Se ah Desconectado
					__handleNotConnect			= 0			&& No estaba conectado
					__handleValue				= 0			&& Obtener el valor devuelto al desconectar 1, -1 y -2
					__transactionNotStarted		= 0			&& No hay una transacción Iniciada
				* Verificar que no haya una Transacción Activa
					IF this.handle_Transaction > __transactionNotStarted
						RETURN this.Post(PROGRAM(),__handleTransaction,false)
					ENDIF
				* Desconectar
					IF this.handle >= 1
						__handleValue = SQLDISCONNECT(this.handle)
						this.handle = 0
						IF __handleValue = 1
							RETURN this.Post(PROGRAM(),__handleDisconnected,true)
						ELSE
							RETURN this.Errors(PROGRAM(),__handleValue,false)
						ENDIF
					ELSE
						this.handle = 0
						RETURN this.Post(PROGRAM(),__handleNotConnect,true)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Db
				LPARAMETERS __dataBaseName as Character
				LOCAL __dataBaseNameEmpty, __dataBaseNotChanged, __sqlCommandNotAvailable, __dataBaseChanged, __commandSql
				* Db
					* Cambiar Base de datos del Servidor
				* Parámetros
					* __dataBaseName, Nombre de la Base de datos a Cambiar
				* Valor devuelto 
					* true (Verdadero) Se cambió la base de datos
					* false (Falso) No se cambió la base de datos
				* Error devuelto
					__dataBaseNameEmpty			= -2		&& Falta nombre de la base de datos
					__dataBaseNotChanged		= -1		&& Base de datos Cambiada
					__sqlCommandNotAvailable	= 0			&& Comando Sql No disponible
					__dataBaseChanged			= 1			&& Base de datos Cambiada
					__commandSql				= ""		&& Comando Sql a ejecutar
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__dataBaseName) <> "C" OR EMPTY(ALLTRIM(__dataBaseName))
						RETURN this.Post(Program(),__dataBaseNameEmpty,false)			
					ENDIF
				* Comando SQL para cambiar de Base de Datos
					DO case
						CASE this.engine = this.mySql 
							__commandSql = "USE " + __dataBaseName 
						CASE this.engine = this.MariaDb
							__commandSql = "USE " + __dataBaseName 
						CASE this.engine = this.fireBird
							RETURN this.Post(PROGRAM(),__sqlCommandNotAvailable,false)
						CASE this.engine = this.postgreSql
							__commandSql = "USE " + __dataBaseName 
						CASE this.engine = this.sqlServer
							RETURN this.Post(PROGRAM(),__sqlCommandNotAvailable,false)
					ENDCASE
				* Cambiar Base de datos
					IF this.Sql(__commandSql,true)
						RETURN this.Post(Program(),__dataBaseChanged,true)
					ELSE
						RETURN this.Errors(PROGRAM(),__dataBaseNotChanged,false)
					ENDIF
			ENDPROC 
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Sql
				LPARAMETERS __commandSql as Character, __cursorName as Variant
				LOCAL __lockModeErrorCommit, __lockModeErrorTransaction, __commandSqlNotFinished, __commandSqlEmpty, ;
					__handleNotConnected, __commandSqlError, __commandSqlExecuted, __commandSqlSequence, ;
					__transactionReadOnly, __transactionNotStarted, __transactionReadOnlyAutomatic
				* Sql
					* Enviar Comando Sql por medio de SqlExec al servidor de base de datos
				* Parámetros
					* __commandSql, instrucción SQL a ejecutar en el servidor de base de datos
					* __CursorName, 
						* Carácter: Nombre del Cursor a Devolver de la Consulta
						* Lógico: Solo ejecutar instrucción y no devolver registros afectados 
				* Valor devuelto: Lógico
					* true Ejecutado correctamente
					* false Error en commando SQL
				* Error devuelto:
					__handleNotReconnected			= -7				&& No Reconectado
					__lockModeErrorCommit			= -6				&& Error al aplicar Commit en transacción de solo lectura
					__lockModeErrorTransaction		= -5				&& Error al preparar Transacción de solo lectura Automática
					__commandSqlNotFinished			= -4				&& Comando SQL se sigue ejecutando
					__commandSqlEmpty 				= -3				&& Falta instrucción SQL
					__handleNotConnected			= -2				&& No conectado al servidor
					__commandSqlError				= -1 				&& Error en Instrucción SQL
					__commandSqlExecuted			= 1					&& SQL ejecutado correctamente
					__commandSqlSequence			= false				&& Para no solicitar __sqlRecordsArray (Registros Afectados)
					__transactionReadOnly			= 1					&& Iniciar Transacción de Solo lectura
					__transactionNotStarted			= 0					&& No hay una transacción Iniciada
					__transactionReadOnlyAutomatic	= false				&& Transacción Automática de Solo Lectura
					this.error_OdbcInSql			= false				&& Inicializa en false la propiedad de error SQL
					this.error_ODBC					= 0					&& Inicializa en 0 la propiedad de Código de Error ODBC
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__commandSql) <> "C" OR EMPTY(ALLTRIM(__commandSql))
						RETURN this.Post(Program(),__commandSqlEmpty,false)
					ENDIF
					IF VARTYPE(__cursorName) = "L"
						__commandSqlSequence = __cursorName
						__cursorName = ""
					ELSE
						IF VARTYPE(__cursorName) <> "C"
							__commandSqlSequence = false
							__cursorName = ""
						ENDIF
					ENDIF
				* Verificar Conexión a la Base de Datos
					IF NOT this.Connected(this.handle_Verify)
						* Reconectar
							IF this.handle_Reconnection
								IF NOT this.Reconnection()
									RETURN this.Post(PROGRAM(),__handleNotReconnected,false)
								ENDIF
							ELSE
								RETURN this.Post(Program(),__handleNotConnected,false)
							ENDIF
					ENDIF
				* Preparar Transacción Automática de Solo Lectura si no hay una transacción abierta
					IF NOT this.handle_Transaction > __transactionNotStarted
						IF this.Begin(__transactionReadOnly)
							__transactionReadOnlyAutomatic = true
						ELSE
							RETURN this.Post(Program(),__lockModeErrorTransaction,false)
						ENDIF
					ENDIF
				* Ultima Instrucción SQL enviada
					this.sql_Send = __commandSql
				* Ejecutar Consulta SQL en el Servidor de Base de Datos
					IF __commandSqlSequence
						__commandSqlResult = SQLEXEC(this.handle,__commandSql)
					ELSE
						__commandSqlResult = SQLEXEC(this.handle,__commandSql,__cursorName,__sqlRecordsArray)
						* Registros devueltos o afectados
							this.sql_Records = __sqlRecordsArray(2)
					ENDIF
					* Capturar Errores ODBC en SQL del último comando enviado
						AERROR(this.error_array)

				* Finalizar Transacción Automática de solo lectura aún si hubo error en el comando SQL
					IF this.handle_Transaction = __transactionReadOnly
						IF __transactionReadOnlyAutomatic
							IF NOT this.Commit()
								RETURN this.Errors(Program(),__lockModeErrorCommit,false)
							ENDIF
						ENDIF
					ENDIF
				* Desconectar o Permanecer Conectado al servidor
					IF NOT this.handle_Network
						this.disconnect()
					ENDIF
				* Verificar Resultado
					DO CASE
						CASE __commandSqlResult = -1
							* Notificar que hubo error ODBC en el último comando SQL enviado
								this.error_OdbcInSql = true
								this.error_Odbc = this.error_array[5]
							RETURN this.Errors(Program(),__commandSqlError,false)
						CASE __commandSqlResult = 0
							* Notificar que hubo error ODBC en el último comando SQL enviado
								this.error_OdbcInSql = true
								this.error_Odbc = this.error_array[5]
							RETURN this.Errors(Program(),__commandSqlNotFinished,false)
						CASE __commandSqlResult = 1
							RETURN this.Post(Program(),__commandSqlExecuted,true)
					ENDCASE
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Begin
				LPARAMETERS __transactionType as Integer
				LOCAL __handleNotConnected, __transactionNotStarted, __transactionAlreadyInitiated, ;
					  __transactionInitiated, __transactionTypeReadOnly, __transactionTypeWrite, ;
					  __transactionTypeRemote, __transactionTypeInvalid, __handleNotReconnected
				* Begin
					* Inicia una transacción de lectura y escritura, local y Remota
				* Parámetros	
					* __transactionType, determina el tipo de transacción
					* 1 Transacción Solo Lectura
					* 2 Transacción Lectura y Escritura Local y Remota
					* 3 Transacción Lectura y Escritura Remota
				* Valor devuelto
					* true	Transacción Iniciada
					* false	No se inició la Transacción
				* Error devuelto
					__handleNotReconnected			= -4			&& No Reconectado al servidor
					__transactionTypeInvalid		= -3			&& Tipo de Transacción no valido
					__handleNotConnected			= -2			&& No conectado al servidor
					__transactionErrorNotStarted	= -1			&& Transacción error no iniciada
					__transactionAlreadyInitiated	= 0				&& Transacción ya iniciada
					__transactionInitiated			= 1				&& Transacción Iniciada
					__transactionNotStarted			= 0				&& No hay una transacción Iniciada
					__transactionTypeReadOnly		= 1				&& Transacción de Solo Lectura
					__transactionTypeWrite			= 2				&& Transacción de Lectura y Escritura Local y Remota
					__transactionTypeRemote			= 3				&& Transacción de Lectura y Escritura Remota
				* Validar Parámetros
					IF PCOUNT() = 0	
						__transactionType = __transactionTypeReadOnly
					ELSE
						IF VARTYPE(__transactionType) <> "N" OR (__transactionType <= 0 OR __transactionType > 3)
							RETURN this.Post(Program(),__transactionTypeInvalid,false)
						ENDIF
					ENDIF
				* Verificar si no hay una transacción
					IF this.handle_Transaction > 0
						IF this.handle_Transaction = __transactionType 
							RETURN this.Post(Program(),__transactionAlreadyInitiated,true)
						ELSE
							RETURN this.Post(Program(),__transactionAlreadyInitiated,false)
						ENDIF
					ENDIF
				* Verificar Conexión a la Base de Datos
					IF NOT this.Connected(this.handle_Verify)
						* Reconectar
							IF this.handle_Reconnection
								IF NOT this.Reconnection()
									RETURN this.Post(PROGRAM(),__handleNotReconnected,false)
								ENDIF
							ELSE
								RETURN this.Post(Program(),__handleNotConnected,false)
							ENDIF
					ENDIF
				* Preparar Transacción de Lectura y Escritura
					DO case
						CASE __transactionType = __transactionTypeReadOnly 		&& Solo Lectura
							DO CASE
								CASE this.engine = this.mySql
									IF this.mysql_Compatibility 	&& Compatibilidad con Mysql inferior a 5.6
										__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_MySql
									ELSE
										__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_MySql
									ENDIF
								CASE this.engine = this.mariaDb
									__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_MariaDb
								CASE this.engine = this.fireBird
									__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_FireBird
								CASE this.engine = this.postgreSql
									__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Select_PostgreSql
								CASE this.engine = this.sqlServer
								CASE this.engine = this.sqlLite
							ENDCASE
						CASE __transactionType		= __transactionTypeWrite ;			&& Lectura y Escritura
							 OR __transactionType	= __transactionTypeRemote			&& Remota
							DO CASE
								CASE this.engine = this.mySql
									__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_MySql
								CASE this.engine = this.mariaDb
									__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_MariaDb
								CASE this.engine = this.fireBird
									__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_FireBird
								CASE this.engine = this.postgreSql
									__commandSql = "SET TRANSACTION " + this.handle_Transaction_Mode_Update_PostgreSql
								CASE this.engine = this.sqlServer
							ENDCASE
					ENDCASE
				* Iniciar transacción
					IF SQLEXEC(this.handle,__commandSql,"") = __transactionInitiated
						* Iniciar transacción en Cursores locales
							IF __transactionType = __transactionTypeWrite
								BEGIN TRANSACTION
							ENDIF
						this.handle_Transaction = __transactionType
						RETURN this.Post(Program(),__transactionInitiated,true)
				 	ELSE
						this.handle_Transaction = __transactionNotStarted
						RETURN this.Post(Program(),__transactionErrorNotStarted,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Commit
				LOCAL __transactionError, __transactionNotStarted, __transactionApplied, __transactionTypeWrite
				* Commit
					* Aplicar una transacción activa
				* Parámetros	
					* No requiere
				* Valor devuelto
					* true	Transacción Aplicada
					* false	No se aplicó la Transacción
				* Error devuelto
					__transactionError				= -1			&& No se Aplicó la transacción
					__transactionNotStarted			= 0				&& No hay una transacción Iniciada
					__transactionApplied			= 1				&& Transacción Aplicada
					__transactionTypeWrite			= 2				&& Transacción de Lectura y Escritura Local y Remota
				* Verificar si hay una transacción Activa
					IF this.handle_Transaction > __transactionNotStarted
						IF SQLCOMMIT(this.handle) = __transactionApplied
							&& Commit VFP Guardar Cursores locales
								IF this.handle_Transaction = __transactionTypeWrite
									END TRANSACTION
								ENDIF
							this.handle_Transaction = __transactionNotStarted
							* Desconectar
								IF NOT this.handle_Network
									this.Disconnect()
								ENDIF
							RETURN this.Post(Program(),__transactionApplied,true)
						ELSE
					 		RETURN this.Errors(Program(),__transactionError,false)
						ENDIF
					ELSE
						RETURN this.Post(Program(),__transactionNotStarted,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Rollback
				LOCAL __transactionNotCanceled, __transactionNotStarted, __transactionCanceled, __transactionTypeWrite
				* Rollback
					* Cancelar una transacción activa
				* Parámetros	
					* No requiere
				* Valor devuelto
					* true	Transacción Cancelada
					* false	No se canceló la Transacción
				* Error devuelto
					__transactionNotCanceled		= -1			&& No se canceló la transacción
					__transactionNotStarted			= 0				&& No hay una transacción Iniciada
					__transactionCanceled			= 1				&& Transacción Cancelada
					__transactionTypeWrite			= 2				&& Transacción de Lectura y Escritura Local y Remota
				* Verificar si no hay una transacción
					IF this.handle_Transaction > __transactionNotStarted
						IF SQLROLLBACK(this.handle) = __transactionCanceled
							&& RollBack VFP Deshacer Cursores locales
								IF this.handle_Transaction = __transactionTypeWrite
									ROLLBACK
								ENDIF
							this.handle_Transaction = __transactionNotStarted
							* Desconectar
								IF NOT this.handle_Network
									this.Disconnect()
								ENDIF
							* Aplicar Go Top a los cursores locales
								this.TablesGoTop()
							RETURN this.Post(Program(),__transactionCanceled,true)
						ELSE
					 		RETURN this.Errors(Program(),__transactionError,false)
						ENDIF

					ELSE
						RETURN this.Post(Program(),__transactionNotStarted,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------
	
	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Use
				LPARAMETERS __tableNameAliasCursorName as Character, __filterWhere as Character, __fieldList as Character
				LOCAL __nameTableInvalid, __tableNameEmpty, __cursorNotOpen, __cursorOpen, __commandSql, __cursorAddDbCursor
			 	* Use 		
			 		* Abrir Cursor en memoria a partir del nombre de la tabla del servidor
				* Parámetros
					* __tableNameAliasCursorName, Nombre de la Tabla real del servidor de base de datos (opcional Alias para especificar nombre del cursor)
					* __filterWhere, Filtro, debe incluir la cláusula WHERE para aplicar el filtro (opcional)
					* __fieldList, Lista de Campos a mostrar (opcional)
				* Valor devuelto
					* true	Cursor Abierto listo para usar
					* false	Cursor No abierto
				* Error devuelto
					__nameTableInvalid			= -3				&& Nombre de Tabla invalido
					__tableNameEmpty			= -2				&& Nombre de tabla vacío
					__cursorNotOpen				= -1				&& Cursor No abierto
					__cursorOpen				= 1					&& Cursor abierto
					__commandSql				= ""				&& Comando SQL para abrir el cursor
					__cursorAddDbCursor			= 1					&& Agregar a DbCursor
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__tableNameAliasCursorName) <> "C" OR EMPTY(ALLTRIM(__tableNameAliasCursorName))
						RETURN this.Post(Program(),__tableNameEmpty,false)
					ENDIF
					IF VARTYPE(__filterWhere) <> "C" OR EMPTY(ALLTRIM(__filterWhere))
						__filterWhere = ""
					ENDIF
					IF VARTYPE(__fieldList) <> "C" OR EMPTY(ALLTRIM(__fieldList))
						__fieldList = "*"
					ENDIF
				* Obtener Nombre de la Tabla y Cursor
					__tableName  = this.GetNameInString(__tableNameAliasCursorName,"T")
					__cursorName = this.GetNameInString(__tableNameAliasCursorName,"C")
					IF EMPTY(ALLTRIM(__tableName)) OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__nameTableInvalid,false)
					ENDIF
				* Preparar Instrucción SQL
					__commandSql = "Select " + __fieldList + " From " + __tableName + " " + __filterWhere
				* Crear Cursor
					IF this.Sql(__commandSql,__cursorName)
						* Agregar a dbCursor
							this.dbCursor(__cursorName,__cursorAddDbCursor,__commandSql,__tableName)
						* Seleccionar
							SELECT (__cursorName)
							RETURN this.Post(Program(),__cursorOpen,true)
				 	ELSE
						RETURN this.Post(Program(),__cursorNotOpen,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------
	
	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Engine_Version
			LOCAL __notAvailable, __versionGenerated, __currentVersion, __commandSql
				* Engine_Version
					* Devuelve la Versión del Servidor de Base de datos
				* Parámetros
					* No Requiere
				* Valor devuelto
					* Carácter, Versión del Servidor de Base de datos
				* Error Devuelto
					__notAvailable			= 0			&& No disponible
					__versionGenerated		= 1			&& Versión Obtenida
					__currentVersion		= ""		&& Versión Actual
					__commandSql 			= ""		&& Generar Comando según Servidor de Base de datos
				* Seleccionar Motor
					DO case
						CASE this.engine = this.mySql
							__commandSql = "SELECT VERSION() AS VERSION"
						CASE this.engine = this.mariaDb
							__commandSql = "SELECT VERSION() AS VERSION"
						CASE this.engine = this.fireBird
							__commandSql = "SELECT RDB$GET_CONTEXT('SYSTEM', 'ENGINE_VERSION') as version FROM RDB$DATABASE;"
						CASE this.engine = this.postgreSql
							RETURN this.Post(Program(),__notAvailable,"")
						CASE this.engine = this.sqlServer
							RETURN this.Post(Program(),__notAvailable,"")
					ENDCASE
				* Obtener Versión
					IF this.Sql(__commandSql,"foxydb_version")
						__currentVersion = foxydb_version.version
						USE IN foxydb_version
						RETURN this.Post(Program(),__versionGenerated,__currentVersion)
				 	ELSE
						RETURN this.Post(Program(),__commandSqlError,"")
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Uuid
			LOCAL __commandSqlError, __notAvailable, __generated, __uuidGenerated, __commandSql
				* UUID
					* Generar valor UUID (Identificador universalmente único)
				* Parámetros
					* No Requiere
				* Valor devuelto
					* Carácter, Código Único Universal o Vacío
				* Error Devuelto
					__commandSqlError	= -1		&& Error SQL al devolver UUID
					__notAvailable		= 0			&& No disponible
					__generated			= 1			&& Generado
					__uuidGenerated		= ""		&& UIID Generado
					__commandSql 		= ""		&& Generar Comando según Servidor de Base de datos
				* Seleccionar Motor
					DO case
						CASE this.engine = this.mySql
							__commandSql = "SELECT UUID() as UUID"
						CASE this.engine = this.mariaDb
							__commandSql = "SELECT UUID() as UUID"
						CASE this.engine = this.fireBird
							__commandSql = "SELECT UUID_TO_CHAR(GEN_UUID()) AS UUID FROM RDB$DATABASE"
						CASE this.engine = this.postgreSql
							RETURN this.Post(Program(),__notAvailable,"")
						CASE this.engine = this.sqlServer
							RETURN this.Post(Program(),__notAvailable,"")
					ENDCASE
				* Generar UUID
					IF this.Sql(__commandSql,"foxydb_uuid")
						__uuidGenerated = foxydb_uuid.uuid
						USE IN foxydb_uuid
						RETURN this.Post(Program(),__generated,__uuidGenerated)
				 	ELSE
						RETURN this.Post(Program(),__commandSqlError,"")
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE New
				LPARAMETERS __tableNameAliasCursorName as Character, __idFieldName as Character, __fieldList as Character
				LOCAL __cursorNotEdit, __tableNameEmpty, __cursorNotOpen, __cursorReadyForUse
			 	* New
			 		* Abrir un Cursor vació listo para Editar a partir de una tabla del servidor
				* Parámetros
					* __tableNameAliasCursorName, Nombre de la Tabla real del servidor de base de datos (opcional Alias para especificar nombre del cursor)
					* __idFieldName, Nombre del campo ID AutoIncremental Primary Key (Default el especificado en la propiedad id_name)
				* Valor devuelto
					* true	Cursor vacío Abierto listo para editar
					* false	Cursor No abierto
				* Error Devuelto
					__cursorNotEdit				= -5		&& Cursor abierto pero no editable
					__tableNameEmpty			= -2		&& Nombre de la tabla vacío
					__cursorNotOpen				= -1		&& Cursor no abierto
					__cursorReadyForUse			= 1			&& Cursor abierto y listo para editar
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__tableNameAliasCursorName) <> "C" OR EMPTY(ALLTRIM(__tableNameAliasCursorName))
						RETURN this.Post(Program(),__tableNameEmpty,false)
					ENDIF
					IF VARTYPE(__idFieldName) <> "C" OR EMPTY(ALLTRIM(__idFieldName))
						__idFieldName = this.id_name
					ENDIF
					IF VARTYPE(__fieldList) <> "C" OR EMPTY(ALLTRIM(__fieldList))
						__fieldList = ""
					ENDIF
				* Crear Cursor Nuevo
					IF this.Use(__tableNameAliasCursorName,"where " + __idFieldName + " = -1",__fieldList)
						IF this.CursorEdit(__tableNameAliasCursorName)
							RETURN this.Post(Program(),__cursorReadyForUse,true)
						ELSE
							RETURN this.Post(Program(),__cursorNotEdit,false)
						ENDIF
				 	ELSE
						RETURN this.Post(Program(),__cursorNotOpen,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------


	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE GetNameInString
				LPARAMETERS __nameToSearch as Character, __typeName as Character
				LOCAL __typeNameTabla, __typeNameCursor, __nameWordCount, _nameWordArray
				* GetNameInString
					* Obtener Nombre de Tabla (T) o Nombre de Cursor (C) dentro de la cadena de caracteres
				* Parámetros
					* __nameToSearch, nombre a buscar
					* __typeName, Tipo de nombre a Buscar 1 Tabla, 2 Cursor
				* Valor devuelto
					* Carácter, Con nombre devuelto o vacío
				* Error Devuelto
					__typeNameInvalid			= -2		&& Tipo de búsqueda invalido
					__nameToSearchEmpty			= -1		&& Nombre a buscar vacío
					__nameFound					= 1			&& Nombre encontrado
					__typeNameTabla 			= "T"		&& Tabla
					__typeNameCursor			= "C"		&& Cursor
					DIMENSION __nameWordArray[1]
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__nameToSearch) <> "C" OR EMPTY(ALLTRIM(__nameToSearch))
						RETURN this.Post(Program(),__nameToSearchEmpty,"")
					ENDIF
					IF VARTYPE(__typeName) <> "C"
						RETURN this.Post(Program(),__typeNameInvalid,"")
					ENDIF
				* Eliminar espacios en blanco al principio y final, espacios dobles o triples entre palabras
					__nameToSearch = STRTRAN( STRTRAN(LTRIM(ALLTRIM(__nameToSearch)),"  "," "),"   "," ")
				* Obtener Array y cantidad de elementos de la cadena
					__nameWordCount = ALINES(__nameWordArray,__nameToSearch,true," ")
					IF __nameWordCount = 1
						RETURN this.Post(Program(),__nameFound,__nameToSearch)
					ENDIF
				* Obtener Nombre según el tipo
					DO case
						CASE __typeName = __typeNameTabla			&& Tabla
							IF __nameWordCount = 3
								RETURN this.Post(Program(),__nameFound,__nameWordArray(1))
							ENDIF
						CASE __typeName = __typeNameCursor			&& Cursor
							IF __nameWordCount = 3
								RETURN this.Post(Program(),__nameFound,__nameWordArray(3))
							ENDIF
						OTHERWISE
							RETURN this.Post(Program(),__typeNameInvalid,"")
					ENDCASE
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE GetTableNameInSql
				LPARAMETERS __commandSql as Character
				LOCAL __commandSqlEmpty, __nameWordArray, __nameWordCount, __nameTableFound, __nameTableEmpty
				* GetTableNameInSql
					* Obtener Nombre de Tabla dentro de comando Sql Select
				* Valor devuelto
					* Carácter, nombre de la tabla
				* Error devuelto
					__commandSqlEmpty		 		= -1		&& Comando SQL Vacío
					__nameTableNotFound				= 0			&& Nombre de tabla No Encontrado
					__nameTableFound				= 1			&& Nombre de la tabla Encontrado
					DIMENSION __nameWordArray[1]				&& Array para obtener nombre de Tabla
					__nameTableEmpty				= ""		&& Nombre de Tabla vacía
					__nameTable						= ""		&& Nombre de la Tabla
					_nameTableInList				= false		&& Nombre de Tabla en Lista
				* Validar Parámetros
					IF VARTYPE(__commandSql) <> "C" OR EMPTY(ALLTRIM(__commandSql))
						RETURN this.Post(Program(),__commandSqlEmpty,__nameTableEmpty)
					ENDIF
				* Obtener cadena después de la palabra "FROM"
					__commandSql = ALLTRIM(SUBSTR(__commandSql,AT("FROM",UPPER(__commandSql))+4))
				* Eliminar espacios
					__commandSql = STRTRAN(__commandSql, chr(13), ' ')
					__commandSql = STRTRAN(__commandSql, chr(10), ' ')
					__commandSql = STRTRAN(__commandSql, chr(9), ' ')
				* Obtener Array con cantidad de elementos de la cadena
					FOR __nameWordCount = 1 TO ALINES(__nameWordArray,__commandSql,true," ")
						IF NOT EMPTY(ALLTRIM(__nameWordArray(__nameWordCount)))
							RETURN this.Post(Program(),__nameTableFound,ALLTRIM(__nameWordArray(__nameWordCount)))
						ENDIF
					NEXT
					RETURN this.Post(Program(),__nameTableNotFound,__nameTableEmpty)
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
		PROCEDURE Undo
			LOCAL __cursorNotChanges, __CursorChangesReversed,__transactionRollBack, __cursorContainsChanges, ;
				  __cursorCount, __transactionError, __cursorName
			* Undo
				* Deshacer Cambios en todos los Cursores y Finaliza una transacción activa 
			* Valor devuelto
				* true	Cambios Revertidos
				* false	No se pudieron Revertir los cambios
			* Error devuelto
				__cursorNotChanges			= 0			&& No hay Cambios para Deshacer
				__CursorChangesReversed		= 1			&& Cambios Revertidos
				__cursorContainsChanges	 	= false		&& Saber si se revirtieron cambios
				__transactionError			= -1		&& Error en transacción
				__cursorName				= ""		&& Nombre del cursor a deshacer cambios
				__transactionNotStarted			= 0				&& No hay una transacción Iniciada
				__transactionTypeReadOnly		= 1				&& Transacción de Solo Lectura
				__transactionTypeWrite			= 2				&& Transacción de Lectura y Escritura Local y Remota
				__transactionTypeRemote			= 3				&& Transacción de Lectura y Escritura Remota
			* Enviar RollBack a Transacción si hay una activa
				DO case
					CASE this.handle_Transaction = __transactionTypeReadOnly
						IF NOT this.Commit()
							RETURN this.Post(Program(),__transactionError,false)
						ENDIF
					CASE this.handle_Transaction = __transactionTypeWrite OR this.handle_Transaction = __transactionTypeRemote
						IF NOT this.RollBack()
							RETURN this.Post(Program(),__transactionError,false)
						ENDIF
				ENDCASE
			* Deshacer Cambios en Cursores agregados a DBCURSOR
				IF this.Changes()
					SELECT dbcursor
					SCAN
						IF this.CursorChanges(ALLTRIM(dbcursor.cursor))
							IF TABLEREVERT(true,ALLTRIM(dbcursor.cursor)) >= 1
								__cursorContainsChanges = true
							ENDIF
						ENDIF
					ENDSCAN
					IF __cursorContainsChanges
						RETURN this.Post(Program(),__CursorChangesReversed,true)
					ELSE
						RETURN this.Post(Program(),__cursorNotChanges,true)
					ENDIF
				ELSE
					RETURN this.Post(Program(),__cursorNotChanges,true)
				ENDIF
		ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE CursorOpen
				LPARAMETERS __cursorName as Character
				LOCAL __cursorNameEmpty, __cursorNotOpen, __cursorOpen
			 	* CursorOpen
			 		* Verificar si el Cursor está Abierto
				* Parámetros
					* __cursorName, Nombre del Cursor a verificar si está abierto
				* Valor devuelto
					* true 	Cursor Abierto
					* false	Cursor no abierto
				* Error devuelto
					__cursorNameEmpty	= -2		&& Falta nombre del cursor
					__cursorNotOpen		= 0			&& Cursor No abierto
					__cursorOpen		= 1			&& Cursor Abierto
			 	* Verificar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
				* Abierto
					IF USED(__cursorName)
						RETURN this.Post(Program(),__cursorOpen,true)
					ELSE
						RETURN this.Post(Program(),__cursorNotOpen,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE CursorEdit
				LPARAMETERS __cursorName as Character
				LOCAL __cursorNameEmpty , __cursorNotEditable, __cursorEditable
				* CursorEdit
					* Hacer Cursor editable (Aplica Buffering 5)
				* Parámetros
			 		* __cursorName, Nombre del Cursor para hacer editable
				* Valor devuelto
					* true 	Cursor Editable
					* false	Cursor No Editable
				* Error devuelto
			 		__cursorNameEmpty 		= -2		&& Error falta nombre del cursor
					__cursorNotEditable 	= -1		&& Cursor No Editable (Error al Aplicar Buffering 5)
					__cursorEditable		= 1			&& Cursor Editable
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
				* Aplicar Buffering 5
					IF CURSORSETPROP("Buffering", 5,__cursorName)
						RETURN this.Post(Program(),__cursorEditable,true)
					ELSE
						RETURN this.Post(Program(),__cursorNotEditable,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE CursorCount
				LOCAL __cursorsCounted
				* CursorCount
					* Devuelve la Cantidad de Cursores abiertos y Array con Nombres
				* Parámetros
					* No requiere
				* Valor devuelto
					* Numérico, cantidad de cursores abiertos
				* Error devuelto
					__cursorsCounted	= 1		&& Cursores Contados
				* Contar
					RETURN this.Post(Program(),__cursorsCounted,AUSED(this.cursor_Array))
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE CursorClose
				LPARAMETERS __cursorName as Character, __cursorClosingForce as Boolean
				LOCAL __cursorNameEmpty, __cursorClosed, __cursorContainsChanges, __cursorNameClosed
				* Close
					* Cerrar un cursor abierto
				* Parámetros
					* __CursorName, Nombre del Cursor a Cerrar
					* __cursorClosingForce, Forzar cierre aun cuando tengan cambios por confirmar
				* Valor devuelto
					* true 	Cerrado
					* false	No Cerrado
				* Error devuelto
					__cursorNameEmpty			= -1		&& Nombre del Cursor Vacío
					__cursorClosed				= 1			&& Cursor Cerrado
					__cursorContainsChanges		= 0			&& Cursor Contiene Cambios Pendientes
					__cursorNameDelete			= 2			&& Constante para Eliminar Cursor en DBCURSOR
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(__cursorName)
						RETURN this.Post(Program(),__cursorNameEmpty,true)
					ENDIF
					IF VARTYPE(__cursorClosingForce) <> "L"
						__cursorClosingForce = false
					ENDIF
				* Verificar Cambios
					IF this.CursorChanges(__cursorName)
						IF __cursorClosingForce
							= TABLEREVERT(true,__cursorName)
						ELSE
							RETURN this.Post(Program(),__cursorContainsChanges,false)
						ENDIF
					ENDIF
				* Cerrar Cursor
					USE IN (__cursorName)
				* Quitar de dbCursor
					this.dbCursor(__cursorName,__cursorNameDelete)
				RETURN this.Post(Program(),__cursorClosed,true)
			ENDPROC
	*** --------------------------------------------------------------------------------------------
	
	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE CursorChanges
				LPARAMETERS __cursorName as String
				LOCAL __cursorNotBuffering, __cursorNameEmpty, __cursorNotChanges, __cursorChanges
				* Changes
					* Saber si hay Cambios en un Cursor
				* Parámetros
					* __CursorName, Nombre del Cursor a Verificar Cambios
				* Valor devuelto
					* true 	Contiene Cambios
					* false	No Contiene Cambios
				* Error devuelto
					__cursorNotBuffering 		= -5		&& El cursor no es editable
					__cursorNameEmpty			= -1		&& Nombre del Cursor vació
					__cursorNotChanges 			= 0			&& El cursor no contiene cambios
					__cursorChanges				= 1			&& El cursor contiene cambios
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
				* Verificar cambios
					IF CURSORGETPROP("Buffering",__cursorName) = 5
						IF GETNEXTMODIFIED(0,__cursorName) <> 0
							RETURN this.Post(Program(),__cursorChanges,true)
						ELSE
							RETURN this.Post(Program(),__cursorNotChanges,false)
						ENDIF
					ELSE
						RETURN this.Post(Program(),__cursorNotBuffering,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------
	
	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Changes
				LOCAL __cursorNotChanges, __cursorChanges, __cursorCount
				* Changes
					* Saber si hay Cambios en los cursores abiertos en DbCursor
				* Parámetros
					* No requeridos
				* Valor devuelto
					* true 	(Hay Cambios en los cursores)
					* false	(No hay Cambios)
				* Error devuelto
					__cursorNotChanges 	= 0			&& No hay Cambios
					__cursorChanges		= 1			&& Hay Cambios
				* Verificar cambios en Cursores
					IF USED("dbcursor")
						SELECT dbcursor
						SCAN
							IF this.CursorChanges(ALLTRIM(dbcursor.cursor))
								RETURN this.Post(Program(),__cursorChanges,true)
							ENDIF
						ENDSCAN
					ENDIF
					RETURN this.Post(Program(),__cursorNotChanges,false)
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
		 	PROCEDURE Query
		 		LPARAMETERS __commandSql as Character, __cursorName as Character
		 		LOCAL __commandSqlEmpty, __cursorNameEmpty, __commandSqlError, __cursorReadyToUse, ;
					  __cursorAddDbCursor, __tableName
		 		* Query
					* Abrir cursor por medio de una consulta SQL al servidor
				* Parámetros
					* __commandSql, Instrucción SQL para generar la consulta al servidor y obtener el Cursor
					* __cursorName, Nombre del Cursor que será devuelto por la consulta
				* Valor devuelto
					* true 	Consulta Realizada
					* false	Error en consulta
				* Error devuelto
					__commandSqlEmpty			= -2				&& Falta instrucción o comandos SQL
					__commandSqlError			= -1				&& Error en Instrucción SQL
					__cursorReadyForUse			= 1					&& Cursor listo para usar
					__cursorAddDbCursor			= 1					&& Agregar a DbCursor
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__commandSql) <> "C" OR EMPTY(ALLTRIM(__commandSql))
						RETURN this.Post(Program(),__commandSqlEmpty,false)
					ENDIF
					* Nombre de la Tabla
						__tableName = this.GetTableNameInSql(__commandSql)
					* Nombre del Cursor
						IF VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
							__cursorName = __tableName
						ENDIF
				* Abrir Cursor
					IF this.Sql(__commandSql,__cursorName)
						* Agregar a dbCursor
							this.dbCursor(__cursorName,__cursorAddDbCursor,__commandSql,__tableName)
						* Seleccionar 
							SELECT (__cursorName)
						* Listo
							RETURN this.Post(Program(),__cursorReadyForUse,true)
				 	ELSE
					 	RETURN this.Post(Program(),__commandSqlError,false)
					ENDIF
		 	ENDPROC
	*** --------------------------------------------------------------------------------------------
	
	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Close
				LPARAMETERS __cursorClosingForce as Boolean
				LOCAL __cursorClosed, __cursorNotClosed, __cursorCloasedAll, __cursorCount
				* Close
					* Cerrar todos los cursores abiertos en DbCursor
				* Parámetros
					* __cursorClosingForce, Forzar cierre de todos los cursores aun cuando tengan cambios por confirmar.
				* Valor devuelto
					* true 	Cerrados
					* false	No Cerrados
				* Error devuelto
					__cursorNotClosed			= 0			&& Algún Cursor no Cerrado
					__cursorClosed				= 1			&& Cursores Cerrados
					__cursorCloasedAll 			= true		&& Saber si se cerraron todos los cursores
				* Verificar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorClosingForce) <> "L"
						__cursorClosingForce = false
					ENDIF
				* Cerrar Cursores
					FOR __cursorCount = 1 TO this.CursorCount()
						IF !UPPER(this.cursor_Array(__cursorCount,1)) == "DBCURSOR"
							IF this.CursorClose(this.cursor_Array(__cursorCount,1),__cursorClosingForce)
								* Continuar Cerrando
							ELSE
								__cursorCloasedAll = false
							ENDIF
						ENDIF
					NEXT
				* Resultado
					IF __cursorCloasedAll
						RETURN this.Post(Program(),__cursorClosed,true)
					ELSE
						RETURN this.Post(Program(),__cursorNotClosed,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Id
				LOCAL __idNotReturned, __notAvailable, __idReturned, __commandSql
				* Id
					* Obtener el Ultimo ID al insertar un Registro Nuevo, el valor se obtiene en la propiedad .id_Last
				* Parámetros
					* No Requiere
				* Valor devuelto
					* true	Ultimo ID obtenido
					* false	No se pudo obtener el Ultimo ID
				* Error Devuelto
					__idNotReturned			= -1	&& ID no obtenido
					__notAvailable			= 0		&& No disponible
					__idReturned			= 1		&& ID Obtenido
					__commandSql			= ""	&& Comando SQL según el motor de base de datos
					this.Id_last 			= 0		&& Iniciar valor de Ultimo ID Insertando en Cero
				* Generar Comando Sql
					DO CASE
						CASE this.engine = this.mySql
							__commandSql = "SELECT LAST_INSERT_ID() as id"
						CASE this.engine = this.mariaDb
							__commandSql = "SELECT LAST_INSERT_ID() as id"
						CASE this.engine = this.fireBird
							IF USED("foxydb_last_id")
								this.id_last = foxydb_last_id.id
								USE IN foxydb_last_id
								RETURN this.Post(Program(),__idReturned,true)
							ELSE
								RETURN this.Post(Program(),__idNotReturned,false)
							ENDIF
						CASE this.engine = this.postgreSql
							RETURN this.Post(Program(),__notAvailable,false)
						CASE this.engine = this.sqlServer
							RETURN this.Post(Program(),__notAvailable,false)
					ENDCASE
				* Obtener Ultimo Id
					IF this.Sql(__commandSql,"foxydb_last_id")
						this.id_last = INT(VAL(foxydb_last_id.id))
						USE IN foxydb_last_id
						RETURN this.Post(Program(),__idReturned,true)
					ELSE
						RETURN this.Post(Program(),__idNotReturned,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Tables
				LPARAMETERS __cursorName as Character, __tableTypes as Character
				LOCAL __cursorNameEmpty, __tablesReady, __commandSqlError
				* Tables
					* Devuelve Cursor con listado de Tablas de la base de datos
				* Parámetros
					* __cursorName, Nombre del Cursor a devolver listado de tablas
					* __tableTypes, Listado de Tipos de Tablas ejemplo: " 'TABLE,' 'VIEW,' 'SYSTEM TABLE,' "
				* Valor devuelto
					* true	Listado Correcto
					* false	No se pudo obtener el listado
				* Error devuelto
					__cursorNameEmpty		= -2				&& Nombre del cursor vacío
					__commandSqlError		= -1				&& Error al obtener el listado
					__tablesReady			= 1					&& Listado Listo
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
					IF VARTYPE(__tableTypes) <> "C" OR EMPTY(ALLTRIM(__tableTypes))
						__tableTypes = "TABLE"
					ENDIF
				* Obtener Campos de la tabla
					IF SQLTABLES(this.handle, __tableTypes, __cursorName) = 1
						RETURN this.Post(Program(),__tablesReady,true)
					ELSE
			 			RETURN this.Post(Program(),__commandSqlError,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------
	
	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE TableFields
				LPARAMETERS __tableName as Character, __cursorName as Character, __structureNative as Boolean
				LOCAL __tableNameEmpty, __tableFieldsReady, __commandSqlError
				* TableFields
					* Devuelve Cursor con Campos (estructura) de Tabla de la base de datos
				* Parámetros
					* __tableName, Nombre real de la Tabla de la base de datos
					* __cursorName, Nombre del Cursor a devolver información
					* __structureNative, si muestra la estructura Nativa del servidor o estilo VFP (default)
				* Valor devuelto
					* true	Listado Correcto
					* false	No se pudo obtener el listado
				* Error devuelto
					__tableNameEmpty			= -1
					__tableFieldsReady			= 1
					__commandSqlError			= 0
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__tableName) <> "C" OR EMPTY(ALLTRIM(__tableName))
						RETURN this.Post(Program(),__tableNameEmpty,false)
					ENDIF
					IF VARTYPE(__cursorName) <> "C"
						__cursorName = __tableName
					ENDIF
					IF VARTYPE(__structureNative) <> "L"
						__structureNative = false
					ENDIF
				* Obtener Campos de la tabla
					IF SQLCOLUMNS(this.handle, __tableName, IIF(__structureNative,"NATIVE","FOXPRO"), __cursorName) = 1
						RETURN this.Post(Program(),__tableFieldsReady,true)
					ELSE
			 			RETURN this.Post(Program(),__commandSqlError,false)
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Command
				LPARAMETERS __cursorName as Character, __tableName as Character, __idFieldName as Character, __lastId as Boolean
				LOCAL __idFieldInvalidValue, __idFieldEmpty, __idFieldValueZero, __cursorNameEmpty, __recordNotChanges, __commandSqlReady, ;
					  __commandSql, __typeStateRecord, __updateRecord, __fieldsChangedNumber, __typeStateUpdate, __typeStateDelete, ;
					  __typeStateInsert, __typeStateInsertAndDelete, __fieldCurrent, __fieldsChanges, __fieldsValues, __stringFieldsChanged, ;
					  __fieldValue
				* Command
					* Generar Comando SQL del registro actual del cursor según los cambios hechos, consultar la propiedad .sql_Command para
					* ver el comando SQL generado.
				* Parámetros
					* __tableName, Nombre real de la Tabla de la base de datos
					* __cursorName, Nombre del Cursor a devolver información
					* __idFieldName, Nombre del campo ID Primaty Key Autoincremental
					* __lastId,	Si se obtiene el Ultimo Id insertado
				* Valor devuelto
					* true	Commando Sql generado
					* false	Error al Generar comando Sql
				* Error devuelto
					__idFieldInvalidValue		= -5			&& Campo ID valor invalido
					__idFieldEmpty				= -4			&& Campo ID está vacío
					__idFieldValueZero			= -3			&& Campo ID valor cero			
					__cursorNameEmpty			= -2			&& Nombre del cursor vacío
					__recordNotChanges			= 0				&& No tiene cambios el registro
					__commandSqlReady			= 1				&& Comando SQL generado 
					__commandSql				= ""			&& Comando SQL a generar
					__typeStateRecord			= 0				&& Para obtener el Estado del Registro
					__updateRecord				= false			&& Para saber si hay cambios en el registro
					__fieldsChangedNumber		= 0				&& Para iniciar ciclo y recorrer los campos modificados
					__typeStateUpdate			= 1				&& Estado del registro Modificado
					__typeStateDelete			= 2				&& Estado del registro Eliminado
					__typeStateInsert			= 3				&& Estado del registro insertado
					__typeStateInsertAndDelete	= 4				&& Se agregó un registro nuevo pero fue eliminado
					__fieldCurrent 				= false			&& Campo Actual
					__fieldsChanges				= ""			&& Campos Modificados
					__fieldsValues				= ""			&& Valores de Campos
					__stringFieldsChanged		= ""			&& Obtener cadena de estado de los campos del cursor en el registro
					this.sql_Command			= ""			&& Instrucción SQL que se va a generar
					this.id_Active				= false			&& Desactivar solicitud de Ultimo ID Insertado
					this.sql_CommandType		= 0				&& Iniciar a 0 el tipo de Comando SQL que se retornara
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
					IF VARTYPE(__tableName) <> "C" OR EMPTY(ALLTRIM(__tableName))
						__tableName = __cursorName
					ENDIF
					IF VARTYPE(__idFieldName) <> "C" OR EMPTY(ALLTRIM(__idFieldName))
						__idFieldName = ALLTRIM(this.id_name)
					ENDIF
				* Obtener Estado Global del Registro
					__typeStateRecord = GETFLDSTATE(0,__cursorName)
				* Campos del Cursor
					SELECT (__cursorName)
					nCampos = AFIELDS(arrayFieldList)
				* Campo ID autoincremental (Primary Key) de Tabla y Cursor
					__idFieldTableName = __tableName + "." + __idFieldName
					__fieldValue = __cursorName + "." + __idFieldName
				* Validar Cambios en el Registro
					DO case
						CASE __typeStateRecord = __typeStateUpdate OR __typeStateRecord = __typeStateInsert
							__stringFieldsChanged = GETFLDSTATE(-1,__cursorName)
							FOR a = 1 TO nCampos
								SELECT foxydb_TableFields
								SCAN FOR ALLTRIM(UPPER(ALLTRIM(foxydb_TableFields.field_name))) == ALLTRIM(UPPER((arrayFieldList(a,1))))
									SELECT (__cursorName)
									IF GETFLDSTATE(arrayFieldList(a,1)) = 2 OR GETFLDSTATE(arrayFieldList(a,1)) = 4
										__updateRecord = true
										EXIT
									ENDIF
									SELECT foxydb_TableFields
								ENDSCAN
							NEXT

						CASE __typeStateRecord = __typeStateDelete
							__updateRecord = true
					ENDCASE
				* Validar Campo ID AutoIncremental Primary Key del Cursor que no este vacío o sea CERO
					IF __updateRecord
						IF __typeStateRecord <> __typeStateInsert
							DO case
								CASE VARTYPE(EVALUATE(__fieldValue)) = "N"
									IF EVALUATE(__fieldValue) = 0
										RETURN this.Post(Program(),__idFieldValueZero,false)
									ENDIF
								CASE VARTYPE(EVALUATE(__fieldValue)) = "C"
									IF EMPTY(ALLTRIM(EVALUATE(__fieldValue)))
										RETURN this.Post(Program(),__idFieldEmpty,false)
									ENDIF
								OTHERWISE
									RETURN this.Post(Program(),__idFieldInvalidValue,false)
							ENDCASE
						ENDIF
					ELSE
						RETURN this.Post(Program(),__recordNotChanges,true)
					ENDIF
				* Generar Comando Sql porque se encontraron Cambios
					DO CASE
						CASE __typeStateRecord = __typeStateUpdate
							__commandSql = "UPDATE " + __tableName + " SET "
							__fieldsChanges = ""
							FOR a = 1 TO nCampos
								SELECT foxydb_TableFields
								SCAN FOR ALLTRIM(UPPER(ALLTRIM(foxydb_TableFields.field_name))) == ALLTRIM(UPPER((arrayFieldList(a,1))))
									SELECT (__cursorName)
									IF GETFLDSTATE(arrayFieldList(a,1)) = 2 OR GETFLDSTATE(arrayFieldList(a,1)) = 4
										IF __fieldCurrent
											__commandSql = __commandSql + " , " 
										ENDIF
										* Validar Campos
										 DO case
										 	CASE arrayFieldList(a,2) = "C"
										 		* Eliminar Espacios a los Campos Carácter
												__commandSql = __commandSql + arrayFieldList(a,1) + "= ?ALLTRIM(" + __cursorName + "." + arrayFieldList(a,1) + ")"
											CASE arrayFieldList(a,2) $ "DT"
												* Validar Fechas vacías según Motor de base de datos
													IF EMPTY(EVALUATE(__cursorName + "." + arrayFieldList(a,1)))
														DO case
															CASE this.engine = this.mySql
																__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.mysql_Empty_Date "
															CASE this.engine = this.mariaDb
																__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.mariaDb_Empty_Date "
															CASE this.engine = this.fireBird
																__commandSql = __commandSql + arrayFieldList(a,1) + " = ?this.fireBird_Empty_Date "
															CASE this.engine = this.postgreSql
															CASE this.engine = this.sqlServer
															CASE this.engine = this.sqlLite
																__commandSql = __commandSql + arrayFieldList(a,1) + "= ?" + __cursorName + "." + arrayFieldList(a,1)
														ENDCASE
													ELSE
														__commandSql = __commandSql + arrayFieldList(a,1) + "= ?" + __cursorName + "." + arrayFieldList(a,1)
													ENDIF
											OTHERWISE
											__commandSql = __commandSql + arrayFieldList(a,1) + "= ?" + __cursorName + "." + arrayFieldList(a,1)
										ENDCASE								
										__fieldCurrent = true
										EXIT
									ENDIF
									SELECT foxydb_TableFields
								ENDSCAN
							NEXT
							__commandSql = __commandSql + " WHERE " + __idFieldTableName + " = ?" + __fieldValue
						CASE __typeStateRecord = __typeStateDelete
							IF DELETED()
								__commandSql = "DELETE FROM " + __tableName + " WHERE " + __idFieldTableName + " = ?" + __fieldValue
							ELSE
								__commandSql = ""
							ENDIF
						CASE __typeStateRecord = __typeStateInsert
							__commandSql = "INSERT INTO " + __tableName + " ("
							__fieldsChanges = ""
							__fieldsValues = ""
							FOR a = 1 TO nCampos
								SELECT foxydb_TableFields
								SCAN FOR ALLTRIM(UPPER(ALLTRIM(foxydb_TableFields.field_name))) == ALLTRIM(UPPER(arrayFieldList(a,1)))
									SELECT (__cursorName)
									IF GETFLDSTATE(arrayFieldList(a,1)) = 2 OR GETFLDSTATE(arrayFieldList(a,1)) = 4
										IF __fieldCurrent
											__fieldsChanges = __fieldsChanges + " , "
											__fieldsValues = __fieldsValues + " , "
										ENDIF
										__fieldsChanges = __fieldsChanges + LOWER(arrayFieldList(a,1))
										* Validar Campos
										 DO case
										 	CASE arrayFieldList(a,2) = "C"
										 		* Eliminar Espacios a los Campos Caracter
												__fieldsValues = __fieldsValues + "?ALLTRIM(" + __cursorName + "." + LOWER(arrayFieldList(a,1)) + ")"
											CASE arrayFieldList(a,2) $ "DT"
												* Validar Fechas vacias segun Motor de base de datos
													IF EMPTY(EVALUATE(__cursorName + "." + arrayFieldList(a,1)))
														DO case
															CASE this.engine = this.mySql
																__fieldsValues = __fieldsValues + "?this.mysql_Empty_Date"
															CASE this.engine = this.mariaDb
																__fieldsValues = __fieldsValues + "?this.mariaDb_Empty_Date"
															CASE this.engine = this.fireBird
																__fieldsValues = __fieldsValues + "?this.fireBird_Empty_Date"
															CASE this.engine = this.postgreSql
															CASE this.engine = this.sqlServer
															CASE this.engine = this.sqlLite
																__fieldsValues = __fieldsValues + "?" + __cursorName + "." + LOWER(arrayFieldList(a,1))
														ENDCASE
													ELSE
														__fieldsValues = __fieldsValues + "?" + __cursorName + "." + LOWER(arrayFieldList(a,1))
													ENDIF
											OTHERWISE
											__fieldsValues = __fieldsValues + "?" + __cursorName + "." + LOWER(arrayFieldList(a,1))
										ENDCASE								
										__fieldCurrent = true
										EXIT
									ENDIF
									SELECT foxydb_TableFields
								ENDSCAN
							NEXT
							__commandSql = __commandSql + __fieldsChanges + ") values (" + __fieldsValues + ")"
							* Verificar si se requiere obtener el Ultimo ID Insertado
								IF __lastId
									this.id_Active = true
									* Obtener Ultimo Id para FireBird
										IF this.engine = this.fireBird
											__commandSql = __commandSql + " RETURNING " + __idFieldTableName
										ENDIF
								ELSE
									this.id_Active = false
								ENDIF
						CASE __typeStateRecord = __typeStateInsertAndDelete
							RETURN this.Post(Program(),__recordNotChanges,true)
					ENDCASE
				* Tipo de Commando SQL Generado
					this.sql_CommandType = __typeStateRecord
				* Comando Sql Generado
					this.sql_Command = __commandSql
					RETURN this.Post(Program(),__commandSqlReady,true)
		ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Update
				LPARAMETERS __cursorName as Character, __idFieldName as Variant, __lastId as Boolean
				LOCAL __transactionError, __tableStructureError, __tableNameEmpty, __cursorNameEmpty, __cursorNotUpdate, ;
					  __cursorNoChanges, __cursorUpdate, __cursorUpdate, __transactionEnabled, __transactionRollBack
				* Update
					* Genera y Envia instrucciones Sql (Insert / Update / Delete) al servidor según los cambios hechos al cursor
				* Parámetros
					* __cursorName, Nombre del Cursor a Actualizar información en el servidor
					* __idFieldName, Acepta los siguiente valores
						* Lógico: true / false, para solicitar el Ultimo ID Insertado
						* Carácter, Nombre del campo Primary Key Autoincremental
					* __lastId, Para solicitar el Ultimo ID Insertado
				* Valor devuelto
					* true	Cursor Actualizado
					* false	Cursor No Actualizado
				* Error devuelto
					__transactionErrorType		= -6		&& Error Transaccion de Solo Lectura o Remota
					__transactionError			= -5		&& Error al iniciar una transacción
					__tableStructureError		= -4		&& Error al obtener la estructura de la tabla
					__tableNameEmpty 			= -3		&& Nombre de la tabla vacío
					__cursorNameEmpty 			= -2		&& Nombre del cursor vacío
					__cursorNotUpdate			= -1		&& No se puedo actualizar el cursor
					__cursorNoChanges 			= 0			&& Cursor sin Cambios
					__cursorUpdate				= 1			&& Cursor Actualizado en el servidor
					__transactionEnabled		= 1			&& Activar transacción
					__transactionNotStarted			= 0				&& No hay una transacción Iniciada
					__transactionTypeReadOnly		= 1				&& Transacción de Solo Lectura
					__transactionTypeWrite			= 2				&& Transacción de Lectura y Escritura Local y Remota
					__transactionTypeRemote			= 3				&& Transacción de Lectura y Escritura Remota
					this.id_Last				= 0			&& Iniciar en 0 el valor del Ultimo ID Insertado
					this.error_ODBC				= 0			&& Iniciar en 0 el valor de error ODBC
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
					IF VARTYPE(__idFieldName) = "L"
						__lastId = __idFieldName
					ENDIF
					IF VARTYPE(__idFieldName) <> "C" OR EMPTY(ALLTRIM(__idFieldName))
						__idFieldName = this.id_name
					ENDIF
					IF VARTYPE(__lastId) <> "L"
						__lastId = false
					ENDIF
				* Verificar Cambios en el Cursor
					IF NOT this.CursorChanges(__cursorName)
						RETURN this.Post(Program(),__cursorNoChanges,true)
					ENDIF
				* Validar o Iniciar Transaccion
					IF this.handle_Transaction = __transactionTypeReadOnly OR this.handle_Transaction = __transactionTypeRemote
						RETURN this.Post(Program(),__transactionErrorType,false)
					ELSE
						IF this.handle_Transaction = __transactionNotStarted
							IF NOT this.Begin(__transactionTypeWrite)
								RETURN this.Post(Program(),__transactionError,false)
							ENDIF
						ENDIF
					ENDIF
				* Obtener Nombre de la Tabla Real
					__tableName = ALLTRIM(this.dbTableName(__cursorName))
					IF EMPTY(ALLTRIM(__tableName))
						RETURN this.Post(Program(),__tableNameEmpty,false)
					ENDIF
				* Estructura de la tabla
					IF !this.TableFields(__tableName,"foxydb_TableFields")
						RETURN this.Post(PROGRAM(),__tableStructureError,false)
					ENDIF
				* Recorrer Registros
					SELECT (__cursorName)
					SET DELETED OFF
					__UpdateRecord = true
					SCAN
						IF this.command(__cursorName, __tableName, __idFieldName, __lastId)
							IF !EMPTY(ALLTRIM(this.sql_Command))
								* Enviar SQL para Actualizar
									IF this.Sql(this.sql_Command,"foxydb_last_id")
										* Ultimo comando SQL enviado por Update
											this.Sql_Update = this.sql_Command
										* Obtener Ultimo ID Insertado y Código de Error
											IF this.id_Active
												this.Id()
												this.error_Id = this.error_Code
												this.id_Active = false
											ENDIF
									ELSE
										* Hubo un Error
										__UpdateRecord = false
										EXIT
									ENDIF
							ENDIF
						ELSE
							* Hubo un Error
							__UpdateRecord = false
							EXIT
						ENDIF
						SELECT (__cursorName)
					ENDSCAN
					SET DELETED ON
				* Verificar que se haya actualizado el Cursor en el Servidor remoto
					IF NOT __UpdateRecord 
						* Enviar RollBack a Transacción
							IF NOT this.RollBack()
								RETURN this.Post(Program(),__transactionError,false)
							ENDIF
							RETURN this.Post(PROGRAM(),__cursorNotUpdate,false)
					ENDIF
				* Regresar al Primer Registro
					SELECT (__cursorName)
						IF EOF() OR BOF()
							GO TOP
						ENDIF
				* Cerrar tabla de Estrcutura de Campos
					IF USED("foxydb_TableFields")
						USE IN foxydb_TableFields
					ENDIF
				* Aplicar TableUpdate al Cursor Local
					= TABLEUPDATE(true,false,__cursorName)
				* Listo
					RETURN this.Post(Program(),__cursorUpdate,true)
		 	ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Refresh
		 		LPARAMETERS __cursorName as Character, __commandSql as Variant, __idFieldName as Character
		 		LOCAL __commandSqlError, __commandSqlEmpty, __tablaNameNotFound,__cursorNameEmpty, ;
		 			  __cursorRefresh, __lastValueId, __tablaNameRequery
				* Refresh
					* Actualizar (Refrescar) los datos del Cursor
				* Parámetros
					* __cursorName, Nombre del Cursor a Refrescar datos
					* __commandSql, 
						* Carácter: Comando SQL a ejecutar en la consulta
						* Numérico: Valor del Campo Autoincremental
					* __idFieldName, Nombre del Campo Id Autoincremental
				* Valor devuelto
					* true	Cursor Refrescado
					* false	Cursor No refrescado
				* Error devuelto
					__commandSqlError			= -4			&& Comando SQL invalido
					__commandSqlEmpty			= -3			&& Comando SQL vacío
					__cursorNameEmpty 			= -2			&& Nombre del cursor vacío
					__tablaNameNotFound			= -1			&& Nombre de la tabla no registrada en DBCURSOR
					__cursorRefresh				= 1				&& Cursor Refrescado
					__lastValueId				= 0				&& Valor del Ultimo ID
					__tablaNameRequery			= ""			&& Nombre de la Tabla a Refrescar datos
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
					* __commandSql 
						DO case
							CASE VARTYPE(__commandSql) = "L"
								__commandSql 	= ""
								__lastValueId 	= 0
							CASE VARTYPE(__commandSql) = "C"
								__lastValueId 	= 0
							CASE VARTYPE(__commandSql) = "N"
								__lastValueId 	= __commandSql 
								__commandSql 	= ""
							OTHERWISE
								__commandSql = ""
								__lastValueId = 0
						ENDCASE
					IF VARTYPE(__idFieldName) <> "C"
						__idFieldName = this.id_Name
					ENDIF
				* Obtener tabla en DbCursor
					__tablaNameRequery = this.DbTableName(__cursorName)
					IF EMPTY(ALLTRIM(__tablaNameRequery))
						RETURN this.Post(Program(),__tablaNameNotFound,false)
					ENDIF
				* Obtener Instrucción SQL
					IF __lastValueId > 0
						* Campo ID y valor
						__commandSql = "Select * from " + __tablaNameRequery + " Where " + __idFieldName + " = " + ALLTRIM(STR(__lastValueId))
					ELSE
						IF EMPTY(ALLTRIM(__commandSql))
							* Obtener Consulta
								IF EMPTY(ALLTRIM(dbcursor.sql))
									RETURN this.Post(Program(),__commandSqlEmpty,false)
								ELSE 
									__commandSql = dbcursor.sql
								ENDIF
						ENDIF
					ENDIF					
				* Refrescar Cursor
					IF this.Sql(__commandSql,__cursorName)
						* Actualizar comando SQL en DBCURSOR
							REPLACE dbcursor.sql WITH __commandSql IN DBCURSOR
						RETURN this.Post(Program(),__cursorRefresh,true)
				 	ELSE
						RETURN this.Post(PROGRAM(),__commandSqlError,false)
					ENDIF
		 	ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE DbCursor
				LPARAMETERS __cursorName as Character, __cursorTypeAction as Integer,__commandSql as Character ,__tablaName as Character
				LOCAL __cursorNameEmpty, __cursorCreate, __cursorDelete, __actionCompleted
				* DbCursor
					* Crea un Cursor temporal para administrar los cursores creados con Use() y Query()
				* Parámetros
					* __cursorName, Nombre del Cursor a agregar o buscar
					* __cursorTypeAction, Acción a realizar 1 Crear, 2 Eliminar
					* __commandSql, Comando Sql con que se abrió el cursor
					* __tablaName, Nombre de la Tabla real en el servidor de base de datos
				* Valor devuelto
					* true	Acción Completada
					* false	Error no se completo
				* Error devuelto
					__cursorNameEmpty 			= -2			&& Nombre del cursor vacío
					__cursorCreate				= 1				&& Crear o editar Cursor
					__cursorDelete				= 2				&& Eliminar Cursor
					__actionCompleted			= 1				&& Acción Completada
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,false)
					ENDIF
				* Crear cursor temporal
					IF !USED("dbCursor")
						CREATE CURSOR dbCursor (tabla C(100), cursor C(100), sql Memo)
					ENDIF
					SELECT dbCursor
						DO CASE
							CASE __cursorTypeAction = __cursorCreate
								LOCATE FOR ALLTRIM(dbCursor.tabla) == UPPER(ALLTRIM(__tablaName)) AND ALLTRIM(dbCursor.cursor) == UPPER(ALLTRIM(__cursorName)) AND !DELETED()
								IF FOUND()
									REPLACE dbCursor.sql WITH __commandSql IN dbCursor
								ELSE
									INSERT INTO dbCursor (tabla,cursor,sql) values(UPPER(__tablaName),UPPER(__cursorName),__commandSql)
								ENDIF
								RETURN this.Post(Program(),__actionCompleted,true)
							CASE __cursorTypeAction = __cursorDelete
								DELETE FROM dbCursor WHERE ALLTRIM(dbCursor.cursor) == ALLTRIM(UPPER(__cursorName))
								RETURN this.Post(Program(),__actionCompleted,true)
						ENDCASE			
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE DbTableName
				LPARAMETERS __cursorName as Character
				LOCAL __cursorNameEmpty, __dbCursorUnCreated, __tableNameNotFound, __tableNameFound
				* DbCursorName
					* Devuelve el nombre de la tabla asociada a un cursor
				* Parámetros
					* __cursorName, Nombre del Cursor a agregar o buscar
				* Valor devuelto
					* Carácter, Nombre de la tabla o cadena vacía
				* Error devuelto
					__cursorNameEmpty 			= -2			&& Nombre del cursor vacío
					__dbCursorUnCreated			= -1			&& Cursor DbCursor no creado
					__tableNameNotFound			= 0				&& Nombre de la tabla No encontrado
					__tableNameFound			= 1				&& Nombre de la tabla encontrado
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__cursorName) <> "C" OR EMPTY(ALLTRIM(__cursorName))
						RETURN this.Post(Program(),__cursorNameEmpty,"")
					ENDIF
				* Verificar que este en uso
					IF !USED("dbCursor")
						RETURN this.Post(Program(),__dbCursorUnCreated,"")
					ENDIF
				* Obtener nombre de la tabla
					SELECT dbCursor
					LOCATE FOR ALLTRIM(dbCursor.cursor) == UPPER(ALLTRIM(__cursorName)) AND !DELETED()
					IF FOUND()
						RETURN this.Post(Program(),__tableNameFound,ALLTRIM(dbCursor.tabla))
					ELSE
						RETURN this.Post(Program(),__tableNameNotFound,"")
					ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------


	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE Code
				LPARAMETERS __tableName as Character, __fieldNameToIncrease as Character, __fieldName as Character, __fieldValue as Character, __defaultValue as Integer, __defaultValueChange as Boolean
				LOCAL __transactionError, __multipleRecordsQuery, __fieldNameAndFieldValueNotEqual, __fieldNameToIncreaseEmpty, __tableNameEmpty , ;
					  __commandSqlError, __transactionEnabled, __commandSql
				* Code
					* Obtener Códigos Únicos (Correlativos)
				* Parámetros
					* __tableName, Nombre de la Tabla Real en el servidor
					* __fieldNameToIncrease, Nombre del campo a incrementar su valor
					* __fieldName, Lista de Campos para usar como filtro o agregar registro
					* __fieldValue, Lista de Valores para el filtro o agregar registro
					* __defaultValue, Valor inicial del contador
					* __defaultValueChange, Si remplaza el valor aun cuando ya existe
				* Valor devuelto
					* true 	Código Generado
					* false	Código NO Generado
				* Error devuelto
					__transactionError					= -8		&& Error al iniciar o terminar la transaccion
					__transactionReadOnly				= -7		&& Transaccion de solo lectura
					__multipleRecordsQuery				= -6		&& Error múltiples registros en la consulta
					__fieldNameAndFieldValueNotEqual	= -5		&& La cantidad de Campos no es igual a la cantidad de valores
					__fieldNameToIncreaseEmpty			= -4 		&& Falta Nombre del Campo que se incrementara
					__tableNameEmpty 					= -3 		&& Falta Nombre de la Tabla
					__commandSqlError					= -1		&& Error en comando SQL
					__filter							= ""
					__cursorName						= "__correlative__"
					__transactionNotStarted				= 0			&& No hay una transacción Iniciada
					__transactionTypeReadOnly			= 1			&& Transaccion de solo lectura
					__transactionTypeWrite				= 2			&& Transacción de Lectura y Escritura Local y Remota
					__commandSql 						= ""		&& 
					DIMENSION __fieldNameArray[1]
					DIMENSION __fieldValueArray[1]
					this.id_Code = 0
				* Validar Parámetros
					IF PCOUNT() = 0 OR VARTYPE(__tableName) <> "C" OR EMPTY(ALLTRIM(__tableName))
						RETURN this.Post(Program(),__tableNameEmpty,false)
					ENDIF
					IF VARTYPE(__fieldNameToIncrease) <> "C" OR EMPTY(ALLTRIM(__fieldNameToIncrease))
						RETURN this.Post(Program(),__fieldNameToIncreaseEmpty,false)
					ENDIF
					IF VARTYPE(__fieldName) <> "C" 
						__fieldName = ""
					ENDIF
					IF VARTYPE(__fieldValue) <> "C"
						__fieldValue = ""
					ENDIF
					IF VARTYPE(__defaultValue) <> "N"
						__defaultValue = 0
					ENDIF
				* Generar Filtro
					IF EMPTY(ALLTRIM(__fieldName)) OR EMPTY(ALLTRIM(__fieldValue))
						__filter = ""
					ELSE
						IF ALINES(__fieldNameArray,UPPER(__fieldName),true,",") = ALINES(__fieldValueArray,UPPER(__fieldValue),true,",")
							FOR __fieldNameCount = 1 TO ALEN(__fieldNameArray)
								* Campo
									IF __fieldNameCount = 1
										__filter = __fieldNameArray(__fieldNameCount)
									ELSE
										__filter = __filter + " and " + __fieldNameArray(__fieldNameCount)
									ENDIF
								* Valor
									__filter = __filter + " = " + __fieldValueArray(__fieldNameCount)
							NEXT
						ELSE
							RETURN this.Post(Program(),__fieldNameAndFieldValueNotEqual,false)
						ENDIF
					ENDIF
				* Generar SQL según el motor
					DO CASE
						CASE this.engine = this.mySql
							IF EMPTY(ALLTRIM(__filter))
								__commandSql = "Select * From " + __tableName + " FOR UPDATE"
							ELSE
								__commandSql = "Select * From " + __tableName + " where " + __filter + " FOR UPDATE"
							ENDIF
						CASE this.engine = this.mariaDb
							IF EMPTY(ALLTRIM(__filter))
								__commandSql = "Select * From " + __tableName + " FOR UPDATE"
							ELSE
								__commandSql = "Select * From " + __tableName + " where " + __filter + " FOR UPDATE"
							ENDIF
						CASE this.engine = this.fireBird
							IF EMPTY(ALLTRIM(__filter))
								__commandSql = "Select * From " + __tableName + " WITH LOCK"
							ELSE
								__commandSql = "Select * From " + __tableName + " where " + __filter + " WITH LOCK"
							ENDIF
						CASE this.engine = this.postgreSql
						CASE this.engine = this.sqlServer
					ENDCASE
				* Iniciar Transacción
					DO case
						CASE this.handle_Transaction = __transactionNotStarted
							IF NOT this.Begin(__transactionTypeWrite)
								RETURN this.Post(Program(),__transactionError,false)
							ENDIF
						CASE this.handle_Transaction <= __transactionTypeReadOnly
							RETURN this.Post(Program(),__transactionReadOnly,false)
					ENDCASE
				* Obtener Código
					IF this.sql(__commandSql,__cursorName)
						SELECT (__cursorName)
						DO case
							CASE this.sql_Records = 0				&& Agregar
								IF __defaultValue = 0
									this.id_Code = 1
								ELSE
									this.id_Code = __defaultValue
								ENDIF
								IF EMPTY(ALLTRIM(__filter))
									__commandSql = "INSERT INTO " + __tableName + " (" + __fieldNameToIncrease + ") values ( " + ALLTRIM(STR(this.id_Code)) + ")"
								ELSE
									__commandSql = "INSERT INTO " + __tableName + " (" + __fieldName + "," + __fieldNameToIncrease + ") values (" + __fieldValue + "," + ALLTRIM(STR(this.id_Code)) + ")"
								ENDIF
							CASE this.sql_Records = 1				&& Incrementar
								IF __defaultValueChange
									IF __defaultValue = 0
										this.id_Code = EVALUATE(__cursorName + "." + __fieldNameToIncrease) + 1
									ELSE
										this.id_Code = __defaultValue
									ENDIF
								ELSE
									this.id_Code = EVALUATE(__cursorName + "." + __fieldNameToIncrease) + 1
								ENDIF
								IF EMPTY(ALLTRIM(__filter))
									__commandSql = "update " + __tableName + " set " + __fieldNameToIncrease + " = " + ALLTRIM(STR(this.id_Code))
								ELSE
									__commandSql = "update " + __tableName + " set " + __fieldNameToIncrease + " = " + ALLTRIM(STR(this.id_Code)) + " where " + __filter
								ENDIF
							OTHERWISE								&& Error
								USE IN (__cursorName)
								IF this.handle_Transaction
									IF NOT this.Cancel()
										RETURN this.Post(Program(),__transactionError,false)		&& Error en RollBack
									ENDIF
								ENDIF								
								RETURN this.Post(Program(),__multipleRecordsQuery,false)
						ENDCASE
						* Cerrar Cursor
							USE IN (__cursorName)
						* Actualizar
							IF this.Sql(__commandSql,true)
								RETURN this.Post(Program(),1,true)	&& Código Asignado
							ENDIF
					ENDIF
				* Error en comando SQL, aplicar Rollback a Transacción
					IF this.handle_Transaction
						IF NOT this.Cancel()
							RETURN this.Post(Program(),__transactionError,false)	&& Error en RollBack
						ENDIF
					ENDIF
					RETURN this.Post(Program(),__commandSqlError,false)
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE TablesGoTop
				LOCAL __cursorsNotOpen, __goTopAplicate
				* TablesGoTop
					* Aplicar un Go Top a los cursores abiertos en DbCursor
				* Parámetros
					* No requerido
				* Valor devuelto
					* true 	Go Top Aplicado
				* Error devuelto
					__cursorsNotOpen		= 0				&& No hay cursores abiertos
					__goTopAplicate			= 1				&& Go Top Aplicado
				IF USED("dbcursor")
					SELECT dbcursor
					SCAN
						GO TOP IN (ALLTRIM(dbcursor.cursor))
					ENDSCAN
					RETURN this.Post(Program(),__goTopAplicate,true)
				ELSE
					RETURN this.Post(Program(),__cursorsNotOpen,true)
				ENDIF
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
			PROCEDURE End
				* End
					* Cerrar Transacción con RollBack, Cerrar todos los cursores, conexión al servidor y finalizar la librería
				* Verificar Transacciones
					IF this.handle_Transaction > 0
						this.undo()
					ENDIF
				* Cerrar Todos los Cursores en la session
					this.Close(true)
				* Cerrar DbCursor
					IF USED("DBCURSOR")
						USE IN DBCURSOR
					ENDIF
				* Cerrar conexión 
					this.Disconnect()
				* Finalizar librería
					RETURN null
			ENDPROC
	*** --------------------------------------------------------------------------------------------

	*** --------------------------------------------------------------------------------------------
	*** --------------------------------------------------------------------------------------------
		PROCEDURE TextMessage
			LPARAMETERS __procedureName, __errorNumber, __returnValue
			LOCAL __procedureName, __errorNumber, __returnValue
			* TextMessage
				* Convertir Códigos de Error de la librería en Texto y traducirlos en diferentes idiomas
			* Parámetros
				* __procedureName: Nombre del procedimiento que envía el error
				* __errorNumber,  Numero de error
				* __returnValue, Valor que fue Retornado por el precedimiento
			* Asignar Propiedades de error
				this.error_code			= __errorNumber			&& Numero de Error devuelto por el procedimiento
				this.error_procedure	= __procedureName		&& Nombre del procedimiento que devolvio el Error
				this.error_Value		= __returnValue			&& Valor devuelto por el procedimiento
			* Asignar mensaje de error según el Idioma
				this.error_Post = ""
				DO case
					CASE __procedureName == "FOXYDB.CONNECT"
						DO case
							CASE __errorNumber = 1
								DO case
									CASE this.language = "es"
										this.error_post	= "Conectado al Servidor"
									CASE this.language = "us"
										this.error_post	= ""
								ENDCASE
							CASE __errorNumber = 0
								DO case
									CASE this.language = "es"
										this.error_post	= "Ya esta Conectado al Servidor"
									CASE this.language = "us"
										this.error_post	= ""
								ENDCASE
							CASE __errorNumber = -1
								DO case
									CASE this.language = "es"
										this.error_post	= "No se pudo Conectar al Servidor"
									CASE this.language = "us"
										this.error_post	= ""
								ENDCASE
						ENDCASE
					CASE __procedureName == "FOXYDB.CONNECTED"
						DO case
							CASE __errorNumber = 2
								DO case
									CASE this.language = "es"
										this.error_post	= "Esta Conectado al Servidor y Verificado"
									CASE this.language = "us"
										this.error_post	= ""
								ENDCASE
							CASE __errorNumber = 1
								DO case
									CASE this.language = "es"
										this.error_post	= "Esta Conectado al Servidor"
									CASE this.language = "us"
										this.error_post	= ""
								ENDCASE
							CASE __errorNumber = -1
								DO case
									CASE this.language = "es"
										this.error_post	= "No esta Conectado al Servidor"
									CASE this.language = "us"
										this.error_post	= ""
								ENDCASE
						ENDCASE
				ENDCASE
		ENDPROC
	*** --------------------------------------------------------------------------------------------

ENDDEFINE
*
*-- EndDefine: foxydb
**************************************************
