require 'storage_proxy_client'

module StorageProxyClient
  class Response
    attr_accessor :faraday_response, :parsed_body

    def initialize(faraday_response: nil)
      @faraday_response = faraday_response
    end

    def staged?
      parsed_body['staged'] == '1'
    end

    private

      def parsed_body
        @parsed_body ||= JSON.parse faraday_response.body
      end
  end
end