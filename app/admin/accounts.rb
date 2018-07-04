ActiveAdmin.register Account do
  permit_params :name, :url
  filter :name
  filter :url
  index do
      column :name
      column :url
      actions
    end



end
