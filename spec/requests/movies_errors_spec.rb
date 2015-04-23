require 'rails_helper'

describe 'Movies' do
  before do
    @movie = Movie.create!(title: "Birdman", rating: 'r',
                           total_gross: 9_300_000,
                           description: "birdman",
                           released_on: Date.parse("October 17, 2014"))
  end

  before(:all) do
    # DO NOT Raise exceptions
    # Wdi6RailsApiMovies::Application.config
    # .action_dispatch.show_exceptions  = true
    # Rails.application.configure{config.action_dispatch
    # .show_exceptions = true }
    # Rails.application.configure{
    # puts "Show Exceptions: " + config.action_dispatch.show_exceptions.to_s
    # }
  end

  it "#show with non-existing movie" do
    get "/movies/9999"

    expect(response.status).to eq 404
    movie_error = JSON.parse(response.body)
    expect(movie_error['railsErrorSymbol']).to eq 'not_found'
    expect(movie_error['httpStatus']).to eq 404
    expect(movie_error['originalPath']).to eq '/movies/9999'

    expect(movie_error['detail'])
      .to match(/ActiveRecord::RecordNotFound.*find Movie with 'id'=9999/)
  end

  it "#destroy" do
    delete "/movies/#{@movie.id}"
    expect(response.status).to eq 404
  end
end
