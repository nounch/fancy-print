require 'rspec'
require 'rspec/expectations'
require 'rack/test'


describe 'Info about the application' do
  include Rack::Test::Methods

  def app
    path = '../../../lib/fancy_print/web_app/config.ru'
    Rack::Builder.parse_file(File.expand_path(path, __FILE__)).first
  end

  it 'gets the client info' do
    get '/info/doc/client'
    expect(last_response).to be_ok
  end

  it 'gets the api info' do
    get '/info/doc/api'
    expect(last_response).to be_ok
  end

  it 'gets the cli info' do
    get '/info/doc/cli'
    expect(last_response).to be_ok
  end
end
