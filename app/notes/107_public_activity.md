# Ruby on Rails #53 Gem Public Activity - add an Activity Feed to your app

- https://www.youtube.com/watch?v=oxdgYIHtlFc
- https://github.com/public-activity/public_activity
- https://github.com/corsego/53-gem-public-activity/commit/e598b93ae8942479c62a092c01299493ae2cc3da
- bundle add public_activity

```
rails g public_activity:migration
rake db:migrate
```

- add to post.rb

```
  include PublicActivity::Model
  tracked
```

- in rails console

```
PublicActivity::Activity.count
PublicActivity::Activity.last
```

- refresh and create a new post
- run: PublicActivity::Activity.count, we get 1 now
- i created an activities page index

```
class ActivitiesController < ApplicationController
  def index
    @activities = PublicActivity::Activity.order(created_at: :desc)
  end
end
```

- added to activities/index

```
<h1>Activity#index</h1>
<% @activities.each do |a| %>
  <%= a.created_at %>
  <%= link_to a.trackable.title, a.trackable if a.trackable_type == 'Post' %>
  <%= a.key %>
  <%= a.owner&.email %>
  <%= a.parameters %>
  <br>
<% end %>
```

- LINKING IT WITH A USER
- update user.rb

```
  include PublicActivity::Model
  tracked only: [:create, :destroy], owner: :itself
```

- add to app controller

```
class ApplicationController < ActionController::Base
    include Pundit::Authorization
    include Pagy::Backend
    include PublicActivity::StoreController
```

- update post.rb

```
  tracked owner: proc { |controller, model| controller.current_user }
```

- refresh and update a post, go to activities page
- got a bullet notice so i updated the activites controller

```
    @activities = PublicActivity::Activity.order(created_at: :desc).includes([:owner, :trackable])
```

- update post.rb

```
  include PublicActivity::Model
  # tracked
  tracked owner: proc { |controller, model| controller.current_user }
  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity',
    dependent: :destroy
    
```

- update posts index

```
...
        <th>Activities</th>
...
          <td><%= post.activities.pluck(:id) %></td>        
```

- ADDING A CUSTOM ACTIVITY
- update posts controller


```
  def update
    Post.public_activity_off
    respond_to do |format|
      if @post.update(post_params)
      Post.public_activity_on
      @post.create_activity :details_updated, parameters: { time_zone: Time.zone.now }        
        format.html { redirect_to post_url(@post), notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
```

- add to config/application.rb

```
    config.active_record.yaml_column_permitted_classes = [Symbol, Date, Time, ActiveSupport::TimeWithZone, ActiveSupport::TimeZone]
```

- refresh and test it out, it should work
