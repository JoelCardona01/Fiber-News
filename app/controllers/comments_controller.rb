class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :like, :unvote]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    @submission = Submission.find_by(id: @comment.postid)
     if !session[:user_id].nil?
      @likedcomments = Likedcomments.all.where(:user_id => session[:user_id])
    end
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end
  
  def commFromUser
    @comments = Comment.all.where(:user_id => params[:user_id])
    render "index"
  end
  
  def userUpvotes
      @comments = Likedcomments.all.where(:user_id => session[:user_id])
      render :upvotes
    
  end
  
  # GET /comments/1/edit
  def edit
  end
  
  def tree
    if !session[:user_id].nil?
      @likedcomments = Likedcomments.all.where(:user_id => session[:user_id])
    end
    @comment = Comment.find_by(:id => params[:id])
    @comments = Comment.all.where(:parentid => @comment.id).order(:parentid)
    @commentsAux = @comments.to_a
    for i in 0..@commentsAux.length-1
      @commentsAux.push(Comment.all.where(:parentid => @commentsAux[i].id))
      @comments = @comments + (Comment.all.where(:parentid => @commentsAux[i].id))
    end
    @submission = Submission.find_by(:id => @comment.postid)
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to request.referrer }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    commentliked = Likedcomments.all.where(:comment_id => @comment.id)
    commentliked = commentliked.to_a
    for i in 0..commentliked.length-1
      commentliked[i].destroy
    end
    @sub = Submission.find(@comment.postid)
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to submission_path(@sub.id) }
      format.json { head :no_content }
    end
  end
  
  def like
    @comment.likes = @comment.likes+1
    if @comment.save
      @likedcomment = Likedcomments.new(:comment_id => @comment.id, :user_id => session[:user_id])
      @likedcomment.save
    end 
    redirect_to request.referrer
  end
  
  def unvote
    @comment.likes = @comment.likes - 1
    if @comment.save
      @likedcomment = Likedcomment.find_by(:comment_id => @comment.id, :user_id => session[:user_id])
      @likedcomment.destroy
    end
    redirect_to request.referrer
  end
  
  def comment
    params.permit!
    if !params[:comment][:text].blank? ##Si el text no es buit, aleshores creem el comentari.
      @comment = Comment.new(params[:comment])
      respond_to do |format|
        if @comment.save
          format.html { redirect_to "/submissions/"+@comment.postid.to_s }
          format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end 

def treecomment
     params.permit!
    if !params[:comment][:text].blank? ##Si el text no es buit, aleshores creem el comentari.
      @comment = Comment.new(params[:comment])
      respond_to do |format|
        if @comment.save
          format.html { redirect_to "/submissions/"+@comment.postid.to_s }
          format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:text, :postid, :parentid, :likes, :user_id)
    end
end
