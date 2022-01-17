module Admins
  class StatisticsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @results = Admins::Statistics.result
    end
  end
end
