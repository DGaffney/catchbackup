class SessionsController < ApplicationController
  def create
    # raise request.env["omniauth.auth"].to_yaml
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
    if user.first_time
      redirect_to new_user_url(user), flash: { success: "Welcome, #{user.name}!" }
    else
      redirect_to request.referer || dashboard_url, flash: { success: "Hi, #{user.name}!" }
    end

  end

  def destroy
    session[:user_id] = nil
    redirect_to request.referer || root_url, flash: { success: "Signed out." }
  end

  def fail
    redirect_to root_url, :error => "We're sorry, but something went wrong when you tried to log in. Care to try again?"
  end
end
