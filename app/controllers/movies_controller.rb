class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all
    #@movies = Movie.order(params[:sort]) 
    @all_ratings = Movie.all_ratings
    if(params[:ratings] == nil and params[:sort] == nil and (session[:ratings] != nil or session[:sort] != nil))
	if(params[:ratings] == nil and session[:ratings] != nil)
	  params[:ratings] = session[:ratings]
	end
	if(params[:sort] == nil and session[:sort] != nil)
	  params[:sort] = session[:sort]
	end
	redirect_to movies_path(:sort => params[:sort], :ratings => params[:ratings])
    else
	#if(params[:strratings] != nil and params[:strratings] != "[]")
	#  @selected = params[:strratings].scan(/[\w-]+/)
	#  session[:strratings] = params[:strratings]
	if
	  @selected = params[:ratings]? params[:ratings].keys : @all_ratings
	  session[:ratings] = params[:ratings] ? params[:ratings].keys : []
	end
    if(params[:sort]==nil and session[:sort] != nil)
	params[:sort]=session[:sort]
    end
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
    if(params[:sort] == "title")
      if(params[:ratings] )
	@movies = Movie.where(:rating => (@selected==[]? @all_ratings : @selected)).order(params[:sort])
      else
	@movies = Movie.all.order(params[:sort])
      end
    elsif (params[:sort] == "release_date")
      if(params[:ratings])
	@movies = Movie.where(:rating => @selected).order(params[:sort])
      else
	@movies = Movie.all.order("release_date")
      end
    elsif (params[:sort]==nil)
      if(params[:ratings] )
	@movies = Movie.where(:rating => @selected==[] ? @all_ratings : @selected)
      else
	@movies = Movie.all
      end
    end
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
