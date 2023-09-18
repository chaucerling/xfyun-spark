# xfyun-spark

讯飞星火大模型 web 接口 ruby 封装

[官方文档](https://www.xfyun.cn/doc/spark/Web.html)

## Installation

Install the gem and add to the application's Gemfile by executing:

$ bundle add xfyun-spark

If bundler is not being used to manage dependencies, install the gem by executing:

$ gem install xfyun-spark

## Usage

xfyun spark ruby sdk

```ruby
client = Xfyun::Spark::Client.new({
  appid: 'appid',
  api_secret: 'api_secreti',
  api_key: 'api_key'
})

response_body = client.chat([{"role": "user", "content": "你是谁"}])
answer = response_body.dig('payload', 'choices', 'text', 0, 'content')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/chaucerling/xfyun-spark>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/chaucerling/xfyun-spark/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Xfyun::Spark project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/chaucerling/xfyun-spark/blob/master/CODE_OF_CONDUCT.md).
