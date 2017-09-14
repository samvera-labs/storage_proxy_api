require 'storage_proxy_client'
require 'json'

module StorageProxyClient
  class Response
    attr_accessor :faraday_response, :parsed_body

    def initialize(faraday_response: nil)
      @faraday_response = faraday_response
    end

    def staged?
      parsed_body['staged'] == '1'
    end

    def staging?
      # FIXME There is no staging field yet in the api spec.
      parsed_body['staging'] == '1'
    end

    def staged_location
      parsed_body['staged_location']
    end

    private

      def parsed_body
        @parsed_body ||= JSON.parse faraday_response.body
      end
  end
end
