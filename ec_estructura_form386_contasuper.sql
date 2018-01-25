/**********************************************************************/
/*  Archivo:              ec_estructura_form386_contasuper.sql        */
/*  Base de datos:        cob_conta_super                             */
/*  Producto:             REC                                         */
/*  Fecha de escritura:   01 de Noviembre de 2017                     */
/**********************************************************************/
/*                        IMPORTANTE                                  */
/*  Este programa es parte de los paquetes bancarios propiedad de     */
/*  "COBISCORP", su uso no autorizado queda expresamente prohibido asi*/
/*  como cualquier alteracion o agregado hecho por alguno de sus      */
/*  usuarios sin el debido consentimiento por escrito de la           */
/*  presidencia Ejecutiva de COBISCORP o su representante.            */
/**********************************************************************/
/*                        PROPOSITO                                   */
/*  Creacion de estructuras cob_conta_super formato 386               */
/**********************************************************************/
/*                         MODIFICACIONES                             */
/*  FECHA         AUTOR                   RAZON                       */
/*  01/Nov/2017   Ana Viera           Emision Inicial                 */
/**********************************************************************/
use cob_conta_super
go

SET NOCOUNT ON
go

SET ANSI_NULLS ON
go

SET QUOTED_IDENTIFIER ON
go

print '********************************'
print '*****  CREACION DE TABLAS ******'
print '********************************'
print ''
print 'Inicio Ejecucion Creacion de Tablas para Formato 386 en cob_conta_super : ' + convert(varchar(60),getdate(),109)
print ''

if exists (select 1 from sysobjects where name = 'sb_dato_nextday' and type = 'U') 
   drop table sb_dato_nextday
go
print '-->Tabla: sb_dato_nextday'
   create table sb_dato_nextday(
   dn_referencia	         varchar(50) NOT NULL,
   dn_tipo_operacion         varchar(50) NOT NULL,
   dn_id_cliente	         varchar(80) NOT NULL,
   dn_fecha_valor	         datetime	 NULL,
   dn_fecha_pago	         datetime	 NOT NULL,
   dn_fecha_venc	         datetime	 NOT NULL,
   dn_plazo	                 Smallint	 NOT NULL,
   dn_plazo_original	     Smallint	 NOT NULL,
   dn_valor_nominal	         Money	     NOT NULL,
   dn_valor_moneda_legal	 Money	     NOT NULL,
   dn_cotización_pactada	 Money	     NULL,
   dn_cotización_spot_cierre Money	     NULL,
   dn_tasa	                 float	     NOT NULL,
   dn_tasa_mon_legal	     float	     NOT NULL,
   dn_valoracion_derechos	 Money	     NOT NULL,
   dn_valoracion_obligacion	 Money	     NOT NULL,
   dn_pyg	                 Money	     NOT NULL,
   dn_aplicativo             smallint    NULL,
   dn_fecha_proc             datetime    NULL,
   dn_origen                 varchar(5)  default 'B')
   
if exists (select 1 from sysobjects where name = 'sb_carteras_colectivas' and type = 'U') 
   drop table sb_carteras_colectivas
go
print '-->Tabla: sb_carteras_colectivas'
   create table sb_carteras_colectivas(
   cc_cartera_colectiva	    varchar(100) NOT NULL,
   cc_id_cliente	        varchar(100) NOT NULL,
   cc_factor_riesgo_actual	Float	     NULL,
   dn_saldo_actual	        Money	     NULL,
   dn_moneda	            varchar(10)	 NULL,
   dn_rendimiento_dia       Money	     NULL,
   cc_aplicativo            smallint     NULL,
   cc_fecha_proc            datetime     NULL,
   cc_origen                varchar(5)   default 'B')

go
