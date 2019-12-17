require 'sinatra/base'
require_relative '../generator'

module App
  class Base < Sinatra::Base

    if ENV['HTTP_AUTH_USER'] && ENV['HTTP_AUTH_PASS']
      use Rack::Auth::Basic, "Protected Area" do |username, password|
        username == ENV['HTTP_AUTH_USER'] && password == ENV['HTTP_AUTH_PASS']
      end
    end

    get '/testfiles' do
      @files = TEMPLATES

      erb :testfiles
    end

    get '/testfiles/:file' do
      zip_path = Generator::Base.generate(params[:file])
      filename = File.basename(zip_path)
      send_file zip_path, :filename => filename, :type => 'Application/octet-stream'
    end
  end
end
