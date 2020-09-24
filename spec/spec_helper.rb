require 'vtiger-ruby'
require 'webmock/rspec'

VTIGER_API_RESPONSE = {
  challenge: {
    "success": true,
    "result": {
        "token": 'test_token',
        "serverTime": 1599816377,
        "expireTime": 1599816677
    }
  },
  login: {
    "success": true,
    "result": {
        "sessionName": 'test_session_id',
        "userId": '19x101',
        "version": '0.22',
        "vtigerVersion": '7.20.9.1'
    }
  }
}

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:each) do
    stub_request(:get, /your_instance.odx.vtiger.com/).
      to_return(status: 200, body: VTIGER_API_RESPONSE[:challenge].to_json)

    stub_request(:post, /your_instance.odx.vtiger.com/).
      to_return(status: 200, body: VTIGER_API_RESPONSE[:login].to_json)
  end
end

WebMock.disable_net_connect!(allow_localhost: true)
