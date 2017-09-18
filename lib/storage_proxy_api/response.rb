require 'storage_proxy_api'
require 'json'

module StorageProxyAPI
  class Response
    attr_accessor :status, :body, :headers

    def initialize(status: nil, body: nil, headers: nil)
      @status = status
      @headers = headers
      # Assume the body is JSON.
      @body = JSON.parse body unless body.empty?
    end

    def staged?
      body['staged'] == '1'
    end

    def staging?
      # FIXME There is no staging field yet in the api spec.
      parsed_body['staging'] == '1'
    end

    def staged_location
      body['staged_location']
    end
  end
end
