# adding fonts

- create the folder assets/fonts
- add to config/manifest.js

```
//= link_tree ../fonts
```
- update the css file

```
@font-face {
    font-family: FontAwesome;
    src: font-url('fontawesome-webfont.eot?v=4.7.0');
    src: font-url('fontawesome-webfont.eot?#iefix&v=4.7.0') format("embedded-opentype"), font-url('fontawesome-webfont.woff2?v=4.7.0') format("woff2"), font-url('fontawesome-webfont.woff?v=4.7.0') format("woff"),
        font-url('fontawesome-webfont.ttf?v=4.7.0') format("truetype"), font-url('fontawesome-webfont.svg?v=4.7.0#fontawesomeregular') format("svg");
    font-weight: 400;
    font-style: normal;
}
```