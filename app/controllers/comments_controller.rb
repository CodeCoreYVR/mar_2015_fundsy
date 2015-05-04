class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  def create
    @comment             = Comment.new comment_params
    @comment.commentable = @commentable
    if @comment.save
      redirect_to @commentable, notice: "Comment created!"
    else
      view_folder = @commentable.class.name.underscore.pluralize
      render "/#{view_folder}/show"
    end
  end

  private

  def find_commentable
    if params[:campaign_id]
      @commentable = @campaign = Campaign.find params[:campaign_id]
    elsif params[:discussion_id]
      @commentable = @discussion = Discussion.find params[:discussion_id]
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
