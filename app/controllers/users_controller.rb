class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :statuses]
  before_action :set_nearby_users, only: [:nearby, :all_nearby]

  # GET /users
  # GET /users.json
  def index
  end

  # POST /users/nearby.json
  def nearby
    @users_data = user_data @users, @locations
    render json: { users: @users_data }
  end

  def all_nearby
    @users_data = all_user_data @users, @locations
    render json: { users: @users_data }
  end


  # POST /users/1/statuses.json
  def statuses
    @statuses = @user.statuses.pluck(:status)
    render json: { statuses: @statuses }
  end

  # POST /users/1
  # POST /users/1.json
  def show
    @user = (User.find_by(auth_token: params[:id]) or User.find_by(id: params[:id]))
    render json: {
        user_id: @user.id,
        name: @user.name,
        profile_pic_url: "http://graph.facebook.com/#{@user.fb_id}/picture?width=100&height=100",
        job: get_job(@user),
        education: get_education(@user),
        status: @user.status
    }
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
    @user = User.find_by(email: user_params[:email]) 
    if @user
      render json: { auth_token: @user.auth_token }
    else
      @user = User.new(user_params)
      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render json: { auth_token: @user.auth_token } }
        else
          format.html { render action: 'new' }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  #POST /chats/get_meta.json
  def get_chat_meta
    @user = current_user
    @other_user = User.find(params[:other_user_id])
    render json: {
      user: { name: @user.name, profile_pic_url: @user.profile_pic },
      other_user: { name: @other_user.name, profile_pic_url: @other_user.profile_pic }
    }
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_nearby_users
      @user = current_user
      @user_locations = @user.locations
      @location = @user_locations.new(location_params)
      if not @location.save
        @location = @user_locations.last
      end
      @users, @locations = User.nearby @location, @user.id
    end

    def all_user_data users, locations
      info = []
      users.each do |user|
        user_info = {}
        user_info[:name] = user.name
        user_location = locations.where(user_id: user.id).last
        user_info[:location] = { longitude: user_location.longitude, latitude: user_location.latitude }
        info << user_info
      end
      info
    end

    def user_data users, locations
      info = []
      users.each do |user|
        user_info = {}
        user_info[:user_id] = user.id
        user_info[:name] = user.name
        user_info[:description] = get_user_desc user
        user_info[:status] = user.status
        user_info[:profile_pic_url] = user.profile_pic_url.nil? ? "http://graph.facebook.com/#{user.fb_id}/picture?width=70&height=70" : user.profile_pic_url
        user_location = locations.where(user_id: user.id).last
        user_info[:location] = { longitude: user_location.longitude, latitude: user_location.latitude }
        info << user_info
      end
      info
    end

    def get_job user
      status = ""
      if job = user.jobs.last
        company = job.company
        status += "Works"
        if not (job.position.nil? or job.position == "")
          status += " as "+job.position
        end
        status+=" at "+(company.company_name or "")+" "+(company.city or "")+" "+(company.country or "")
      end
      status
    end

    def get_education user
      status = ""
      if degree = user.degrees.last
        institute = degree.institute
        status += "Studies "+(degree.major or "")+" at "+(institute.institute_name or "")+" "+(institute.city or "")+" "+(institute.country or "")
      end
      status
    end

    def get_user_desc user
      type = "job"
      status = ""
      if job = user.jobs.last
        company = job.company
        # binding.pry
        status += "Works"
        if not (job.position.nil? or job.position == "")
          status += " as "+job.position
        end
        status+=" at "+(company.company_name or "")+" "+(company.city or "")+" "+(company.country or "")
      elsif degree = user.degrees.last 
        type = "degree"
        institute = degree.institute
        status += "Studies "+(degree.major or "")+" at "+(institute.institute_name or "")+" "+(institute.city or "")+" "+(institute.country or "")
      end
      { type: type, status: status }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:email, :name, :auth_token, :dob, :maretial_status, :gender, :fb_id, :linkedin_id)
    end

    def location_params
      params.require(:location).permit(:longitude, :latitude, :name)
    end
end
