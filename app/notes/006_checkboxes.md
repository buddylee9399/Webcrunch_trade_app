# Ruby on Rails #51 array of checkboxes in a Rails app

- https://www.youtube.com/watch?v=nFJZuqqBlds
- rails g migration AddTagsToPosts tags:text
- update migration

```
add_column :posts, :tags, :text, array: true, default: []
```

- rails db:migrate
- TypeError: can't quote Array: only works with postgres db
- his github: https://github.com/corsego/51-checkbox-array/commit/dc7183f680bc48184e6481c458611adae0706505

