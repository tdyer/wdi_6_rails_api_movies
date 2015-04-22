# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  name       :string
#  stars      :integer
#  comment    :text
#  movie_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Review < ActiveRecord::Base
  belongs_to :movie
end
