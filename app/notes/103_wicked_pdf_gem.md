# Ruby on Rails #17 Gem Wicked PDF - generate, save, and send PDFs

- https://www.youtube.com/watch?v=tFvtwEmW-GE
- https://github.com/mileszs/wicked_pdf
- https://blog.corsego.com/gem-wicked-pdf
- to gemfile:

```
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
```

- bundle
- in terminal: rails generate wicked_pdf
- in config/initializers/mime_types.rb

```
Mime::Type.register "application/pdf", :pdf
```

- mime_types.rb isn't in rails 7
- so instead, in the posts controller show action

```
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "posts/show", formats: [:html]
      end
    end    
  end
```

- refresh and go to posts/2.pdf
- add the link in the posts/index

```
<%= link_to "PDF", post_path(post, format: :pdf) %>
```

- create the file: posts/pdf.html.erb

```
PDF generation date:
<%= Time.zone.now %>

<p>
  <strong>Post ID:</strong>
  <%= @post.id %>
</p>

<p>
  <strong>Title:</strong>
  <%= @post.title %>
</p>

<p>
  <strong>Content:</strong>
  <%= simple_format(@post.content) %>
</p>
```

- update posts controller show aciton

```
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "file_name", template: "posts/pdf", formats: [:html]
      end
    end    
  end
```

- adding a pdf to the index of posts
- update posts controller

```
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Posts: #{@posts.count}", template: "posts/index.html.erb"
      end
    end
```

- add the link to posts/index

```
<h1>Posts</h1>
<%= link_to "New post", new_post_path %>
<%= link_to "Posts PDF", posts_path(format: :pdf) %>
```

- CREATING A SEPARATE LAYOUT
- create layouts/pdf.html.erb

```
<!doctype html>
<html>
  <head>
    <meta charset='utf-8' />
    <%= wicked_pdf_stylesheet_link_tag "pdf" -%>
    <%= wicked_pdf_javascript_include_tag "number_pages" %>
  </head>
  <body onload='number_pages'>
    <div id="header">
      <%= wicked_pdf_image_tag 'mysite.jpg' %>
    </div>
    <div id="content">
      <%= yield %>
    </div>
  </body>
</html>
```

- update posts controller:

```
render pdf: "Posts: #{@posts.count}", template: "posts/index", formats: [:html], layout: "pdf"
```

- we can use our own stylesheets for the pdf
- create: stylesheets/pdf.css

```
body{
/*  background: pink;*/
}
```

- from the wicked gem github, we can add a bunch of other specifications

```
class ThingsController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf:                            'file_name',
               disposition:                    'attachment',                 # default 'inline'
               template:                       'things/show',
               locals:                         {foo: @bar},
               file:                           "#{Rails.root}/files/foo.erb",
               inline:                         '<!doctype html><html><head></head><body>INLINE HTML</body></html>',
               layout:                         'pdf',                        # for a pdf.pdf.erb file
               wkhtmltopdf:                    '/usr/local/bin/wkhtmltopdf', # path to binary
               show_as_html:                   params.key?('debug'),         # allow debugging based on url param
               orientation:                    'Landscape',                  # default Portrait
               page_size:                      'A4, Letter, ...',            # default A4
               page_height:                    NUMBER,
               page_width:                     NUMBER,
               save_to_file:                   Rails.root.join('pdfs', "#{filename}.pdf"),

etc....               
```

- you can specify them in the initializers/wicked file instead
- restart server
- ADDING A PDF TO AN EMAIL
- rails g mailer PostsMailer new_post
- update post_mailer

```
  def new_post
    post = Post.second
    @post = Post.second
    pdf = WickedPdf.new.pdf_from_string(
      render_to_string('posts/pdf', layout: 'pdf', formats: [:html])
    )
    attachments["post_#{post.id}.pdf"] = pdf
    @greeting = "Hi"

    mail to: "to@example.org"
  end
```

- to see it, go to: http://localhost:3000/rails/mailers
- FOR PRODUCTION WE NEED TO DO SOME TWEAKS
- HE SHOWS FOR HEROKU AT THE END OF THE VIDEO, I DIDNT DO IT SINCE NO HEROKU