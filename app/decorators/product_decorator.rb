class ProductDecorator < Draper::Decorator
  delegate_all

  def image
    helpers.image_tag(object.image) if object.image.present?
  end

  def archived_by_admin
    'archived' unless object.archived_at.nil?
  end
end
