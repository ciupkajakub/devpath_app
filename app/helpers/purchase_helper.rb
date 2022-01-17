module PurchaseHelper
  def current_purchase
    if session[:purchase_id].nil?
      Purchase.create(user_id: current_user.id)
    else
      Purchase.find(session[:purchase_id])
    end
  end
end
