# Ruby on Rails #46 gem invisible_captcha - pure Ruby reCaptcha alternative.

- https://www.youtube.com/watch?v=4Z4yVSXDRyw
- https://github.com/markets/invisible_captcha
- bundle add invisible_captcha
- add to posts controller

```
class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  invisible_captcha only: [:create, :update]
```

- add to form

```
  <%= invisible_captcha %>
```

- add the error to layout/app

```
<body>
  <%= flash[:error] %>
  <%= yield %>
```

- refresh the posts form and click a quick create post
- we get the error that it was too quick
- ADDING AN INTITIALIZER
- create: config/initializers/invisible_captcha.rb

```
InvisibleCaptcha.setup do |config|
  # config.honeypots           << ['more', 'fake', 'attribute', 'names']
  # config.visual_honeypots    = false
  config.timestamp_threshold = 4
  # config.timestamp_enabled   = true
  # config.injectable_styles   = false
  # config.spinner_enabled     = true

  # Leave these unset if you want to use I18n (see below)
  config.sentence_for_humans     = 'If you are a human, ignore this field :)'
  config.timestamp_error_message = 'Sorry, something went wrong! Please resubmit.'
end
```

- HE DID IT FOR DEVISE, I DIDNT
- https://github.com/corsego/46-invisible_captcha/commit/8f1cfc329df995c5b7d633f260a5d3f414d4c837
