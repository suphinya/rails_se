# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController

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
      redirect_to movies_path
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
  
end
