# Markdown and pygments
- redcarpet gem - https://github.com/vmg/redcarpet
- Pygments gem - https://github.com/pygments/pygments.rb
- pygments.scss - https://github.com/buddylee9399/aam_mackchild_blog_course/blob/main/app/assets/stylesheets/pygments.scss

- From: aam_mackchild_blog_course

```
Redcarpet 

Bundle add redcarpet

Pygments
gem 'pygments.rb'
```

* Add to app helper

```
module ApplicationHelper
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end
  def markdown(content)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end
end

```

* Restart server
* Add to the show view

```
<%= markdown @project.description %>
```

* Using a strip markdown while using truncate
* In the view

```
<%= truncate(strip_markdown(discussion.content), length: 140) %>
            <p><em><small>Posted <%= time_ago_in_words(discussion.created_at) %> ago in
```

* And in the app helper

```
module ApplicationHelper
  require 'redcarpet/render_strip'
  require 'pygments'

  def has_role?(role)
    current_user && current_user.has_role?(role)
  end

  def strip_markdown(text)
    markdown_to_plain_text = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    markdown_to_plain_text.render(text).html_safe
  end

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end
  def markdown(content)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options = {
      autolink: true,
      no_intra_emphasis: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end

end

```

- There’s a pygments.scss
- Add to app.scss: @import "pygments";
