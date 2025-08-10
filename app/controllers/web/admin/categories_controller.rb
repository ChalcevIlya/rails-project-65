# frozen_string_literal: true

class Web::Admin::CategoriesController < ApplicationController
  before_action :authorize_admin!
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = Category.all.page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def edit; end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: I18n.t('categories.notice', action: I18n.t('categories.actions.created'))
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: I18n.t('categories.notice', action: I18n.t('categories.actions.updated'))
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    redirect_to admin_categories_path, notice: I18n.t('categories.notice', action: I18n.t('categories.actions.deleted'))
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
