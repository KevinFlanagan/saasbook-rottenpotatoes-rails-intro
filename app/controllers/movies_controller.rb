class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings
    @sort = params[:sort] || session[:sort]
    @ratings_to_show = [] 
    
    
    if params[:sort].nil? && params[:ratings].nil? &&
      (!session[:sort].nil? || !session[:ratings].nil?)
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end   
    
    session[:sort] = @sort
    session[:ratings] = @ratings
    
    #if params[:ratings]
     # @ratings_to_show = params[:ratings].keys || session[:ratings].keys
      #session[:ratings] = @ratings_to_show
      #elsif session[:ratings]
       # @ratings_to_show = session[:ratings] 
      #else
       # @ratings_to_show = @all_ratings
        #session[:ratings] = @ratings_to_show  
    #end
    
   #if statements for rating params
   if !params[:sort] && !params[:ratings]
    @ratings_to_show = @all_ratings
    session[:ratings] = @ratings_to_show
   end
   
   if params[:sort] 
     @sort = params[:sort]
     session[:sort] = @sort
   else
     @sort = session[:sort]
   end
   
   if @sort == "title"
     @movies = @movies.order("title")
     @title_classes = "hilite text-primary"
   elsif @sort == "release_date"
     @movies = @movies.order("release_date")
     @release_date_classes = "hilite text-primary" # hi lite the text
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
