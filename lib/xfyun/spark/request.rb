require 'faye/websocket'
require 'eventmachine'
require 'time'
require 'openssl'
require 'uri'
require 'json'

module Xfyun
  module Spark
    module Request

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
            code = response_data.dig('header', 'code')
            if code == 0
              status = response_data.dig('header', 'status')
              case status
              when 0, 1
                content << response_data.dig('payload', 'choices', 'text', 0, 'content')
              when 2
                # last message
                response_data['payload']['choices']['text'][0]['content'] = content
                data = response_data
              end
            else
              data = response_data
            end
          end
        }
        return data
      end

      private
        def authorization_url(path)
          httpdate = Time.now.httpdate

          tmp_str = "host: #{@host}\n"
          tmp_str << "date: #{httpdate}\n"
          tmp_str << "GET /#{@request_version}#{path} HTTP/1.1"

          tmp_sha = OpenSSL::HMAC.digest('sha256', @api_secret, tmp_str)
          signature = Base64.strict_encode64(tmp_sha)

          authorization_origin = "api_key=\"#{@api_key}\", algorithm=\"hmac-sha256\", headers=\"host date request-line\", signature=\"#{signature}\""
          authorization = Base64.strict_encode64(authorization_origin.encode('utf-8'))

          query = URI.encode_www_form({
            authorization: authorization,
            date: httpdate,
            host: @host,
          })

          url = "wss://#{@host}/#{@request_version}#{path}?#{query}"
        end

    end
  end
end
