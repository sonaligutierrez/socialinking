
function update_dni(fuser_id){
  var expreg = new RegExp(/^\d{7,8}$/);
  var dni = $("#dni-"+fuser_id).val();
  if(expreg.test(dni) || dni == ''){
    $.ajax({
          method: "put",
          url: '/admin/facebook_users/'+fuser_id+'/fuser_update',
          data: {id: fuser_id, dni: dni}
    })
    .done(function(data) {
      $("#facebook_user_"+fuser_id).fadeOut();
      
      $("#add-"+fuser_id).addClass("hidden");
      $("#close-"+fuser_id).addClass("hidden");
      $("#dni-"+fuser_id).attr("readonly", "readonly");
      $("#dni-"+fuser_id).addClass("dni-input-readonly");
      $("#facebook_user_"+fuser_id).fadeIn();
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

function see_button(id){
  if(!$("#dni-"+id).prop("readonly")){
    $("#dni-"+id).val("");
    $("#add-"+id).toggleClass("hidden");
    $("#close-"+id).toggleClass("hidden");  
  }
}

function see_select(id){
  $("#p-category-"+id).toggleClass("hidden");
  $("#category-"+id).toggleClass("hidden");
}

function search(){
    module = $("#module").val();
    column_order = $("#order").val();
    type_order = $("#type_order").val();
    if(module == "posts"){
      post_creator_id = $("#post_creator").val();
      $.ajax({
            method: "get",
            url: '/admin/'+module+'/search',
            data: {post_creator_id:post_creator_id, column_order: column_order, type_order: type_order}
          });

  
    }
    else if(module == "post_creators"){
      channel = $("#channel").val();
      $.ajax({
            method: "get",
            url: '/admin/'+module+'/search',
            data: {channel:channel, column_order: column_order, type_order: type_order}
          });

    }
    
}


//Selecciona los comentaros por categorias
function select_by_category(category_id){
  var post = $("#post_id").val();
  //search_comments(post, category_id);
  var rows = $('tr');
  $("#current_category_id").val(category_id);
  if(category_id == 0)
    $(".checkmark").click();
  else{
    rows.each(function(){
    var cat_id_coment = $(this).find('td input').attr('data-cat-id');
    var id_coment = $(this).find('td input').attr('id');
    if (cat_id_coment == category_id)
      $("#checkmark-"+id_coment).click();

    });  
  }
  
}

//Actualiza la categoria de los cometarios en lote
function update_post_comments(category_id){
  var id_category = category_id.split("-")[1];
  var current_category_id = $("#current_category_id").val();
  var post_id = $("#post_id").val();
  if(current_category_id != "") //Cuando es por lote de categorias
    update_comments_in_batches(post_id,current_category_id, id_category);
  else{ //cuando es por lotes pero sin ninguna caraceristica que lo elaciones
    var rows = $('tr');
    rows.each(function(){
      var id_check = $(this).find('td input').attr('id');
      if ($('#'+id_check).prop("checked"))
        update(id_check, id_category);

    });
  }  
}

function get_posts(elem){
  var creator_id = $(elem).val();

  $.ajax({
          method: "get",
          url: '/admin/posts/search_by_post_creator',
          data: {post_creator_id:creator_id}
  }).fail(function(data) {
      alert( "No se pudo cargar los posts" );
    });

}

function remove_word(elem){
  var array_elements = [];
  array_elements = $("#post_comment_keywords").val().split("-");
  var remove_elem = $(elem).attr("id").split("_")[1];
  var pos = array_elements.indexOf($("#"+remove_elem).html().split("<div")[0].trim());
  array_elements.splice(pos, 1);
  var string = "";
  array_elements.forEach(function(text){ 
    if(text != "")
      string = string + text.trim()+"-";
  });
  $("#post_comment_keywords").val(string);
  $("#"+remove_elem).remove();
}

function update(comment_id, category_id){
  var text_select = $("#category-"+comment_id +" option:selected" ).text().toUpperCase();
  $.ajax({
          method: "put",
          url: '/admin/post_comments/'+comment_id+'/categorize_comment',
          data: {id: comment_id, category_id:category_id}
  })
  .done(function(data) {
      $("#comment_"+comment_id).fadeOut();
      if(text_select == "UNCATEGORIZED")
        $("#p-category-"+comment_id).html("<p class='color-border-select-red' id='p-category-'"+comment_id+"' onmouseover='see_select("+comment_id+")''>"+text_select+"</p>");
      else
        $("#p-category-"+comment_id).html("<p class='color-border-select' id='p-category-'"+comment_id+"' onmouseover='see_select("+comment_id+")''>"+text_select+"</p>");
      
      $("#comment_"+comment_id).fadeIn();
    })
    .fail(function(data) {
      alert( "No se pudo actualizar el DNI" );
    })
    .always(function(data) {
      $("#comment_"+comment_id).fadeTo("slow", 1);
    });
}

function update_comments_in_batches(post_id,current_category_id, id_category){
 $.ajax({
          method: "put",
          url: '/admin/posts/'+post_id+'/update_comments_in_batches',
          data: {id: post_id, category_id:current_category_id, new_category_id: id_category}
  }); 
}


function search_comments(post_id, category_id){
  $.ajax({
    method: "get",
    url: '/admin/posts/search_by_category',
    data: {id: post_id, category_id:category_id}
  });
}

function see_more(id){
   $("#js-text-truncate-"+id).toggleClass("hidden");
   $("#js-text-complete-"+id).toggleClass("hidden");
}

function refresh_grafic(section){
  $.ajax({
    method: "get",
    url: '/admin/posts/refresh_section',
    data: {type: section}
  });
}

function clear_form(){
    $("#new_post_comment")[0].reset();
    $("#keywords").html("");
    $("#post_comment_keywords").val("");
}

function abrir_menu(){
  $("#tabs").toggleClass("ver-menu");
}

$(document).on('keypress',function(e) {
    if(e.which == 13) {
        if($("#word").val() != ""){
          var array_tmp = $("#post_comment_keywords").val();
          var id_element = $("#word").val().replace(/ /g,"").trim();
          $("#keywords").append("<div id="+id_element+" class='div-words'>"+$("#word").val()+" <div id='close_"+id_element+"' class='close-div' onclick='remove_word(this);' >X</div> </div> ");
          array_tmp = array_tmp + $("#word").val()+"-"; 
          $("#post_comment_keywords").val(array_tmp);
          $("#word").val("");
          return false;
        }
    }
});


$(document).ready(function(e){
    $("#login h2").html("");
    $("#login fieldset.inputs  ol").before("<p class='text-title-login'>Ingrese a su cuenta</p>");
    $("#user_email").attr("placeholder", "Usuario");
    $("#user_password").attr("placeholder", "Contraseña");
    $("#user_submit_action").html("<input type='submit' name='commit' value='Ingresar' data-disable-with='Ingresar'>");
    

    $("#site_title").append("<div class= 'col-sm-1 link_menu' onclick='abrir_menu();'><div class='element-menu menu-show-post js-menu', id='js-menu-responsive'<div class='linea'></div><div class='linea'></div><div class='linea'></div><div class='linea'></div></div></div>");


    $(".js-menu").on('click', function(){
      var id = $(this).attr("id").split("-")[3];
      $("#menu-dropdown-"+id).toggle();
      $(this).toggleClass("shadow-menu");
    });

    $("#asc").removeClass("hidden");
    $("#desc").removeClass("hidden");
    if($("#type_order").val() == "desc")
      $("#asc").addClass("hidden");
    else
      $("#desc").addClass("hidden");

    $(".js-img").on('click', function(){
      $("#asc").toggleClass("hidden");
      $("#desc").toggleClass("hidden");
      if($("#desc").hasClass("hidden"))
        $("#type_order").val("ASC");
      else
        $("#type_order").val("DESC"); 
      search();
    });

    $("#item-comment").on('click', function(){
      $("#comment-list").removeClass("hidden");
      $("#comment-category").addClass("hidden");
    });

    $(".js-item").on('click', function(){
      if($(this).attr("id") != "item-comment")
        var id = $(this).attr("id").split('-')[2];
      else
        var id = null;
      var post_id = $("#post_id").val();
      $(".js-item").removeClass("active");
      $(this).addClass("active");
      $.ajax({
            method: "get",
            url: '/admin/posts/search_comments',
            data: {id:post_id, category_id: id}
          });
    });

    $(".js-item-react").on('click', function(){
      if($(this).attr("id") != "item-reaction")
        var id = $(this).attr("id").split('-')[2];
      else
        var id = null;
      var post_id = $("#post_id").val();
      $(".js-item-react").removeClass("active");
      $(this).addClass("active");
      $.ajax({
            method: "get",
            url: '/admin/posts/search_reactions',
            data: {id:post_id, reaction: id}
          });
    });

});
  
  


