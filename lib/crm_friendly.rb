%w(
error_proxy.rb
friendly_extensions.rb
).each { |libname| require libname }

class Friendly::HasIndex < Friendly::Error; end
