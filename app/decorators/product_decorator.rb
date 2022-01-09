class ProductDecorator < Draper::Decorator
  delegate_all

  def image
    if object.image.present?
      helpers.image_tag(object.image)
    end
  end

  def archived_by_admin
    if object.archived_at != nil
      'archived'
    end
  end
end
