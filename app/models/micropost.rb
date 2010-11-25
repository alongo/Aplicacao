class Micropost < ActiveRecord::Base
	belongs_to :participantes

	validates :content, :length => { :maximum => 140 }
	
end
