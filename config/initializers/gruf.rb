require "gruf"

Gruf.configure do |c|
  c.server_binding_url = 'localhost:9080'

  Dir.glob(Rails.root.join("app/proto/*_pb.rb")).each do |file|
    require file
  end
end
