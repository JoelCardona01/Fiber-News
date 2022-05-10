class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :edit, :update, :destroy, :vote, :unvote]
  skip_before_action :verify_authenticity_token
  # GET /submissions
  # GET /submissions.json
  def index
    @submissions = Submission.all.order(votes: :desc)
    if !session[:user_id].nil?
      @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
    end
     respond_to do |format|
            format.html {  }
            format.json { render json: @submissions }
    end
  end
  
   # GET /api/submissions
  def indexAPI
    @submissions = Submission.all.order(votes: :desc)
  
     respond_to do |format|
        format.json { render json: @submissions }
    end
  end

  # GET /submissions/1
  # GET /submissions/1.json
  def show
    @comments= Comment.all.where(:postid => params[:id]).order(:parentid)
    if !session[:user_id].nil?
      @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
      @likedcomments = Likedcomments.all.where(:user_id => session[:user_id])
    end
  end


  # GET /api/submissions/:post_id
  def submission_JSON
    @submissions = Submission.all.where(:id => params[:post_id])
  
    respond_to do |format|
      format.json { render json: @submissions }
    end
  end
  
  # GET /api/submissions/:post_id/comments
  def sub_comments_JSON
    @comments= Comment.all.where(:postid => params[:post_id]).order(:parentid)
  
    respond_to do |format|
      format.json { render json: @comments }
    end
  end
  
  
  # GET /submissions/new
  def new
    @submission = Submission.new
  end
  
  #GET /submissions/user/:id
  def submFromUser
    @submissions = Submission.all.where(:user_id => params[:user_id]).order(created_at: :desc)
    if !session[:user_id].nil?
      @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
    end
    render "index"
  end
  
  #GET /api/submissions/user/:user_id
  def submFromUserJSON
    respond_to do |format|
      if User.find_by(:id => params[:user_id]).nil?
        format.json { render json: {"status": 404, "error": "User does not exists", "message": "There is no user with same user_id as provided"}, status: 404
          return } 
      else 
        @submissions = Submission.all.where(:user_id => params[:user_id]).order(created_at: :desc)
        if !session[:user_id].nil?
          @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
        end
        format.json { render json: @submissions }
      end
    end
  end
  
  def submFromUrl
    params.permit!
    @submissions = Submission.all.where("url like ?", "%#{params[:url].to_s}%").order(created_at: :desc)
    if !session[:user_id].nil?
      @likedsubmissions = Likedsubmission.all.where(:user_id => session[:user_id])
    end
    render "index"
  end
  
  def userUpvotes
    @submissions = Likedsubmission.all.where(:user_id => session[:user_id]).order(created_at: :desc)
    render :upvotes
  end
  
  #GET /api/submissions/upvoted/user/:user_id
  def userUpvotesJSON
    respond_to do |format|
      if User.find_by(:id => params[:user_id]).nil?
        format.json { render json: {"status": 404, "error": "User does not exists", "message": "There is no user with same user_id as provided"}, status: 404
          return } 
      else 
        @likedsubmissions = Likedsubmission.all.where(:user_id => params[:user_id]).order(created_at: :desc)
        format.json { 
          submissions = []
          @likedsubmissions.each do |ls|
            submissions.push(Submission.find_by(:id => ls.submission_id))
          end
          render json: submissions.to_json, status: :ok
        }
      end
    end
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
      
      if !(@submission.url != "" and  @submission.url=~ /\A#{URI::regexp(['http', 'https'])}\z/) then format.html { redirect_to request.referrer, alert: 'That is not a valid URL.' }
      elsif @submission.title=="" then format.html { redirect_to request.referrer, alert: 'That is not a valid title.' } ##Comprovem que el titol no es buit
      elsif (@submission.url=="") 
        if @submission.save
            format.html { redirect_to submissions_path }
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
            format.html { redirect_to submissions_path }
            format.json { render :show, status: :created, location: @submission }
          else
            format.html { render :new }
            format.json { render json: @submission.errors, status: :unprocessable_entity }
          end
        else
          if @submission.save
            format.html { redirect_to submissions_path }
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
  
  
  # POST /api/submissions
  def createAPI
    if request.headers["X-API-KEY"].nil? or request.headers["X-API-KEY"].blank? 
     respond_to do |format|
        format.json{
         render json: {
          "status":401,
          "error": "Unauthorized",
          "message": "You provided no api key (X-API-KEY Header)"
        },
        status: 401
        }
      end
      return
    end
    if User.find_by(:APIKey => request.headers["X-API-Key"]).nil?
     respond_to do |format|
      format.json{
        render json: {
          "status":403,
          "error": "Forbidden",
          "message": "Your api key (X-API-KEY Header) is not valid"
         },
        status: 403
      }
     end 
    return
    end
    respond_to do |format|

    @user = User.all.where(:APIKey => request.headers["X-API-Key"]).first()
    @submission = Submission.new(submission_params)
    @submission.user_id = @user.id
    if @submission.title=="" 
      format.json{
        render json: {
          "status":400,
          "error": "Bad request",
          "message": "The title of the submission must contain at least 1 character"
        },
        status: 400
      }
      
    elsif (!@submission.url.nil? and  @submission.url != "" and  !(@submission.url=~ /\A#{URI::regexp(['http', 'https'])}\z/)) 
       format.json{
        render json: {
          "status":400,
          "error": "Bad request",
          "message": "The url provided is not in a valid format."
        },
        status: 400
      }
       
    elsif (@submission.url.nil? or @submission.url=="") 
      if @submission.save
         format.json { 
            render json: {
            "status":201,
            "submission":@submission,
            "message": "Submission posted",
            },
            status: :ok
          }
          
      else
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    elsif ((@submission.url!="" or !@submission.url.nil? and Submission.find_by(url: @submission.url).nil?))##Comprovem que no existeixi cap submission amb el mateix url i guardem la nova
      if @submission.text!="" or !@submission.text.nil?
        text = @submission.text
        @submission.text=""
        if @submission.save
          @comment= Comment.new(:text => text, :user_id =>@submission.user_id, :postid => @submission.id, :parentid => "0", :likes => 0)
          @comment.save
          format.json { 
            render json: {
              "status":201,
              "submission": @submission,
              "comment": @comment,
              "message": "Submission posted"
            },
            status: :ok
         }
         
        else
          format.json { render json: @submission.errors, status: :unprocessable_entity }
        end
      else
        if @submission.save
          format.json { 
            render json: {
              "status":201,
              "submission": @submission,
              "message": "Submission posted",
            },
            status: :ok
         }
         
        else
          format.json { render json: @submission.errors, status: :unprocessable_entity }
        end
      end
    else ##Ja existia una submission amb el mateix url de manera que redirigim a la submission amb el mateix url.
    @submissionAux = Submission.find_by(:url => @submission.url )
      format.json{
        render json: {
          "status":409,
          "error": "Conflict",
          "message": "There is already an existing submission with that url",
          "Already existing submission": @submissionAux
        },
        status: 409
      }
      
    end
  end 
end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission }
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
    submissionliked = Likedsubmission.all.where(:submission_id => @submission.id)
    submissionliked = submissionliked.to_a
    for i in 0..submissionliked.length-1
      submissionliked[i].destroy
    end
    id = @submission.id
    @submission.destroy
    respond_to do |format|
      format.html { 
         referrerPath = URI(request.referrer).path
        if  referrerPath == submission_path(id)
            redirect_to submissions_path
        else 
          redirect_to request.referrer
        end
      }
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
  
  #POST /api/submissions/:submission_id/vote
  def APIVote
    if request.headers["X-API-KEY"].nil? or request.headers["X-API-KEY"].blank? then
      respond_to do |format|
        format.json{
         render json: {
          "status":401,
          "error": "Unauthorized",
          "message": "You provided no api key (X-API-KEY Header)"
        },
        status: 401
        }
      end
      return
    end
    if User.find_by(:APIKey => request.headers["X-API-Key"]).nil?
      respond_to do |format|
        format.json{
          render json: {
            "status":403,
            "error": "Forbidden",
            "message": "Your api key (X-API-KEY Header) is not valid"
          },
          status: 403
        }
      end
      return
    end
    if (Submission.find_by(id: params[:submission_id]).nil?)
      respond_to do |format|
        format.json{
        render json: {
          "status":404,
          "error": "Not Found",
          "message": "Submission not found"
        },
        status: 404
        }
        end
    return
    end
    if request.headers["X-API-Key"] == Submission.find_by(id: params[:submission_id]).user.APIKey
      respond_to do |format|
        format.json{
          render json: {
            "status":403,
            "error": "Forbidden",
            "message": "You cannot vote your own submission"
          },
          status: 403
        }
      end
      return
    end
    @user = User.all.where(:APIKey => request.headers["X-API-Key"]).first()
    if not Likedsubmission.all.find_by(user_id: @user.id, submission_id: params[:submission_id]).nil?
      respond_to do |format|
        format.json{
          render json: {
            "status":403,
            "error": "Forbidden",
            "message": "You cannot vote twice a submission"
          },
          status: 403
        }
      end
      return
    end
    @submission = Submission.find_by(id: params[:submission_id])
    @submission.votes = @submission.votes+1
    if @submission.save
      @likedsubmission = Likedsubmission.new(:submission_id => @submission.id, :user_id => @user.id)
      if @likedsubmission.save
        respond_to do |format|
        format.json { 
          render json: {
            "status":200,
            "comment":@submission,
            "message": "Submission voted",
          },
          status: 200
        }
        end
      else 
        respond_to do |format|
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
      format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #DELETE /api/submissions/:submission_id/vote
  def APIUnvote
        if request.headers["X-API-KEY"].nil? or request.headers["X-API-KEY"].blank? then
      respond_to do |format|
        format.json{
         render json: {
          "status":401,
          "error": "Unauthorized",
          "message": "You provided no api key (X-API-KEY Header)"
        },
        status: 401
        }
      end
      return
    end
    if User.find_by(:APIKey => request.headers["X-API-Key"]).nil?
      respond_to do |format|
        format.json{
          render json: {
            "status":403,
            "error": "Forbidden",
            "message": "Your api key (X-API-KEY Header) is not valid"
          },
          status: 403
        }
      end
      return
    end
    if (Submission.find_by(id: params[:submission_id]).nil?)
      respond_to do |format|
        format.json{
        render json: {
          "status":404,
          "error": "Not Found",
          "message": "Submission not found"
        },
        status: 404
        }
        end
    return
    end
    if request.headers["X-API-Key"] == Submission.find_by(id: params[:submission_id]).user.APIKey
      respond_to do |format|
        format.json{
          render json: {
            "status":403,
            "error": "Forbidden",
            "message": "You cannot unvote your own submission and will never be ablo to because you can't vote your own submission"
          },
          status: 403
        }
      end
      return
    end
    @user = User.all.where(:APIKey => request.headers["X-API-Key"]).first()
    if Likedsubmission.all.find_by(user_id: @user.id, submission_id: params[:submission_id]).nil?
      respond_to do |format|
        format.json{
          render json: {
            "status":403,
            "error": "Forbidden",
            "message": "You cannot unvote a submission that you haven't voted"
          },
          status: 403
        }
      end
      return
    end
    @submission = Submission.find_by(id: params[:submission_id])
    @submission.votes = @submission.votes-1
    if @submission.save
      @likedsubmission = Likedsubmission.find_by(:submission_id => @submission.id, :user_id => @user.id)
      @likedsubmission.destroy
      respond_to do |format|
        format.json { 
          render json: {
            "status":200,
            "comment":@submission,
            "message": "Submission unvoted",
          },
          status: 200
        }
      end
    else
      respond_to do |format|
      format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def unvote
    @submission.votes = @submission.votes - 1
    if @submission.save
      @likedsubmission = Likedsubmission.find_by(:submission_id => @submission.id, :user_id => session[:user_id])
      @likedsubmission.destroy
    end
    redirect_to request.referrer
  end
  

  #POST /api/submissions/:submission_id/comment
  def commentAPI
    respond_to do |format|
      if request.headers["X-API-KEY"].nil? or request.headers["X-API-KEY"].blank? then
        format.json{
           render json: {
            "status":401,
            "error": "Unauthorized",
            "message": "You provided no api key (X-API-KEY Header)"
          },
          status: 401
          return
      }
      elsif User.find_by(:APIKey => request.headers["X-API-Key"]).nil?
          format.json{
            render json: {
              "status":403,
              "error": "Forbidden",
              "message": "Your api key (X-API-KEY Header) is not valid"
            },
            status: 403
          }
      else
        @user = User.all.where(:APIKey => request.headers["X-API-Key"]).first()
        params.permit!
        if !params[:text].blank? ##Si el text no es buit, aleshores creem el comentari.
            @comment = Comment.new
            @comment.user_id = @user.id
            @comment.text = params[:text]
            @comment.postid = params[:submission_id]
            @comment.parentid = 0
            if Submission.find_by(:id => params[:submission_id]).nil? then
              format.json{
                 render json: {
                  "status":404,
                  "error": "Submission not found",
                  "message": "It does not exists any submission with the same id as you provided in the query parameters"
                },
                status: 404
              }
            else
              if @comment.save
                format.json { 
                  render json: {
                    "status":201,
                    "comment":@comment,
                    "message": "Comment posted",
                  },
                  status: :ok
                }
              else
              format.json { render json: @comment.errors, status: :unprocessable_entity }
              end
            end
        else 
          format.json{
                 render json: {
                  "status":400,
                  "error": "Bad request",
                  "message": "The text must contain atleast 1 character."
                },
                status: 400
          }
        end
      end
    end
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
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:url, :title, :text, :user_id, :submission_id)
    end
end