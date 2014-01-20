class RPImageView < UIImageView
  def load_async_image(url, placeholderImageName = nil, &block)
    that = self

    cachedData = FTWCache.objectForKey(url.MD5Hash)
    if cachedData
      cImage = UIImage.imageWithData(cachedData)
      if block
        block.call(cImage) if block.respond_to?(:call)
      else
        that.image = cImage
      end
    else
      placeholderImage = nil
      placeholderImage = UIImage.imageNamed(placeholderImageName) if placeholderImageName
      that.image = placeholderImage ? placeholderImage : nil

      request = BW::HTTP.get(url) do |response|
        firstAvailableUIViewController.requests.delete(request) if firstAvailableUIViewController && firstAvailableUIViewController.respond_to?(:requests)

        if response.ok?
          FTWCache.setObject(response.body, forKey:url.MD5Hash)
          rImage = UIImage.imageWithData(response.body)
          if block
            block.call(rImage) if block.respond_to?(:call)
          else
            that.image = rImage
          end
        end
      end
      firstAvailableUIViewController.requests.push(request) if firstAvailableUIViewController && firstAvailableUIViewController.respond_to?(:requests)
    end
  end
end