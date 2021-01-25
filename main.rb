require_relative 'extensions.rb'

user = User.new

user.first_name = 'bob'
user.last_name = ''
user.age = '23'

p user.valid?
user.validate!
