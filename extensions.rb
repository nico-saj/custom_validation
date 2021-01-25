Dir['lib/errors/*.rb'].each { |file| require_relative file }
Dir['lib/*.rb'].each { |file| require_relative file }
Dir['entities/*.rb'].each { |file| require_relative file }
