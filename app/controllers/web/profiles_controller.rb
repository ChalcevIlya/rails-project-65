# frozen_string_literal: true

class Web::ProfilesController < Web::ApplicationController
  before_action :require_login

  def show
    @states = Bulletin.aasm.states.map do |s|
      [I18n.t("aasm.state.#{s.name}"), s.name]
    end
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.where(user: current_user).order(created_at: :desc).page(params[:page]).per(10)
  end
end
