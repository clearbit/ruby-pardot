# frozen_string_literal: true

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pardot::Objects::Prospects do
  before do
    @client = create_client
  end

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

      @client.prospects.query(assigned: true).should == { 'total_results' => 2,
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

      @client.prospects.create('user@test.com', first_name: 'Jim').should == { 'last_name' => 'Smith', 'first_name' => 'Jim' }
      assert_authorization_header
    end
  end

  context 'for API version 4:' do
    before { @client.version = 4 }

    describe 'batch_create' do
      let(:sample_response) do
        <<~RESPONSE
          <?xml version=\"1.0\" encoding=\"UTF-8\"?>
          <rsp stat=\"ok\" version=\"1.0\">
            <errors/>
          </rsp>
        RESPONSE
      end

      it 'calls the proper endpoint' do
        fake_post '/api/prospect/version/4/do/batchCreate?format=simple', sample_response

        @client.prospects.batch_create([{ email: 'user@test.com', first_name: 'Jim' }])

        expect(FakeWeb.last_request.body).to eq('abc123')
      end
    end

    describe 'batch_update' do
      let(:sample_response) do
        <<~RESPONSE
          <?xml version=\"1.0\" encoding=\"UTF-8\"?>
          <rsp stat=\"ok\" version=\"1.0\">
            <errors/>
          </rsp>
        RESPONSE
      end

      it 'calls the proper endpoint' do
        fake_post '/api/prospect/version/4/do/batchUpdate?format=simple', sample_response

        @client.prospects.batch_update('123' => { first_name: 'Jim' })

        expect(FakeWeb.last_request.body).to eq('abc123')
      end
    end

    describe 'batch_upsert' do
      let(:sample_response) do
        <<~RESPONSE
          <?xml version=\"1.0\" encoding=\"UTF-8\"?>
          <rsp stat=\"ok\" version=\"1.0\">
            <errors/>
          </rsp>
        RESPONSE
      end

      it 'calls the proper endpoint' do
        fake_post '/api/prospect/version/4/do/batchUpsert?format=simple', sample_response

        @client.prospects.batch_upsert([{ email: 'user@test.com', first_name: 'Jim' }])

        expect(FakeWeb.last_request.body).to eq('abc123')
      end
    end
  end
end
