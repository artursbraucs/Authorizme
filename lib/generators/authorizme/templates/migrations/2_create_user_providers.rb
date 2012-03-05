class CreateUserProviders < ActiveRecord::Migration
  def change
    create_table :user_providers do |t|
      t.references :user
      t.integer :origin_user_id

      t.string :social_id
      t.string :name
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end