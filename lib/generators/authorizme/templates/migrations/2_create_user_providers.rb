class CreateUserProviders < ActiveRecord::Migration
  def change
    create_table :user_providers do |t|
      t.integer :user_id
      t.integer :origin_user_id

      t.column :social_id, 'bigint'
      t.string :name
      t.string :token
      t.string :secret

      t.timestamps
    end
  end
end