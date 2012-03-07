class CreateUserProviders < ActiveRecord::Migration
  def change
    create_table :user_providers do |t|
      t.references :user
      t.integer :origin_user_id

      t.string :social_id
      t.string :provider_type
      t.string :token
      t.string :secret

      t.timestamps
    end
    # Indices
    change_table :user_providers do |t|
      t.index :user_id
      t.index :origin_user_id
      t.index :social_id
    end
  end
end