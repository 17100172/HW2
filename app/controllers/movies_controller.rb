class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
  
  def delete_any
  end
  
  def delete_done
    if (params[:movie][:title] != '')
      @movie = Movie.find_by_title(params[:movie][:title])
      if (@movie == nil)
        flash[:notice] = "#{params[:movie][:title]} does not exist."
      else
        @movie.destroy
        flash[:notice] = "Movie '#{params[:movie][:title]}' deleted."
      end
    end
    if (params[:movie][:rating] != '')
      Movie.where('rating = ?', params[:movie][:rating]).each do |mov|
        mov.destroy
      end
      flash[:notice] = "Movies with Rating '#{params[:movie][:rating]}' deleted."
    end
    redirect_to movies_path#(@movie)
  end
  
  def update_any
  end
  
  def update_post
    @movie = Movie.find_by_title(params[:movie][:in_movie])
    if (@movie == nil)
      flash[:notice] = "#{params[:movie][:in_movie]} does not exist."
    else
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{params[:movie][:title]} was successfully updated."
    end
    redirect_to movies_path#(@movie)
  end
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings =  {'G'=>true,'PG'=>true,'PG-13'=>true,'R'=>true,'NC-17'=>true}
    if ((params[:sort_by] == 'title') || (params[:sort_by] == 'release_date'))
      @movies = Movie.all.order(params[:sort_by])
    elsif (!(params[:ratings].nil?))
      @movies = Movie.where(:rating => params[:ratings].keys)
    else
      @movies = Movie.all
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
