# frozen_string_literal: true

class Web::Admin::CategoriesController < Web::Admin::ApplicationController
  def index
    @categories = Category.all.page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: I18n.t('categories.notice', action: I18n.t('categories.actions.created'))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: I18n.t('categories.notice', action: I18n.t('categories.actions.updated'))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.bulletins.any?
      redirect_to admin_categories_path, alert: I18n.t('categories.alert_not_deleted')
    else
      @category.destroy
      redirect_to admin_categories_path, notice: I18n.t('categories.notice', action: I18n.t('categories.actions.deleted'))
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
