class CallbacksController < Devise::OmniauthCallbacksController
  def facebook
    if request.env["omniauth.auth"]
      u = current_user
      u.real_name = request.env["omniauth.auth"]["extra"]["raw_info"]["first_name"]
      u.real_middle_name = request.env["omniauth.auth"]["extra"]["raw_info"]["middle_name"]
      u.real_last_name = request.env["omniauth.auth"]["extra"]["raw_info"]["last_name"]
      u.gender = request.env["omniauth.auth"]["extra"]["raw_info"]["gender"]
      u.timezone = request.env["omniauth.auth"]["extra"]["raw_info"]["timezone"]
      u.facebook_link = request.env["omniauth.auth"]["extra"]["raw_info"]["link"]
      u.provider = 'facebook'

      u.save!
      redirect_to root_path
    else
      nil
    end
  end
end