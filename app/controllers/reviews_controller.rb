class ReviewsController < ApplicationController
  
  before_action :has_user_and_movie, :only => [:new, :create ,:show]
  protected
  def has_user_and_movie
    unless @current_user
      @movie = Movie.find_by_id(params[:movie_id])
      flash[:warning] = 'You must be logged in.'
      redirect_to movie_path(@movie)
    end
    unless (@movie = Movie.find_by_id(params[:movie_id]))
      flash[:warning] = 'Review must be for an existing movie.'
      redirect_to movies_path
    end
  end

  public
  
  ############ index ############

  def index
    id_movie = params[:movie_id]
    @movie = Movie.find(id_movie)
    @review = Review.where(movie_id: id_movie)
  end

  ############ new ##############

  def new
    @review = @movie.reviews.build
  end
  
  ########### review info #########

  def review_info
    params.require(:review).permit(:potatoes, :user, :movie, :comments)
  end

  ############ create #################
  
  def create
    @current_user.reviews << @movie.reviews.build(review_info)
    flash[:notice] = "#{@movie.title} review was successfully given."
    redirect_to movie_path(@movie)
  end
  
  ############ update #################

  def edit
    id_movie = params[:movie_id]
    @movie = Movie.find(id_movie)
    @review_a = Review.where(movie_id: id_movie)
    @review = @review_a.find_by_user_id(@current_user[:id])
  end

  def update
    id_movie = params[:movie_id]
    @movie = Movie.find(id_movie)
    @review = Review.where(movie_id: id_movie)
    @review_user = @review.find_by_user_id(@current_user[:id])

    if @review_user.update_attributes(review_info) 
      flash[:notice] = "#{@movie.title} review was successfully updated."
      redirect_to movie_review_path(@movie,@review)
    else
      render 'edit'
    end
  end

  ############ show #################
  def show
    begin
      id_movie = params[:movie_id]
      @movie = Movie.find(id_movie)
      @review = Review.where(movie_id: id_movie)
      @review_user = @review.find_by_user_id(@current_user[:id])
      

      if @review_user == nil
        @status = false
      else
        @status = true
      end

    rescue ActionController::UrlGenerationError
      flash[:warning] = "You not have review."
    end
  end


end