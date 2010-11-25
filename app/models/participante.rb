class Participante < ActiveRecord::Base
	has_many :microposts
end
