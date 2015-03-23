class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :update]
  def index
    @movies = Movie.all
    render json: @movies
  end

  def show
    render json: @movie
  end

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      render json: @movie, status: :created, location: @movie
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  def update
    if @movie.update(movie_params)
      head :no_content
    else
      render json: @movie.errors, status: :unprocessable_entity
    end
  end

  protected

  # this method will also be used by subclasses
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :total_gross, :released_on, reviews_attributes: [:name, :stars, :comment])
  end

  def set_movie
    @movie = Movie.find(params[:id])
  end
end
