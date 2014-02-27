class InstitutesController < ApplicationController
  before_action :set_institute, only: [:show, :edit, :update, :destroy]

  # GET /institutes
  # GET /institutes.json
  def index
    @institutes = Institute.all
  end

  # GET /institutes/1
  # GET /institutes/1.json
  def show
  end

  # GET /institutes/new
  def new
    @institute = Institute.new
  end

  # GET /institutes/1/edit
  def edit
  end

  def from_facebook
    @user = current_user
    @user_degrees = @user.degrees
    @institutes = params[:institutes].reverse
    @institutes.each do |institute|
      begin
        major = institute[:classes][0][:name]
      rescue
        major = ""
      end
      begin
        passing_year = institute[:year][:name].to_i
      rescue 
        passing_year = 0
      end
      institute_name = institute[:school][:name]
      institute = Institute.find_or_create_by(institute_name: institute_name)
      @user_degrees.find_or_create_by(institute: institute, passing_year: passing_year, major: major)
    end
    render json: { status: :success }
  end

  def from_linkedin
    @user = current_user
    @user_degrees = @user.degrees
    @institutes = params[:institutes].reverse
    @institutes.each do |institute|
      begin
        major = institute[:fieldOfStudy]
      rescue
        major = ""
      end
      begin
        passing_year = institute[:endDate][:year].to_i
      rescue 
        passing_year = 0
      end
      institute_name = institute[:schoolName]
      institute = Institute.find_or_create_by(institute_name: institute_name)
      @user_degrees.find_or_create_by(institute: institute, passing_year: passing_year, major: major)
    end
    render json: { status: :success }
  end

  # POST /institutes
  # POST /institutes.json
  def create
    @institute = Institute.new(institute_params)

    respond_to do |format|
      if @institute.save
        format.html { redirect_to @institute, notice: 'Institute was successfully created.' }
        format.json { render action: 'show', status: :created, location: @institute }
      else
        format.html { render action: 'new' }
        format.json { render json: @institute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /institutes/1
  # PATCH/PUT /institutes/1.json
  def update
    respond_to do |format|
      if @institute.update(institute_params)
        format.html { redirect_to @institute, notice: 'Institute was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @institute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /institutes/1
  # DELETE /institutes/1.json
  def destroy
    @institute.destroy
    respond_to do |format|
      format.html { redirect_to institutes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_institute
      @institute = Institute.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def institute_params
      params.require(:institute).permit(:institute_name, :city, :country)
    end
end
