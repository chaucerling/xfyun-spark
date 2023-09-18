module Xfyun
  module Spark
    class Client
      include Xfyun::Spark::Request

      CONFIG_KEYS = %i[appid api_key api_secret api_type api_version uri_base request_timeout].freeze
      attr_reader *CONFIG_KEYS

      def initialize(config = {})
        CONFIG_KEYS.each do |key|
          instance_variable_set("@#{key}", config[key] || Xfyun::Spark.configuration.send(key))
        end
      end

      def chat(question)
        request(path: "/chat", parameters: gen_params(question))
      end

    end
  end
end
