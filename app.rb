require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'openssl'
require 'base64'

class App < Sinatra::Base
  log = Logger.new(STDOUT)

  configure :development do
    register Sinatra::Reloader
  end

  configure do
    if ENV['CANVAS_ORIGIN'].to_s.empty?
      set :protection, except: :frame_options
    else
      set :protection, frame_options: "ALLOW-FROM #{ENV['CANVAS_ORIGIN']}"
    end
  end

  post '/' do
    sign, data = params['signed_request'].split('.', 2)
    digest = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), ENV['CANVAS_CLIENT_SECRET'], data)).strip
    return 403 unless digest == sign

    @data = Base64.decode64(data)
    slim :index
  end
end
