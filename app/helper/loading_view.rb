class LoadingView
  attr_accessor :hud

  class << self
    def instance
      Dispatch.once { @instance ||= new }
      @instance
    end

    def show(loading_text = "Loading")
      hud = MBProgressHUD.showHUDAddedTo(instance.window, animated:true)
      hud.labelText = loading_text
    end

    def hide
      MBProgressHUD.hideHUDForView(instance.window, animated:true)
    end
  end

  def window
    @window ||= UIApplication.sharedApplication.delegate.window
  end
end