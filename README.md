## Pundit-Blog

A simple blog application with authentication that restricts certain parts to authorized users only.


### Overview


### Create App and Setup

```bash
rails new pundit-blog -T
```

##### Add Gems

```ruby
gem 'bootstrap-sass'
gem 'devise'

# in development, test
gem 'pry-rails'
gem 'pry-byebug'
gem 'pry-theme'
gem 'rubocop', require: false

gem 'rspec-rails'
gem 'factory_bot_rails'
gem 'faker', :git => 'https://github.com/faker-ruby/faker.git', :branch => 'master'

# in test
gem 'shoulda-matchers', '~> 5.0'
gem 'simplecov', require: false
gem 'database_cleaner-active_record', require: false
```

```bash
cat >> ~/.irbrc
IRB.conf[:USE_AUTOCOMPLETE] = false
```

The [pry-theme gem](https://github.com/kyrylo/pry-theme) adds some spice to the rails console.

```ruby
[1] pry(main)> pry-theme install vividchalk

[2] pry(main)> pry-theme try vividchalk

[3] pry(main)> pry-theme list
```

```bash
cat >> .pryrc
Pry.config.theme = 'vividchalk'
# Pry.config.theme = 'tomorrow-night'
# Pry.config.theme = 'pry-modern-256'
# Pry.config.theme = 'ocean'
```

#### Building Out

Now rename `app/assets/stylesheets/application.css` to `app/assets/stylesheets/application.scss`. Add the following lines of code to import bootstrap.

```scss
#app/assets/stylesheets/application.scss

...
@import 'bootstrap-sprockets';
@import 'bootstrap';

```

Create a partial named `_navigation.html.erb` to hold your navigation code; the partial should be located in `app/views/layouts directory`.

```erb
#app/views/layouts/_navigation.html.erb

<nav class="navbar navbar-inverse">
  <div class="container">
    <div class="navbar-header">
      <%= link_to 'Pundit Blog', root_path, class: 'navbar-brand' %>
    </div>
    <div id="navbar">

    <ul class="nav navbar-nav pull-right">
      <li><% link_to 'Home', root_path %></li>
      <ul class="nav navbar-nav pull-right">
        <% if user_signed_in? %>
        <li><%= current_user.email %></li>
        <li><%= link_to 'Log out', destroy_user_session_path, method: :delete %></li>
        <% else %>
          <li><%= link_to 'Log In', new_user_session_path %></li>
          <li><%= link_to 'Sign Up', new_user_registration_path %></li>
        <% end %>
      </ul>
    </ul>
  </div>
</nav>
```

For the navigation to be used, you need to render it in your application layout.

```erb
#app/views/layouts/application.html.erb

<!DOCTYPE html>
<html>
  <head>
    <title>Pundit-Blog</title>
    <%= csrf_meta_tags %>

    <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
    <%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
  </head>

  <body>
    <%= render "layouts/navigation" %>
    <div id="flash">
      <% flash.each do |key, value| %>
        <div class="flash <%= key %>"><%= value %></div>
      <% end %>
    </div>
    <div class="container-fluid">
      <%= yield %>
    </div>
  </body>
</html>
```

#### Generate User Model

Install Devise

```bash
bin/rails generate devise:install
```

Generate User model

```bash
bin/rails generate devise User

bin/rails db:migrate
```









### References

[https://code.tutsplus.com/tutorials/authorization-with-pundit--cms-28202](https://code.tutsplus.com/tutorials/authorization-with-pundit--cms-28202)
