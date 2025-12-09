class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  protect_from_forgery with: :exception, unless: -> { request.format.json? }

  helper_method :current_user

  def current_user
    User.find_by(id: cookies.signed[:user_id])
  end

  def authenticate_user
    unless current_user
      render json: {error: "unauthenticated user"}, status: :unauthorized
    end
  end

  def authenticate_admin
    unless current_user && current_user.admin
      render json: { error: "Unauthorized - must be an admin"}, status: :unauthorized
    end
  end

  def authorize_post_owner
    post = Post.find(params[:id])
    unless current_user.admin || post.user_id == current_user.id
      render json: { message: "You don't have permission to modify this post." }, status: :unauthorized
    end
  end
end
