# Ruby on Rails #48 Gem Rolify for assigning user roles - Complete Guide

- https://github.com/RolifyCommunity/rolify
- https://github.com/RolifyCommunity/rolify/wiki/Usage
- https://github.com/corsego/48-gem-rolify/commit/929b6646efac8467f2e502266cf2b2d8b8683aa0
- bundle add rolify
- rails g rolify Role User
- rake db:migrate
- add to user

```
class User < ApplicationRecord

  rolify

  after_create :assign_default_role
  def assign_default_role
    if User.count == 1
      self.add_role(:site_admin) if self.roles.blank?
      self.add_role(:admin)
      self.add_role(:customer)      
    else
      self.add_role(:customer) if self.roles.blank?
    end
  end  
end
```

- in layouts/app: just to see in the view

```
Are you admin? <%= current_user.has_role? :admin %>
<%= current_user.roles.pluck(:name) %>
```

- update users/index

```
  <p>
    <%= user.full_name %> <br>
    <%= user.roles.pluck(:name) %> <br>
    number of posts: 
    <%= user.posts_count %>
  </p>
```

- to edit roles
- create: app/views/users/edit.html.erb

```
<%= form_with(model: @user) do |form| %>
  <%= form.collection_check_boxes :role_ids, Role.all, :id, :name %>
  <%#= form.collection_check_boxes :role_ids, Role.where(resource_type: nil), :id, :name %><br>  
  <%= @user.errors[:roles] %>
  <%= form.button :submit %>
<% end %>
```

- add to users/index

```
<% @users.each do |user| %>
  <p>
    <%= user.full_name %> <br>
    <%= user.roles.pluck(:name) %> <br>
    number of posts: 
    <%= user.posts_count %> <br>
    <%= link_to 'Edit roles', edit_user_path(user) %>
  </p>
<% end %>
```

- update users controller

```
class UsersController < ApplicationController

  def import
    file = params[:file]
    return redirect_to users_path, notice: 'Only CSV please' unless file.content_type == 'text/csv'

    CsvImportUsersService.new.call(file)

    redirect_to users_path, notice: 'Users imported!'
  end
  
  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.csv { send_data User.to_csv(@users), 
                    filename: "Users-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv", 
                    content_type: 'text/csv'}
    end    
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_url, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit({role_ids: []})
    end  
end
```

- refresh and test, IT WORKED
- ADDING VALIDATION
- must have 1 role

```
  after_create :assign_default_role
  validate :must_have_a_role, on: :update
    
  private
  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "must have at least 1 role")
    end
  end
  def assign_default_role
    if User.count == 1
      self.add_role(:site_admin) if self.roles.blank?
      self.add_role(:admin)
      self.add_role(:customer)      
    else
      self.add_role(:customer) if self.roles.blank?
    end
  end  
```

- refresh and TEST, it worked
- RESOURCIFYING POSTS
- update post.rb

```
class Post < ApplicationRecord
  resourcify
```

- update posts controller

```
  def create
    @post = Post.new(post_params)
    if @post.save
      current_user.add_role :creator, @post
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
@@ -26,6 +27,7 @@ def create

  def update
    if @post.update(post_params)
      current_user.add_role :editor, @post
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
```

- refresh and create a new post, IT WORKED
- ADDING SCOPES FOR ASSOCIATIONS
- update post/index

```
...
      <th scope="col">Users</th>
      <th scope="col">Creators</th>
      <th scope="col">Editors</th>
...
      <td><%= post.users.distinct.pluck(:email) %></td>
      <td><%= post.creators.distinct.pluck(:email) %></td>
      <td><%= post.editors.distinct.pluck(:email) %></td>   
```

- refresh error
- update post.rb

```
class Post < ApplicationRecord

  resourcify
  has_many :users, through: :roles, class_name: 'User', source: :users
  has_many :creators, -> { where(roles: {name: :creator}) }, through: :roles, class_name: 'User', source: :users
  has_many :editors, -> { where(roles: {name: :editor}) }, through: :roles, class_name: 'User', source: :users  
```
- refresh, create post, edit post, view post index it worked
- adding it to the users
- update users/index

```
<% @users.each do |user| %>
  <p>
    <%= user.full_name %> <br>
    <%= user.roles.pluck(:name) %> <br>
    number of posts: 
    <%= user.posts_count %> <br>
    <%= link_to 'Edit roles', edit_user_path(user) %>
    <%= user.posts.pluck(:id) %>
    <%= user.creator_posts.pluck(:id) %>
    <%= user.editor_posts.pluck(:id) %>    
  </p>
<% end %>
```

- update users.rb

```
  has_many :posts, through: :roles, source: :resource, source_type: :Post
  has_many :creator_posts, -> { where(roles: {name: :creator}) }, through: :roles, source: :resource, source_type: :Post
  has_many :editor_posts, -> { where(roles: {name: :editor}) }, through: :roles, source: :resource, source_type: :Post
```

-------------------------------

# Ruby on Rails #62 Live session: User Roles: Different approaches
- https://www.youtube.com/watch?v=nSx2RBt8l3g
- https://github.com/corsego/62-workshop-user-roles
- https://blog.corsego.com/user-roles-one-field
- https://blog.corsego.com/rolify-edit-roles
- https://blog.corsego.com/rolify-scopes

```
Topics covered:
1. post.user_id
2. admin:boolean
3. roles:integer enum
4. roles json hash
5. rolify
6. rolify - resourcify Posts
```

-------------------------------
```
FROM WEBCRUNCH
Gem Rolify

From GitHub - https://github.com/RolifyCommunity/rolify

gem "rolify"
rails g rolify Role User
rake db:migrate
```

* Add to model

```
class User < ApplicationRecord
  rolify
```

* From aja_webcrunch_discussion_forum
* Created a helper for rolify
*  Add to app.helper

```
  def has_role?(role)
    current_user && current_user.has_role?(role)
  end
```

* In the view

```
<% if has_role?(:admin) %>
<div class="level">
  <div class="level-left"></div>
  <div class="level-right">
    <%= link_to 'New Channel', new_channel_path, class:'button is-dark' %>
  </div>
</div>
```


