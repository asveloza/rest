/**********************************************************************/
/*  Archivo:                            ec_cab_cibf_form386.sql       */
/*  Base de datos:                      cobis                         */
/*  Producto:                           CIBF                          */
/*  Fecha de escritura:                 16.11.2017                    */
/**********************************************************************/
/*                          IMPORTANTE                                */
/*  Este programa es parte de los paquetes bancarios propiedad de     */
/*  "COBISCORP", su uso no autorizado queda expresamente prohibido asi*/
/*  como cualquier alteracion o agregado hecho por alguno de sus      */
/*  usuarios sin el debido consentimiento por escrito de la           */
/*  presidencia Ejecutiva de COBISCORP o su representante.            */
/**********************************************************************/
/*                           PROPOSITO                                */
/*  Creacion de la parametrizacion del fomrato 386                    */
/**********************************************************************/
/*                         MODIFICACIONES                             */
/*  FECHA         AUTOR                   RAZON                       */
/*  16.11.2017   Rodrigo Prada         Emision Inicial                */
/**********************************************************************/
use cobis
go

declare
@w_tabla   int,
@w_campo   int,
@w_mensaje varchar(250)

select @w_mensaje = '',
       @w_tabla = 0,
       @w_campo = 0

/*CABECERA*/

print 'CABECERA FORMATO 386 INVENTARIO NEXTDAY'
if exists(select 1 from  cl_arch_formato where af_archivo='FORMATO 386 INVENTARIO NEXTDAY' and af_tabla = 'ex_dato_nextday' )
begin
   select @w_tabla=af_codigo from cl_arch_formato where af_archivo = 'FORMATO 386 INVENTARIO NEXTDAY'  and af_tabla = 'ex_dato_nextday'

   delete cl_arch_formato where af_codigo=@w_tabla
   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN ELIMINACION'
      goto FIN
   end

   delete cl_det_archivo where da_codigo=@w_tabla
   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN ELIMINACION'
      goto FIN
   end
end

print 'CABECERA FORMATO 386 INVENTARIO CARTERAS COLECTIVAS'
if exists(select 1 from  cl_arch_formato where af_archivo= 'FORMATO 386 INVENTARIO CARTERAS COLECTIVAS' and af_tabla = 'ex_carteras_colectivas')
begin
   select @w_tabla=af_codigo from cl_arch_formato where af_archivo= 'FORMATO 386 INVENTARIO CARTERAS COLECTIVAS' and af_tabla = 'ex_carteras_colectivas'

   delete cl_arch_formato where af_codigo=@w_tabla
   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN ELIMINACION'
      goto FIN
   end

   delete cl_det_archivo where da_codigo=@w_tabla
   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN ELIMINACION'
      goto FIN
   end
end

if exists(select 1 from  cl_arch_formato where af_archivo= 'FORMATO 386 FACTORES CARTERAS COLECTIVAS' and af_tabla = 'ex_carteras_colectivas')
begin
   select @w_tabla=af_codigo from cl_arch_formato where af_archivo= 'FORMATO 386 FACTORES CARTERAS COLECTIVAS'

   delete cl_arch_formato where af_codigo=@w_tabla
   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN ELIMINACION'
      goto FIN
   end

   delete cl_det_archivo where da_codigo=@w_tabla
   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN ELIMINACION'
      goto FIN
   end
end
--*************************************************************--
-- 1 --
print 'DETALLE FORMATO 386 INVENTARIO NEXTDAY'
    select @w_tabla = max(af_codigo) + 1 from  cl_arch_formato

    insert into cobis..cl_arch_formato  (
       af_codigo          , af_archivo                      , af_descripcion                   ,
       af_delimitador     , af_delimitador_reg              , af_base                          ,
       af_tabla           , af_proceso                      , af_campo_usr_carga               ,
       af_campo_sec_carga , af_tolerancia                   , af_linea_inicial                 ,
       af_linea_final     , af_transaccion                  , af_estado                        ,
       af_user_crea       , af_fecha_crea                   , af_user_mod                      ,
       af_fecha_mod       , af_longitud_fija                , af_porcentaje                    ,
       af_actualiza       , af_cod_producto                 , af_des_producto                  ,
       af_tipo_plantilla)
    values(
       @w_tabla           , 'FORMATO 386 INVENTARIO NEXTDAY', 'FORMATO 386 INVENTARIO NEXTDAY' ,
       ';'                , 'ENT'                           , 'cob_externos'                   ,
       'ex_dato_nextday'  , NULL                            , NULL                             ,
       NULL               , 'N'                             , 1                                ,
       0                  , NULL                            , 'V'                              ,
       'caruiz'           , getdate()                       , NULL                             ,
       NULL               , 'N'                             , NULL                             ,
       'N'                , NULL                            , 'REPORTES SUPER BANCARIA'        ,
       'I')
	
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end
      -------------------------------------------------------
   
    select @w_campo =@w_campo+1


    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'COD_REF'           ,
       'dn_referencia'        , 'A'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'OPER'              ,
       'dn_tipo_operacion'    , 'A'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'CLIENTE'           ,
       'dn_id_cliente'        , 'A'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'FECHA_VALOR'       ,
       'dn_fecha_valor'       , 'D'             , null                ,
       null                   , 0               , 'M'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'FECHA_PAGO'        ,
       'dn_fecha_pago'        , 'D'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'FECHA_VENC'        ,
       'dn_fecha_venc'        , 'D'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'PLAZO'             ,
       'dn_plazo'             , 'S'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'PLAZO_ORIGINAL'    ,
       'dn_plazo_original'    , 'S'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'VALOR_NOMINAL'     ,
       'dn_valor_nominal'     , 'M'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'VALOR_MONEDA_LEGAL',
       'dn_valor_moneda_legal', 'M'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'COTIZACION_PACTADA',
       'dn_cotización_pactada', 'M'             , null                ,
       null                   , 0               , 'M'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo                   , da_secuencia    , da_campo_arch            ,
       da_campo_tabla              , da_tipo         , da_catalogo              ,
       da_formato_fech             , da_cod_for_fech , da_obligatoriedad        ,
       da_equivalencia             , da_cataloga     , da_operable              ,
       da_llave                    , da_pos_ini      , da_longitud              ,
       da_tipo_equ)                
    values (                       
       @w_tabla                    , @w_campo        , 'COTIZACION_SPOT_CIERRE' ,
       'dn_cotización_spot_cierre' , 'M'             , null                     ,
       null                        , 0               , 'M'                      ,
       'N'                         , 'N'             , null                     ,
       'N'                         , 1               , 0                        ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'TASA_INTERES'      ,
       'dn_tasa'              , 'F'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch             ,
       da_campo_tabla         , da_tipo         , da_catalogo               ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad         ,
       da_equivalencia        , da_cataloga     , da_operable               ,
       da_llave               , da_pos_ini      , da_longitud               ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'TASA_INTERES_MON_LEGAL'  ,
       'dn_tasa_mon_legal'    , 'F'             , null                      ,
       null                   , 0               , 'A'                       ,
       'N'                    , 'N'             , null                      ,
       'N'                    , 1               , 0                         ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo                , da_secuencia    , da_campo_arch         ,
       da_campo_tabla           , da_tipo         , da_catalogo           ,
       da_formato_fech          , da_cod_for_fech , da_obligatoriedad     ,
       da_equivalencia          , da_cataloga     , da_operable           ,
       da_llave                 , da_pos_ini      , da_longitud           ,
       da_tipo_equ)                                                       
    values (                    
       @w_tabla                 , @w_campo        , 'VALORACION_DERECHOS' ,
       'dn_valoracion_derechos' , 'M'             , null                  ,
       null                     , 0               , 'A'                   ,
       'N'                      , 'N'             , null                  ,
       'N'                      , 1               , 0                     ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo                  , da_secuencia    , da_campo_arch           ,
       da_campo_tabla             , da_tipo         , da_catalogo             ,
       da_formato_fech            , da_cod_for_fech , da_obligatoriedad       ,
       da_equivalencia            , da_cataloga     , da_operable             ,
       da_llave                   , da_pos_ini      , da_longitud             ,
       da_tipo_equ)               
    values (                     
       @w_tabla                   , @w_campo        , 'VALORACION_OBLIGACION' ,
       'dn_valoracion_obligacion' , 'M'             , null                    ,
       null                       , 0               , 'A'                     ,
       'N'                        , 'N'             , null                    ,
       'N'                        , 1               , 0                       ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'PYG'               ,
       'dn_pyg'               , 'M'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)

    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

/**********************************************************************/
-- 2 --
print 'DETALLE FORMATO 386 INVENTARIO CARTERAS COLECTIVAS'

    select @w_tabla = max(af_codigo) + 1 from  cl_arch_formato

    insert into cobis..cl_arch_formato  (
       af_codigo                 , af_archivo                                  , af_descripcion                              ,
       af_delimitador            , af_delimitador_reg                          , af_base                                     ,
       af_tabla                  , af_proceso                                  , af_campo_usr_carga                          ,
       af_campo_sec_carga        , af_tolerancia                               , af_linea_inicial                            ,
       af_linea_final            , af_transaccion                              , af_estado                                   ,
       af_user_crea              , af_fecha_crea                               , af_user_mod                                 ,
       af_fecha_mod              , af_longitud_fija                            , af_porcentaje                               ,
       af_actualiza              , af_cod_producto                             , af_des_producto                             ,
       af_tipo_plantilla)                                                                                                   
    values(                                                                                                               
       @w_tabla                  , 'FORMATO 386 INVENTARIO CARTERAS COLECTIVAS', 'FORMATO 386 INVENTARIO CARTERAS COLECTIVAS',
       ';'                       , 'ENT'                                       , 'cob_externos'                              ,
       'ex_carteras_colectivas'  , NULL                                        , NULL                                        ,
       NULL                      , 'N'                                         , 1                                           ,
       0                         , NULL                                        , 'V'                                         ,
       'caruiz'                  , getdate()                                   , NULL                                        ,
       NULL                      , 'N'                                         , NULL                                        ,
       'N'                       , NULL                                        , 'REPORTES SUPER BANCARIA'                   ,
       'I')
	
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end
      -------------------------------------------------------
    select @w_campo = 0
    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'CARTERA_COLECTIVA' ,
       'cc_cartera_colectiva' , 'A'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)
	   
    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch     ,
       da_campo_tabla         , da_tipo         , da_catalogo       ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad ,
       da_equivalencia        , da_cataloga     , da_operable       ,
       da_llave               , da_pos_ini      , da_longitud       ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'CLIENTE '        ,
       'cc_id_cliente'        , 'A'             , null              ,
       null                   , 0               , 'A'               ,
       'N'                    , 'N'             , null              ,
       'N'                    , 1               , 0                 ,
       null)
	   
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch     ,
       da_campo_tabla         , da_tipo         , da_catalogo       ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad ,
       da_equivalencia        , da_cataloga     , da_operable       ,
       da_llave               , da_pos_ini      , da_longitud       ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'SALDO_ACTUAL'    ,
       'dn_saldo_actual'      , 'M'             , null              ,
       null                   , 0               , 'M'               ,
       'N'                    , 'N'             , null              ,
       'N'                    , 1               , 0                 ,
       null)
	   
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch     ,
       da_campo_tabla         , da_tipo         , da_catalogo       ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad ,
       da_equivalencia        , da_cataloga     , da_operable       ,
       da_llave               , da_pos_ini      , da_longitud       ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'MONEDA'          ,
       'dn_moneda'            , 'A'             , null              ,
       null                   , 0               , 'M'               ,
       'N'                    , 'N'             , null              ,
       'N'                    , 1               , 0                 ,
       null)
	   
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch         ,
       da_campo_tabla         , da_tipo         , da_catalogo           ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad     ,
       da_equivalencia        , da_cataloga     , da_operable           ,
       da_llave               , da_pos_ini      , da_longitud           ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'RENDIMIENTO_DEL_DIA' ,
       'dn_rendimiento_dia'   , 'M'             , null                  ,
       null                   , 0               , 'M'                   ,
       'N'                    , 'N'             , null                  ,
       'N'                    , 1               , 0                     ,
       null)
	   
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

/**********************************************************************/
-- 3 --
print 'DETALLE FORMATO 386 FACTORES CARTERAS COLECTIVAS'

    select @w_tabla = max(af_codigo) + 1 from  cl_arch_formato

    insert into cobis..cl_arch_formato  (
       af_codigo                 , af_archivo                                  , af_descripcion                              ,
       af_delimitador            , af_delimitador_reg                          , af_base                                     ,
       af_tabla                  , af_proceso                                  , af_campo_usr_carga                          ,
       af_campo_sec_carga        , af_tolerancia                               , af_linea_inicial                            ,
       af_linea_final            , af_transaccion                              , af_estado                                   ,
       af_user_crea              , af_fecha_crea                               , af_user_mod                                 ,
       af_fecha_mod              , af_longitud_fija                            , af_porcentaje                               ,
       af_actualiza              , af_cod_producto                             , af_des_producto                             ,
       af_tipo_plantilla)                                                                                                   
    values(                                                                                                               
       @w_tabla                  , 'FORMATO 386 FACTORES CARTERAS COLECTIVAS'  , 'FORMATO 386 FACTORES CARTERAS COLECTIVAS'  ,
       ';'                       , 'ENT'                                       , 'cob_externos'                              ,
       'ex_carteras_colectivas'  , NULL                                        , NULL                                        ,
       NULL                      , 'N'                                         , 1                                           ,
       0                         , NULL                                        , 'V'                                         ,
       'caruiz'                  , getdate()                                   , NULL                                        ,
       NULL                      , 'N'                                         , NULL                                        ,
       'N'                       , NULL                                        , 'REPORTES SUPER BANCARIA'                   ,
       'I')
	
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end
      -------------------------------------------------------
    select @w_campo = 0
    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch       ,
       da_campo_tabla         , da_tipo         , da_catalogo         ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad   ,
       da_equivalencia        , da_cataloga     , da_operable         ,
       da_llave               , da_pos_ini      , da_longitud         ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'CARTERA_COLECTIVA' ,
       'cc_cartera_colectiva' , 'A'             , null                ,
       null                   , 0               , 'A'                 ,
       'N'                    , 'N'             , null                ,
       'N'                    , 1               , 0                   ,
       null)
	   
    if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo              , da_secuencia    , da_campo_arch     ,
       da_campo_tabla         , da_tipo         , da_catalogo       ,
       da_formato_fech        , da_cod_for_fech , da_obligatoriedad ,
       da_equivalencia        , da_cataloga     , da_operable       ,
       da_llave               , da_pos_ini      , da_longitud       ,
       da_tipo_equ)           
    values (               
       @w_tabla               , @w_campo        , 'CLIENTE '        ,
       'cc_id_cliente'        , 'A'             , null              ,
       null                   , 0               , 'A'               ,
       'N'                    , 'N'             , null              ,
       'N'                    , 1               , 0                 ,
       null)
	   
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

    select @w_campo =@w_campo+1

    insert into cobis..cl_det_archivo(
       da_codigo                 , da_secuencia    , da_campo_arch          ,
       da_campo_tabla            , da_tipo         , da_catalogo            ,
       da_formato_fech           , da_cod_for_fech , da_obligatoriedad      ,
       da_equivalencia           , da_cataloga     , da_operable            ,
       da_llave                  , da_pos_ini      , da_longitud            ,
       da_tipo_equ)           
    values (               
       @w_tabla                  , @w_campo        , 'FACTOR_RIESGO_ACTUAL' ,
       'cc_factor_riesgo_actual' , 'F'             , null                   ,
       null                      , 0               , 'M'                    ,
       'N'                       , 'N'             , null                   ,
       'N'                       , 1               , 0                      ,
       null)
	   
     if @@error <>0
     begin
       select @w_mensaje = '[15000]: ERROR EN INSERCION'
       goto FIN
    end

	print 'FINALIZA SCRIPT'
	
FIN:
    print @w_mensaje

go
