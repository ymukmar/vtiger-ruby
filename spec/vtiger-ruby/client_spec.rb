require 'spec_helper'

describe VtigerRuby::Client do
  let(:endpoint) { 'https://your_instance.odx.vtiger.com/webservice.php?' }
  let(:username) { 'test@example.com' }
  let(:accesskey) { 'testAccessKey' }
  let(:client) { described_class.new(endpoint: endpoint, username: username, accesskey: accesskey) }

  describe 'get_challenge' do
    it 'sets @token' do
      expected = VTIGER_API_RESPONSE[:challenge][:result][:token]

      client.get_challenge

      expect(client.instance_variable_get(:@token)).to eq(expected)
    end
  end

  describe 'login' do
    it 'sets @session_id and @md5_token' do
      token = VTIGER_API_RESPONSE[:challenge][:result][:token]
      expected = VTIGER_API_RESPONSE[:login][:result][:sessionName]
      md5_token = Digest::MD5.hexdigest(token + accesskey)

      client.instance_variable_set(:@token, token)
      client.login

      expect(client.instance_variable_get(:@session_id)).to eq(expected)
      expect(client.instance_variable_get(:@md5_token)).to eq(md5_token)
    end
  end

  describe 'connect' do
    it 'sets @token, @md5_token and @session_id' do
      token = VTIGER_API_RESPONSE[:challenge][:result][:token]
      session_id = VTIGER_API_RESPONSE[:login][:result][:sessionName]
      md5_token = Digest::MD5.hexdigest(token + accesskey)

      client.connect

      expect(client.instance_variable_get(:@session_id)).to eq(session_id)
      expect(client.instance_variable_get(:@token)).to eq(token)
      expect(client.instance_variable_get(:@md5_token)).to eq(md5_token)
    end
  end

  describe 'logout' do
    it 'unsets @token' do
      token = VTIGER_API_RESPONSE[:challenge][:result][:token]

      client.connect

      expect { client.logout }
        .to change { client.instance_variable_get(:@token) }
          .from(token)
            .to(nil)
    end

    it 'unsets @session_id' do
      session_id = VTIGER_API_RESPONSE[:login][:result][:sessionName]

      client.connect

      expect { client.logout }
        .to change { client.instance_variable_get(:@session_id) }
          .from(session_id)
            .to(nil)
    end

    it 'unsets @md5_token' do
      token = VTIGER_API_RESPONSE[:challenge][:result][:token]
      md5_token = Digest::MD5.hexdigest(token + accesskey)

      client.connect

      expect { client.logout }
        .to change { client.instance_variable_get(:@md5_token) }
          .from(md5_token)
            .to(nil)
    end
  end

  describe 'account' do
    it 'sets the client as a class object and returns the account class' do
      client.connect

      expect(client.account.class_variable_get(:@@client)).to eq(client)
      expect(client.account.class_variable_get(:@@client)).to be_a(VtigerRuby::Client)
      expect(client.account).to eq(VtigerRuby::Account)
    end
  end
end
