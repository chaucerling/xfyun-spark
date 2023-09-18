require_relative "spark/version"
require_relative "spark/request"
require_relative "spark/client"

module Xfyun
  module Spark
    class Error < StandardError; end

    class Configuration
      attr_accessor :appid, :api_key, :api_secret, :model, :host, :request_timeout

      DEFAULT_MODEL = "V1.5".freeze
      DEFAULT_HOST = "spark-api.xf-yun.com".freeze
      DEFAULT_REQUEST_TIMEOUT = 120

      def initialize
        @appid = nil
        @api_key = nil
        @api_secret = nil
        @model = DEFAULT_MODEL
        @host = DEFAULT_HOST
        @request_timeout = DEFAULT_REQUEST_TIMEOUT
      end
    end

    class << self
      attr_writer :configuration
    end

    def self.configuration
      @configuration ||= Xfyun::Spark::Configuration.new
    end

    def self.configure
      yield(configuration)
    end
  end
end
