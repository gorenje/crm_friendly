%w(
  error_proxy
  friendly_extensions
).each { |a| require File.dirname(__FILE__) + "/#{a}.rb" }

class Friendly::HasIndex < Friendly::Error; end
