class CreateSynchronizeRequests < ActiveRecord::Migration
  def change
    create_table :synchronize_requests do |t|
      t.references :user
      t.integer :requested_user_id
      t.string :status, :null => false, :default => "new"

      t.timestamps
    end
  end

  
end