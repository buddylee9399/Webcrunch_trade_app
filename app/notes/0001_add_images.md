# HOW TO ADD TEMP IMAGES IN THE ASSETS IMAGES

- basic in assets folder

```
<%= image_tag ("pic02.jpg") %>
```

- images in a gallery slide show, using the url as the link

```
<div class="gallery">
  <%= link_to image_url("gallery/fulls/01.jpg"), class: "landscape" do %>
     <%= image_tag "gallery/thumbs/01.jpg" %>
  <% end %>      
  <%= link_to image_url("gallery/fulls/02.jpg") do %>
     <%= image_tag "gallery/thumbs/02.jpg" %>
  <% end %>               
  <%= link_to image_url("gallery/fulls/03.jpg") do %>
     <%= image_tag "gallery/thumbs/03.jpg" %>
  <% end %>                   
  <%= link_to image_url("gallery/fulls/04.jpg"), class: "landscape" do %>
     <%= image_tag "gallery/thumbs/04.jpg" %>
  <% end %>                         
</div>
```

- HOW TO ADD BACKGROUND IMAGES IN CSS

```
.hero {
  height: 1000px;
  width: 1000px;
  background-image: url(image_path('gallery/fulls/03.jpg'));
  // background: asset_url('gallery/fulls/03.jpg');
}
```

- HOW TO ADD BACKGROUND IMAGE IN CSS IN THE HTML

```
    <div class="g-flex-centered g-height-100vh g-min-height-500--md g-bg-cover g-bg-pos-center g-bg-img-hero g-bg-black-opacity-0_5--after" style="background-image: url('<%= asset_path('vendor/img-temp/1900x1265/img1.jpg') %>');">
```