# Ruby on Rails #84 Cookies Consent Banner

- https://www.youtube.com/watch?v=Udkil4287pM
- rails g controller cookies index

```
class CookiesController < ApplicationController
  def index
  end
end
```

- update routes

```
get 'cookies', to: 'cookies#index'
```

- update cookies/index

```
<%= turbo_frame_tag :cookies_modal do %>
  <section class="cookies-modal">
    <h1>Cookies policy</h1>
    <p>We use cookies to provide a better browsing experience</p>
    <%= link_to "✅ Accept", cookies_path(cookies_accepted: true) %>
    <%= link_to "⛔ Reject", cookies_path(cookies_accepted: false) %>
  </section>
<% end %>
```

- update layouts/application

```
      <%= turbo_frame_tag :cookies_modal, src: cookies_path %>       
    </div>
    <%= render 'shared/footer' %>   
  </body>
```

- update app.css

```
.cookies-modal {
  position: absolute;
  padding: 0.5rem;
  z-index: 2;
  right: 0.5rem;
  bottom: 0.5rem;
  min-width: 50%;
  max-width: 24rem;
  word-break: break-word;
  border-radius: 0.5rem;
  background: #bad5ff;
}

<!-- a:link {
  text-decoration: none;
}

a {
  text-decoration: none;
} -->
```

- refresh the home page and we should see the turbo frame tag
- update cookies controller

```
class CookiesController < ApplicationController
  def index
    session[:cookies_accepted] = params[:cookies_accepted] if params[:cookies_accepted]
  end
end
```

- update layouts/app

```
    <div class="container">
      <%= Time.zone.now %> <br>
      <%= flash[:error] %>
      <%= session[:cookies_accepted] %>
```

- refresh the home page and click a cookie, we should see 'true' or 'false'
- update cookies partial with the condidtion

```
<%= turbo_frame_tag :cookies_modal do %>
  <% if session[:cookies_accepted].nil? %>
    <section class="cookies-modal">
      <h1>Cookies policy</h1>
      <p>We use cookies to provide a better browsing experience</p>
      <%= link_to "✅ Accept", cookies_path(cookies_accepted: true) %>
      <%= link_to "⛔ Reject", cookies_path(cookies_accepted: false) %>
    </section>
  <% end %>
<% end %>
```

- update layouts/app

```
      <%#= turbo_frame_tag :cookies_modal, src: cookies_path %>     
      <%= turbo_frame_tag :cookies_modal, src: cookies_path if session[:cookies_accepted].nil? %>  
    </div>
```

- update statics pages controller

```
class StaticPagesController < ApplicationController
  def index
    session[:cookies_accepted] = nil
  end
```

- refresh and test
- it worked
