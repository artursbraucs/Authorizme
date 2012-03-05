class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :origin_provider_id

      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :image_url
      
      # Extending with your own data for user

      t.timestamps
    end
  end
end