module PurchaseHelper
  def current_purchase
    if !session[:purchase_id].nil?
      Purchase.find(session[:purchase_id])
    else
      Purchase.create(user_id: current_user.id)
    end
  end
end
