require 'faraday'
require 'storage_proxy_client/response'

module StorageProxyClient
  class Client
    attr_accessor :conn, :config

    def initialize
      @conn = Faraday.new
      @config = {
        url: 'http://localhost'
      }
    end

    def status(external_uri)
      response = conn.get do |req|
        req.headers.merge! default_headers
        req.url "#{config[:url]}/status/#{URI.escape(external_uri)}"
      end

      StorageProxyClient::Response.new(faraday_response: response)
    end


    private

      def default_headers
        {}
      end
  end
end