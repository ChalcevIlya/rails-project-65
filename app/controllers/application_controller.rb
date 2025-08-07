# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern
  helper_method :current_user, :user_signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def user_signed_in?
    current_user.present?
  end

  def require_login
    return if user_signed_in?

    redirect_to root_path, alert: I18n.t('auth.require_login')
  end

  def user_not_authorized
    redirect_to root_path, alert: I18n.t('auth.access_denied')
  end

  private

  def authorize_admin!
    authorize :admin, :access?
  end
end
