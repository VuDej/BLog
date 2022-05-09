class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(text: comment_params[:text], author_id: current_user.id, post_id: @post.id)

    if @comment.save
      flash[:notice] = 'Comment has been created successfully'
      redirect_to user_posts_path(@comment.author.id)
    else
      flash[:alert] = 'The comment adding failed.'
      render :_comment_form, status: :unprocessable_entity
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @post = @comment.post
    @post.comments_counter -= 1
    @comment.destroy!
    @post.save
    flash[:alert] = 'You have deleted this post successfully!'
    redirect_to user_posts_path(@post.author_id)
  end
  
  private

  def comment_params
    params.require(:comment).permit(:text).tap do |comment_params|
      comment_params.require(:text)
    end
  end
end
