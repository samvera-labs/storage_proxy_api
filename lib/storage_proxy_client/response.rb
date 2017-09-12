require 'storage_proxy_client'

module StorageProxyClient
  class Response

    def initialize(faraday_response: nil)
      parse_faraday_response!(faraday_response) if faraday_response
    end

    private

      def parse_faraday_response!(faraday_response)

      end
  end
end
