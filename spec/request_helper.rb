require "rails_helper"
require "shared_context/request"
require "shared_examples/request"

RSpec.configure do |config|
  config.include_context "request"
end
