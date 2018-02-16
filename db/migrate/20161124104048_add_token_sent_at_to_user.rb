class AddTokenSentAtToUser < ActiveRecord::Migration
  def change
    add_column :users, :token_sent_at, :timestamp, null: true
  end
end
