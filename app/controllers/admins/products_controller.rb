module Admins
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[show edit update destroy archive]
    before_action :authenticate_admin!

    def index
      @q = Product.ransack(params[:q])
      @q.sorts = 'name asc'
      @products = @q.result(distinct: true).includes([:categories]).
        page(params[:page]).per(4)
    end

    def show; end

    def new
      @product = Product.new
    end

    def edit; end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to products_path, notice: 'Product has been successfully created.'
      else
        redirect_to products_path, notice: @product.errors.full_messages.first
      end
    end

    def update
      @product.update(product_params)
      redirect_to product_path
    end

    def destroy
      @product.destroy
      redirect_to products_path
    end

    def upload_product_csv
      Admins::UploadProductCsv.call(params[:file])
    rescue CsvNoCategoryError => e
      flash[:alert] = e.message
      redirect_to root_path
    end

    def archive
      if product_archived
        @product.update(archived_at: nil)
      else
        @product.update(archived_at: DateTime.now)
      end
    end

    private

    def set_product
      @product = Product.find(params[:id]).decorate
    end

    def product_archived
      !@product.archived_at.nil?
    end

    def product_params
      params[:product]&.permit(:name, :image, :description, :stock_amount)&.
        merge(category_ids: params[:category_ids])
    end
  end
end
