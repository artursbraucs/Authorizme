class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.string :name

      t.timestamps
    end
    
    member_role = Authorizme::UserRole.new
    member_role.name = "member"
    member_role.save!

    admin_role = Authorizme::UserRole.new
    admin_role.name = "admin"
    admin_role.save!
  end

  
end