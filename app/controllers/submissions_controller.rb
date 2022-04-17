class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :vote, :unvote]

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all.order(votes: :desc)
    if !session[:user_id].nil?
      @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
    end
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @comments= Comment.all.where(:postid => params[:id]).order(:parentid)
    if !session[:user_id].nil?
      @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
    end
  end

  
  # GET /submissions/new
  def new
    @submission = Submission.new
  end
  
  #GET /submissions/user/:id
  def submFromUser
    @submissions = Submission.all.where(:user_id => params[:user_id])
    render "index"
  end

  # GET /submissions/1/edit
  def edit
  end
  
  def newest
        @submissions = Submission.all.order(created_at: :desc)
        if !session[:user_id].nil?
          @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
        end

  end

  def ask
      @submissions = Submission.all.where(:url=>"").order(votes: :desc)
      if !session[:user_id].nil?
        @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
      end
  end
  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new(submission_params)
    
    respond_to do |format|
      
      if @submission.title=="" then format.html { redirect_to request.referrer, alert: 'That is not a valid title.' } ##Comprovem que el titol no es buit
      elsif (@submission.url=="") 
        if @submission.save
            format.html { redirect_to submissions_path, notice: 'Submission was successfully created.' }
            format.json { render :show, status: :created, location: @submission }
          else
            format.html { render :new }
            format.json { render json: @submission.errors, status: :unprocessable_entity }
          end
      elsif ((@submission.url!="" && Submission.find_by(url: @submission.url).nil?))##Comprovem que no existeixi cap submission amb el mateix url i guardem la nova
        if @submission.text!=""
          text = @submission.text
          @submission.text=""
          if @submission.save
            @comment= Comment.new(:text => text, :user_id =>@submission.user_id, :postid => @submission.id, :parentid => "0", :likes => 0)
            @comment.save
            format.html { redirect_to submission_path(@submission.id), notice: 'Submission was successfully created.' }
            format.json { render :show, status: :created, location: @submission }
          else
            format.html { render :new }
            format.json { render json: @submission.errors, status: :unprocessable_entity }
          end
        else
          if @submission.save
            format.html { redirect_to submissions_path, notice: 'Submission was successfully created.' }
            format.json { render :show, status: :created, location: @submission }
          else
            format.html { render :new }
            format.json { render json: @submission.errors, status: :unprocessable_entity }
          end
        end
       
      else ##Ja existia una submission amb el mateix url de manera que redirigim a la submission amb el mateix url.
        @submission2 = Submission.find_by(url: @submission.url)
        format.html {redirect_to @submission2 }
      end
       
    end 
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def vote
    @submission.votes = @submission.votes+1
    if @submission.save
      @likedsubmission = Likedsubmission.new(:submission_id => @submission.id, :user_id => session[:user_id])
      @likedsubmission.save
    end
    redirect_to request.referrer

  end
  
  def unvote
    @submission.votes = @submission.votes - 1
    if @submission.save
      @likedsubmission = Likedsubmission.find_by(:submission_id => @submission.id, :user_id => session[:user_id])
      @likedsubmission.destroy
    end
    redirect_to request.referrer
  end
  
  def comment
    params.permit!
    if !params[:comment][:text].blank? ##Si el text no es buit, aleshores creem el comentari.
      @comment = Comment.new(params[:comment])
      respond_to do |format|
        if @comment.save
          format.html { redirect_to "/submissions/"+@comment.postid.to_s, notice: 'Comment was successfully created.' }
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
     def set_submission
      @submission = Submission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:url, :title, :text, :user_id)
    end
end