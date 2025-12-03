class SessionsController < ApplicationController
  def create
    # find the user by their email
    user = User.find_by(email: params[:email])

    #if the user exists and they have a valid password - based on bcrypt
    if user && user.authenticate(params[:password])
      #start creating the cookie object
      cookie = { value: user.id }
      # make sure that no one can tamper with the cookie and merge the cookie settings into the cookie object we created
      cookies.signed[:user_id] = cookie.merge(cookie_settings)
      render json: { email: user.email, user_id: user.id }, status: :created
    else
      render json: {}, status: :unauthorized
    end
  end

  def destroy
    cookies.delete(:user_id, cookie_settings)
    render json: { message: "Logged out successfully" }
  end

  private

  def cookie_settings
    # checks if we are in test mode (if we're running rails test)
    if Rails.env.test?
      { httponly: true }
    else
      { httponly: true, secure: true, same_site: "None" }
    end
  end
end
