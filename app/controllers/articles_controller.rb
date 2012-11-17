class ArticlesController < ApplicationController

before_filter :load_article, :except => [:index, :new, :create]
before_filter :title_upcase, :only => :index
around_filter :error_handler
  def index
    if !params[:order_by].nil?
      @articles = Article.sorted_by(params[:order_by])
    elsif !params[:limit].nil?
      @articles = Article.only(params[:limit])
    else
      @articles = Article.all
    end
  end

  def show
    @article = Article.includes(:comments).find(params[:id])
  end

  def new
    @article = Article.new
  end

  def edit
    # @article = Article.find(params[:id])
  end

  # -------------------
  # Change the redirect_to to a render and recreate the 
  # problem of refreshing the page after a successful save. 
  # The browser should prompt you about resubmitting the form data.

  def create
    # @article = Article.new(params[:article])
    @article = Article.new(:title => params[:article][:title], :body  =>  params[:article][:body])
    
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
      else
        format.html { render action: "new" }
      end
    end
  end

  def update
    @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        render @article, notice: 'Article was successfully updated.'
      else
        render action: "edit"
      end
    end
  end

# def update
#   @book = Book.find(params[:id])
#   if @book.update_attributes(params[:book])
#     redirect_to(@book)
#   else
#     render :action => :edit
#   end
# end

  def destroy
    # @article = Article.find(params[:id])
    @article.destroy
  end

  private
  def load_article
    @article = Article.find(params[:id])
  end

  def title_upcase
    @articles = Article.all.each do |article| 
        article.title.upcase!
    end
  end

  def error_handler
     begin
      yield
    rescue Exception => error
      flash[:notice] = "Sorry, #{error} #{params[:action]} is broked!"
      unless params[:action] == 'index'
        redirect_to :action => 'index'
      else
        render :action => 'index'
      end
    end
  end
end
