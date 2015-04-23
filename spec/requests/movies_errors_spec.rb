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

  # it "#show with invalid id with exception" do
  #   expect {
  #     get "/movies/9999"
  #   }.to raise_error(ActiveRecord::RecordNotFound)
  # end

  it "#show with non-existing movie" do
    get "/movies/9999"

    # expect(response).to be_error # status is 500
    expect(response.status).to eq 404

    movie_error = JSON.parse(response.body)

    expect(movie_error['railsErrorSymbol']).to eq 'not_found'
    expect(movie_error['httpStatus']).to eq 404
    expect(movie_error['originalPath']).to eq '/movies/9999'

    expect(movie_error['detail'])
      .to match(/ActiveRecord::RecordNotFound.*find Movie with 'id'=9999/)
  end

  it "#destroy" do
    # expect { delete "/movies/#{@movie.id}" }.to
    # raise_error(ActionController::RoutingError)
    delete "/movies/#{@movie.id}"
    expect(response.status).to eq 404
    # movie_error = JSON.parse(response.body)
  end
end
