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

#### Generate Article Resources

```bash
bin/rails generate scaffold Articles title:string body:text

      invoke  active_record
      create    db/migrate/20220703130443_create_articles.rb
      create    app/models/article.rb
      invoke    rspec
      create      spec/models/article_spec.rb
      invoke      factory_bot
      create        spec/factories/articles.rb
      invoke  resource_route
       route    resources :articles
      invoke  scaffold_controller
      create    app/controllers/articles_controller.rb
      invoke    erb
      create      app/views/articles
      create      app/views/articles/index.html.erb
      create      app/views/articles/edit.html.erb
      create      app/views/articles/show.html.erb
      create      app/views/articles/new.html.erb
      create      app/views/articles/_form.html.erb
      create      app/views/articles/_article.html.erb
      invoke    resource_route
      invoke    rspec
      create      spec/requests/articles_spec.rb
      create      spec/views/articles/edit.html.erb_spec.rb
      create      spec/views/articles/index.html.erb_spec.rb
      create      spec/views/articles/new.html.erb_spec.rb
      create      spec/views/articles/show.html.erb_spec.rb
      create      spec/routing/articles_routing_spec.rb
      invoke    helper
      create      app/helpers/articles_helper.rb
      invoke      rspec
      create        spec/helpers/articles_helper_spec.rb
      invoke    jbuilder
      create      app/views/articles/index.json.jbuilder
      create      app/views/articles/show.json.jbuilder
      create      app/views/articles/_article.json.jbuilder
```

Update `app/views/articles/_form.html.erb` to be like the following
```erb
<%= form_for(article) do |f| %>
  <% if article.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(article.errors.count, "error") %> prohibited this article from being saved:</h2>
 
      <ul>
      <% article.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>
 
  <div class="field">
    <%= f.label :title %>
    <%= f.text_field :title %>
  </div>
 
  <div class="field">
    <%= f.label :body %>
    <%= f.text_area :body %>
  </div>
 
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

Next edit `app/views/articles/index.html.erb` to have
```erb
<table class="table table-bordered table-striped table-condensed table-hover">
  <thead>
  <tr>
    <th>Title</th>
    <th>Body</th>
    <th colspan="3"></th>
  </tr>
  </thead>
 
  <tbody>
    <% @articles.each do |article| %>
    <tr>
      <td><%= article.title %></td>
      <td><%= article.body %></td>
      <td><%= link_to 'Show', article %></td>
      <td><%= link_to 'Edit', edit_article_path(article) %></td>
      <td><%= link_to 'Destroy', article, method: :delete, data: { confirm: 'Are you sure?' } %></td>
    </tr>
    <% end %>
  </tbody>
</table>
 
<br>
 
<%= link_to 'New article', new_article_path %>
```

Routes should look like
```ruby
Rails.application.routes.draw do
  devise_for :users

  root to: "articles#index"

  resources :articles
end
```


#### Integrate Pundit

[Pundit](https://github.com/varvet/pundit) provides a set of helpers for building an authorization system.  It allows the application to give access to or restrict certain parts of the application by use of policy classes.
 
Add pundit to the `Gemfile`
```ruby
gem 'pundit`
```
```bash
bundle install
```

Integrate Pundit in your application by adding the following line to your `app/controllers/application_controller.rb`.
```ruby
...
  include Pundit
...
```

Run pundit's generator
```bash
bin/rails generate pundit:install
```

This will generate an `app/policies` directory which contains a base class for policies. Each policy is a basic Ruby class.









### References

[https://code.tutsplus.com/tutorials/authorization-with-pundit--cms-28202](https://code.tutsplus.com/tutorials/authorization-with-pundit--cms-28202)
