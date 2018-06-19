ActiveAdmin.register_page "PostCreatorList" do
    menu label: proc { I18n.t("active_admin.post_creators") }, priority: 1
    content do
      render partial: "post_creator_list"
    end
  end
