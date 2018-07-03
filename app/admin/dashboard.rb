ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }


  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do

      column class: "column small-column" do
        panel "" do
          image_tag asset_url("social_linking_logo.png")
        end
        panel "Categorizados vs No Categorizados", class: "category_panel" do
          render partial: "categorized_grafic"
        end
      end
      column class: "column big-column" do
        panel "Cantidad de Comentarios por Categoría" do
          render partial: "cant_category_grafic"
        end
      end

    end
    columns do
      column class: "column" do
        panel "Últimas 10 Publicaciones" do
          table_for Post.last_ten_posts, class: "index_table index" do |o|
            column "Título", :title
            column "Fecha",  :post_date
            column "Fan Page",  :fan_page
            column "" do |p|
              link_to("Comentarios (#{Post.cant_comments p.id})", comments_admin_post_path(p)).html_safe
            end
          end
        end
      end
    end



  end # content
end
