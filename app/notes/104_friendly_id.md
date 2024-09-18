# Gem Friendly ID

```
GitHub gem:
- https://github.com/norman/friendly_id
gem 'friendly_id', '~> 5.4.0'
Bundle
```

```
rails generate friendly_id
rails g migration AddSlugToUsers slug:uniq
rails db:migrate
```

* Add to model

```
class User < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
//or
friendly_id :title, use: [:slugged, :finders]
# if you use this 'finders' then in posts controllers you can leave
# @post = Post.find(params[:id])
end
```

* Add to controller

```
class UserController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
  end
Private
  def post_params
    params.require(:post).permit(:title, :content, :slug)
  end
end
```

* To re-save files in the database 

```
User.find_each(&:save)
```

## USING SLUG CANDIDATES

- Ruby on Rails #52 gem Friendly ID: The Complete guide. Generate readable URLs like a PRO
- https://www.youtube.com/watch?v=6orj2qU6JdA
- starting around minute 10 he explains is
- if you create a post with the same name, it adds a unique identifier at the end
- the-best-one-963d9abd-7169-4054-829f-ee59e2bcfa9e
- with slug candidates you can customize it
- from here: http://norman.github.io/friendly_id/file.Guide.html

```
class Restaurant < ActiveRecord::Base
  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :name,
      [:name, :city],
      [:name, :street, :city],
      [:name, :street_number, :street, :city]
    ]
  end
end

r1 = Restaurant.create! name: 'Plaza Diner', city: 'New Paltz'
r2 = Restaurant.create! name: 'Plaza Diner', city: 'Kingston'

r1.friendly_id  #=> 'plaza-diner'
r2.friendly_id  #=> 'plaza-diner-kingston'
```

# IF WE UPDATE THE TITLE, THE SLUG DOESNT CHANGE

- add to post.rb

```
  def should_generate_new_friendly_id?
    title_changed?
  end
```

- refresh and it works, edit a new title
- the problem is if any links outside the page used the old title, the link is broken
- because it is looking for post-2, not post-2-magical
- so update the post.rb

```
friendly_id :title, use: [:slugged, :finders, :history]
```

- now, because of the rails generate friendly id migration, it stores all the previous names