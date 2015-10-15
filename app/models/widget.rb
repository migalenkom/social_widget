class Widget < ActiveRecord::Base

  belongs_to :user
  belongs_to :authorization

end
