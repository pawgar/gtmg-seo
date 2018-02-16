class ClientUser < ActiveRecord::Base
  belongs_to :user
  belongs_to :client
  
  enum user_role: { Member: 0, Owner: 1 }
end
