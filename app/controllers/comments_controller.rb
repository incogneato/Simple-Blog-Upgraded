class CommentsController < ApplicationController
  before_filter :sad_to_happy, :only => :create
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.build(params[:comment])

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment.article, notice: 'Comment was successfully created.' }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { redirect_to @comment.article }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @comment.article }
      format.json { head :no_content }
    end
  end

  private
  def sad_to_happy
    params[:comment][:body].gsub!("sad", "happy")
  end
end


# Comments get created in CommentsController, but what if they fail validation?

# Add a validation to the Comment model.
# Add a flash message about the comment failing validation
# Display the validation error in the comment form
# Test it out in the interface!

