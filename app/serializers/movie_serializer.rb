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
class MovieSerializer < ActiveModel::Serializer
  attributes :id, :title, :rating, :total_gross, :description, :released_on
  has_many :reviews
end
