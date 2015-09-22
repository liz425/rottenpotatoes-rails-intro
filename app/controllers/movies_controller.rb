class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :ratings, :description, :release_date, :sort_by)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sort_by = params[:sort_by]
    @all_ratings = Movie.all_ratings
    @ratings = params[:ratings]

    #If no rating check_box checked, show all movies
    if(@ratings)
      @rating_keys = @ratings.keys
    else
      @rating_keys = @all_ratings
    end

    #Select movies been checked
    @movies = Movie.where(rating: @rating_keys)
    #Sort movies 
    if(@sort_by)
      @movies = @movies.order(@sort_by)
    else
      @movies = @movies.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
