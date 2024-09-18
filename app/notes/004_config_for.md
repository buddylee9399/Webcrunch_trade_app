# Ruby on Rails #45 config_for Settings.yml - add default settings to your app

- https://www.youtube.com/watch?v=5YPFAHOeo-k
- we can use a gem like: https://github.com/rubyconfig/config
- he did it manually
- in temrinal: touch config/settings.yml

```
production:
  name: MasterAppPRO
development:
  name: MasterAppDEV 2
shared:
  app_name: MasterApp
  post_categories:
    sports: Sports & Outdoors, Running
    music: Music & Culture
```

- update the head partial and the navbar partial

```
<!-- <title><%#= Rails.configuration.application_name %></title> -->
<title><%= Rails.application.config_for(:settings).dig(:name) %></title>
<meta name="viewport" content="width=device-width,initial-scale=1">

navbar
<nav class="navbar navbar-expand-lg bg-body-tertiary">
  <div class="container-fluid">
    <%= link_to "#{Rails.application.config_for(:settings).dig(:name)}", root_path, class: 'navbar-brand' %>
```

- CREATING CATEGORIES
- rails g migration AddCategoryToPosts category:string
- rails db:migrate
- update post partial

```
<p>
  <strong>Category:</strong>
  <%= post.category %>
</p>
```

- update post controller

```
    def post_params
      # params.require(:post).permit(:title, :content)
      params.require(:post).permit(:title, :content, :category)
    end
```

- update post form

```
    <%#= f.select :category, [['Sports & Outdoors', 'sports'], ['Music & Culture', 'music']], include_blank: true %>
    <%= f.select :category, Rails.application.config_for(:settings).dig(:post_categories).to_h.invert.to_a, include_blank: true %>

```

