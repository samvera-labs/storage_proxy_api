require 'faraday'
require 'storage_proxy_api/response'


module StorageProxyAPI
  class Client
    attr_reader :base_url

    def initialize(base_url:)
      @base_url = base_url
    end

    def conn
      @conn ||= Faraday.new(url: base_url)
    end

    # Sends an API request and returns the response.
    def send_request(http_method:, action: '/', headers: nil, params: nil, body: nil)
      faraday_response = conn.send(http_method) do |faraday_request|
        faraday_request.url(action)
        faraday_request.params = params if params
        faraday_request.headers = headers if headers
        faraday_request.body = body if body
      end

      StorageProxyAPI::Response.new(
        status: faraday_response.status,
        body: faraday_response.body,
        headers: faraday_response.headers
      )
    end

    def status(service:, external_uri:, include_events: false)
      send_request(http_method: :get, action: 'status', headers: { service: service, include_events: include_events }, params: { external_uri: external_uri} )
    end

    def stage(service:, external_uri:)
      send_request(http_method: :post, action: 'stage', headers: { service: service }, params: { external_uri: external_uri } )
    end
  end
end
