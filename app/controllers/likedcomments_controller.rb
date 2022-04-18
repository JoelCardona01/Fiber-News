class LikedcommentsController < ApplicationController
  before_action :set_likedcomment, only: [:show, :edit, :update, :destroy]

  # GET /likedcomments
  # GET /likedcomments.json
  def index
    @likedcomments = Likedcomment.all
  end

  # GET /likedcomments/1
  # GET /likedcomments/1.json
  def show
  end

  # GET /likedcomments/new
  def new
    @likedcomment = Likedcomment.new
  end

  # GET /likedcomments/1/edit
  def edit
  end

  # POST /likedcomments
  # POST /likedcomments.json
  def create
    @likedcomment = Likedcomment.new(likedcomment_params)

    respond_to do |format|
      if @likedcomment.save
        format.html { redirect_to @likedcomment, notice: 'Likedcomment was successfully created.' }
        format.json { render :show, status: :created, location: @likedcomment }
      else
        format.html { render :new }
        format.json { render json: @likedcomment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likedcomments/1
  # PATCH/PUT /likedcomments/1.json
  def update
    respond_to do |format|
      if @likedcomment.update(likedcomment_params)
        format.html { redirect_to @likedcomment, notice: 'Likedcomment was successfully updated.' }
        format.json { render :show, status: :ok, location: @likedcomment }
      else
        format.html { render :edit }
        format.json { render json: @likedcomment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likedcomments/1
  # DELETE /likedcomments/1.json
  def destroy
    @likedcomment.destroy
    respond_to do |format|
      format.html { redirect_to likedcomments_url, notice: 'Likedcomment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_likedcomment
      @likedcomment = Likedcomment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def likedcomment_params
      params.require(:likedcomment).permit(:user_id, :users_id, :comment_id, :comments_id)
    end
end
