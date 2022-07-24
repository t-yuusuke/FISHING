class Public::CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    @comment = current_customer.comments.new(comment_params)
    @comment.post_id = post.id
    if @comment.save
    post.create_notification_comment!(current_customer, @comment.id)#コメントの通知を作成

    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
