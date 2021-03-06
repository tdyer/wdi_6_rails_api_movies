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

require 'rails_helper'

describe Movie, type: :model do
  subject do
    Movie.create!(title: "Birdman", rating: 'r', total_gross: 9_300_000,
                  description: "birdman",
                  released_on: Date.parse("October 17, 2014"))
  end

  its(:title) { is_expected.to eq("Birdman") }
  its(:rating) { is_expected.to eq "r" }

  let(:ben_hur_params) do
    {
      title: 'Ben Hur',
      reviews_attributes:
        [
          { name: 'joe smoe', stars: 2, comment: 'too long' },
          { name: 'jill doe', stars: 4, comment: 'nice chariots' }
        ]
    }
  end
  it "create with reviews" do
    expect { Movie.create!(ben_hur_params) }.to change { Movie.count }
                                                 .from(0).to(1)
    movie = Movie.last
    expect(movie.title).to eq "Ben Hur"
  end
  let(:ben_hur_movie) { Movie.create!(ben_hur_params) }

  it "update with review updates" do
    last_review = ben_hur_movie.reviews.last
    expect(last_review.stars).to eq 4
    expect(last_review.comment).to match(/chariots/)

    ben_hur_movie.update(
      description: "50's movie",
      reviews_attributes: [
        { id: last_review.id, name: 'joe', stars: 1, comment: "sucks, really" }
      ]
    )
    movie = Movie.find(ben_hur_movie.id)
    expect(movie.title).to eq 'Ben Hur'
    expect(movie.description).to eq "50's movie"

    updated_review = movie.reviews.find(last_review.id)
    expect(updated_review.name).to eq 'joe'
    expect(updated_review.stars).to eq 1
    expect(updated_review.comment).to match(/sucks/)
  end

  it "add a new review" do
    ben_hur_movie.update(
      reviews_attributes: [
        { name: 'tom', stars: 3, comment: "to egyptian" }
      ]
    )
    movie = Movie.find(ben_hur_movie.id)

    updated_review = movie.reviews.last
    expect(updated_review.name).to eq 'tom'
    expect(updated_review.stars).to eq 3
    expect(updated_review.comment).to match(/egyptian/)
  end
end
