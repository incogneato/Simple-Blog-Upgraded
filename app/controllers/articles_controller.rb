class ArticlesController < ApplicationController

  before_filter do
    @article = Article.find(params[:id]) if params[:id]
  end

  before_filter :title_upcase, :only => :index

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
                           :body => params[:article][:title])
      

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
  def title_upcase
    @articles = Article.all.each do |article| 
        article.title.upcase!
    end
  end

end
