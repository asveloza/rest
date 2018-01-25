/************************************************************************/
/*  Archivo:                         ecfor_386.sp                       */
/*  Stored procedure:                sp_formato_386                     */
/*  Base de datos:                   cob_conta_super                    */
/*  Producto:                        REC                                */
/*  Fecha de escritura:              10/31/2017                         */
/************************************************************************/
/*              IMPORTANTE                                              */
/*  Este programa es parte de los paquetes bancarios propiedad de       */
/*  "COBISCORP",                                                        */
/*  Su uso no autorizado queda expresamente prohibido asi como          */
/*  cualquier alteracion o agregado hecho por alguno de sus             */
/*  usuarios sin el debido consentimiento por escrito de la             */
/*  Presidencia Ejecutiva de COBISCORP o su representante.              */
/************************************************************************/
/*              PROPOSITO                                               */
/*  Ingresar los saldos del formato 386                                 */
/************************************************************************/
/*                           MODIFICACIONES                             */
/*  10/31/2017             Rodrigo Prada      Emision inicial           */
/************************************************************************/
use cob_conta_super
go

SET ANSI_NULLS OFF
go

SET QUOTED_IDENTIFIER OFF
go

if exists (select 1 from sysobjects where name = 'sp_formato_386')
drop proc sp_formato_386
go

create proc [sp_formato_386](
   @i_param1                    int      = null, --Empresa
   @i_param2                    datetime = null, --Fecha de Proceso
   @i_param3                    char(1)  = null, --Opcion F: Formatos
   @i_param4                    int      = null, --Formato
   @i_param5                    char(1)  = null  --Periodicidad
)
as
declare
   @w_empresa                   int,
   @w_sp_name                   varchar(40),
   @w_error                     int,
   @w_mensaje                   varchar(200),
   @w_periodo                   int,
   @w_corte                     int,
   @w_opcion                    char(1),
   @w_fto_ingreso               int,
   @w_columna                   int,
   @w_proceso                   varchar(30),
   @w_fila                      int,
   @w_fecha_ingreso             datetime,
   @w_valor_saldo               float,
   @w_return                    bigint,
   @w_periodicidad              char(1),
   @w_factor                    int,
   @w_tes_gar                   int,
   @w_tes_pf                    int,
   @w_tes_uvr                   int,
   @w_arcfor                    int,
   @w_invcartcol                int,
   @w_faccartcol                int,
   @w_valmer                    float,
   @w_durmod                    float,
   @w_totval                    float,
   @w_frw                       float,
   @w_uvr                       float,
   @w_colect                    float,
   @w_facsen                    float,
   @w_parfwd                    int,
   @w_parnd                     int,
   @w_colmin                    int,
   @w_trm                       money,
   @w_scta                      char(3),
   @w_curcol                    int,
   @w_curuc                     varchar(3),
   @w_cursct                    varchar(3),
   @w_curval                    money,
   @w_curtipo                   char(1),
   @w_curcat                    varchar(12),
   @w_curarch                   char(1)

   select
   @w_empresa       = @i_param1,
   @w_fecha_ingreso = @i_param2,
   @w_opcion        = @i_param3,
   @w_fto_ingreso   = @i_param4,
   @w_periodicidad  = @i_param5,
   @w_sp_name       = 'sp_formato_386'

   select
   @w_error          = 1,
   @w_mensaje        = 'FIN DEL PROCESO'

   select @w_facsen = convert(float,b.valor)
   from   cobis..cl_tabla a, cobis..cl_catalogo b
   where  a.codigo = b.tabla
   and    a.tabla = 'cl_fac_sen_386'
   and    b.codigo = 'USD'

   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Factor de sensibilizacion no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end

   select @w_factor = pa_int
   from cobis..cl_parametro 
   where pa_nemonico = 'FAC386'

   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Factor de tasa de interes no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end

   select @w_invcartcol = af_codigo
   from  cobis..cl_arch_formato
   where af_archivo like '%FORMATO 386 INVENTARIO CARTERAS COLECTIVAS%'
   and   af_tabla = 'ex_carteras_colectivas'
   
   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Plantilla Inventario Carteras Colectivas no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end
      
   select @w_faccartcol = af_codigo
   from  cobis..cl_arch_formato
   where af_archivo like '%FORMATO 386 FACTORES CARTERAS COLECTIVAS%'
   and   af_tabla = 'ex_carteras_colectivas'
   
   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Plantilla Factores Carteras Colectivas no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end
    
   select @w_arcfor = af_codigo
   from  cobis..cl_arch_formato
   where af_archivo like '%FORMATO 458 PORTAFOLIO TV%'
   and   af_tabla = 'ex_tipo_vencimientos'
   
   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Plantilla Formato 458 Portafolio TV no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end
    
   select @w_proceso      = cr_proceso
   from   cob_conta_super..sb_configurar_reportes
   where  cr_formato      = @w_fto_ingreso
   and    cr_estado       = 'V'
   and   (cr_periodicidad = @w_periodicidad
   or     cr_periodicidad is null)

   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Codigo Proceso no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end

   select @w_periodo = co_periodo,
          @w_corte   = co_corte
   from cob_conta..cb_corte
   where co_fecha_ini = @w_fecha_ingreso

   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Periodo y corte no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end

   select @w_trm    = ct_valor
   from   cob_conta..cb_cotizacion
   where  ct_moneda = 1
   and    ct_fecha  = @w_fecha_ingreso --dateadd(d,+1,@w_fecha_ingreso)
   
   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Valor de TRM no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end

   select @w_uvr = ct_valor
   from cob_conta..cb_cotizacion
   where ct_moneda = 3
   and   ct_fecha = @w_fecha_ingreso

   if @@rowcount = 0
   begin
      select @w_mensaje = 'Error - Valor de UVR no parametrizado',
             @w_error   = 999999
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
----------------------CREACION TABLA PARAMETROS TABLA DE INTERES------------------------------
----------------------------------------------------------------------------------------------

   select
   mo_moneda                                                                                  as moneda,
   mo_nemonico                                                                                as nemonico,
   substring(eq_valor_cat,1                                ,patindex('%-%',eq_valor_cat) - 1) as minimo,
   substring(eq_valor_cat,patindex('%-%',eq_valor_cat) + 1 ,len(eq_valor_cat)               ) as maximo,
   convert(float,eq_valor_arch) / @w_factor                                                   as facsen
   into #tmp_tasainteres
   from  cob_conta_super..sb_equivalencias a, cobis..cl_moneda
   where eq_descripcion = mo_nemonico
   and eq_catalogo = 'EC_RAN386'


   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE PARAMETRIZACION TASA DE INTERES 386.'
      goto ERRORFIN
   end
   
   
   select * 
   into #tmp_productos_ti
   from  cob_conta_super..sb_equivalencias
   where eq_catalogo ='EC_PROD386'
   
   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE PARAMETRIZACION PRODUCTOS TASA DE INTERES 386.'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
--------------------------------ASIGNACION VALOR FORWARD--------------------------------------
----------------------------------------------------------------------------------------------

   select di_tipo, sum(di_monto) valor
   into #tmp_forwards
   from cob_conta_super..sb_dato_inventariofrwd
   where di_tipo in (select substring(eq_valor_arch,7,1)
                     from  cob_conta_super..sb_equivalencias
                     where eq_catalogo                  = 'EC_OPER386'
                     and   substring(eq_valor_arch,3,4) = 'FWD_')
   and di_fecha_proc  = @w_fecha_ingreso

   group by di_tipo

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE INFORMACION PARA FORWARDS 386.'
   end

----------------------------------------------------------------------------------------------
---------------------------------CREACION TABLA NEXT DAY--------------------------------------
----------------------------------------------------------------------------------------------

   select dn_tipo_operacion, sum(dn_valor_nominal)  as valor
   into #tmp_nextday
   from cob_conta_super..sb_dato_nextday
   where dn_tipo_operacion in (select substring(eq_valor_arch,6,1)
                               from  cob_conta_super..sb_equivalencias
                               where eq_catalogo                  = 'EC_OPER386'
                               and   substring(eq_valor_arch,3,3) = 'ND_')
   and dn_fecha_proc   = @w_fecha_ingreso
   group by dn_tipo_operacion

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE INFORMACION PARA NEXT DAY.'
   end

----------------------------------------------------------------------------------------------
------------------------------CREACION TABLA PORTAFOLIO TV------------------------------------
----------------------------------------------------------------------------------------------

   select 
   moneda, 
   tv_valornominal   , tv_preciomercado , tv_duracion   , tv_valorgarantia,
   tv_estadoinversion, tv_producto      , tv_nemotecnico, eq_valor_arch   ,
   (tv_valorgarantia * (tv_preciomercado / 100)) valor  , b.facsen        
   into #tmp_vencimientos
   from  sb_tipo_vencimientos a, 
         #tmp_tasainteres     b,
		 #tmp_productos_ti    c
   where  b.nemonico            = c.eq_descripcion
   and    a.tv_producto         = c.eq_valor_cat
   and    a.tv_estadoinversion  = c.eq_valor_arch 
   and    tv_origen             = @w_arcfor
   and    tv_fecha_proc         = @w_fecha_ingreso
   and    a.tv_duracion between b.minimo and b.maximo

   
   union all
   
   select 
   moneda, 
   tv_valornominal   , tv_preciomercado , tv_duracion   , tv_valorgarantia,
   tv_estadoinversion, tv_producto      , tv_nemotecnico, eq_valor_arch   ,
   (tv_valornominal * (tv_preciomercado / 100)) valor  , b.facsen 
   from  sb_tipo_vencimientos a, 
         #tmp_tasainteres     b,
		 #tmp_productos_ti    c
   where  b.nemonico     =  c.eq_descripcion
   and    a.tv_producto  =  c.eq_valor_cat
   and    a.tv_origen    =  @w_arcfor
   and    tv_fecha_proc  = @w_fecha_ingreso
   and    a.tv_producto  in (select eq_valor_cat from #tmp_productos_ti where eq_valor_arch <> 'EN GARANTIA' )
   and    a.tv_duracion  between b.minimo and b.maximo
 

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE INFORMACION PARA VENCIMIENTOS 386.'
	  
   end
   else
   begin
 
      update #tmp_vencimientos
      set valor = valor * ct_valor
      from cob_conta..cb_cotizacion , #tmp_vencimientos
      where ct_moneda = moneda
      and   ct_fecha  = @w_fecha_ingreso
      
      if @@error <> 0
      begin
         select @w_error = @@error
         select @w_mensaje = 'ERROR AL ACTUALIZAR EL VALOR DE LA UVR'
         goto ERRORFIN
      end

	  select @w_totval = sum(a.valor * a.tv_duracion * a.facsen)
      from  #tmp_vencimientos a

   end
----------------------------------------------------------------------------------------------
--------------------------------CREACION CUENTAS CONTABLES------------------------------------
----------------------------------------------------------------------------------------------

   select convert(varchar(2),cf_columna)+cf_uc+cf_subcuenta as posicion, df_signo, abs(sum(isnull(hi_saldo,0))) / @w_trm as valor
   into #tmp_cuentas
   from cob_conta_his..cb_hist_saldo,
        cob_conta..cb_cuenta,
        cob_conta_super..sb_cab_ctacontable_vrsformato,
        cob_conta_super..sb_det_ctacontable_vrsformato
   where hi_cuenta   = df_cta_contabilid
   and   cf_proceso  = df_proceso
   and   cf_sec_cab  = df_sec_cab
   and   cu_cuenta   = hi_cuenta
   and   hi_oficina  > 0
   and   hi_area     > 0
   and   df_proceso  = @w_proceso
   and   hi_empresa  = @w_empresa
   and   hi_periodo  = @w_periodo
   and   hi_corte    = @w_corte
   group by convert(varchar(2),cf_columna)+cf_uc+cf_subcuenta, df_signo

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE PARAMETRIZACION DE CUENTAS CONTABLES PARA EL FORMATO 386.'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
-------------------------------CREACION CARTERA COLECTIVA-------------------------------------
----------------------------------------------------------------------------------------------

   select eq_valor_cat as ep_descripcion_or , eq_valor_arch as ep_descripcion_des
   into #tmp_entidades
   from cob_conta_super..sb_equivalencias
   where eq_catalogo = 'EC_CARC386'

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE PARAMETRIZACION DE CARTERA COLECTIVA 386.'
   end

   select cc_cartera_colectiva,cc_id_cliente,dn_saldo_actual,dn_moneda,dn_rendimiento_dia
   into #inventario_cartcol
   from cob_conta_super..sb_carteras_colectivas
   where cc_origen      = @w_invcartcol
   and   cc_fecha_proc  = @w_fecha_ingreso

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE INFORMACION DE INVENTARIO CARTERA COLECTIVA 386.'
   end

   select cc_cartera_colectiva,cc_id_cliente,cc_factor_riesgo_actual
   into #factores_cartcol
   from cob_conta_super..sb_carteras_colectivas
   where cc_origen = @w_faccartcol
   and   cc_fecha_proc  = @w_fecha_ingreso

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE INFORMACION DE FACTORES CARTERA COLECTIVA 386.'
   end

   select @w_colect = sum(round(a.dn_saldo_actual * c.cc_factor_riesgo_actual,1))
   from #inventario_cartcol a,
        #tmp_entidades b,
        #factores_cartcol c
   where a.cc_id_cliente     = b.ep_descripcion_des
   and   b.ep_descripcion_or = c.cc_id_cliente

----------------------------------------------------------------------------------------------
-----------------------------CREACION TABLA #tmp_valores--------------------------------------
----------------------------------------------------------------------------------------------

   select
   'va_num_val'        = eq_descripcion,
   'va_valor_cat'      = eq_valor_cat,
   'va_grupo_arch'     = substring(eq_valor_arch,1,1),
   'va_simbol_arch'    = substring(eq_valor_arch,2,1),
   'va_valor_arch'     = substring(eq_valor_arch,3,12),
   'va_val_arch'       = 0
   into  #tmp_valores
   from  cob_conta_super..sb_equivalencias
   where   eq_catalogo     = 'EC_OPER386'
   and   eq_estado         = 'V'
   order by va_valor_cat

   if @@rowcount = 0
   begin
      select
      @w_error   = 999999,
      @w_mensaje = 'NO EXISTE PARAMETRIZACION EQUIVALENCIAS PARA EL FORMATO 386.'
      goto ERRORFIN
   end

   alter table #tmp_valores alter column va_val_arch float

----------------------------------------------------------------------------------------------
---------------------------------ACTUALIZACION VALORES----------------------------------------
----------------------------------------------------------------------------------------------

   update #tmp_valores
   set va_val_arch = case when va_valor_arch = 'TASA'      then isnull(@w_totval,0)
                          when va_valor_arch = 'COLECTIVA' then isnull(@w_colect,0)
                     else va_val_arch end
   from #tmp_valores

   if @@error <> 0
   begin
      select
      @w_error   = 9999999,
      @w_mensaje = 'ERROR AL ACTUALIZAR SALDO REC EN TABLA TEMPORAL'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
---------------------------------ACTUALIZACION FORWARDS---------------------------------------
----------------------------------------------------------------------------------------------

   update #tmp_valores
   set va_val_arch =  isnull(valor,0)
   from #tmp_valores, #tmp_forwards
   where substring(va_valor_arch,5,1) = di_tipo
   and   substring(va_valor_arch,1,4) = 'FWD_'

   if @@error <> 0
   begin
      select
      @w_error   = 9999999,
      @w_mensaje = 'ERROR AL ACTUALIZAR SALDO REC EN TABLA TEMPORAL'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
---------------------------------ACTUALIZACION NEXT DAY---------------------------------------
----------------------------------------------------------------------------------------------

   update #tmp_valores
   set va_val_arch =  isnull(valor,0)
   from #tmp_valores, #tmp_nextday
   where substring(va_valor_arch,4,1) = dn_tipo_operacion
   and   substring(va_valor_arch,1,3) = 'ND_'

   if @@error <> 0
   begin
      select
      @w_error   = 9999999,
      @w_mensaje = 'ERROR AL ACTUALIZAR SALDO REC EN TABLA TEMPORAL'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
----------------------------ACTUALIZACION CUENTAS CONTABLES-----------------------------------
----------------------------------------------------------------------------------------------

   update #tmp_valores
   set va_val_arch = abs(isnull(valor,0))
   from #tmp_cuentas,
        #tmp_valores
   where posicion = convert(int,substring(va_valor_cat,5,len(va_valor_cat)))
   and   df_signo = va_simbol_arch

   if @@error <> 0
   begin
      select @w_error = @@error
      select @w_mensaje = 'ERROR AL ACTUALIZAR EL VALOR DE LA CUENTA'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
-------------------------------CREACION TABLA #validaciones-----------------------------------
----------------------------------------------------------------------------------------------

   select
   'va_num_val'     = va_num_val,
   'va_grupo_arch'  = va_grupo_arch,
   'va_valor_cat'   = substring(va_valor_cat,2,12),
   'va_val_arch'    = sum(isnull(va_val_arch,0))
   into #validaciones
   from #tmp_valores
   group by va_num_val, va_grupo_arch, substring(va_valor_cat,2,12)

   if @@rowcount = 0
   begin
      select
      @w_error   = 9999999,
      @w_mensaje = 'NO SE PUEDE CREAR LA TABLA DE EQUIVALENCIAS PARA EL PROCESO 386'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
------------------------------------CREACION TABLE CRUCE--------------------------------------
----------------------------------------------------------------------------------------------
    select
    'va_num_val'        = va_num_val        ,
    'va_valor_cat'      = va_valor_cat      ,
    'va_val_arch'       = 0                 ,
    'par1'              = [A]               ,
    'par2'              = [B]               ,
    'par3'              = [C]               ,
    'par4'              = [D]               ,
    'par5'              = [E]               ,
    'par6'              = [F]
    into #tmp_valdiv40
    from
    (select  va_num_val,va_grupo_arch, va_valor_cat,'operacion' as va_valor_arch,va_val_arch
    FROM #validaciones
    )  as  source
    PIVOT
    (
    sum(va_val_arch)
    for va_grupo_arch in ([A],[B],[C],[D],[E],[F])
    ) as piv

    alter table #tmp_valdiv40 alter column va_val_arch float

----------------------------------------------------------------------------------------------
----------------------------CALCULO DE LAS OPERACIONES SOLICITADAS----------------------------
----------------------------------------------------------------------------------------------

   update #tmp_valdiv40
   set va_val_arch     = case when substring(va_valor_cat,8,3) = '005' then par1
                              when substring(va_valor_cat,8,3) = '010' then abs(round(((((par1 + par2) + (par3)) - ((par4 + par5) + (par6)))  * (@w_facsen / 100)) * @w_trm,1))
                              when substring(va_valor_cat,8,3) = '015' then par1
                              when substring(va_valor_cat,8,3) = '020' then par1
                         end

   if @@error <> 0
   begin
      select @w_error = @@error
      select @w_mensaje = 'ERROR AL ACTUALIZAR EL VALOR DE LA CUENTA'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
-------------------------------------CALCULO DE TOTALES---------------------------------------
----------------------------------------------------------------------------------------------

   insert into #tmp_valdiv40
   (va_num_val      , va_valor_cat, va_val_arch     )
   select
   'OPERACIONES 386', '3860102005', abs(sum(va_val_arch))
   from #tmp_valdiv40

   if @@error <>0
   begin
      select @w_mensaje = '[15000]: ERROR EN INSERCION'
      goto ERRORFIN
   end

----------------------------------------------------------------------------------------------
-----------------------------------CARGUE A LA HIST_SALDO-------------------------------------
----------------------------------------------------------------------------------------------

   select @w_colmin   = min(co_num_columna)-1
   from   cob_conta_super..sb_columnas
   where  co_proceso  = @w_proceso
   and    co_tipo_col = '03'


   declare cursor_386 cursor for
      select   substring(va_valor_cat,4,2) + @w_colmin, substring(va_valor_cat,6,2), substring(va_valor_cat,8,3), va_val_arch
      from #tmp_valdiv40
      order by substring(va_valor_cat,4,2) + @w_colmin, substring(va_valor_cat,6,2), substring(va_valor_cat,8,3)
   for read only

   open  cursor_386
   fetch cursor_386
   into  @w_curcol, @w_curuc, @w_cursct, @w_curval

   while (@@fetch_status = 0)
   begin

      select @w_fila = fi_num_fila
      from cob_conta_super..sb_filas
      where fi_proceso=@w_proceso
      and (fi_num_col=1 and fi_descripcion = @w_cursct )
      and fi_num_fila in (select fi_num_fila
                          from cob_conta_super..sb_filas
                          where fi_proceso=@w_proceso
                          and fi_num_col=4
                          and fi_descripcion=@w_curuc)


      exec @w_return=cob_conta_super..sp_ingresa_saldo_386
         @i_empresa    =   @w_empresa,
         @i_periodo    =   @w_periodo,
         @i_corte      =   @w_corte,
         @i_proceso    =   @w_proceso,
         @i_fila       =   @w_fila ,
         @i_columna    =   @w_curcol,
         @i_saldo      =   @w_curval,
         @i_fecha_proc =   @w_fecha_ingreso

      if @w_return<>0
      begin
        select @w_error   = 9999999,
        @w_mensaje  = 'ERROR INSERTANDO DATOS EN SB_HIST_SALDO FORMATO 386'
        goto ERRORFIN
      end

      fetch cursor_386
      into  @w_curcol, @w_curuc, @w_cursct, @w_curval
   end
   close cursor_386
   deallocate cursor_386

return 0

   ERRORFIN:
   begin
      select @w_mensaje = @w_sp_name + ' ' + @w_mensaje

      Exec cob_conta_super..sp_errorlog
         @i_operacion     = 'I',
         @i_fecha_fin     = @w_fecha_ingreso,
         @i_origen_error  = @w_error,
         @i_fuente        = @w_sp_name,
         @i_descrp_error  = @w_mensaje
      return @w_error
   end

   go
   