class QaComment < ActiveRecord::Base
  belongs_to :effort
  belongs_to :user
  
  validates :comment, presence: true
  
  def day
    created_at.to_date.to_s(:db)
  end
  
end
