class Widget < ActiveRecord::Base

  before_create :set_col_position

  belongs_to :user
  belongs_to :authorization



  def set_col_position

    self.col =  1
    self.position = Widget.count
  end


end
