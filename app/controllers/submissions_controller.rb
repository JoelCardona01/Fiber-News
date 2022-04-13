class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :vote]

  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all.order(votes: :desc)
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @comments= Comment.all.where(:postid => params[:id]).order(:parentid)
  end

  
  # GET /submissions/new
  def new
    @submission = Submission.new
  end
  


  # GET /submissions/1/edit
  def edit
  end
  
  def newest
        @submissions = Submission.all.order(created_at: :desc)

  end

  def ask
      @submissions = Submission.all.where(:url=>"").order(votes: :desc)
  end
  # POST /submissions
  # POST /submissions.json
  def create
    @submission = Submission.new(submission_params)

    respond_to do |format|
      if @submission.title=="" then format.html { redirect_to request.referrer, alert: 'That is not a valid title.' } 
      else
        if @submission.save
          format.html { redirect_to submissions_path, notice: 'Submission was successfully created.' }
          ## format.json { render :show, status: :created, location: @submission }
        else
          format.html { render :new }
         format.json { render json: @submission.errors, status: :unprocessable_entity }
        end
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
    @submission.save
    redirect_to request.referrer

  end
  
  def comment
    params.permit!
    if !params[:comment][:text].blank? ##Si el text no es buit, aleshores creem el comentari.
      @comment = Comment.new(params[:comment])
      respond_to do |format|
        if @comment.save
          user = "SoyHardcoded"
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