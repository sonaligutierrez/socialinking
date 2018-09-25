class FbSession < ApplicationRecord
  has_many :post_creators

  def self.new_session name
  	fbs = FbSession.new(name: name)
  	fbs.save!
  	fbs
  end
  
end
