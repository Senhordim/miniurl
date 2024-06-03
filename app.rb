%w(sinatra sequel alphadecimal).each { |gem| require gem }

set :root,  File.dirname(__FILE__)
set :views, Proc.new { File.join(root, 'app', 'views') }

URI_REGEX = /\A(http|https):\/\/[^\s$.?#].[^\s]*\z/i

DB = Sequel.connect('sqlite://miniurl.db')

DB.create_table? :urls do
  primary_key :id
  String :url
end

class Url < Sequel::Model
  def shorten
    self.id.alphadecimal
  end

  def self.find_shorten(shorten)
    find(id: shorten.alphadecimal)
  end
end

get '/' do
  erb :index
end

post '/shorten' do
  url = params['url']
  if url_valida?(url)
    puts "Valida #{url}"
    @shortened = Url.find_or_create(url: url).shorten
    erb :shortened
  else
    puts "Error #{url}"
    @error_message = 'URL inválida'
    erb :error
  end
end

get '/:id' do
  @id = params['id']
  @url = Url.find_shorten(@id)
  if @id
    redirect @url.url
  else
    @error_message = 'URL não encontrada'
    erb :error
  end

end

def url_valida?(url)
  url_regex = URI_REGEX
  !!(url =~ url_regex)
end
