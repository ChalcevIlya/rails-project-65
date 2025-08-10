# frozen_string_literal: true

class Web::AuthController < ApplicationController
  def callback
    auth = request.env['omniauth.auth']

    email = auth.dig('info', 'email').to_s.downcase
    user = User.find_or_initialize_by(email: email)
    user.name = auth.dig('info', 'name')
    user.admin = false if user.new_record?
    user.save!

    session[:user_id] = user.id
    redirect_to root_path, notice: I18n.t('auth.login', name: user.name)
  end

  def logout
    session.delete(:user_id)
    redirect_to root_path, notice: I18n.t('auth.logout')
  end
end
