ActiveAdmin.register Account do
  permit_params :name, :url

  index do
      column :name
      column :url
      actions
    end



end
