# Episode 24 Implementing TimetableJs in Ruby On Rails

- https://www.youtube.com/watch?v=gJ9upo8lhc8
- rails g scaffold event name location start_time:datetime end_time:datetime 
- http://timetablejs.grible.co/
- get the links from that pages view page source

```
<link rel="stylesheet" href="http://timetablejs.grible.co/styles/timetablejs.css">
<link rel="stylesheet" href="http://timetablejs.grible.co/styles/demo.css">
<script src="http://timetablejs.grible.co/scripts/timetable.min.js"></script>
```

- install request js
- https://github.com/rails/requestjs-rails

```
Add the requestjs-rails gem to your Gemfile: gem 'requestjs-rails'
Run ./bin/bundle install.
Run ./bin/rails requestjs:install
```