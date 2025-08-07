# frozen_string_literal: true

class Web::Admin::BulletinsController < ApplicationController
  before_action :authorize_admin!
  before_action :set_bulletin, only: %i[publish reject archive]

  def index
    @categories = Category.all
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.includes(:category, :user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def dashboard
    @bulletins = Bulletin.includes(:category, :user).where(state: :under_moderation).page(params[:page]).per(10)
  end

  def publish
    if @bulletin.may_publish?
      @bulletin.publish!
      redirect_back_or_to admin_root_path, notice: I18n.t('bulletins.notice', action: 'published')
    else
      redirect_back_or_to admin_root_path, alert: I18n.t('bulletins.alert', action: 'publish')
    end
  end

  def reject
    if @bulletin.may_reject?
      @bulletin.reject!
      redirect_back_or_to admin_root_path, notice: I18n.t('bulletins.notice', action: 'rejected')
    else
      redirect_back_or_to admin_root_path, alert: I18n.t('bulletins.alert', action: 'reject')
    end
  end

  def archive
    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_back_or_to admin_root_path, notice: I18n.t('bulletins.notice', action: 'archived')
    else
      redirect_back_or_to admin_root_path, alert: I18n.t('bulletins.alert', action: 'archive')
    end
  end

  private

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end
end
