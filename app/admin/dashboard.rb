ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content  class: "container-fluid" do
    columns do
      column class: "column small-column" do
        div class: "dashboard-panel-small" do
          render partial: "cant_publicadores"
        end
      end
      column class: "column small-column-corner" do
        div class: "dashboard-panel-small width-panel-small-corner" do
          render partial: "cant_publicaciones"
        end
      end
      column class: "column medium-column-der-up" do
        div class: "dashboard-panel-medium" do
          render partial: "cant_categorized_uncategorized"
        end
      end
    end
    columns do
      column class: "column columns-chart medium-column" do
        div class: "category_panel js-category-comments", id: "comments_by_category" do
          render partial: "cant_category_grafic"
        end
      end
      column class: "column columns-chart medium-column-der" do
        div class: "category_panel", id: "category_uncategory" do
          render partial: "categorized_grafic"
        end
      end


    end
    columns do
      column class: "column big-column" do
        panel "Últimas 10 Publicaciones" do
          render partial: "post_table"
        end
      end
    end



  end # content

  controller do

    def index
      @date_hour = "A fecha de hoy a las #{Time.now.strftime("%H:%M")}"
    end
  end
end
