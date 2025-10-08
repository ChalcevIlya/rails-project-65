# frozen_string_literal: true

class Web::Admin::BulletinsController < Web::Admin::ApplicationController
  def index
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.order(created_at: :desc).page(params[:page]).per(10)
  end

  def dashboard
    @bulletins = Bulletin.under_moderation.page(params[:page]).per(10)
  end

  def publish
    @bulletin = Bulletin.find(params[:id])
    if @bulletin.may_publish?
      @bulletin.publish!
      redirect_back_or_to admin_root_path, notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.published'))
    else
      redirect_back_or_to admin_root_path, alert: I18n.t('bulletins.alert', action: I18n.t('actions.publish'))
    end
  end

  def reject
    @bulletin = Bulletin.find(params[:id])
    if @bulletin.may_reject?
      @bulletin.reject!
      redirect_back_or_to admin_root_path, notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.rejected'))
    else
      redirect_back_or_to admin_root_path, alert: I18n.t('bulletins.alert', action: I18n.t('actions.reject'))
    end
  end

  def archive
    @bulletin = Bulletin.find(params[:id])
    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_back_or_to admin_root_path, notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.archived'))
    else
      redirect_back_or_to admin_root_path, alert: I18n.t('bulletins.alert', action: I18n.t('actions.archive'))
    end
  end
end
