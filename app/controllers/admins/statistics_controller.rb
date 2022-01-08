class Admins::StatisticsController < ApplicationController
  before_action :authenticate_admin!

  def index
    #number of clients
    # number of purchases
    # number of products
    # number of categories
    # bestsellers
    # amount of sold products
  end
end

