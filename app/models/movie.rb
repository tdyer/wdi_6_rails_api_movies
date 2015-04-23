# == Schema Information
#
# Table name: movies
#
#  id          :integer          not null, primary key
#  title       :string
#  rating      :string
#  total_gross :decimal(, )
#  description :text
#  released_on :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Movie < ActiveRecord::Base
  RATINGS = %w( g pg pg-13 r nc-17 )

  has_many :reviews, dependent: :destroy

  accepts_nested_attributes_for :reviews
end
