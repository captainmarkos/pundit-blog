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


#### Create the Article Policy

For now, we only want to allow registered users to create new articles.  Additionally, only creators of an article should be able to edit and delete the article.

The policy will look like
```ruby
# app/policies/article_policy.rb

class ArticlePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && user == article.user
  end

  def destroy?
    user.present? && user == article.user
  end

  private

    def article
      record
    end
end
```

With this policy we are permitting everyone (registered and non-registered users) to see the index page.  To create a new article, a user has to be registered.  We use `user.present?` to find out if the user trying to perform the action is registered.

For updating and deleteing we want to make sure only the user who created the article is able to perform these actions.

Now we need to establish a relationship between the `Article` and the `User` models.

```bash
bin/rails generate migration add_user_id_to_articles user:references
bin/rails db:migrate
```

Add associations
```ruby
# app/models/user.rb

...
  has_many :articles
```

```ruby
# app/models/article.rb

...
  belongs_to :user
```

Now we need to update the `ArticlesController`
```ruby
# app/controllers/articles_controller.rb

class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  def index
    @articles = Article.all
    authorize @articles
  end

  def show; end

  def new
    @article = Article.new
    authorize @article
  end

  def edit; end

  def create
    @article = Article.new(article_params)
    @article.user = current_user
    authorize @article

    respond_to do |format|
      if @article.save
        format.html { redirect_to article_url(@article), notice: "Article was successfully created." }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to article_url(@article), notice: "Article was successfully updated." }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy

    respond_to do |format|
      format.html { redirect_to articles_url, notice: "Article was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  def article_params
    params.require(:article).permit(:title, :body)
  end
end
```

We'll want to add a standard error message that shows whenever a non-authorized user tries to access a restricted page.
```ruby
#app/controllers/application_controller.rb

...

  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:warning] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
```

Fire up the rails server and give it a spin!


### References

[https://code.tutsplus.com/tutorials/authorization-with-pundit--cms-28202](https://code.tutsplus.com/tutorials/authorization-with-pundit--cms-28202)
