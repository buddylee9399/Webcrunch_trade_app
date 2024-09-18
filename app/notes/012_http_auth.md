# Ruby on Rails #85 HTTP Authorization in Production

- https://www.youtube.com/watch?v=N7HZ-4zGNe4
- https://github.com/corsego/85-http-authorization/commit/ed2d8fd390e814f7e910f544f1a948d960219953
- update: app/controllers/posts_controller.rb

```
class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :http_auth, except: %i[index show]

  .....

  private

  def http_auth
    return true if Rails.env == 'development'

    authenticate_or_request_with_http_basic do |username, password|
      username == Rails.application.credentials.dig(:http_auth, :name).to_s &&
        password == Rails.application.credentials.dig(:http_auth, :pass).to_s
    end
  end  
```

- app/views/layouts/application.html.erb

```

  <body>
    <%= request.authorization.present? %>
    <%= yield %>
  </body>
</html>
```

- EDITOR='subl -w' bin/rails credentials:edit

```
http_auth:
  name: 'name'
  pass: 123
```