/**********************************************************************/
/*  Archivo:                         ec_param_form386.sql             */
/*  Base de datos:                   cob_conta_super                  */
/*  Producto:                        REC                              */
/*  Fecha de escritura:              14.11.17                         */
/**********************************************************************/
/*                          IMPORTANTE                                */
/*  Este programa es parte de los paquetes bancarios propiedad de     */
/*  "COBISCORP", su uso no autorizado queda expresamente prohibido asi*/
/*  como cualquier alteracion o agregado hecho por alguno de sus      */
/*  usuarios sin el debido consentimiento por escrito de la           */
/*  presidencia Ejecutiva de COBISCORP o su representante.            */
/**********************************************************************/
/*                          PROPOSITO                                 */
/*  parametrizacion de filas,columnas del formato 386                 */
/*  periodicidad mensual                                              */
/**********************************************************************/
/*                          MODIFICACIONES                            */
/*  FECHA         AUTOR                RAZON                          */
/*  14.11.17      Rodrigo Prada        Emision Inicial                */
/**********************************************************************/
use cob_conta_super
go

SET NOCOUNT ON
go

SET ANSI_NULLS ON
go

SET QUOTED_IDENTIFIER ON
go


declare @w_tabla  smallint,
        @w_proceso    int,                    
        @w_max_fila   int,                  
        @w_col        int,                  
        @w_fil        int,                     
        @w_max_col    int,
        @w_error      int,
        @w_tipo_inf   char(2),
        @w_mensaje    varchar(250)

select @w_proceso  = 28850 , -- numero de proceso diario
       @w_tabla    = 0,
       @w_max_fila = 0,
       @w_col      = 0,
       @w_fil      = 0,
       @w_max_col  = 0,
       @w_error    = 0,
       @w_tipo_inf = '55',
       @w_mensaje  = ''


print 'Parametrizacion Formato 386 tipo informe 55'

----------------------------------------------------
print 'INSERTANDO sb_configurar_reportes'

select * from cob_conta_super..sb_configurar_reportes where cr_proceso = @w_proceso

if @@rowcount = 0
   print 'NO EXISTE REPORTE ASOCIADO AL PROCESO'
   
delete from cob_conta_super..sb_configurar_reportes where cr_proceso = @w_proceso

if @@error <>0 
begin
   select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
   goto FIN
end
   
insert into cob_conta_super..sb_configurar_reportes 
 (
   cr_proceso         , cr_formato    , cr_total_columnas ,
   cr_entidad_control , cr_tipo_cifra , cr_nombre_sqr     ,
   cr_tipo_plano      , cr_aplica     , cr_nom_reporte    ,
   cr_periodicidad    , cr_area_inf   , cr_tipo_inf       ,
   cr_sufijo          , cr_estado     , cr_cero            
  )
values 
 (  
   @w_proceso         , 386           , 41,
   '01'               , '02'          , 'ecfor386',
   '01'               , 'S'           , 'Formato 386 periodicidad diaria',
   'D'                , '01'          , @w_tipo_inf,     
   2                  , 'V'           , 'N'
  )

   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

select * from cob_conta_super..sb_configurar_reportes where cr_proceso = @w_proceso
--------------------------------------------------------------

------------------------------------------------------------------

print 'INSERTANDO COLUMNAS'

select * from cob_conta_super..sb_columnas where co_proceso = @w_proceso

if @@rowcount = 0
   print 'NO EXISTEN COLUMNAS ASOCIADAS AL PROCESO'
   
delete from cob_conta_super..sb_columnas where co_proceso = @w_proceso

if @@error <>0 
begin
   select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
   goto FIN
end
   
insert into cob_conta_super..sb_columnas values (1,'SUBCUENTA'                   ,@w_proceso,'02',3 ,'N','01')
insert into cob_conta_super..sb_columnas values (2,'DESCRIPCION'                 ,@w_proceso,'01',50,'N','02')
insert into cob_conta_super..sb_columnas values (3,'VALOR'                       ,@w_proceso,'03',20,'N','04')
insert into cob_conta_super..sb_columnas values (4,'UNIDAD DE CAPTURA'           ,@w_proceso,'04',2, 'S','03')

select * from cob_conta_super..sb_columnas where co_proceso = @w_proceso
---------------------------------------------------------------
print 'INSERTANDO FILAS'

select * from cob_conta_super..sb_filas where fi_proceso = @w_proceso

if @@rowcount = 0
   print 'NO EXISTEN FILAS ASOCIADAS AL PROCESO'
   
   
   -- UC 1
delete from cob_conta_super..sb_filas where fi_proceso = @w_proceso

if @@error <>0 
begin
   select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
   goto FIN
end
   
insert into cob_conta_super..sb_filas values(1,@w_proceso,1,'005')
insert into cob_conta_super..sb_filas values(2,@w_proceso,1,'010')
insert into cob_conta_super..sb_filas values(3,@w_proceso,1,'015')
insert into cob_conta_super..sb_filas values(4,@w_proceso,1,'020')

 --UC2
insert into cob_conta_super..sb_filas values(5,@w_proceso,1,'005')

/****DESCRIPCIONES*****/

--UC1
insert into cob_conta_super..sb_filas values(1,@w_proceso,2,'TASA DE INTERES')
insert into cob_conta_super..sb_filas values(2,@w_proceso,2,'TASA DE CAMBIO')
insert into cob_conta_super..sb_filas values(3,@w_proceso,2,'PRECIO DE ACCIONES')
insert into cob_conta_super..sb_filas values(4,@w_proceso,2,'CARTERAS COLECTIVAS')

 --UC2
insert into cob_conta_super..sb_filas values(5,@w_proceso,2,'VALOR EN RIEGO TOTAL')


/******UNIDADES DE CAPTURA*******/
--UC1
insert into cob_conta_super..sb_filas values(1 ,@w_proceso,4 ,'01')
insert into cob_conta_super..sb_filas values(2 ,@w_proceso,4 ,'01')
insert into cob_conta_super..sb_filas values(3 ,@w_proceso,4 ,'01')
insert into cob_conta_super..sb_filas values(4 ,@w_proceso,4 ,'01')

--UC2
insert into cob_conta_super..sb_filas values(5,@w_proceso,4,'02')

select * from cob_conta_super..sb_filas where fi_proceso = @w_proceso
-------------------------------------------------------

PRINT '----------------------------------------------------------------------'
print 'INGRESANDO PARAMETRIZACION EN SB_TIPO_SALDO PARA FORMATO 386'
PRINT '----------------------------------------------------------------------'

select @w_proceso  = @w_proceso, 
       @w_max_fila = 0 , 
       @w_max_col  = 0

delete from cob_conta_super..sb_tipo_saldo where ts_proceso = @w_proceso

if @@error <>0 
begin
   select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
   goto FIN
end
   
insert into cob_conta_super..sb_tipo_saldo values(1 ,@w_proceso, 1, 3, 0, NULL )
insert into cob_conta_super..sb_tipo_saldo values(1 ,@w_proceso, 2, 3, 0, NULL )
insert into cob_conta_super..sb_tipo_saldo values(1 ,@w_proceso, 3, 3, 0, NULL )
insert into cob_conta_super..sb_tipo_saldo values(1 ,@w_proceso, 4, 3, 0, NULL )
insert into cob_conta_super..sb_tipo_saldo values(1 ,@w_proceso, 5, 3, 0, NULL )

select * from cob_conta_super..sb_tipo_saldo where ts_proceso = @w_proceso
   
-----------------------------------------------------------
print 'CELDAS O SUBCUENTAS QUE SFC SOLICITA EN CERO'
 
   update cob_conta_super..sb_tipo_saldo
   set   ts_reporta_cero = 'S'
   where ts_proceso = @w_proceso
   and   ts_fila    in (3)
   and   ts_columna in (3)
   
   if @@error <>0 
   begin
      select @w_mensaje = '[15001]: ERROR EN ACTUALIZACION'
      goto FIN
   end   
  
select * from cob_conta_super..sb_tipo_saldo where ts_proceso = @w_proceso
and ts_reporta_cero = 'S'

/*------------------------------------------------------------------
-- PARAMETRIZACION CABECERA CUENTA CONTABLE VS FORMATO 386 NIIF --
------------------------------------------------------------------*/

   if exists (select 1 from sb_cab_ctacontable_vrsformato where cf_proceso = @w_proceso)
      delete from sb_cab_ctacontable_vrsformato where cf_proceso = @w_proceso
 
          /*cf_proceso  cf_sec_cab  cf_subcuenta cf_uc      cf_columna  cf_tipo*/
        
   insert into cob_conta_super..sb_cab_ctacontable_vrsformato values (@w_proceso, 1, '010', '01',1, NULL)  
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end 
       

   select '/*** DATOS DESPUES DE PARAMETRIZAR CABECERA CUENTA CONTABLE VS FORMATO 386 NIIF ***/'
   select *
   from   cob_conta_super..sb_cab_ctacontable_vrsformato
   where  cf_proceso = @w_proceso
   
  
   /*** PARAMETRIZACION DETALLE CUENTA CONTABLE VS FORMATO 386 NIIF ***/
  
   if exists (select 1 from sb_det_ctacontable_vrsformato where df_proceso = @w_proceso)
      delete from sb_det_ctacontable_vrsformato where df_proceso = @w_proceso
 

          /*df_proceso   df_fila     df_columna  df_sec_cab  df_sec_det  df_cta_contabilid     df_signo df_cobis df_moneda df_docu*/
          
 
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  1, '110520900', '+', 'S', 'L', NULL)  
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  2, '161695210', '+', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  3, '111510906', '+', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  4, '243505050', '-', 'S', 'L', NULL)  
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  5, '251195790', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  6, '251195791', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	  
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  7, '251195792', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  8, '251195793', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,   9,'251195794', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  10,'251195795', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  11,'251195796', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  12,'251195797', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  13,'251195798', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  14,'251195799', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  15,'251195800', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  16,'251195801', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  17,'251195802', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  18,'251195803', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  19,'251195804', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  20,'251195805', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  21,'251195806', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  22,'251195807', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  23,'251195808', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  24,'251195809', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  25,'251195810', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  26,'251195811', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  27,'251195812', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  28,'251195813', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  29,'251195814', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  30,'251195815', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  31,'251195816', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  32,'251195817', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  33,'251195818', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  34,'251195819', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  35,'251195820', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  36,'251195821', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  37,'251195822', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  38,'251195823', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  39,'251195824', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  40,'251195825', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  41,'251195826', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  42,'251195827', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  43,'251195828', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  44,'251195829', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  45,'251195830', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  46,'251195831', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  47,'251195832', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  48,'251195833', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  49,'251195834', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  50,'251195835', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  51,'251195836', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  52,'251195837', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  53,'251195838', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  54,'251195839', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  55,'251195840', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  56,'251195841', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  57,'251195842', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  58,'251195843', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  59,'251195844', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  60,'251195845', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  61,'251195846', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  62,'251195847', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  63,'251195848', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  64,'251195849', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  65,'251195850', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  66,'251195851', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  67,'251195852', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  68,'251195853', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  69,'251195854', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  70,'251195855', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  71,'251195856', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  72,'251195857', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  73,'251195858', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  74,'251195859', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  75,'251195860', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  76,'251195861', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  77,'251195862', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  78,'251195863', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  79,'251195864', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  80,'251195865', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  81,'251195866', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  82,'251195867', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  83,'251195868', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  84,'251195869', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  85,'251195870', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  86,'251195871', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  87,'251195872', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  88,'251195873', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  89,'251195874', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  90,'251195875', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  91,'251195876', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  92,'251195877', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  93,'251195878', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  94,'251195879', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  95,'251195880', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  96,'251195881', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  97,'251195882', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  98,'251195883', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1,  99,'251195884', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 100,'251195885', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 101,'251195886', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 102,'251195887', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 103,'251195888', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 104,'251195889', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 105,'251195890', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 106,'251195891', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 107,'251195892', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 108,'251195893', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 109,'251195894', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 110,'251195895', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 111,'251195896', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 112,'251195897', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 113,'251195898', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 114,'251195899', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 115,'251195900', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 116,'251195901', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 117,'251195902', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 118,'251195903', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 119,'251195904', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 120,'251195905', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 121,'251195906', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 122,'251195907', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 123,'251195908', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 124,'251195909', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 125,'251195910', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 126,'251195911', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 127,'251195912', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 128,'251195913', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 129,'251195914', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 130,'251195915', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 131,'251195916', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 132,'251195917', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 133,'251195918', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 134,'251195919', '-', 'S', 'L', NULL)   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 135,'251195920', '-', 'S', 'L', NULL)
   if @@error <>0   begin      select @w_mensaje = '[15000]: ERROR EN INSERCION'      goto FIN   end
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 136, '251195921', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 137, '251195922', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 138, '251195923', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 139, '251195924', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 140, '251195925', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 141, '251195926', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 142, '251195927', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 143, '251195928', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 144, '251195929', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 145, '251195930', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 146, '251195931', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 147, '275000901', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 148, '275000902', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 149, '275000903', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	
   insert into cob_conta_super..sb_det_ctacontable_vrsformato values (@w_proceso, 3, 1, 1, 150, '250225005', '-', 'S', 'L', NULL)
   if @@error <>0 
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end	

   select '/*** DATOS DESPUES DE PARAMETRIZAR DETALLE CUENTA CONTABLE VS FORMATO 386 NIIF ***/'
   select *
   from   cob_conta_super..sb_det_ctacontable_vrsformato
   where  df_proceso = @w_proceso
   
    
print 'SCRIPT FINALIZADO'

FIN:
   print @w_mensaje
   
set nocount off
go
