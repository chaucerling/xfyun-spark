require 'faye/websocket'
require 'eventmachine'
require 'time'
require 'openssl'
require 'uri'
require 'json'

module Xfyun
  module Spark
    module Request

      def gen_params(question)
        data = {
          "header": {
              "app_id": @appid,
              "uid": "1234"
          },
          "parameter": {
              "chat": {
                  "domain": @api_type,
              }
          },
          "payload": {
              "message": {
                  "text": question
              }
          }
        }
      end

      def request(path:, parameters:)
        content = ""
        data = nil
        EM.run {
          url = authorization_url(path)
          puts url
          puts parameters
          ws = Faye::WebSocket::Client.new(url)

          ws.on(:open) do |event|
            p [:open, ws.headers]
            ws.send(parameters.to_json)
          end

          ws.on(:close) do |event|
            p [:close, event.code, event.reason]
            EM.stop
          end

          ws.on(:error) do |event|
            p [:error, event.message]
          end

          ws.on(:message) do |event|
            p [:message, event.data]
            response_data = JSON.parse(event.data)
            status = response_data.dig('header', 'status')
            case status
            when 0, 1
              content << response_data.dig('payload', 'choices', 'text', 0, 'content')
            when 2
              # last message
              response_data['payload']['choices']['text'][0]['content'] = content
              data = response_data
            end
          end
        }
        return data
      end

      private
        def authorization_url(path)
          httpdate = Time.now.httpdate

          tmp_str = "host: #{@uri_base}\n"
          tmp_str << "date: #{httpdate}\n"
          tmp_str << "GET /#{api_version}#{path} HTTP/1.1"

          tmp_sha = OpenSSL::HMAC.digest('sha256', @api_secret, tmp_str)
          signature = Base64.strict_encode64(tmp_sha)

          authorization_origin = "api_key=\"#{@api_key}\", algorithm=\"hmac-sha256\", headers=\"host date request-line\", signature=\"#{signature}\""
          authorization = Base64.strict_encode64(authorization_origin.encode('utf-8'))

          query = URI.encode_www_form({
            authorization: authorization,
            date: httpdate,
            host: @uri_base,
          })

          url = "wss://#{@uri_base}/#{@api_version}#{path}?#{query}"
        end

    end
  end
end
