class ArticlesController < ApplicationController

before_filter :load_article, :except => [:index, :new, :create]
before_filter :title_upcase, :only => :index
around_filter :exception_wrap

# Implement an around_filter that catches an exception, 
# writes an apology into the flash[:notice], 
# and redirects to the articles index.

# If the exception was raised in articles#index, 
# render the message as plain text (render :text => "xyz"). 
# Hint: check the value of params[:action]

# After implementing this, try it out by causing an 
# exception (maybe by adding a validation) and make sure it works.

# Wherever yield is called, the action will be executed. 
# So the functionality here could recover from any 
# exception that occurs in the yielded action.

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

  def create
    # @article = Article.new(params[:article])
    @article = Article.new(:title => params[:article][:title],
                           :body => params[:article][:body])
  
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render json: @article, status: :created, location: @article }
      else
        format.html { render action: "new" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    # @article = Article.find(params[:id])
    respond_to do |format|
      if @article.update_attributes(params[:article])
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

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

  def exception_wrap
    begin
      yield
    rescue => exception
      render :text => "So sorry! #{params[:action]} action is broked!"
    end
  end
end
