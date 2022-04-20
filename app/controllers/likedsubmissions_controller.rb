class LikedsubmissionsController < ApplicationController
  before_action :set_likedsubmission, only: [:show, :edit, :update, :destroy]

  # GET /likedsubmissions
  # GET /likedsubmissions.json
  def index
    @likedsubmissions = Likedsubmission.all
  end

  # GET /likedsubmissions/1
  # GET /likedsubmissions/1.json
  def show
  end

  # GET /likedsubmissions/new
  def new
    @likedsubmission = Likedsubmission.new
  end

  # GET /likedsubmissions/1/edit
  def edit
  end

  # POST /likedsubmissions
  # POST /likedsubmissions.json
  def create
    @likedsubmission = Likedsubmission.new(likedsubmission_params)

    respond_to do |format|
      if @likedsubmission.save
        format.html { redirect_to @likedsubmission, notice: 'Likedsubmission was successfully created.' }
        format.json { render :show, status: :created, location: @likedsubmission }
      else
        format.html { render :new }
        format.json { render json: @likedsubmission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /likedsubmissions/1
  # PATCH/PUT /likedsubmissions/1.json
  def update
    respond_to do |format|
      if @likedsubmission.update(likedsubmission_params)
        format.html { redirect_to @likedsubmission, notice: 'Likedsubmission was successfully updated.' }
        format.json { render :show, status: :ok, location: @likedsubmission }
      else
        format.html { render :edit }
        format.json { render json: @likedsubmission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /likedsubmissions/1
  # DELETE /likedsubmissions/1.json
  def destroy
    @likedsubmission.destroy
    respond_to do |format|
      format.html { redirect_to likedsubmissions_url, notice: 'Likedsubmission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_likedsubmission
      @likedsubmission = Likedsubmission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def likedsubmission_params
      params.fetch(:likedsubmission, {})
    end
end
