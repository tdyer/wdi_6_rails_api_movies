require 'rails_helper'

describe 'Reviews' do
  before do
    @movie = Movie.create!(title: "Birdman", rating: 'r',
                           total_gross: 9_300_000, description: "birdman",
                           released_on: Date.parse("October 17, 2014"))
  end

  let(:ben_hur_params) do
    { movie:
        {
          title: 'Ben Hur',
          rating: 'pg',
          description: "Roman Era",
          reviews_attributes:
            [
              { name: 'joe smoe', stars: 2, comment: 'too long' },
              { name: 'jill doe', stars: 4, comment: 'nice chariots' }
            ]
        }
    }
  end

  it "#create with reviews" do
    post "/movies",
         ben_hur_params.to_json,
         'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s
    expect(response).to be_success
    expect(response.status).to eq(201)

    new_movie = Movie.last
    expect(new_movie.title).to match(/Ben Hur/)
    expect(new_movie.description).to match(/Roman/)
    expect(new_movie.reviews.count).to eq(2)

    first_review = new_movie.reviews.first
    expect(first_review.name).to eq "joe smoe"
    expect(first_review.stars).to eq 2

    second_review = new_movie.reviews.last
    expect(second_review.name).to eq "jill doe"
    expect(second_review.stars).to eq 4
  end

  let(:movie_w_reviews) do
    movie = Movie.new(title: "Birdman", rating: 'r',
                      total_gross: 9_300_000, description: "birdman",
                      released_on: Date.parse("October 17, 2014"))
    movie.reviews.build(name: 'joe smoe', stars: 2, comment: 'too long')
    movie.save!
    movie
  end

  it "add review" do
    put "/movies/#{movie_w_reviews.id}",
        {
          movie: {
            id: movie_w_reviews.id,
            reviews_attributes: [
              { name: 'tom smith', stars: 3, comment: 'to egyptian' }
            ]
          }
        }.to_json,
        'Accept' => Mime::JSON, 'Content-Type' => Mime::JSON.to_s

    expect(response).to be_success
    expect(response.status).to eq(204)

    updated_movie = Movie.find(movie_w_reviews.id)
    expect(updated_movie.reviews.length).to eq 2

    new_review = updated_movie.reviews.last
    expect(new_review.name).to eq 'tom smith'
    expect(new_review.stars).to eq 3
    expect(new_review.comment).to match(/egyptian/)
  end

  private

  def check_remote_movie(movie)
    expect(movie['title']).to eq "Birdman"
    expect(movie['total_gross'].to_i).to eq 9_300_000
    expect(movie['rating']).to eq "r"
    # expect(movie['released_on']).to eq Date.parse("October 17, 2014").to_s
  end
end
