# Ruby on Rails #47 TIP: create a list of buttons to change status

## WITH ENUMS DOWN LOWER

- https://www.youtube.com/watch?v=X8kLhQMx1lY
- rails g migration AddStatusToPosts status
- update migration

```
add_column :posts, :status, :string, null: false, default: 'draft'
```

- rails db:migrate
- update post partial

```
  <p>
    <strong>status:</strong>
    <%= @post.status %>
  </p>
```

- refresh and see each one's status is 'draft'
- update post.rb

```
  validates :status, presence: true
  STATUSES = [:draft, :published, :unpublished]
```

- update post partial to show the buttons

```
  <p>
    <strong>status:</strong>
    <%= @post.status %>
    <% Post::STATUSES.each do |status| %>
      <%#= link_to_unless @post.status.eql?(status.to_s), status, update_status_post_path(@post, status: status), method: :patch %>
      <%= button_to status, update_status_post_path(post, status: status), method: :patch unless post.status.eql?(status.to_s) %>
    <% end %>
  </p>
```

- update routes to add the update_status route

```
  resources :posts do
    member do
      patch :vote
      patch :update_status
      # patch "upvote"
      # patch "downvote"
    end
  end
```
- add update status action to posts controller

```
  def update_status
    @post = Post.find(params[:id])
    # the include is so it can verify that the status is the same as we allowed
    # so no one tries to hack the 3 options    
    if params[:status].present? && Post::STATUSES.include?(params[:status].to_sym)
      @post.update(status: params[:status])
      redirect_to @post, notice: "Status changed to #{@post.status}"
    else
      redirect_to @post, alert: "Stop hacking"
    end
  end
```

- refresh and try, it works

----------------------------

# Ruby on Rails #50 ActiveRecord Enum - when and why to use enums?

- https://www.youtube.com/watch?v=Ac8syCb01ys
- https://edgeapi.rubyonrails.org/classes/ActiveRecord/Enum.html
- rails g migration AddStatusToPosts status
- update migration

```
add_column :posts, :status, :string, default: 'draft'
```

- update post index, 

```
....
        <th>Status</th>


....
        <td><%= post.status %></td>
```

- update post.rb

```

  STATUSES = [:draft, :published, :banned]

  validates :status, inclusion: { in: Post::STATUSES }

  scope :draft, -> { where(status: 'draft') }
  scope :published, -> { where(status: 'published') }
  scope :banned, -> { where(status: 'banned') }

  def banned?
    status == 'banned'
  end
```

- update post controller

```
params.require(:post).permit(:title, :content, :status)
```

- USING ENUMS INSTEAD
- rails db:rollback
- update status migration

```
add_column :posts, :status, :integer
```

- update post.rb

```
  enum status: { draft: 0, published: 1, banned: 13, in_review: 534 }
```

- update the post form

```
<%= f.select :status, Post.statuses.keys %>
```

- refresh and test it, it works but has a turbo submit problem
- now we can scope without adding the scopes to post.rb

```
Post.in_review
Post.banned
Post.published
Post.draft

and boolean check
Post.first.draft?
```

- USING STRINGS INSTEAD OF INTEGERS
- rails db:rollback

```
    add_column :posts, :status, :string
```

- update post.rb
```
  enum status: { draft: 'draft', published: 'published', banned: 'banned' }, _default: 'draft'

```

- update post form partial

```
<%= form.select :status, Post.statuses.keys, include_blank: true %>
```

- NEED TO FIGURE OUT HOW TO DO THE BUTTONS WITH THE ENUMS, I THINK HUDGENS HAS THAT SOMEWHERE

