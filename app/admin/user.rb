ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  show do
    panel 'User Details' do
      attributes_table_for user do
        row :id
        row :username
        row :last_login
        row :last_login_ip
        row :level
        row :status
        row :created_at
        row :updated_at
      end
    end

    panel 'Sources' do
      table_for user.sources do
        column :id
        column :name
        column :title
        column :description
        column :text do |source|
          source.text.truncate(50)
        end
      end
    end
  end

end
