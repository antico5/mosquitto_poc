require 'mosca'
require 'rack/cors'

BROKER = "localhost"

def mqtt_client
  @mqtt_client ||= Mosca::Client.new broker: BROKER
end

use Rack::Cors do
  allow do
    origins '*'
    resource '/publish'
  end
end

app = Proc.new do |env|
  request = Rack::Request.new env
  if request.path =~ /publish/ && request.params["payload"] && request.params["topic"] && request.request_method == "POST"
    mqtt_client.publish request.params["payload"], topic_out: request.params["topic"]
    [200, {}, []]
  else
    [404, {}, []]
  end
end

run app
