# Ruby on Rails #83 import and use SVG in Rails. gem inline_svg

- https://www.youtube.com/watch?v=HEDBhzlrhF8
- https://github.com/jamesmartin/inline_svg
- https://github.com/corsego/83-rails-svg/commit/c96ca0ae88d989abc5579def927cecb39e2201e1
- add svg: app/assets/images/svg/alert.svg

```
<svg width="1em" height="1em" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M7.98882 0.00175758V0.00175758C5.85145 0.0367485 3.81372 0.911463 2.31612 2.43682L2.31612 2.43682C0.802058 3.94421 -0.0336824 6.00264 0.00104035 8.13885L0.0010404 8.1388C-0.00414621 12.4752 3.50702 15.9948 7.84343 16C7.85122 16 7.859 16 7.86678 16H8.00943V16C12.4611 15.9542 16.0355 12.3133 15.9993 7.86156V7.86156V7.86148C16.0094 3.52985 12.5062 0.0101537 8.17455 2.15044e-05C8.11261 -0.000123527 8.05068 0.000465041 7.98876 0.00178708L7.98882 0.00175758ZM7.0003 11.0285L7.0003 11.0285C6.98033 10.4855 7.40435 10.0291 7.94738 10.0092C7.95365 10.0089 7.95992 10.0088 7.96619 10.0086H7.98419V10.0086C8.53081 10.0097 8.97901 10.4423 8.99941 10.9885L8.99941 10.9885C9.01974 11.5312 8.59632 11.9875 8.05368 12.0079C8.04696 12.0081 8.04024 12.0083 8.03351 12.0084H8.01552H8.01552C7.46918 12.0067 7.02137 11.5745 7.0003 11.0285L7.0003 11.0285ZM7.33355 8.33416V4.33461V4.33461C7.33355 3.96646 7.632 3.66802 8.00015 3.66802C8.3683 3.66802 8.66674 3.96646 8.66674 4.33461V4.33461V8.33416V8.33416C8.66674 8.70231 8.3683 9.00075 8.00015 9.00075C7.632 9.00075 7.33355 8.70231 7.33355 8.33416V8.33416Z" fill="currentColor"/>
</svg>
```

- add file: app/assets/images/svg/youtube.svg

```
<svg width="1em" height="1em" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
  <!--! Font Awesome Pro 6.1.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2022 Fonticons, Inc. -->
  <path d="M549.655 124.083c-6.281-23.65-24.787-42.276-48.284-48.597C458.781 64 288 64 288 64S117.22 64 74.629 75.486c-23.497 6.322-42.003 24.947-48.284 48.597-11.412 42.867-11.412 132.305-11.412 132.305s0 89.438 11.412 132.305c6.281 23.65 24.787 41.5 48.284 47.821C117.22 448 288 448 288 448s170.78 0 213.371-11.486c23.497-6.321 42.003-24.171 48.284-47.821 11.412-42.867 11.412-132.305 11.412-132.305s0-89.438-11.412-132.305zm-317.51 213.508V175.185l142.739 81.205-142.739 81.201z" fill="currentColor"/>
</svg>
```

- add to the static_pages/index

```
<code>image_tag</code> <br>
<%= image_tag "svg/alert.svg", style: "height: 100px; color: green; background-color: red;" %>
<%= image_tag "svg/youtube.svg", style: "height: 100px; color: green; background-color: red;" %>
```

- ITS RENDERING AS IMAGE TAG, WE WANT AS SVG
- add the file: app/helpers/svg_helper.rb

```
module SvgHelper
  def svg_tag(icon_name, options = {})
    file = File.read(Rails.root.join('app', 'assets', 'images', 'svg', "#{icon_name}.svg"))
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'

    options.each { |attr, value| svg[attr.to_s] = value }

    doc.to_html.html_safe
  end
end
```

- update the code on static pages/index

```
<hr>
<code>svg_tag</code> <br>
<%= svg_tag "alert", style: "color: blue; background-color: red; font-size: 100px;" %>
<%= svg_tag "youtube", style: "color: blue; background-color: red; font-size: 100px;" %>
```

- USING THE GEM
- bundle add inline_svg
- update static pages/index

```
<hr>
<code>inline_svg_tag</code> <br>
<%= inline_svg_tag "svg/alert", style: "color: purple; background-color: yellow; font-size: 100px;" %>
<%= inline_svg_tag "svg/youtube", style: "color: purple; background-color: yellow; font-size: 100px;" %>
```

- refresh, they all worked
