require 'sinatra'

set :root,  File.dirname(__FILE__)
set :views, Proc.new { File.join(root, 'app', 'views') }

URI_REGEX = /\A(https|http):\/\/[\w\-]+(\.[a-zA-Z]{2,})(:[0-9]+)?(\/[^\/]*(\.[a-zA-Z]{2,})?)?\z/

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
  url_regex = /\A(http|https):\/\/[^\s$.?#].[^\s]*\z/i
  !!(url =~ url_regex)
end
