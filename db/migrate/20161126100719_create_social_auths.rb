class CreateSocialAuths < ActiveRecord::Migration
  def change
    create_table :social_auths do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token

      t.timestamps null: false
    end
  end
end
