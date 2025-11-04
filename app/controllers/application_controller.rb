class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::Helpers
  include Devise::Controllers::Helpers

  before_action :authenticate_user!

  private

  def authenticate_user!
    return if current_user.present?

    render json: { error: "Not authorized" }, status: :unauthorized
  end

  def ensure_active_user
    return if current_user.active?

    render json: { error: "Your account is pending approval" }, status: :forbidden
  end
end
