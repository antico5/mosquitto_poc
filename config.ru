require 'mosca'

BROKER = "localhost"

def mqtt_client
  @mqtt_client ||= Mosca::Client.new broker: BROKER
end

app = Proc.new do |env|
  request = Rack::Request.new env
  if request.path =~ /publish/ && request.params["payload"] && request.params["topic"]
    mqtt_client.publish request.params["payload"], topic_out: request.params["topic"]
    [200, {}, []]
  else
    [404, {}, []]
  end
end

run app
