class Public::CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = current_customer.comments.new(comment_params)
    comment.post_id = post.id
    if comment.save
    post.create_notification_comment!(current_customer, comment.id)#コメントの通知を作成
    redirect_to post_path(post)
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to post_path(params[:post_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
