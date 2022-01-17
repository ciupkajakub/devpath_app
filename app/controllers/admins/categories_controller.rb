module Admins
  class CategoriesController < ApplicationController
    before_action :set_category, only: %i[show edit update destroy]
    before_action :authenticate_admin!

    def index
      @q = Category.ransack(params[:q])
      @q.sorts = 'name asc'
      @categories = @q.result.page(params[:page]).per(4)
    end

    def show; end

    def new
      @category = Category.new
    end

    def edit; end

    def create
      @category = Category.new(category_params)
      @category.save
      redirect_to categories_path
    end

    def update
      @category.update(category_params)
      redirect_to category_path
    end

    def destroy
      if @category.products == []
        @category.destroy
        redirect_to categories_path
      else
        redirect_to categories_path, notice: 'This category contains products.'
      end
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end
  end
end
