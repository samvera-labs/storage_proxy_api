require 'spec_helper'
require 'storage_proxy_api/client'

describe StorageProxyAPI::Client do

  subject { described_class.new(base_url: 'http://mock-storage-proxy-host.org:1234') }
  let(:example_service) { "Example Service" }
  let(:example_external_uri) { ['example_filename.dat', 's3://example_bucket/exmple_file.dat'].sample }

  before do
    # Stub base_uri for both GET and POST requests
    stub_request(:get, "#{subject.base_url}")
    stub_request(:post, "#{subject.base_url}")
  end

  describe '#send_request' do
    context 'when :http_method is :get' do
      it 'sends a GET request' do
        expect(subject.conn).to receive(:get).and_call_original
        subject.send_request(http_method: :get)
      end

      context 'when given headers, params, and a body' do
        let(:action) { 'astley' }

        let(:request_headers) { { rickroll: "1" } }
        let(:request_params) { { give_you_up: "let you down" } }
        let(:request_body) { { run_around: "desert you" }.to_json }

        let(:response_headers) { { make_you_cry: "say goodbye" } }
        let(:response_body) { { tell_a_lie: "hurt you" }.to_json }

        before do
          stub_request(:get, "#{subject.base_url}/#{action}").
            with(headers: request_headers, query: request_params, body: request_body).
            to_return(status: 200, headers: response_headers, body: response_body)
        end

        it 'passes them along to the request' do
          expect(subject.conn).to receive(:get).and_call_original
          expect(StorageProxyAPI::Response).to receive(:new).with(status: 200, headers: response_headers, body: response_body)
          subject.send_request(http_method: :get, action: action, headers: request_headers, params: request_params, body: request_body)
        end
      end
    end

    context 'when :http_method is :post' do
      it 'sends a POST request' do
        expect(subject.conn).to receive(:post).and_call_original
        subject.send_request(http_method: :post)
      end
    end
  end


  describe '#status' do
    let(:headers) { { include_events: '1' } }
    let(:external_uri) { 'fake_uri' }
    let(:service) { 'fake_service' }

    before do
      stub_request(:get, "#{subject.base_url}/#{service}/status/#{external_uri}").
        with(headers: headers)
    end

    it 'calls #send_request with http_method: :get, action: "service/status/id", passes :include_events' do
      expect(subject).to receive(:send_request).with(http_method: :get, action: "fake_service/status/fake_uri", headers: headers).and_call_original
      subject.status(service: service, include_events: headers[:include_events], external_uri: external_uri)
    end
  end

  describe '#stage' do
    let(:external_uri) { 'fake_uri' }
    let(:service) { 'fake_service' }

    before do
      stub_request(:post, "#{subject.base_url}/#{service}/stage/#{external_uri}")
    end

    it 'calls #send_request with http_method: :post, action: "service/stage/id"' do
      expect(subject).to receive(:send_request).with(http_method: :post, action: "fake_service/stage/fake_uri").and_call_original
      subject.stage(service: service, external_uri: external_uri)
    end
  end
end
