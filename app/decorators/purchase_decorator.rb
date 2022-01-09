class PurchaseDecorator < ApplicationDecorator
  delegate_all

  def user_email
    User.find_by(id: purchase.user_id).email
  end
end
