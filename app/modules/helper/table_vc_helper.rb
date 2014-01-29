module Helper
  module TableVCHelper
    def set_remote_image(model, image_url, image_view)
      key = model.class.name.underscore.pluralize.to_sym
      if @cached_images[key][model.id].present?
        image_view.image = @cached_images[key][model.id]
      else
        image_view.load_async_image image_url do |image|
          @cached_images[key][model.id] = image
          image_view.image = image
        end
      end
    end
  end
end