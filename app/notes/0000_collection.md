
# CREATING A RAILS LOCAL SERVER

```
add to con/env/dev:
config.hosts.clear

in terminal: 
rails server -b 0.0.0.0

http://0.0.0.0:3000
in the other computers:
serving computer ip:3000
http://192.168.0.223:3000/
```

- loading on a different port number
```
rails server -p 4000
then go to:
http://localhost:4000/
```

# TESTING TURBO MAKING SURE THE PAGE DOESNT RELOAD
- add to layouts/application
```
  <body>
    <%= render 'shared/navbar' %>
    <div class="container">
      <%= Time.zone.now %>
```
- refresh resourse testing and hit what ever button, and we should see the time not changing


# precompiling assets

- once you do you have to pre compile everytime

```
Now add jquery.js to assets.rb file for precompiling.

Rails.application.config.assets.precompile += %w( jquery.js )
After doing this just Remember to run: rails assets:precompile

 to un precompile
 rails assets:clobber

```