# Ruby on Rails #19 Gem Pagy - Ultimate Guide to the best pagination gem

- https://www.youtube.com/watch?v=1tsWL4EjhMo
- FROM A TEMPLATE: https://railsbytes.com/public/templates/x7msdY
- seed database posts with faker
- https://github.com/ddnexus/pagy
- bundle add pagy
- add to application_controller

```
include Pagy::Backend
```

- restart server
- update posts controller

```
  def index
    # @posts = Post.all
    # @posts = Post.order(cached_weighted_score: :desc)
    @pagy, @posts = pagy(Post.order(created_at: :desc), items: 5)
```

- refresh and we see 5 posts
- update posts index to see how many we showing

```
<h1>Posts: <%= @posts.count %> / <%= Post.count %></h1>
```

- add to app helper

```
module ApplicationHelper
include Pagy::Frontend
```

- add to posts/index

```
<p>
  <%== pagy_nav(@pagy) if @pagy.pages > 1 %>
</p>
```

- refresh we should see the pagy working
- we can add the default settings by creating a initializers/pagy.rb file
- https://github.com/ddnexus/pagy/blob/master/lib/config/pagy.rb
- then edit what you need
- restart the server
- he edited the default number of items per page
- so the posts controller would be

```
 @pagy, @posts = pagy(Post.order(created_at: :desc))
```

- ADDING BOOTSTRAP TO THE LINKS
- in the initializer, uncomment: require 'pagy/extras/bootstrap'
- update the posts/index

```
<div class="d-flex justify-content-center">
  <%== pagy_bootstrap_nav(@pagy) %>
</div>
```

- to avoid a page over flow if you go to the nav bar and enter

```
http://localhost:3000/posts?page=10000
```

- in the init/pagy.rb

```
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page    # default  (other options: :last_page and :exception)
```

- restart server
- it works
- LETTING THE USERS DECIDE HOW MANY ITEMS TO DISPLAY IN A PAGE
- update init/pagy.rb

```
require 'pagy/extras/items'
# set to false only if you want to make :items_extra an opt-in variable
# Pagy::DEFAULT[:items_extra] = false    # default true
Pagy::DEFAULT[:items_param] = :items   # default
Pagy::DEFAULT[:max_items]   = 100      # default
```

- restart server
- update posts controller

```
    @pagy, @posts = pagy(Post.order(created_at: :desc))
```

- update posts/index

```
<div>
<%= link_to_unless_current "10", posts_path(items: 10) %>
<%= link_to_unless_current "20", posts_path(items: 20) %>  
</div>
```

- refresh and test
- it worked



