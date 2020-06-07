# minimal-course

This is a very simple jekyll theme for creating course websites. It does not incorporate blog functionality (other than through standard jekyll routines). The goal is to have a simple navigation bar on every page. 

The site includes [Bootstrap](https://getbootstrap.com) and [Fontawesome](https://fontawesome.com), so any standard Bootstrap components are available as are the Free FA icons.

## Installation

Add this line to your Jekyll site's `Gemfile`:

```ruby
gem "jekyll-remote-theme"
```

And add this line to your Jekyll site's `_config.yml`:

```yaml
remote-theme: dajmcdon/minimal-course
```


### GitHub pages

You can use this theme if using GitHub pages.

Add this line to your `_config.yml`:

```yaml
remote_theme: dajmcdon/minimal-course
```

## Usage

### Navigation

Navigation is implemented in the `_config.yml` file. The intention here is that if you have different course components in different repos, you can share the same menu bar.

### Colors

Everything is standard bootstrap with the exception of the navigation bar. Use `theme-bg` to set the color. Dark colors are best combined setting `navbar: dark` which results in white text. Otherwise, `navbar: light` goes well with light background colors.

### Fonts

By default, Google fonts are used. See https://fonts.google.com to select a font of your choice. 



## License

The theme is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

It is originally derived from https://github.com/granbom/jekyll-theme-bootstrap4-navbar-cdn.
