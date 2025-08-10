# frozen_string_literal: true

class Web::BulletinsController < ApplicationController
  before_action :require_login, only: %i[new create edit update archive send_to_moderation]
  before_action :set_bulletin, only: %i[show edit update archive send_to_moderation]
  before_action :check_author, only: %i[edit update archive send_to_moderation]

  def index
    @categories = Category.all
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.where(state: :published).includes(:category, :user).order(created_at: :desc).page(params[:page]).per(9)
  end

  def profile
    @categories = Category.all
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.where(user: current_user).includes(:category, :user).order(created_at: :desc).page(params[:page]).per(10)
  end

  def show; end

  def new
    @bulletin = Bulletin.new
    @categories = Category.all
  end

  def edit
    @categories = Category.all
  end

  def create
    @bulletin = current_user.bulletins.build(bulletin_params)
    if @bulletin.save
      redirect_to bulletin_path(@bulletin), notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.created'))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bulletin.update(bulletin_params)
      redirect_to bulletin_path(@bulletin), notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.updated'))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_back_or_to profile_path, notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.archived'))
    else
      redirect_back_or_to profile_path, alert: I18n.t('bulletins.alert', action: I18n.t('actions.archive'))
    end
  end

  def send_to_moderation
    if @bulletin.may_send_to_moderation?
      @bulletin.send_to_moderation!
      redirect_back_or_to profile_path, notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.sent_to_moderation'))
    else
      redirect_back_or_to profile_path, alert: I18n.t('bulletins.alert', action: I18n.t('actions.send_to_moderation'))
    end
  end

  private

  def check_author
    redirect_to root_path, alert: I18n.t('auth.access_denied') unless @bulletin.user == current_user
  end

  def set_bulletin
    @bulletin = Bulletin.find(params[:id])
  end

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :image, :category_id)
  end
end
