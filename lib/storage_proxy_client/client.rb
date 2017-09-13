require 'faraday'
require 'storage_proxy_client/response'

module StorageProxyClient
  class Client
    attr_accessor :conn, :config, :external_uri, :service

    def initialize(external_uri:, service:)
      @external_uri = external_uri
      @service = service
      @conn = Faraday.new
      @config = {
        api_root: 'http://localhost:9091'
      }
    end

    def status
      response = conn.get(build_request_uri(:status), nil, build_request_headers)
      StorageProxyClient::Response.new(faraday_response: response)
    end

    def stage
      response = conn.post(build_request_uri(:stage), nil, build_request_headers)
      StorageProxyClient::Response.new(faraday_response: response)
    end


    private

      def build_request_headers(include_events: nil)
        {}.tap do |headers|
          headers[:service] = service
          headers[:events] = '1' if include_events
        end
      end

      def build_request_uri(endpoint)
        escaped_external_uri = CGI.escape external_uri
        case endpoint
        when :stage
          "#{config[:api_root]}/stage?external_uri=#{escaped_external_uri}"
        when :status
          "#{config[:api_root]}/status?external_uri=#{escaped_external_uri}"
        end
      end
  end
end