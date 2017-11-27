require 'spec_helper'

describe StorageProxyAPI::Response do
  let(:mock_external_uri) { 'http://some_service.org' }
  let(:mock_vendor_service) { 'fake vendor' }
  let(:mock_response_status) { 200 }

  subject { described_class.new(status: mock_response_status, body: mock_response_body.to_json) }

  describe 'up?' do
    let(:mock_response_body) { {} }
    context 'when the response is status 200' do
      it 'returns true' do
        expect(subject).to be_up
      end
    end

    context 'when the response is not status 200' do
      let(:mock_response_status) { 503 }
      it 'returns false' do
        expect(subject).to_not be_up
      end
    end
  end

  describe 'staged?' do
    context 'when the response reports that the file is staged' do
      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service,
          stage: {
              result: 'somehost:80/12345',
              status: 'staged'
          }
        }
      end

      it 'returns true' do
        expect(subject).to be_staged
      end
    end

    context 'when the response reports that the file is not staged' do
      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service,
        }
      end

      it 'returns false' do
        expect(subject).to_not be_staged
      end
    end
  end

  describe 'staging?' do
    context 'when the response reports that the file is staging' do
      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service,
          stage: {
              result: 'somehost:80/12345',
              status: 'staging'
          }
        }
      end

      it 'returns true' do
        expect(subject).to be_staging
      end
    end

    context 'when the response reports that the file is not staging' do
      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service,
        }
      end

      it 'returns false' do
        expect(subject).to_not be_staging
      end
    end
  end

  describe 'staged_location' do
    context 'when the response reports that the file is staged' do
      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service,
          stage: {
              result: 'somehost:80/12345',
              status: 'staged'
          }
        }
      end

      it 'returns the staged location of the file' do
        expect(subject.staged_location).to eq 'somehost:80/12345'
      end
    end

    context 'when the response reports that the file is not staged' do
      let(:mock_response_body) do
        {
          external_uri: mock_external_uri,
          service: mock_vendor_service
        }
      end

      it 'returns nil' do
        expect(subject.staged_location).to eq nil
      end
    end
  end
end
