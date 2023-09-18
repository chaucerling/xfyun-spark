module Xfyun
  module Spark
    class Client
      include Xfyun::Spark::Request

      CONFIG_KEYS = %i[appid api_key api_secret model host request_timeout].freeze
      attr_reader *CONFIG_KEYS, :request_version, :request_domain

      def initialize(config = {})
        CONFIG_KEYS.each do |key|
          instance_variable_set("@#{key}", config[key] || Xfyun::Spark.configuration.send(key))
        end

        @request_version = {
          "V1.5" => "v1.1",
          "V2" => "v2.1",
        }.fetch(@model)

        @request_domain = {
          "V1.5" => "general",
          "V2" => "generalv2",
        }.fetch(@model)
      end

      def chat(header: {}, parameter: {}, payload: {})
        header = default_header.merge(header)
        parameter = default_parameter.map do |k, v|
          [k, v.merge(parameter.fetch(k))]
        end.to_h
        request(path: "/chat", parameters: {
          header: header,
          parameter: parameter,
          payload: payload
        })
      end

      def default_header
        {app_id: @appid}
      end

      def default_parameter
        {
          chat: {
            domain: @request_domain,
          }
        }
      end

    end
  end
end
