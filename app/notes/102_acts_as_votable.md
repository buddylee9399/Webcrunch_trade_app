# supeRails - #16 Gem ActsAsVotable - upvote and downvote with AJAX
## DIDNT WORK BECAUSE TURBLINKS NOW NOT VOTE.JS.ERB file

---------------------------------------------------

# supeRails - Ruby on Rails #75 ActsAsVotable likes, bookmarks, hotwire, vote scopes, cached votes

- https://github.com/ryanto/acts_as_votable

- rails g scaffold Post title content:text
- rails db:migrate
- create 2 posts
- bundle add acts_as_votable
- rails generate acts_as_votable:migration
- rails db:migrate
- update post.rb

```
class Post < ApplicationRecord
  acts_as_votable
end
```

- update user.rb

```
acts_as_voter
```

- add to posts/post partial

```
<p><%= render "posts/upvote_link", post: post %></p>
```

- create the posts/upvote_link.html.erb partial

```
<%= content_tag "div", id: "upvote-#{post.id}" do %>
  <%= button_to "Upvote", upvote_post_path(post), method: :patch %>
<% end %>
```

- update posts controller

```
  before_action :set_post, only: %i[ show edit update destroy upvote downvote]
  def upvote
    @post.upvote_by current_user
    redirect_to @post
  end
```

- update posts/post partial to view # of upvotes

```
  <p>Upvotes: <%= post.votes_for.up.size %></p>
  <p>Downvotes: <%= post.votes_for.down.size %></p>
  <p><%= render "posts/upvote_link", post: post %></p>
```

- update routes

```
  resources :posts do
    member do
      patch "upvote"
      patch "downvote"
    end
  end
```

- refresh and test, it should work
- to make an unvote update posts controller

```
  def upvote
    if current_user.voted_up_on? @post
      @post.unvote_by current_user
    else
      @post.upvote_by current_user
    end
    redirect_to @post
  end
```

- refresh and test, it should work
- ADDING DOWNVOTE
- update routes if not from before

```
  resources :posts do
    member do
      patch "upvote"
      patch "downvote"
    end
  end
```

- update posts controller

```
  def downvote
    if current_user.voted_down_on? @post
      @post.unvote_by current_user
    else
      @post.downvote_by current_user
    end
    redirect_to @post    
  end
```

- update posts/post partial

```
  <p><%= render "posts/downvote_link", post: post %></p>
```

- create psts/downvote_link partial

```
<%= content_tag "div", id: "upvote-#{post.id}" do %>
  <%= button_to "Downvote", downvote_post_path(post), method: :patch %>
<% end %>
```

- refresh and test, it should work
- MAKING IT TURBO STREAM
- update posts controller

```
  def upvote
    if current_user.voted_up_on? @post
      @post.unvote_by current_user
    else
      @post.upvote_by current_user
    end
    respond_to do |format|
      format.html do
        redirect_to @post
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@post, partial: "posts/post", locals: {post: @post})
      end
    end        
  end
```

- add to layouts/application

```
  <body>
    <%= render 'shared/navbar' %>
    <div class="container">
      <%= Time.zone.now %>
```

- refresh and test it, to verify that the page isnt reloading
- making the downvote turbo
- update posts controller

```

  def downvote
    if current_user.voted_down_on? @post
      @post.unvote_by current_user
    else
      @post.downvote_by current_user
    end
    respond_to do |format|
      format.html do
        redirect_to @post
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@post, partial: "posts/post", locals: {post: @post})
      end
    end     
  end
```

- refresh and test, it worked
- IF YOU WANTED A VERSION WITH REDIRECT
- update the button to have 'format: :html'

```
<%= content_tag "div", id: "upvote-#{post.id}" do %>
  <%= button_to "Upvote", upvote_post_path(post), method: :patch %>
  <%= button_to "Upvote & Redirect", upvote_post_path(post, format: :html), method: :patch %>
<% end %>
```

- ADDING CACHE TO VOTES
- rails g migration AddCachedVotesToPosts
- update the migration

```
class AddCachedVotesToPosts < ActiveRecord::Migration[7.0]
  def change
    change_table :posts do |t|
      t.integer :cached_votes_total, default: 0
      t.integer :cached_votes_score, default: 0
      t.integer :cached_votes_up, default: 0
      t.integer :cached_votes_down, default: 0
      t.integer :cached_weighted_score, default: 0
      t.integer :cached_weighted_total, default: 0
      t.float :cached_weighted_average, default: 0.0
    end

    # Uncomment this line to force caching of existing votes
    Post.find_each(&:update_cached_votes)
  end
end
```

- rails db:Migrate
- to see the cahces, update the post partial

```

<%=  post.cached_votes_total %> <br>
<%=  post.cached_votes_score %> <br>
<%=  post.cached_votes_up %> <br>
<%=  post.cached_votes_down %> <br>
<%=  post.cached_weighted_score %> <br>
<%=  post.cached_weighted_total %> <br>
<%=  post.cached_weighted_average %> <br>

```

- update the posts helper

```
module PostsHelper
  def upvote_label(post, user)
    label_text = if user.voted_up_on? post
                    "UNvote"
                  else
                    "UPvote"
                  end
    tag.span do
      "#{post.cached_votes_up} #{label_text}"
    end
  end

  def downvote_label(post, user)
    label_text = if user.voted_down_on? post
                    "UNvote"
                  else
                    "DOWNvote"
                  end
    tag.span do
      "#{post.cached_votes_down} #{label_text}"
    end
  end
  def upvote_label_styles(post, user)
    if user.voted_up_on? post
      "background-color: grey;"
    end
  end

  def downvote_label_styles(post, user)
    if user.voted_down_on? post
      "background-color: grey;"
    end
  end
end

```

- update upvote link partial

```
  <%= button_to upvote_label(post, current_user), upvote_post_path(post), method: :patch %>
```

- update downlove link partial

```
<%= content_tag "div", id: "upvote-#{post.id}" do %>
  <%#= button_to "Downvote", downvote_post_path(post), method: :patch %>
  <%= button_to downvote_label(post, current_user), downvote_post_path(post), method: :patch %>
<% end %>
```

- ADDING STYLING TO THE BUTON
- update the buttons:

```
<%= button_to upvote_label(post, current_user), upvote_post_path(post), method: :patch, style: upvote_label_styles(post, current_user) %>
<%= button_to downvote_label(post, current_user), downvote_post_path(post), method: :patch, style: downvote_label_styles(post, current_user) %>
```

- refresh and test out
- MOVING THE LOGIC OUT OF THE CONTROLLER AND SIMPLYFYING THE LOGIC
- update routes

```
  resources :posts do
    member do
      patch :vote
      # patch "upvote"
      # patch "downvote"
    end
  end
```

- posts controller

```
  before_action :set_post, only: %i[ show edit update destroy vote]
  def vote
    case params[:type]
    when 'upvote'
      @post.upvote!(current_user)
    when 'downvote'
     @post.downvote!(current_user)
    else
      return redirect_to request.url, alert: "no such vote type"
    end
    respond_to do |format|
      format.html do
        redirect_to @post
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(@post, partial: "posts/post", locals: {post: @post})
      end
    end
  end  
```

- update post.rb

```
class Post < ApplicationRecord
  acts_as_votable
  def upvote!(user)
    if user.voted_up_on? self
      unvote_by user
    else
      upvote_by user
    end
  end
  
  def downvote!(user)
    if user.voted_down_on? self
      unvote_by user
    else
      downvote_by user
    end
  end  
end

```

- update buttons

```
<%= button_to upvote_label(post, current_user), vote_post_path(post, type: :upvote), method: :patch, style: upvote_label_styles(post, current_user) %>
<%= button_to downvote_label(post, current_user), vote_post_path(post, type: :downvote), method: :patch, style: downvote_label_styles(post, current_user) %>
```

- to order the post listing by # of votes, update the controller of posts

```
  def index
    # @posts = Post.all
    @posts = Post.order(cached_weighted_score: :desc)
  end
```

- ADDED THE OPTION TO SCOPE VIA BOOKMARKS, I DONT KNOW WHAT ITS FOR SO I DIDNT DO IT
- ADDED A WAY TO SCOPE VIA LIKES AND BOOKMARKS

---------------------------------------------------

# USING FONT AWESOME
Gem acts as votable
Acts as votable gem

From: aaa_mackchild_raddit

- Add the gem: gem 'acts_as_votable'
- Create migration

```
rails generate acts_as_votable:migration
rails db:migrate
```

- Add to the model

```
class Link < ApplicationRecord
  acts_as_votable
end
```

- Create the routes

```
  resources :links do
    member do
      put "like", to:    "links#upvote"
      put "dislike", to: "links#downvote"
    end
  end
```

- Update the link partial

```
<div class="link row clearfix">
  <h2>
    <%= link_to link.title, link %><br>
    <small class="author">Submitted <%= time_ago_in_words(link.created_at) %> by <%= link.user.email %></small>
  </h2>

  <div class="btn-group">
    <a class="btn btn-default btn-sm" href="<%= link.url %>">Visit Link</a>
    <%= button_to like_link_path(link), method: :put, class: "btn btn-default btn-sm" do %>
      <span class="glyphicon glyphicon-chevron-up"></span>
      Upvote
      <%= link.get_upvotes.size %>
    <% end %>
    <%= button_to dislike_link_path(link), method: :put, class: "btn btn-default btn-sm" do %>
      <span class="glyphicon glyphicon-chevron-down">
      Downvote
      <%= link.get_downvotes.size %>
    <% end %>
  </div>
</div>
```

- Update the links controller

```
  def upvote
    @link = Link.find(params[:id])
    @link.upvote_by current_user
    redirect_back(fallback_location: root_path)
  end

  def downvote
    @link = Link.find(params[:id])
    @link.downvote_from current_user
    redirect_back(fallback_location: root_path)
  end
```

- Votes with font awesome icons

```
  <%= button_to vote_post_path(post), method: :get, class: "data" do %>
    <i class="fa-regular fa-thumbs-up">
      <%= pluralize(post.cached_votes_up, "Like") %>
    </i>
  <% end %>
```

