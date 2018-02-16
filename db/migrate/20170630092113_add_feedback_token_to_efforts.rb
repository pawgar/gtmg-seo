class AddFeedbackTokenToEfforts < ActiveRecord::Migration
  def change
    add_column :efforts, :feedback_token, :string, limit: 100, null: true
  end
end
