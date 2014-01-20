module Modules
  module RemoteRequestHandler
    attr_writer :requests

    def requests
      @requests ||= []
    end

    def handleViewWillDisappear
      killRequests
    end

    def killRequests
      @loaded = false
      @loading = false
      for request in self.requests
        if request && request.connection
          request.connection.cancel
          request.connection = nil
        end
      end
      @tableView.hideLoading if @tableView.respond_to?(:hideLoading)
      hideLoading if self.respond_to?(:hideLoading)

      UIApplication.sharedApplication.networkActivityIndicatorVisible = false
    end
  end
end