**************************************************
*!* Librería: FoxyDb.prg
*!* Autor: Antonio Meza Pérez
*!* Date: 04/07/2015 07:52:08 PM
*!* Licencia: MIT
*!* Descripción: Capa de Acceso a Datos
*!* Descripción: requiere FoxyDb_class.prg para funcionar
*!* ------------------------------------------------------------------------------------

DEFINE CLASS FoxyDb As foxyDb_clase OF "lib\foxydb_class.prg"

	* Constantes
		#define true 	.t.
		#define false 	.f.

	* Propiedades
		version_acceso 		= "0.1"				&& Versión de la libreria
		revision_acceso 	= "04/07/2015"		&& Revision
		estable_acceso 		= .t.				&& Estable

	* Procedimientos
		* Init
			PROCEDURE Init
				*this.Iniciar()
			ENDPROC

		* Iniciar
			PROCEDURE Iniciar
				this.configurar()
			ENDPROC

		* Abrir Archivo de Configuracion de Conexion
			PROCEDURE archivo_configuracion
				IF NOT USED("ampdb")
					SELECT 0
					USE fusion.amp ALIAS ampdb SHARED
				ENDIF
			ENDPROC

		* Configurar Conexion a la Base de Datos
			PROCEDURE Configurar
				LOCAL _configurar as Boolean
				_configurar = .t.
				* Abrir Archivo de Configuracion de la Conexion
					this.archivo_configuracion()
				* Configurar Parametros
					this.handle_Network			= .f.	&& Conexion a la Red Permanente
					this.handle_Verify			= .f.	&& Verificar estado de la red
					this.handle_Reconnection	= .t.	&& Intentar Reconectar 
					this.error_Show				= .t.	&& Mostrar Errores SQL
					this.Debug					= .f.	&& Depurar
				* Conexión
					this.handle_driver 		= ampdb.driver
					this.handle_server		= ALLTRIM(ampdb.servidor)
					this.handle_user		= ALLTRIM(ampdb.usuario)
					this.handle_password 	= ALLTRIM(ampdb.passwd)
					this.handle_database	= ALLTRIM(ampdb.base)
					this.handle_port		= ALLTRIM(STR(ampdb.puerto))
					this.engine				= ampdb.motordb
				* Cerrar Archivo de Configuración
					SELECT ampdb
					USE
				RETURN _configurar
			ENDPROC

	* Configurar para Pruebas
		PROCEDURE Test
			* Para Realizar pruebas con la librería en diferentes servidores y probar diferentes configuraciones
			* Esto permite tener un método que no interfiere con la librería si no es llamado de forma manual.
			SET DATE BRITISH
			SET CENTURY ON
			SET DELETED ON
			* Depurar y Errores SQL
				this.handle_Network			= false		&& Si mantiene permanente la conexión
				this.handle_Reconnection	= true		&& Si se intenta reconectar al servidor
				this.handle_Verify			= false		&& Si Verifica el estado de la conexión al servidor
				this.debug 					= false		&& Depurar mostrando paso a paso lo que hace la librería
				this.error_Show				= true		&& Mostrar Errores SQL devueltos por Aerror()
			* Motor de Base de datos
*				this.engine	= this.Mysql
				this.engine	= this.MariaDb
*				this.engine	= this.FireBird
*				this.engine	= this.PostgreSql
*				this.engine	= this.SqlServer
*				this.engine	= this.sqlLite
			xLocal = true
			DO case
				CASE this.engine = this.mySql
					this.handle_driver 		= this.driver_Mysql_51
					this.handle_server		= "localhost"
					this.handle_user		= "root"
					this.handle_password 	= ""
					this.handle_database	= ""
					this.handle_port		= this.port_Mysql
				CASE this.engine = this.mariaDb
					IF xlocal
						this.handle_driver 		= this.driver_Mysql_51
*						this.handle_driver 		= this.driver_MariaDb
						this.handle_server		= "localhost"
						this.handle_user		= "root"
						this.handle_password 	= ""
						this.handle_database	= ""
*						this.handle_port		= this.port_MariaDb
						this.handle_port		= "3310"
					ELSE
						this.handle_driver 		= this.driver_Mysql_51
						this.handle_server		= "localhost"
						this.handle_user		= "root"
						this.handle_password 	= ""
						this.handle_database	= ""
						this.handle_port		= "3316"
					ENDIF
				CASE this.engine = this.fireBird
					this.handle_driver 		= this.driver_firebird
					this.handle_server		= "localhost"
					this.handle_user		= "sysdba"
					this.handle_password 	= "masterkey"
					this.handle_database	= "C:\foxydb.fdb"
					this.handle_port		= this.port_firebird
				CASE this.engine = this.postgreSql
					this.handle_driver 		= this.driver_Postgresql
					this.handle_server		= "localhost"
					this.handle_user		= "postgres"
					this.handle_password 	= "admin"
					this.handle_database	= ""
					this.handle_port		= this.port_Postgresql
				CASE this.engine = this.sqlServer
				CASE this.engine = this.sqlLite
					this.handle_driver 		= this.driver_SQLite
					this.handle_server		= ""
					this.handle_user		= ""
					this.handle_password 	= ""
					this.handle_database	= "C:\BaseDeDatos.s3db"  && *.db, *.s3db, ó *.sqlite
					this.handle_port		= ""
			ENDCASE
	ENDPROC
	
ENDDEFINE
