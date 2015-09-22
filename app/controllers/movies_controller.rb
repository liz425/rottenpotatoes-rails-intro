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
    @all_ratings = Movie.all_ratings

    #Update seesion parameters: :sort_by :ratings
    if !params[:sort_by].nil? and params[:sort_by] != session[:sort_by]
      session[:sort_by] = params[:sort_by]
    end

    if !params[:ratings].nil? and params[:ratings] != session[:ratings]
      session[:ratings] = params[:ratings]
    end

    #If no explicitly new sroting/filtering setting, redirect
    if params[:ratings].nil? && params[:sort_by].nil?
      #In case both session[:ratings] and sessioin[:sort_by] are nil, prevent infinite redirect loop
      if !session[:ratings].nil? || !session[:sort_by].nil?
        redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings])
      end
    end

    @sort_by = session[:sort_by]
    @ratings = session[:ratings]

    #If no rating check_box checked, show all movies
    #Initial value of @ratings shouldn't be nil. If it happens, set its value to @all_ratings
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
