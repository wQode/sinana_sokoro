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

  def count_words(words)
    wordcount = {}
    #remove whitespace character
    words.split(/\s/).each do |word| 
    # turn all letters lowercase
    word.downcase!
      # remove whitespaces and do word
      if word.strip.size > 0
        unless wordcount.key?(word.strip)
          wordcount[word.strip] = 1
        else
          wordcount[word.strip] = wordcount[word.strip] + 1
        end
      end
    end
    p wordcount
  end

  def tag_cloud
   tags = Tag.asc(:name)
   if tags.length > 0
      tags_by_count = Tag.desc(:count)
      maxOccurs = tags_by_count.first.count
      minOccurs = tags_by_count.last.count

      # Get relative size for each of the tags and store it in a hash
      minFontSize = 5
      maxFontSize = 100
      @tag_cloud_hash = Hash.new(0)
      tags.each do |tag| 
         weight = (tag.count-minOccurs).to_f/(maxOccurs-minOccurs)
         size = minFontSize + ((maxFontSize-minFontSize)*weight).round
         @tag_cloud_hash[tag] = size if size > 7
      end
    end
  end


end