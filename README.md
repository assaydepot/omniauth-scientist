# OmniAuth Scientist

## Basic Usage

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :scientist, ENV['SCIENTIST_ID'], ENV['SCIENTIST_SECRET']
end
```

## Enterprise Usage

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :scientist, ENV['SCIENTIST_ID'], ENV['SCIENTIST_SECRET'],
    {
      client_options: {
        site: 'https://<YOURSUBDOMAIN>.scientist.com',
        authorize_url: 'https://<YOURSUBDOMAIN>.scientist.com/oauth/authorize',
        token_url: 'https://<YOURSUBDOMAIN>.scientist.com/oauth/token'
      }
    }
end
```

## Credits

Heavily inspired by: [omniauth-github](https://github.com/omniauth/omniauth-github)

## License

Copyright (c) 2024 Assay Depot Inc. d/b/a Scientist.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
