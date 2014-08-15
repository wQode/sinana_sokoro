class SourcesController < ApplicationController

  def index
    @sources = Source.all
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

end