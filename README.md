# xfyun-spark

讯飞星火大模型 web 接口 ruby 封装

[官方文档](https://www.xfyun.cn/doc/spark/Web.html)

## Installation

Install the gem and add to the application's Gemfile by executing:

`bundle add xfyun-spark`

If bundler is not being used to manage dependencies, install the gem by executing:

`gem install xfyun-spark`

## Usage

### Configure

Configure the gem in initializer file

```ruby
Xfyun::Spark.configure do |config|
  config.appid = 'appid'
  config.api_secret = 'api_secret'
  config.api_key = 'api_key'
  # Optional configs
  # config.model = 'V1.5'
  # config.host = 'your host'
  # config.request_timeout = 10
end
```

Create a client

```ruby
client = Xfyun::Spark::Client.new
```

Create a client overriding the default config

```ruby
client = Xfyun::Spark::Client.new({
  appid: 'appid',
  api_secret: 'api_secreti',
  api_key: 'api_key'
  model: 'V2' # use V2 model
})
```

### Chat

Chat with simple payload, using default header and parameter

```ruby
response_body = client.chat(
  payload: {
    message: {
      text: [{"role": "user", "content": "你是谁"}]
    }
  }
)
answer = response_body.dig('payload', 'choices', 'text', 0, 'content')
```

Chat with custom header and parameter

```ruby
response_body = client.chat(
  parameter: {
    header: {
      uid: "12345"
    },
    chat: {
      temperature: 0.5,
      max_tokens: 1024,
    }
  },
  payload: {
    message: {
      text: [{"role": "user", "content": "你是谁"}]
    }
  }
)
answer = response_body.dig('payload', 'choices', 'text', 0, 'content')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/chaucerling/xfyun-spark>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/chaucerling/xfyun-spark/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Xfyun::Spark project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/chaucerling/xfyun-spark/blob/master/CODE_OF_CONDUCT.md).
