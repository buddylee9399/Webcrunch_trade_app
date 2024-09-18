# Drifting ruby - Impressionist

- https://www.driftingruby.com/episodes/impressionist
- https://github.com/charlotte-ruby/impressionist
- https://github.com/driftingruby/002-Impressionist
- bundle add impressionist
- rails g impressionist
- rake db:migrate

```
class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: %i[ show edit update destroy vote]
  invisible_captcha only: [:create, :update]
  # impressionist :actions=>[:show,:index]  if not using friendly id


# since we are using friendly id, we have to do it here
  def show
    impressionist(@post, "message...") # 2nd argument is optional    
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "posts/pdf", formats: [:html]
      end
    end    
  end  
```

- update post.rb

```
class Post < ApplicationRecord
  include GenerateCsv  
  extend FriendlyId
  is_impressionable  
```

- in post partial

```
<p><%= "#{@post.impressionist_count} impressionist count" %></p>
```

- or in post index

```
.....
      <th scope="col">Views</th>
.....      
        <td><%= post.impressionist_count %></td>     
.....        
```

-------------------

```

Impressionist

From github

gem 'impressionist'
Bundle
rails g impressionist
Rails db:migrate
```

* Add to model

```
class Shot < ApplicationRecord

  is_impressionable

end

```

* Add to controller

```
class ShotsController < ApplicationController
  before_action :set_shot, only: [:show, :edit, :update, :destroy, :like, :unlike]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :like, :unlike]
  impressionist actions: [:show], unique: [:impressionable_type, :impressionable_id, :session_hash]
```

* In the view

```
<%= pluralize(@shot.impressionist_count, 'View') %>
```
