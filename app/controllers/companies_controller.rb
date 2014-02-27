class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  def from_facebook
    # binding.pry
    @user = current_user
    @user_jobs = @user.jobs
    @companies = params[:companies].reverse
    @companies.each do |company|
      begin
        position = company[:position][:name]
      rescue
        position = ""
      end
      begin
        start_date = company[:start_date].to_date 
      rescue 
        start_date = nil
      end
      begin
        end_date = company[:end_date].to_date 
      rescue 
        start_date = nil
      end
      company_name = company[:employer][:name]
      begin
        city_and_country = company[:location][:name].split(",")
        city = city_and_country[0].strip
        country = city_and_country[-1].strip
      rescue
        city = country = ""
      end
      @company = Company.find_or_create_by(company_name: company_name, city: city, country: country )
      @user_jobs.find_or_create_by(company: @company, to: start_date, from: end_date, position: position)
    end
    render json: { status: :success }
  end

  def from_linkedin
    @user = current_user
    @user_jobs = @user.jobs
    @companies = params[:companies].reverse
    @companies.each do |company|
      begin
        position = company[:title]
      rescue
        position = ""
      end
      begin
        start_date = ("01/"+company[:startDate][:month].to_s+"/"+company[:startDate][:year].to_s).to_date 
      rescue 
        start_date = nil
      end
      begin
        if  company[:isCurrent] == false
          end_date = ("30/"+company[:endDate][:month].to_s+"/"+company[:endDate][:year].to_s).to_date 
        end
      rescue 
        end_date = nil
      end
      company_name = company[:company][:name]
      city = country = ""
      @company = Company.find_or_create_by(company_name: company_name, city: city, country: country )
      @user_jobs.find_or_create_by(company: @company, to: start_date, from: end_date, position: position)
    end
    render json: { status: :success }
  end
  # POST /companies
  # POST /companies.json
  def create
    binding.pry
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render action: 'show', status: :created, location: @company }
      else
        format.html { render action: 'new' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
      @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
      params.require(:company).permit(:company_name, :city, :country)
    end
end
