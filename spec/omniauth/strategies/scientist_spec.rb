require 'spec_helper'

describe OmniAuth::Strategies::Scientist do
  let(:access_token) { instance_double('AccessToken', :options => {}) }
  let(:parsed_response) { instance_double('ParsedResponse') }
  let(:response) { instance_double('Response', :parsed => parsed_response) }

  let(:enterprise_site)          { 'https://some.other.site.com/' }
  let(:enterprise_authorize_url) { 'https://some.other.site.com/oauth/authorize' }
  let(:enterprise_token_url)     { 'https://some.other.site.com/oauth/token' }
  let(:enterprise) do
    OmniAuth::Strategies::Scientist.new('SCIENTIST_ID', 'SCIENTIST_SECRET',
      {
        :client_options => {
          :site => enterprise_site,
          :authorize_url => enterprise_authorize_url,
          :token_url => enterprise_token_url
        }
      }
    )
  end

  subject do
    OmniAuth::Strategies::Scientist.new({})
  end

  before(:each) do
    allow(subject).to receive(:access_token).and_return(access_token)
  end

  context 'client options' do
    it 'should have correct site' do
      expect(subject.options.client_options.site).to eq('https://app.scientist.com')
    end

    it 'should have correct authorize url' do
      expect(subject.options.client_options.authorize_url).to eq('https://app.scientist.com/oauth/authorize')
    end

    it 'should have correct token url' do
      expect(subject.options.client_options.token_url).to eq('https://app.scientist.com/oauth/token')
    end

    describe 'should be overrideable' do
      it 'for site' do
        expect(enterprise.options.client_options.site).to eq(enterprise_site)
      end

      it 'for authorize url' do
        expect(enterprise.options.client_options.authorize_url).to eq(enterprise_authorize_url)
      end

      it 'for token url' do
        expect(enterprise.options.client_options.token_url).to eq(enterprise_token_url)
      end
    end
  end

  context '#email' do
    it 'should return email from raw_info if available' do
      allow(subject).to receive(:raw_info).and_return({ 'email' => 'you@example.com' })
      expect(subject.email).to eq('you@example.com')
    end

    it 'should return nil if there is no raw_info and email access is not allowed' do
      allow(subject).to receive(:raw_info).and_return({})
      expect(subject.email).to be_nil
    end

    it 'should not return the primary email if there is no raw_info and email access is allowed' do
      emails = [
        { 'email' => 'secondary@example.com', 'primary' => false },
        { 'email' => 'primary@example.com',   'primary' => true }
      ]
      allow(subject).to receive(:raw_info).and_return({})
      subject.options['scope'] = 'user'
      allow(subject).to receive(:emails).and_return(emails)
      expect(subject.email).to be_nil
    end

    it 'should not return the first email if there is no raw_info and email access is allowed' do
      emails = [
        { 'email' => 'first@example.com',   'primary' => false },
        { 'email' => 'second@example.com',  'primary' => false }
      ]
      allow(subject).to receive(:raw_info).and_return({})
      subject.options['scope'] = 'user'
      allow(subject).to receive(:emails).and_return(emails)
      expect(subject.email).to be_nil
    end
  end

  context '#raw_info' do
    it 'should use relative paths' do
      expect(access_token).to receive(:get).with('user').and_return(response)
      expect(subject.raw_info).to eq(parsed_response)
    end
  end

  context '#info.email' do
    it 'should use any available email' do
      allow(subject).to receive(:raw_info).and_return({})
      allow(subject).to receive(:email).and_return('you@example.com')
      expect(subject.info['email']).to eq('you@example.com')
    end
  end

  describe '#callback_url' do
    it 'is a combination of host, script name, and callback path' do
      allow(subject).to receive(:full_host).and_return('https://example.com')
      allow(subject).to receive(:script_name).and_return('/sub_uri')

      expect(subject.callback_url).to eq('https://example.com/sub_uri/auth/scientist/callback')
    end
  end
end
