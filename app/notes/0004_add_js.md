# HOW TO ADD JQUERY as cdn

```
<script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
```

# HOW I SET UP OLD RAILS 5 TYPE SIMPLE JAVASCRIPT

- update the assets/config/manifest file

```
//= link_tree ../javascripts .js
```

- create the folder assets/javascripts
- create the folder assets/javascripts/vendor
- drag in js files from the template
- create the file assets/javascripts/applicationJs.js

```
// require vendor/test
//= require vendor/jquery.min
//= require vendor/browser.min
//= require vendor/breakpoints.min
//= require vendor/util
//= require vendor/main
/*
OR JUST, but i like them separate like above
// require_tree .
*/


// A $( document ).ready() block.
<!-- $(document).on('turbo:load', function() { -->
// $( document ).ready(function() {
//     alert('hi from applicationJs.js');
// });
```

- update the head partial, take out bootstrap and the importmap tags

```
<%= stylesheet_link_tag "application", "data-turbo-track": "reload" %>
<%#= javascript_importmap_tags %>
```

- update layouts/application

```
  <%= javascript_include_tag 'applicationJs' %>
  </body>
```

# SEEING WHAT IMPORTMAP is bringing in

- to see what is being imported

```
bin/importmap json
```

# ADD JQUERY VIA DOWNLOADED FILES

# HOW TO ADD THE DEFAULT JAVASCRIPTS

- https://stackoverflow.com/questions/70548841/how-to-add-custom-js-file-to-new-rails-7-project
- create a folder 'custom' and bring in the js the apps use

```
// import "./custom/test"
import "./custom/jquery.min"
import "./custom/jquery.scrolly.min"
// import "./custom/browser.min"
// import "./custom/breakpoints.min"
import "./custom/util"
import "./custom/main"
```

# ADDING TO vendor/javascript

- put all the files in the vendor/javascript folder
- update config/importmap

```
pin_all_from "vendor/javascript"
```

- update app.js

```
// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "jquery.min"
import "jquery.scrollex.min"
import "jquery.scrolly.min"
// import "browser.min"
// import "breakpoints.min"
import "util"
import "main"
import "vendorTest"
```

- to call directly from layouts/app

```
    <%= javascript_include_tag 'browser.min' %>
    <%= javascript_include_tag 'breakpoints.min' %>
```

# TESTING JQUERY

- in app.js

```
$(document).on('turbo:load', function() {

  alert('jquery working');

});
```