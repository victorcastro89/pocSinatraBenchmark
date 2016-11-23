

require 'rack'
require 'sinatra'

require 'sequel'


# Configure Sequel ORM (Sequel::DATABASES)
DB = Sequel.postgres(   :host => "localhost", :database => 'geo',:user => 'postgres',
    :password => '1q2w3e',

  :max_connections => (ENV['MAX_THREADS'] || 4).to_i,
  :pool_timeout => 5
)
# Allow #to_json on models and datasets
Sequel::Model.plugin :json_serializer


class World < Sequel::Model(:World); end






class App < Sinatra::Base
  configure do
    # Static file serving is ostensibly disabled in modular mode but Sinatra
    # still calls an expensive Proc on every request...
    disable :static

    # XSS, CSRF, IP spoofing, etc. protection are not explicitly required
    disable :protection

    # Only add ;charset= to specific content types per the benchmark requirements
    set :add_charset, %w[text/html]
end

get '/lojas' do

return {"res":DB["SELECT id as loja,ST_Distance(geography(location),ST_GeographyFromText('POINT(-23.556693 -46.645589)')) as distance
FROM lojas
ORDER BY
lojas.location <-> 'SRID=4326;POINT(-23.556693 -46.645589)'::geometry
LIMIT 30;"].all}.to_json


end

end
