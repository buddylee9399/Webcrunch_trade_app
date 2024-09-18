# Ruby on Rails #86 Bulk Actions, Edit Multiple Selected Records

- https://www.youtube.com/watch?v=lFjOXvJC2nA
- https://github.com/corsego/86-edit-multiple/commit/93be87e9b0a65b0afdd1ccd1782d7458e481c9ad
- update post/index

```
...
      <th scope="col">Status</th>
      <th scope="col">Checkbox</th>
...
        <td><%= post.status %></td>
        <td>  <%= check_box_tag "post_ids[]", post.id, nil, { multiple: true } %></td>      
```

- refresh post index, we should see the check boxes
- ADDING THE FORM TO LINK THE CHECKBOXES WITH
- add to post/index

```
<div class="d-flex justify-content-center">
  <%== pagy_bootstrap_nav(@pagy) %>
</div>
<div>
  <%= form_with url: bulk_update_posts_path, method: :patch, id: :bulk_actions_form do |form| %>
    <%= form.submit "draft" %>
    <%= form.submit "published" %>
    <%= form.submit "banned" %>
  <% end %>  
</div>
```

- update the post/index checkboxes

```
        <td>  <%= check_box_tag "post_ids[]", post.id, nil, { multiple: true, form: :bulk_actions_form } %></td>
```

- update routes with the collection

```
  resources :posts do
    member do
      patch :vote
      patch :update_status
      # patch "upvote"
      # patch "downvote"
    end
    collection do
      patch :bulk_update
    end    
  end
```

- add to posts controller

```
  def bulk_update
    binding.b
  end
```

- refresh and check a few boxes, and submit
- look at log

```
params
we can see the params
```

- update the posts controller

```
  def bulk_update
    # binding.b
    @selected_posts = Post.where(id: params.fetch(:post_ids, []).compact)
    if params[:commit] == 'draft'
      @selected_posts.update_all(status: :draft)
    elsif params[:commit] == 'published'
      @selected_posts.each { |p| p.published! }
    elsif params[:commit] == 'banned'
      @selected_posts.each { |p| p.banned! }
    end
    flash[:notice] = "#{@selected_posts.count} posts marked as #{params[:commit]}"
    redirect_to action: :index
  end
```

- refresh and test, it should WORK

