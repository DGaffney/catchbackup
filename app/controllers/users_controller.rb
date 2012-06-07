class UsersController < ApplicationController
  before_filter :login_required, except: [:index, :show]
  before_filter :admin_required, only: [:destroy, :panel]

  def index
    @page_title = "Users"
    #removed dope-ass join because paginate wouldn't play nice.
    if current_user && current_user.admin?
    @users = User.paginate(:page => params[:page], :per_page => 16, :order => "id desc")
    else
      @users = User.where(:hidden_account => false).paginate(:page => params[:page], :per_page => 16, :order => "id desc")
    end
  end

  def dashboard
    @page_title = "Dashboard"
    @user = User.find(current_user.id)
    @curations = @user.curations.where("status != 'hidden'").paginate(:page => params[:page], :per_page => 10, :order => "id desc")
    # @curations = @user.curations.order(:created_at)
  end

  def show
    @user = User.where(user_name: params[:user_name]).first
    @page_title = @user.name
    @curations = @user.curations.where("status != 'hidden'").paginate(:page => params[:page], :per_page => 20, :order => "id desc", :limit => 10)
  end

  def edit
    @user = User.find_by_user_name(params[:user_name])
    @page_title = "Editing "+@user.name
  end

  def new
    # NOTE: Not your typical 'new' because the user is already created
    @user = User.find_by_user_name(params[:user_name])
  end

  def update
    @user = User.find_by_user_name(params[:user_name], select: [:id, :user_name])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to @user, flash: { success: "Your info has been updated." } }
        format.js
      else
        format.html { render action: 'edit', flash: { error: @reseacher.errors } }
        format.js
      end
    end
  end

  def destroy
    @user = User.find_by_user_name(params[:user_name], select: [:id])
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to @user, notice: "User successfully updated." }
        format.js
      else
        format.html { render action: 'edit' }
        format.js
      end
    end
  end
  
  def panel
  end
  
  def upgrade
    @user = User.find_by_user_name(params[:user_name])
    roles = Setting.find_by_name("roles").actual_value
    @user.role = roles[roles.index(@user.role)+1]
    @user.upgrade_requested = false
    @user.save!
    redirect_to request.referer
  end

  def request_upgrade
    @user = User.find_by_user_name(params[:user_name])
    @user.upgrade_requested = true
    @user.save!
    redirect_to request.referer
  end
end
