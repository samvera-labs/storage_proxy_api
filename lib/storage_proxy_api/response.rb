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
      body.dig('stage', 'status') == 'staged'
    end

    def staging?
      # FIXME There is no staging field yet in the api spec.
      body.dig('stage', 'status') == 'staging'
    end

    def staged_location
      body.dig('stage', 'result')
    end
  end
end
