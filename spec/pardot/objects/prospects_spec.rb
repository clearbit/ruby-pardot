# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pardot::Objects::Prospects do
  let(:client) { create_client }

  describe 'query' do
    def sample_results
      %(<?xml version="1.0" encoding="UTF-8"?>
      <rsp stat="ok" version="1.0">
        <result>
          <total_results>2</total_results>
          <prospect>
            <first_name>Jim</first_name>
            <last_name>Smith</last_name>
          </prospect>
          <prospect>
            <first_name>Sue</first_name>
            <last_name>Green</last_name>
          </prospect>
        </result>
      </rsp>)
    end

    it 'should take in some arguments' do
      fake_get '/api/prospect/version/3/do/query?assigned=true&format=simple', sample_results

      client.prospects.query(assigned: true).should == { 'total_results' => 2,
                                                         'prospect' => [
                                                           { 'last_name' => 'Smith', 'first_name' => 'Jim' },
                                                           { 'last_name' => 'Green', 'first_name' => 'Sue' }
                                                         ] }
      assert_authorization_header
    end
  end

  describe 'create' do
    def sample_results
      %(<?xml version="1.0" encoding="UTF-8"?>
      <rsp stat="ok" version="1.0">
        <prospect>
          <first_name>Jim</first_name>
          <last_name>Smith</last_name>
        </prospect>
      </rsp>)
    end

    it 'should return the prospect' do
      fake_post '/api/prospect/version/3/do/create/email/user%40test.com?first_name=Jim&format=simple', sample_results

      client.prospects.create('user@test.com', first_name: 'Jim').should == { 'last_name' => 'Smith', 'first_name' => 'Jim' }
      assert_authorization_header
    end
  end

  context 'for API version 4:' do
    let(:sample_response) do
      <<~'RESPONSE'
        <?xml version="1.0" encoding="UTF-8"?>
        <rsp stat="ok" version="1.0">
          <errors/>
        </rsp>
      RESPONSE
    end

    before do
      client.version = 4
    end

    describe '#batch_create' do
      it 'calls the proper endpoint' do
        fake_post '/api/prospect/version/4/do/batchCreate?format=simple', sample_response

        client.prospects.batch_create([{ email: 'user@test.com', first_name: 'Jim' }])

        expected_result = URI.encode_www_form(
          prospects: {
            prospects: [{ email: 'user@test.com', first_name: 'Jim' }]
          }.to_json
        )
        expect(FakeWeb.last_request.body).to eq(expected_result)
      end
    end

    describe '#batch_update' do
      it 'calls the proper endpoint' do
        fake_post '/api/prospect/version/4/do/batchUpdate?format=simple', sample_response

        client.prospects.batch_update([{ id: '123', first_name: 'Jim' }])

        expected_result = URI.encode_www_form(
          prospects: {
            prospects: [{ id: '123', first_name: 'Jim' }]
          }.to_json
        )
        expect(FakeWeb.last_request.body).to eq(expected_result)
      end
    end

    describe '#batch_upsert' do
      it 'calls the proper endpoint' do
        fake_post '/api/prospect/version/4/do/batchUpsert?format=simple', sample_response

        client.prospects.batch_upsert([{ email: 'user@test.com', first_name: 'Jim' }])

        expected_result = URI.encode_www_form(
          prospects: {
            prospects: [{ email: 'user@test.com', first_name: 'Jim' }]
          }.to_json
        )
        expect(FakeWeb.last_request.body).to eq(expected_result)
      end
    end

    context 'when the API returns an error' do
      let(:error_response) do
        <<~'RESPONSE'
          <?xml version="1.0" encoding="UTF-8"?>
          <rsp stat="fail" version="1.0">
            <errors>
              <prospect identifier="0">Invalid prospect email address</prospect>
            </errors>
          </rsp>
        RESPONSE
      end

      it 'raises an error' do
        fake_post '/api/prospect/version/4/do/batchCreate?format=simple', error_response

        expect do
          client.prospects.batch_create([{ first_name: 'Jim' }])
        end.to raise_error(Pardot::ResponseError, /Invalid prospect email address/)
      end
    end
  end
end
