/**********************************************************************/
/*  Archivo:                         ec_equiv_form_386.sql            */
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
/*  parametrizacion de equivalencias del formato 386                  */
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

declare @w_mensaje    varchar(250),
        @w_tabla      smallint,
        @w_cod_prod   smallint,
        @w_cod_ent    int,
        @w_proceso    int,
        @w_error      int

select @w_proceso = 28850 , -- numero de proceso diario
       @w_tabla   = 0,
       @w_error   = 0,
       @w_mensaje = ''

print '************************************************'
print '*****      INSERCION PARAMETRIZACION      ******'
print '************************************************'
print ''

print 'Parametro de factor'

if exists(select 1 from cobis..cl_parametro where pa_nemonico = 'FAC386')
begin
   delete cobis..cl_parametro where pa_nemonico = 'FAC386'
end

if @@error <>0
begin
   select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
   goto FIN
end

insert into cobis..cl_parametro
values
('Factor 386','FAC386','I',NULL,NULL,NULL,10000,NULL,NULL,NULL,'REC')

if @@error <>0
begin
   select @w_mensaje = '[15000]: ERROR EN INSERCION'
   goto FIN
end

-------------------------------------------------------------------
------ PARAMETRIZACION CATALOGOS Y EQUIVALENCIAS FORMATO 386 ------
-------------------------------------------------------------------

select @w_tabla = codigo from cobis..cl_tabla where tabla = 'ec_equivalencias'

if @w_tabla = null or @w_tabla =''
   print 'TABLA DE CATALOGO - ec_equivalencias NO EXISTE'
else
begin

   if exists(select 1 from cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_OPER386')
   begin
      delete cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_OPER386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end

   insert into cobis..cl_catalogo
   values
   (@w_tabla,'EC_OPER386','OPERACIONES 386','V',NULL,NULL,NULL)

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   if exists(select 1 from cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_OPER386')
   begin
      delete cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_OPER386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end

   print 'Ingreso en equivalencias Cuentas contables 386'
   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'A3860101005', 'A|TASA'     , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'B3860101010', 'A+386'      , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'B3860101010', 'B|ND_C'     , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'B3860101010', 'C|FWD_C'    , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'B3860101010', 'D-386'      , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'B3860101010', 'E|ND_V'     , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'B3860101010', 'F|FWD_V'    , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'A3860101015', 'A|0'        , 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   insert into cob_conta_super..sb_equivalencias values ('EC_OPER386', 'C3860101020', 'A|COLECTIVA', 'OPERACIONES 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   print 'Fin Ingreso en equivalencias OPERACIONES 386'

   ------

   if exists(select 1 from cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_CARC386')
   begin
      delete cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_CARC386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end

   insert into cobis..cl_catalogo
   values
   (@w_tabla,'EC_CARC386','CARTERA COLECTIVA 386','V',NULL,NULL,NULL)

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end


   if exists(select 1 from cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_CARC386')
   begin
      delete cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_CARC386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end

   print 'Ingreso en equivalencias Cartera colectiva 386'
   insert into cob_conta_super..sb_equivalencias values ('EC_CARC386', 'CARTERA COLECTIVA ABIERTA POR COMPARTIMIENTOS VALOR PLUS', 'CARTERA COLECTIVA ABIERTA POR COMPARTIMIENTOS VALOR PLUS'   , 'CARTERA COLECTIVA 386', 'V')
   
   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   insert into cob_conta_super..sb_equivalencias values ('EC_CARC386', 'CARTERA COLECTIVA ABIERTA SUMAR CARTERA POR COMPARTIMENTOS' , 'CARTERA COLECTIVA ABIERTA SUMAR CARTERA POR COMPARTIMENTOS' , 'CARTERA COLECTIVA 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_CARC386', 'CARTERA COLECTIVA SIN PACTO DE PERMANENCIA OCCIRENTA'  , 'CARTERA COLECTIVA SIN PACTO DE PERMANENCIA OCCIRENTA'       , 'CARTERA COLECTIVA 386', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   print 'Fin Ingreso en equivalencias OPERACIONES 386'
   ------

   if exists(select 1 from cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_RAN386')
   begin
      delete cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_RAN386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end
   insert into cobis..cl_catalogo
   values
   (@w_tabla,'EC_RAN386','PARAMETROS TASA DE INTERES 386','V',NULL,NULL,NULL)

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   if exists(select 1 from cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_RAN386')
   begin
      delete cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_RAN386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end

   print 'Ingreso en equivalencias PARAMETROS TASA DE INTERES 386'

   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0-0.08'    , '274' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0.08-0.25' , '268' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0.25-0.5'  , '259' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0.5-1'     , '233' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '1-1.9'     , '222' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '1.9-2.8'   , '222' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '2.8-3.6'   , '211' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '3.6-4.3'   , '211' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '4.3-5.7'   , '172' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '5.7-7.3'   , '162' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '7.3-9.3'   , '162' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '9.3-10.6'  , '162' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '10.6-12'   , '162' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '12-20'     , '162' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '20-99'     , '162' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0-0.08'    , '274' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0.08-0.25' , '274' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0.25-0.5'  , '274' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '0.5-1'     , '274' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '1-1.9'     , '250' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '1.9-2.8'   , '250' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '2.8-3.6'   , '220' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '3.6-4.3'   , '220' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '4.3-5.7'   , '200' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '5.7-7.3'   , '170' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '7.3-9.3'   , '170' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '9.3-10.6'  , '170' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '10.6-12'   , '170' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '12-20'     , '170' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_RAN386', '20-99'     , '170' , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   print 'Fin Ingreso en equivalencias PARAMETROS TASA DE INTERES 386'

   if exists(select 1 from cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_PROD386')
   begin
      delete cobis..cl_catalogo where tabla = @w_tabla and codigo = 'EC_PROD386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end

   insert into cobis..cl_catalogo
   values
   (@w_tabla,'EC_PROD386','PARAMETROS PRODUCTOS TASA DE INTERES','V',NULL,NULL,NULL)

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   if exists(select 1 from cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_PROD386')
   begin
      delete cob_conta_super..sb_equivalencias where eq_catalogo = 'EC_PROD386'
   end

   if @@error <>0
   begin
      select @w_mensaje = '[15004]: ERROR EN LA ELIMINACION'
      goto FIN
   end

   print 'Ingreso en equivalencias Productos tasa de interes 386'
   
   insert into cob_conta_super..sb_equivalencias values ('EC_PROD386', 'TES PESOS'   , 'PESOS'       , 'COP', 'V')
   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end

   insert into cob_conta_super..sb_equivalencias values ('EC_PROD386', 'TDA CLASE A' , 'EN GARANTIA' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
   
   insert into cob_conta_super..sb_equivalencias values ('EC_PROD386', 'TDA CLASE B' , 'EN GARANTIA' , 'COP', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end   
   
   insert into cob_conta_super..sb_equivalencias values ('EC_PROD386', 'TES UVR'     , 'UVR'         , 'UVR', 'V')

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto FIN
   end
  

   print 'Fin Ingreso en equivalencias Productos tasa de interes 386'
   
end

FIN:

go
