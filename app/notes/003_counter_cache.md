# Ruby on Rails #44 Rails Counter Cache: Count associated child records

- https://www.youtube.com/watch?v=30FZFU3oTiQ
- rails g migration add_user_to_posts user:references
- rails db:migrate
- error: because theres users and posts already and they dont have the user id
- update posts.rb and user.rb

```
class Post < ApplicationRecord
  extend FriendlyId
  acts_as_votable
  belongs_to :user

class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  acts_as_voter  
  has_many :posts  
```

- rails db:reset, updated the seed file to add a user to posts

```
def create_posts
  50.times do |p|
    u = User.all.sample
    Post.create(
      title: Faker::Hipster.sentence,
      content: Faker::Hipster.paragraph(sentence_count: 5),
      user: u
    )
  end
  puts "#{Post.count} posts created"
end
```

- bullet gem said include user in posts controller

```
@pagy, @posts = pagy(Post.order(created_at: :desc).includes([:user]))
```

- update posts controller create action

```
  def create
    # @post = Post.new(post_params)
    @post = current_user.posts.build(post_params)
```

- integrating the counter cache
- update routes

```
resources :users, only: [:index]
```

- create users_controller.rb 

```

class UsersController < ApplicationController
  def index
    @users = User.all
  end
end
```

- create views/users/index.html.erb

```
<h1>Users</h1>

<% @users.each do |user| %>
  <p>
    <%= user.full_name %> <br>
    number of posts: 
    <%= user.posts.count %>
  </p>
<% end %>
```

- this works but it hits the database too many times
- rails g migration add_posts_count_to_users posts_count:integer
- update the migration

```
class AddPostsCountToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :posts_count, :integer, default: 0, null: false
  end
end
```

- rails db:migrate
- update post.rb

```
class Post < ApplicationRecord
  extend FriendlyId
  acts_as_votable
  belongs_to :user, counter_cache: true
```

- update users/index

```
<%= user.posts_count %>
```

- rails db:reset
- to update the posts manually without resetting the database

```
in rails console:
User.find_each { |u| User.reset_counters(u.id, :posts) }
```

- restart server it worked, checkout the server logs
