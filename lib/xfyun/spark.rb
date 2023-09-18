require_relative "spark/version"
require_relative "spark/request"
require_relative "spark/client"

module Xfyun
  module Spark
    class Error < StandardError; end

    class Configuration
      attr_accessor :appid, :api_key, :api_secret, :api_type, :api_version, :uri_base, :request_timeout

      DEFAULT_API_TYPE = "general".freeze
      DEFAULT_API_VERSION = "v1.1".freeze
      DEFAULT_URI_BASE = "spark-api.xf-yun.com".freeze
      DEFAULT_REQUEST_TIMEOUT = 120

      def initialize
        @appid = nil
        @api_key = nil
        @api_secret = nil
        @api_type = DEFAULT_API_TYPE
        @api_version = DEFAULT_API_VERSION
        @uri_base = DEFAULT_URI_BASE
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
