# Ruby on Rails #77 HACKERMAN: strong params authorization

- https://www.youtube.com/watch?v=j1QrkqX5DXQ
- https://github.com/corsego/77-strong-params-authorization/commit/4609d17e23b5b5f244e554d91b32e68d852b6ae8
- https://api.rubyonrails.org/classes/ActionController/StrongParameters.html
- THIS IS IF YOU ASSIGN A ROLE PARAM TO THE DEVISE USER MODEL,
- I DIDNT DO IT TO THE MASTER APP
- update: app/controllers/users_controller.rb

```
  def update_params
    # params.require(:user).permit(:name, :role)

    # return params.require(:user).permit(:name) if @user == current_user
    # return params.require(:user).permit(:name, :role) if current_user.admin?

    allowed_params = []
    allowed_params += [:name] if @user == current_user
    allowed_params += [:role] if current_user.admin?
    params.require(:user).permit(allowed_params)
  end
```

```
- update: app/views/users/_user.html.erb

<%= link_to "Edit", edit_user_path(user) if user == current_user || current_user.admin? %>
```
