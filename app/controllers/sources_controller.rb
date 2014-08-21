class SourcesController < ApplicationController

  def index
    if params[:search]
      search_function
      # binding.pry
      # raise @sources.to_json
      render :search_results
      return
    else
    @sources = Source.all
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

  def update
    source = Source.find params[:id]
    if source.update source_params
      flash[:notice] = 'Updated changes'
      redirect_to source
    else
      render :edit
    end
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

  def cloud_data
    @source = Source.find params[:id]
    json = 
    {
     name: "flare",
     children: @source.bucket_words
     # children: @source.words.map {|k,v| { :name => k, :size => v }}
    }
    render :json => json
  end

  private
  def source_params
    params.require(:source).permit(:title, :original, :exceptions)
  end

  def search_function
    search = params[:search]
    @sources = []
    unless search == ""
      @sources.concat(Source.where("title ILIKE :search", search: "%#{ search }%"))# % retrieves everything before and after 'and'
      @sources.concat(Source.where("original ILIKE :search", search: "%#{ search }%")) # ILIKE enables search term to becase insensitive
      # @sources = @sources.flatten.uniq
    end
  end

  def cloud
  end

end