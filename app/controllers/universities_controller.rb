class UniversitiesController < ApplicationController
  # before_action :authenticate_user!
  # before_action :confirm_admin

  def index
    @univs = University.all
  end

  def create
    @univ = University.new(university_params)
    @univ.save
    redirect_to university_path(@univ.id)
  end

  def new
    @univ = University.new
  end

  def show
    @univ = University.find(params[:id])
  end

  def edit
    @univ = University.find(params[:id])
  end

  def update
    @univ = University.find(params[:id])
    @univ.update
  end

  def destroy
    @univ = University.find(params[:id])
    @univ.destroy
  end

  private
  def university_params
    params.require(:university).permit(:name)
  end

  def confirm_admin
    if current_user.admin == false
      redirect_to user_path(current_user)
    end
  end
end
