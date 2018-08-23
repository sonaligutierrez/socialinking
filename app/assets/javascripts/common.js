
function update_dni(fuser_id, dni){
  if (dni != ''){
  	var expreg = new RegExp(/^\d{7,8}$/);
	  if(expreg.test(dni)){
	  	$.ajax({
						method: "put",
	      		url: '/admin/facebook_users/'+fuser_id+'/fuser_update',
	      		data: {id: fuser_id, dni: dni}
	    });
	  } 	
	  else{
	  	alert("El número de DNI no es válido");
	  }	
  }
}
  
  


