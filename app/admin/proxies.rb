ActiveAdmin.register Proxy do
  permit_params :name, :disabled
  menu label: proc { I18n.t("active_admin.proxies") }, priority: 8
  index do
    selectable_column
    id_column
    column :disabled
    column :created_at
    column :updated_at
    actions
  end

  show title: :id do
    attributes_table do
      row :name
      row :disabled
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :disabled
    end
    f.actions
  end

end
