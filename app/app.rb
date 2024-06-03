require 'sinatra'
require 'sequel'

set :root,  File.dirname(__FILE__)
set :views, Proc.new { File.join(root, 'app', 'views') }

URI_REGEX = /\A(http|https):\/\/[^\s$.?#].[^\s]*\z/i

DB = Sequel.connect('sqlite://miniurl.db')

DB.create_table? :urls do
  primary_key :id
  String :url
end

get '/' do
  erb :index
end

post '/shorten' do
  url = params['url']
  if url_valida?(url)
    puts "Valida #{url}"
    @shortened = 'Valid'
    erb :shortened
  else
    puts "Error #{url}"
    @error_message = 'URL inválida'
    erb :error
  end
end

def url_valida?(url)
  url_regex = URI_REGEX
  !!(url =~ url_regex)
end
