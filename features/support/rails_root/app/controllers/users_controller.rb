class UsersController < ApplicationController
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.create(params[:user])
    
    if @user.valid?
      flash[:notice] = "Succesfully created a new user"
      redirect_to users_path
    else
      render :action => :new
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update_attributes(params[:user])
      flash[:notice] = "Succesfully updated user"
      redirect_to(@user)
    else
      render :action => :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    redirect_to users_url
  end
end
