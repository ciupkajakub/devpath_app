module Admins
  class PurchasesController < ApplicationController
    before_action :authenticate_admin!

    def index
      all_purchases = Purchase.all
      @q = all_purchases.ransack(params[:q])
      @q.sorts = 'purchase_date asc'
      @query_params = query_params
      @purchases = @q.result(distinct: true).includes(:purchase_products).
                   page(params[:page]).per(4)
    end

    def export_purchases
      @purchases = if query_params.nil?
                     Purchase.all
                   else
                     Purchase.ransack(params[:q]).result
                   end
      render xlsx: 'export_purchases'
    end

    private

    def query_params
      params[:q]&.permit(:aasm_state_eq, :purchase_products_product_id_eq,
                         :purchase_date_gteq, :purchase_date_lteq,
                         :user_email_eq)
    end
  end
end
