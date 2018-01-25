/************************************************************************/
/*  Archivo:              script_catalogos_386.sql                      */
/*  Base de datos:        cobis                                         */
/*  Producto:             REC                                           */
/************************************************************************/
/*              IMPORTANTE                                              */
/*  Este programa es parte de los paquetes bancarios propiedad de       */
/*  "COBISCORP", representantes exclusivos para el Ecuador de la        */
/*  "NCR CORPORATION".                                                  */
/*  Su uso no autorizado queda expresamente prohibido asi como          */
/*  cualquier alteracion o agregado hecho por alguno de sus             */
/*  usuarios sin el debido consentimiento por escrito de la             */
/*  Presidencia Ejecutiva de COBISCORP o su representante.              */
/************************************************************************/
/*                        PROPOSITO                                     */
/* Script creacion de los productos del mercado de portafolio  TV       */
/*                                                                      */
/************************************************************************/
/*                      MODIFICACIONES                                  */
/*  FECHA             AUTOR                RAZON                        */
/*  20/NOV/2017     Rodrigo Prada         Emision Inicial                */
/************************************************************************/
use cobis
go

SET NOCOUNT ON
go

SET ANSI_NULLS OFF
go

SET QUOTED_IDENTIFIER OFF
go

declare
@w_cod_prod smallint,
@w_cod_uvr  smallint,
@w_cod_fwd  smallint,
@w_cod_sen  smallint,
@w_cod_gar  smallint


print '************************************************'
print '***** INSERCION PARAMETRIZACION           ******'
print '************************************************'
print ''

-----------------------------------------------------------------
------------------------CATALOGO DE TDA--------------------------
-----------------------------------------------------------------
print '------Eliminacion catalogo de Productos'

select @w_cod_gar  = codigo
from   cobis..cl_tabla
where  tabla = 'cl_tda_gar_386'

delete cobis..cl_tabla
where  tabla  = 'cl_tda_gar_386'
and    codigo = @w_cod_gar

delete cobis..cl_catalogo
where  tabla = @w_cod_gar

delete cl_catalogo_pro
where  cp_tabla = @w_cod_gar

-----------------------------------------------------------------
------------------------CATALOGO DE TES--------------------------
-----------------------------------------------------------------
print '------Eliminacion catalogo de Productos TES'

select @w_cod_prod  = codigo
from   cobis..cl_tabla
where  tabla = 'cl_tes_pf_386'

delete cobis..cl_tabla
where  tabla  = 'cl_tes_pf_386'
and    codigo = @w_cod_prod

delete cobis..cl_catalogo
where  tabla = @w_cod_prod

delete cl_catalogo_pro
where  cp_tabla = @w_cod_prod

-----------------------------------------------------------------
------------------------CATALOGO DE UVR--------------------------
-----------------------------------------------------------------

print '------Eliminacion catalogo de Productos UVR'

select @w_cod_uvr = codigo
from   cobis..cl_tabla
where  tabla = 'cl_tes_uvr_386'

delete cl_tabla
where  tabla  = 'cl_tes_uvr_386'
and    codigo = @w_cod_uvr

delete cobis..cl_catalogo
where  tabla = @w_cod_uvr

delete cl_catalogo_pro
where  cp_tabla = @w_cod_uvr

-----------------------------------------------------------------
-------------CATALOGO DE FACTOR DE SENSIBILIZACION---------------
-----------------------------------------------------------------
print ''

print '------creando catalogo de Factor de sensibilizacion'



select @w_cod_sen = codigo
from   cobis..cl_tabla
where  tabla = 'cl_fac_sen_386'

if @w_cod_sen is null
begin
   select @w_cod_sen = max(codigo) + 1
   from   cobis..cl_tabla
end

begin tran

delete cl_tabla
where  tabla  = 'cl_fac_sen_386'
and    codigo = @w_cod_sen

if @@error <> 0 begin
   print '[ERROR]: Al borrar en tabla Factor de sensibilizacion'
   rollback tran
   goto FIN
end

delete cobis..cl_catalogo
where  tabla = @w_cod_sen

if @@error <> 0 begin
   print '[ERROR]: Al borrar en catalogo Factor de sensibilizacion'
   rollback tran
   goto FIN
end

delete cl_catalogo_pro
where  cp_tabla = @w_cod_sen

if @@error <> 0 begin
   print '[ERROR]: Al borrar en producto-catalogo Factor de sensibilizacion'
   rollback tran
   goto FIN
end

insert into cobis..cl_tabla
(codigo      , tabla          , descripcion)
values
(@w_cod_sen  , 'cl_fac_sen_386' , 'FACTOR DE SENSIBILIZACION 386')

if @@error <> 0 begin
   print '[ERROR]: Al insertar en tabla Factor de sensibilizacion'
   rollback tran
   goto FIN
end

update cobis..cl_seqnos set
siguiente = @w_cod_sen
where tabla = 'cl_tabla'

if @@error <> 0 begin
   print '[ERROR]: Al actualizar cl_seqnos'
   rollback tran
   goto FIN
end

print '--------------- se crea la tabla de catalogo cl_fac_sen_386'

insert into cobis..cl_catalogo
(tabla       , codigo , valor    , estado)
values
(@w_cod_sen , 'USD'    , '5.5' , 'V'   )

if @@error <> 0 begin
   print '[ERROR]: Al insertar en cl_catalogo Factor de sensibilizacion'
   rollback tran
   goto FIN
end

insert into cobis..cl_catalogo
(tabla       , codigo , valor    , estado)
values
(@w_cod_sen , 'EUR'    , '6' , 'V'   )

if @@error <> 0 begin
   print '[ERROR]: Al insertar en cl_catalogo Factor de sensibilizacion'
   rollback tran
   goto FIN
end

insert into cobis..cl_catalogo
(tabla       , codigo , valor    , estado)
values
(@w_cod_sen , 'ORO'    , '8' , 'V'   )

if @@error <> 0 begin
   print '[ERROR]: Al insertar en cl_catalogo Factor de sensibilizacion'
   rollback tran
   goto FIN
end

insert into cobis..cl_catalogo
(tabla       , codigo , valor    , estado)
values
(@w_cod_sen , 'RIESGO' , '14.7', 'V'   )

if @@error <> 0 begin
   print '[ERROR]: Al insertar en cl_catalogo Factor de sensibilizacion'
   rollback tran
   goto FIN
end

print '------------ se ingresan Factor de sensibilizacion'

insert into cobis..cl_catalogo_pro
(cp_producto, cp_tabla    )
values
('SUP'      , @w_cod_sen )

if @@error <> 0 begin
   print '[ERROR]: Al insertar en cl_catalogo Factor de sensibilizacion'
   rollback tran
   goto FIN
end

commit tran

print '------------ Se termina creacion de Factor de sensibilizacion'

FIN:
go
