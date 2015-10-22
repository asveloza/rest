$(function()
{

	listadoTareas = [];
//Para cargar la información de localStorage...
	if(localStorage.getItem("listados"))
	{
		objTMP = eval(localStorage.getItem("listados"));
		var Ta = "";
		for(var i in objTMP)
		{
			var Ta = objTMP[i].tarea1;
			console.log(Ta);
			//var nuevaTarea = new persona(Ta);
			listadoTareas.push(Ta);
		}
	}

	function tarea(n_tarea)
	{
		this.tarea1 = n_tarea;
		//Para devolver los datos del usuario a ser impresos...
		this.imprime = function()
		{
			return	this.tarea1;
		}
	}

	$("#guarda").click(function (event)
	{
		var valorInput = $("#TB_Tarea").val();
		alert(valorInput);
		var nuevaTarea = new tarea(valorInput);
	    //listadoTareas.push(nuevaTarea);
	    listadoTareas.push({tarea1 : valorInput});
	    localStorage.setItem("listados", JSON.stringify(listadoTareas));
		//F_imprimeTareas();
		$("#TB_Tarea").val = "";
	});

var F_imprimeTareas = (function F_imprimeTareas()
	{
		var txt = "<table class = 'table-fill'>" + 
					"<thead><tr>" + 
					"<th>Terminada</th>" + 
					"<th>Tarea</th>" + 
					"<th>Eliminar</th></tr></thead>" + 
					"<tbody class = 'table-hover'>";
		for(var i = 0; i < listadoTareas.length; i++)
		{
			txt += "<tr>";
			var datosTarea = listadoTareas[i].imprime();
			
			//terminada...
			txt += "<td><center>";
			txt += "<img src = 'imagenes/done.png' border = '0' id = 'e_"+i+"'/>";
			txt += "</center</td>";

			txt += "<td><center>"+(datosTarea)+"</center></td>";
		
			//Eliminar...
			txt += "<td><center>";
			txt += "<img src = 'imagenes/eliminar.png' border = '0' id = 'd_"+i+"'/>";
			txt += "</center</td>";
			txt += "</tr>";
		}
		txt += "</tbody></table>";
		$("#imprime").html(txt);
		//Poner las acciones de editar y eliminar...
		for(var i = 0; i < listadoTareas.length; i++)
		{
			
			/*/Editar...
			$("#e_" + i).addEventListener('click', function(event)
			{
				var ind = event.target.id.split("_")[1];
				var idUser = listadoTareas[ind].identificacion;
				console.log("Valor de idUser: ", idUser);
				ind = buscaIndice(idUser);
				if(ind >= 0)
				{
					
				}
		
			});*/
			//Eliminar...
			$("#d_" + i).click(function (event)
			{
				var ind = event.target.id.split("_")[1];
				var idUser = listadoTareas[ind].tarea1;
				if(confirm("¿Está segur@ de realizar está acción?"))
				{
					ind = buscaIndice(idUser);
					if(ind >= 0)
					{
						listadoTareas.splice(ind, 1);
						localStorage.setItem("listados", JSON.stringify(listadoTareas));
						indEdita = -1;
						F_imprimeTareas();
					}
				}
			});
		}
		return F_imprimeTareas;
	});

	var buscaIndice = function(id)
	{
		var indice = -1;
		for(var i in listadoTareas)
		{
			if(listadoTareas[i].tarea1 === id)
			{
				indice = i;
				break;
			}
		}
		return indice;
	}


});