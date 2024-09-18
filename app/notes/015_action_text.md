# Ruby on Rails #36 Action Text - Rich text editing with Trix

- https://www.youtube.com/watch?v=4JNDy03d0Uw
- https://edgeguides.rubyonrails.org/action_text_overview.html
- https://edgeguides.rubyonrails.org/action_text_overview.html
- rails action_text:install
- rails db:migrate
- add to app.scss, if not css

```
@import "trix";
@import "actiontext";
```

- make sure this is in app.js

```
import "trix"
import "@rails/actiontext"
```

- add to post.rb

```
has_rich_text :description
the post had a content field, you can remove that field and add:
has_rich_text :content instead
or from the treminal:
bin/rails generate model Post content:rich_text
** you don't need to add a content field to your messages table.
```

- add to the post form

```
  <%= f.rich_text_area :description %>
```

- add to post / post partial

```
  <p>
    <strong>Rich Text:</strong>
    <%= post.description %>
  </p>  
```

- update post controller

```
params.require(:post).permit(:title, :content, :status, :description)
```

- refresh and test
- IT WORKED, and images worked, the gem file needs image processing gem

