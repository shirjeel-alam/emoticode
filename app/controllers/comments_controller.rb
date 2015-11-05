class CommentsController < ApplicationController
  before_filter :authenticate!

  def create
    respond_to do |format|
      format.js {
        @comment = Comment.new comment_params
        @comment.user_id = @current_user.id

        if @comment.save
          Event.new_comment(@current_user,@comment)

          if @comment.commentable.user != @current_user
            if @comment.parent_id.nil?
              UserMailer.comment_email( @current_user, @comment.commentable.user, @comment.commentable.url ).deliver_now
            else
              UserMailer.comment_reply_email( @current_user, @comment.commentable.user, @comment.commentable.url ).deliver_now
            end
          end
        end
      }
    end
  end

  private

  def comment_params
    params.require(:comment).permit( :parent_id, :commentable_type, :commentable_id, :content )
  end
end
