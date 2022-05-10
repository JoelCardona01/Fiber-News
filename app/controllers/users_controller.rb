class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #GET /api/users/:user_id
  def userJSON
    respond_to do |format|
      @user = User.find_by(:id => params[:user_id])
      if @user.nil? 
        format.json { render json: {"status": 433, "error": "User does not exists", "message": "There is no user with same user_id as provided"}, status: 433
          return } 
      else
        format.json { 
          userJson = {
            "id": @user.id,
            "name": @user.name,
            "email": @user.email,
            "karma": @user.karma,
            "about": @user.about,
            "created_at": @user.created_at,
            "updated_at": @user.updated_at,
            
          }
          render json: userJson
        }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /api/users/1.json
  def updateAPI
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
     if User.find_by(:id => params[:user_id]).nil?
       respond_to do |format|
        format.json{
         render json: {
          "status":404,
          "error": "Not Found",
          "message": "There is not an existing user with the id provided"
        },
        status: 404
        }
      end
      return
    end
    if User.find_by(:id => params[:user_id]).APIKey !=  request.headers["X-API-KEY"]
       respond_to do |format|
        format.json{
         render json: {
          "status":403,
          "error": "Forbidden",
          "message": "You are not allowed to edit someone else profile. The api key provided does not belong to the user with id provided"
        },
        status: 403
        }
      end
      return
    end
    respond_to do |format|
      if params[:about]=="" or params[:about].nil?
        format.json{
        render json: {
          "status":400,
          "error": "Bad request",
          "message": "The about field must contain at least 1 character"
        },
        status: 400
      }
      else 
        @user = User.find_by(:id => params[:user_id])
        @user.about = params[:about]
        if @user.save
           format.json { 
            render json: {
            "status":200,
            "user":@user,
            "message": "User updated",
            },
            status: :ok
          }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url}
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :about, :karma)
    end
end
