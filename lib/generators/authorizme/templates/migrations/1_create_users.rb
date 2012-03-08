class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      # References to user role and user origin provider
      t.references :user_role
      t.integer :origin_provider_id
      
      # Required attributes for user
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :image_url
      t.boolean :has_provider

      # For password
      t.string :password_digest

      # Extending with your own data for user
      # here

      t.timestamps
    end

    # Indices
    change_table :users do |t|
      t.index :email, :unique => true
      t.index :user_role_id
      t.index :origin_provider_id
    end
  end


end