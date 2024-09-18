# HOW TO ADD THE DEFAULT CSS

- add gemfile 

```
gem "sassc-rails"
```

- rename app.css to app.scss
- import other css files

```
// default site style
@import "style";
// default sass styles
@import "main";
```

- if sass files, add the folders to the stylesheets

# USING THE VENDOR FOLDER

- create a folder vendor/plugins
- add to app.rb

```
config.assets.paths << Rails.root.join("vendor", "plugins")
```

- copy the files in there

```
in app.scss
@import 'bootstrap/bootstrap.min';
@import 'icon-awesome/css/font-awesome.min';
@import 'icon-line/css/simple-line-icons';
```

# import in sass

```
@import url('https://fonts.googleapis.com/css?family=Open + Sans:300,400,600,700'); /*!
```