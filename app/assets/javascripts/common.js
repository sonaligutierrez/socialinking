
function update_dni(fuser_id, dni){
	var expreg = new RegExp(/^\d{7,8}$/);
  if(expreg.test(dni) || dni == ''){
  	$.ajax({
					method: "put",
      		url: '/admin/facebook_users/'+fuser_id+'/fuser_update',
      		data: {id: fuser_id, dni: dni}
    })
    .done(function(data) {
    	$("#facebook_user_"+fuser_id).fadeTo("slow", 0.45);
  	})
  	.fail(function(data) {
    	alert( "No se pudo actualizar el DNI" );
  	})
  	.always(function(data) {
    	$("#facebook_user_"+fuser_id).fadeTo("slow", 1);
  	});

  } 	
  else{
  	alert("El número de DNI no es válido");
  }	

}
  
  


