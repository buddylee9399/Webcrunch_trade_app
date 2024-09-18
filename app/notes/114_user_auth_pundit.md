# Ruby on Rails #49 gem Pundit for Authorization - Complete Guide

- https://www.youtube.com/watch?v=xxkx57-vbQI
- https://github.com/corsego/49-gem-pundit/commit/3e3c65d8b6deaf382dea5ce554c732e85731d6d2
- https://github.com/varvet/pundit
- https://blog.corsego.com/complete-guide-to-gem-pundit
- bundle add pundit
- add to app controller

```
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized  

  private

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
    # or
    # redirect_to(request.referrer || root_path)
  end      
end
```

- rails g pundit:install
- CREATING THE USER POLICY
- rails g pundit:policy user

```
class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_any_role? :site_admin, :admin, :customer
  end

  def edit?
    update?
  end

  def update?
    @user.has_any_role? :site_admin, :admin
  end

end
```

- update users controller with authorize @users

```
  def index
    @users = User.all
    authorize @users
    respond_to do |format|
      format.html
      format.csv { send_data User.to_csv(@users), 
                    filename: "Users-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv", 
                    content_type: 'text/csv'}
    end    
  end
```

- refresh and get rid of one of the roles, and refresh users page, 
- in layout app, message needs to be there

```
      <% flash.each do |name, msg| %>
        <%= content_tag :div, msg, class: name %>
        <p>
      <% end %>
```

- we should see not authorized
- adding to edit and update

```
class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_any_role? :site_admin, :admin, :customer
  end

  def edit?
    update?
  end

  def update?
    @user.has_any_role? :site_admin, :admin
  end

end
```

- add to users controller

```
  def edit
    @user = User.find(params[:id])
    authorize @user
  end

  def update
    @user = User.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to users_url, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end
```

- refresh and click 'edit role' link
- adding authorization to the links

```
    <b>current user can see users index?</b>
    <%= policy(User).index? %> <br>
    <b>current user can edit a user?</b>
    <%= policy(User).edit? %> <br>
    <%= link_to 'Edit roles', edit_user_path(user) if policy(User).edit? %>
```

- ADDING POLICY TO POSTS
- rails g pundit:policy post
- this is who has acces to see what posts

```

class PostPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if @user.has_role? :admin
        scope.all
      else
        scope.where(content: "")
      end
    end
  end

  def index?
    true
    # false - nobody has access
  end
end

```

- in posts controller

```
    @pagy, @posts = pagy(policy_scope(Post).order(created_at: :desc).includes([:user, :qr_code_attachment, :barcode_attachment]))
    authorize @posts  
```

- refresh the posts index and we should see based on roles
