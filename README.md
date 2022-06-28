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
