# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

  before_action :require_login , :except => [:index , :show]
  
  def require_login
    unless @current_user
      flash[:warning] = 'You must be logged in before.'
      redirect_to movies_path
    end
  end
  
  ############### index ##############
  
  def index
    @movies = Movie.all
    
  end
  
  ############### new ##############
  
  def new
    @movie = Movie.new
  end
  
  ############### show ##############
  
  def show
    begin
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.html.haml by default
  
      @review = Review.find_by_movie_id(id)
      
    rescue ActiveRecord::RecordNotFound
      flash[:warning] = "Movie is not found."
      redirect_to movies_path
    end
  end
  
  ############### param ##############
  
  def movie_params
    params.require(:movie).permit(:title,:rating,:release_date, :description)
  end
  
  ############### create ##############

  def create
    @movie = Movie.new(movie_params)
    if @movie.save
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to new_movie_review_path(@movie) 
    else
      render 'new' # note, 'new' template can access @movie's field values!
    end
  end
 
  ############### edit ##############
  
  def edit
    id = params[:id]
    @movie = Movie.find(id)
  end
  
  ############### update ##############
  
  def update
    id = params[:id]
    @movie = Movie.find(id)
    if @movie.update_attributes(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    else
      render 'edit' # note, 'edit' template can access @movie's field values!
    end
  end
  
  ############### destroy ##############
  
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  

  ############### filter ##############

  def movies_with_filters_2
    @movies = Movie.with_good_reviews(params[:threshold])
    %w(for_kids with_many_fans recently_reviewed).each do |filter|
      @movies = @movies.send(filter) if params[filter]
    end
  end

  ############## tmdb search ############
  
  def search_tmdb
    @search_terms = params[:search_terms]
    @movies = Movie.find_in_tmdb(@search_terms)

    if @movies
      render 'tmdb'
    else
      flash[:warning] = "'#{params[:search_terms]}' was not found in TMDb."
      redirect_to movies_path
    end 
  end

  def create_from_tmdb
    movie_id = params[:tmdb_id]
    m = Movie.get_from_tmdb(movie_id)
    @movie = Movie.new({
      :title => m["title"], 
      :rating => "",    
      :release_date => m["release_date"], 
      :description => m["overview"]
      })
    if @movie.save
      flash[:notice] = "'#{@movie.title}' was successfully created."
      redirect_to new_movie_review_path(@movie)
    end
  end

end
