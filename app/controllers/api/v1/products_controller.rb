class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]

  def index
    products = Product.all
    render json: products
  end

  def show
    product = set_product
    render json: product
  end

  def create
    # binding.pry
    product = Product.new(product_params)
    if product.save
      render json: product, status: 201
    else
      render json: { message: "can not create product" }, status: 400
    end
  end

  def update
    product = set_product
    if product.update(product_params)
      render json: { message: "product updated" }, status: 202
    else
      render json: { message: "can not update product" }, status: 400
    end
  end

  def destroy
    product = set_product
    if product_archived
      product.update(archived_at: nil)
      render json: { message: "product available" }, status: 202
    else
      product.update(archived_at: DateTime.now)
      render json: { message: "product archived" }, status: 202
    end
  end

  private

  def product_params
    {
      name: params[:name],
      description: params[:description],
      stock_amount: params[:stock_amount],
      category_ids: params[:category_ids]
    }
  end

  def set_product
    Product.find(params[:id])
  end

  def product_archived
    product = set_product
    product.archived_at != nil
  end
end