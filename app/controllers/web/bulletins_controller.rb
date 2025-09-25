# frozen_string_literal: true

class Web::BulletinsController < Web::ApplicationController
  before_action :require_login, only: %i[new create edit update archive send_to_moderation]

  def index
    @categories = Category.all
    @q = Bulletin.ransack(params[:q])
    @bulletins = @q.result.where(state: :published).order(created_at: :desc).page(params[:page]).per(9)
  end

  def show
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin
  end

  def new
    @bulletin = Bulletin.new
    @categories = Category.all
  end

  def edit
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin, :author?
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
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin, :author?
    if @bulletin.update(bulletin_params)
      redirect_to bulletin_path(@bulletin), notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.updated'))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def archive
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin, :author?
    if @bulletin.may_archive?
      @bulletin.archive!
      redirect_back_or_to profile_path, notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.archived'))
    else
      redirect_back_or_to profile_path, alert: I18n.t('bulletins.alert', action: I18n.t('actions.archive'))
    end
  end

  def send_to_moderation
    @bulletin = Bulletin.find(params[:id])
    authorize @bulletin, :author?
    if @bulletin.may_send_to_moderation?
      @bulletin.send_to_moderation!
      redirect_back_or_to profile_path, notice: I18n.t('bulletins.notice', action: I18n.t('bulletins.actions.sent_to_moderation'))
    else
      redirect_back_or_to profile_path, alert: I18n.t('bulletins.alert', action: I18n.t('actions.send_to_moderation'))
    end
  end

  private

  def bulletin_params
    params.require(:bulletin).permit(:title, :description, :image, :category_id)
  end
end
