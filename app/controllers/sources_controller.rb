class SourcesController < ApplicationController

  def index
    if params[:search]
      search_function
      render :search_results
      return
    else
    @sources = Source.all
    # @results = Source.where("title iLIKE ?", "%#{params[:search]}%")
    end
  end

  def create
    @source = Source.new source_params
    @source.save

    flash[:notice] = "New cloud created"
    redirect_to @source
  end

  def new
    @source = Source.new
  end

  def edit
    @source = Source.find params[:id]
  end

  def show
    @source = Source.find params[:id]
  end

  def destroy
    source = Source.find params[:id]
    source.destroy

    flash[:notice] = "Cloud deleted"

    redirect_to sources_path
  end

  private
  def source_params
    params.require(:source).permit(:title, :original)
  end

  def search_function
    search = params[:search]
    @sources = []
    unless search == ""
      @sources << Source.where("title ILIKE :search", search: "%#{ search }%") # % retrieves everything before and after 'and'
      @sources << Source.where("original ILIKE :search", search: "%#{ search }%") # ILIKE enables search term to becase insensitive
      @sources = @sources.flatten.uniq
    end
  end
end