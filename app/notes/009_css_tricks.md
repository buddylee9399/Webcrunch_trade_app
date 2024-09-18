# How to use mixins, includes and extends

- convert app.css to .scss
- install sass rails gem
- bundle
- update app.scss

```
@import "bootstrap";

@mixin important-header {
  @extend .p-5;
  @extend .m-5;  
}

.padding-five {
  padding: 20px;
}

.my-header {
  // @extend .p-2;
  // @extend .m-2;
  @include important-header;
  background: lightblue;
}

pre {
  @extend .p-5;
}
```

- update the html with the .my-header class;

```
<h1 class = "my-header">StaticPages#contact</h1>
```

--------------------------

# Ruby on Rails #79 Classless CSS frameworks

- https://www.youtube.com/watch?v=dqwg0sdQHZ4
- https://github.com/corsego/79-classless-css-frameworks/commit/c569484b89ae6f41a13ec64c1c4326059897a3c5
- https://simplecss.org/
- https://andybrewer.github.io/mvp/ = minimalist css

----------------------