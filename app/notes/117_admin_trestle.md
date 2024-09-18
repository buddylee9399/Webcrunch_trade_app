# Episode 33 Trestle Admin Panel in Ruby on Rails
# https://www.youtube.com/watch?v=szuDzIlLWCk

- trestle github
- https://github.com/TrestleAdmin/trestle
- bundle add trestle
- $ rails generate trestle:install
- $ rails generate trestle:resource Post (or the resoureces added)

## USING DEVISE

- https://github.com/TrestleAdmin/trestle-auth
- gem 'trestle-auth'
- bundle
- $ rails generate trestle:auth:install User --devise
- After running the trestle:auth:install generator, check your config/initializers/trestle.rb for further configuration options.