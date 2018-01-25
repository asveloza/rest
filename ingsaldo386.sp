/************************************************************************/
/*  Archivo:                         ingsaldo386.sp                     */
/*  Stored procedure:                sp_ingresa_saldo_386               */
/*  Base de datos:                   cob_conta_super                    */
/*  Producto:                        REC                                */
/*  Fecha de escritura:              09/27/2017                         */
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

if exists (select 1 from sysobjects where name = 'sp_ingresa_saldo_386')
   drop proc sp_ingresa_saldo_386
go

create proc sp_ingresa_saldo_386(
  @i_empresa       int,
  @i_periodo       int,
  @i_corte         int,
  @i_proceso       int,
  @i_fila          int,
  @i_columna       int,
  @i_saldo         money,
  @i_fecha_proc    datetime
)
as
declare
@w_sp_name                   varchar(30),
@w_error                     varchar(255),
@w_retorno                   tinyint,
@w_mensaje                   varchar(255)

select @w_sp_name ='sp_ingresa_saldo_386'


if exists (select 1 from cob_conta_super..sb_hist_saldo
           where hs_empresa = @i_empresa and hs_periodo = @i_periodo
           and   hs_corte   = @i_corte   and hs_proceso = @i_proceso
           and   hs_fila    = @i_fila    and hs_columna = @i_columna)
begin

     update cob_conta_super..sb_hist_saldo
     set hs_saldo=@i_saldo
     where hs_empresa = @i_empresa and hs_periodo = @i_periodo
     and   hs_corte   = @i_corte   and hs_proceso = @i_proceso
     and   hs_fila    = @i_fila    and hs_columna = @i_columna

     if @@error <> 0
     begin

        print '@i_empresa: ' +
              '@i_proceso: ' + cast(@i_proceso as varchar) + ' @i_fila    : ' + cast(@i_fila as varchar)   +
              '@i_col    : ' + cast(@i_columna as varchar) + ' @i_saldo   : ' + cast(@i_saldo as varchar)  +
              '@i_saldo  : ' + cast(@i_saldo as varchar)   + ' @i_periodo : ' + cast(@i_periodo as varchar)+
              '@i_corte  : ' + cast(@i_corte as varchar)   +
              '@i_empresa: '

     select
        @w_error   = 151068,
        @w_mensaje  = 'ERROR ACTUALIZANDO DATOS EN SB_HIST_SALDO'
        goto ERROR
     end
end
else
begin
     insert into  cob_conta_super..sb_hist_saldo
     (hs_empresa, hs_periodo, hs_corte, hs_proceso, hs_fila, hs_columna, hs_saldo)
     values
     (@i_empresa, @i_periodo, @i_corte, @i_proceso, @i_fila, @i_columna, @i_saldo)

     if @@error <> 0
     begin
        print '@i_empresa: ' +
              '@i_proceso: ' + cast(@i_proceso as varchar) + ' @i_fila    : ' + cast(@i_fila as varchar)   +
              '@i_col    : ' + cast(@i_columna as varchar) + ' @i_saldo   : ' + cast(@i_saldo as varchar)  +
              '@i_saldo  : ' + cast(@i_saldo as varchar)   + ' @i_periodo : ' + cast(@i_periodo as varchar)+
              '@i_corte  : ' + cast(@i_corte as varchar)   +
              '@i_empresa: '
        select
        @w_error   = 151068,
        @w_mensaje  = 'ERROR INSERTANDO DATOS EN SB_HIST_SALDO'
        goto ERROR
    end

end

return 0

ERROR:
    select @w_error = 'ERROR CRITICO : ' + cast(@w_error as varchar)
    print  cast(@w_error as varchar)
    select @w_retorno =@w_error
    return @w_retorno

go
