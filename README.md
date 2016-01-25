# Grimm
[![Coverage Status](https://coveralls.io/repos/github/andela-aadepoju/grimm/badge.svg?branch=ch-tests-07)](https://coveralls.io/github/andela-aadepoju/grimm?branch=ch-tests-07)
[![Gem Version](https://badge.fury.io/rb/grimm.svg)](https://badge.fury.io/rb/grimm)
[![Code Climate](https://codeclimate.com/github/andela-aadepoju/grimm/badges/gpa.svg)](https://codeclimate.com/github/andela-aadepoju/grimm)

Grimm is a mini  MVC framework written in ruby. It is a look alike of Ruby on Rails. It is light weight and very easy to use.

## Installation

From your terminal run:

    $ gem install grimm

if you have an existing app, just add the gem to your gem file.

```ruby
gem "grimm"
```

And then execute:

    $ bundle install

### Grimm App
Grimm App is the base app for Grimm gem. Clone the app to your local machine:

    $ git clone link to grimm app

# Understanding Grimm and Grimm App


## Controllers

They are made up of one or more actions that are executed on request it either renders a template or redirects to another action. An action is defined as a public method on the controller, which will automatically be made accessible to the web-server through the Routes.

`ApplicationController` should inherit from `grimm::BaseController` as seen in `application_controller.rb`
and all other controllers needed for your application can inherit from your `ApplicationController`  e.g  `PostsController`

```ruby
#application_controller.rb
class ApplicationController < Grimm::BaseController

end

#posts_controller.rb
class PostsController < ApplicationController
  def index #action method index, renders index.html.erb
    @posts = Post.all
  end
end
```

Actions, by default, render a template in the app/views directory corresponding to the name of the controller and action after executing code in the action. For example, the index action of the `PostsController` would render the template app/views/posts/index.html.erb by default after populating the @posts instance variable. Also controllers should be named in their pluralized form.

## Requests

For every request, the router determines the value of the controller and action keys. These determine which controller and action are called. The remaining request parameters and the full request with all the HTTP headers are made available to the action. Then the action is performed.

Example request:

    http://localhost:4444/posts


## Responses

Each action results in a response, which holds the headers and document to be sent to the user's browser. The actual response object is generated automatically through the use of renders and redirects and requires no user intervention.

Example response for the request above:

    All Posts

    First post

    This is the first post

    By Sarah

    Edit Delete


    Second post

    This is the second post

    By John

    Edit Delete


    Create New Post

## Parameters

All request parameters, whether they come from a GET or POST request, or from the URL, are available through the `params` method which returns a hash. For example, an action that was performed through `/posts?id=5` or `/posts/5`(depends on how route is defined) will include `{ "id => "5" }` in params.

It's also possible to construct multi-dimensional parameter hashes by specifying keys using brackets, such as:

```html
<input type="text" name="post[author]" value="BLessing">
<input type="text" name="post[title]" value="grimm studies">
<input type="text" name="post[description]" value="grimm studies, is the study of the grimm gem">
```
A request stemming from a form holding these inputs will include:

```ruby
{ "post" => { "author" => "Blessing", "title" => "grimm studies", "description" => "grimm studies, is the study of the grimm gem" } }
```

## Routes

Routes are HTTP methods paired with a URL matching patter, the first route that matches a request is invoked.
Route patterns may include named parameters, which can be gotten from the params hash:
They are defined in the file `config/routes.rb`
The resources method is also available for you, it makes available all the routes written below `resources(:posts)`
Where `posts` is the name of the controller, and all words behind the `#` are action methods defined in your controller.

```ruby
#PostApplication is your chosen application name as defined in your config.ru file.
PostApplication.routes.draw do
  get "/all_posts", to: "posts#index" #defined route, posts is the controller and index the action method.
  resources(:posts)
  # All routes below are made available by the resources method, but you have to define the methods in your controller.
  get("/#{name}", to: "#{name}#index")
  get("/#{name}/new", to: "#{name}#new")
  get("/#{name}/:id", to: "#{name}#show")
  get("/#{name}/edit/:id", to: "#{name}#edit")
  get("/#{name}/delete/:id", to: "#{name}#destroy")
  post("/#{name}", to: "#{name}#create")
  patch("/#{name}/:id", to: "#{name}#update")
  put("/#{name}/:id", to: "#{name}#update")
  post("/#{name}/:id", to: "#{name}#update")
end
```

In the case of a request being made to an undefined route a 404 page is rendered.

## Rendering Views

`Neddina::BaseController` sends response to the user either by making use of render method specified within your controller method or by inferring the template to display from the name of your controller(which should be the name of the folder that contains the template) and the action method which should be the name of the file template to be rendered).
The render method which enables rendering of ERB templates is automatically configured.
Objects can be passed from the controller to the view by either assigning them as instance variables or by passing the object as a parameter to the render method:

Having instance variable `@post` makes `post` object available to `views\posts\show.html.erb` and this is automatically rendered without explicitly calling the render method.

```ruby
def show
  @post = Post.find(params["id"])
end
```

```html
Post Title: <%= post.title %>
```

Calling the render method and passing an object exposes the object to the view template.

```ruby
def show
  post = Post.find(params["id"])
  render :show, post
end
```

```html
Post Title: <%= title %>
```

If render is called twice a DoubleRenderError is raised.

## Models

Models are Ruby classes located in the models folder each model class represents an object e.g Post model represents the Post object andits data structures. They talk to the database, store and validate data and perform the business logic.
All models should inherit from the `grimm::BaseModel`. The BaseModel comes with a host of methods for creating, saving, and finding data objects, all without having to use the structured query language. Also model classes should be named as a singular object.

Example model class displaying available methods:

```ruby
#post.rb file
class Post < grimm::BaseModel
  to_table :posts
  #to_table method infers that this model models posts table in DB located in db/app.sqlite3

  property :id, type: :integer, primary_key: true
  property :description, type: :text, nullable: false
  property :title, type: :text
  property :author, type: :text, nullable: false

  #property method defines the property of the object as columns in the posts table.
  #The first argument passed to the property method is taken as the table column name
  #The type hash is taken as the data-type for the column
  #The primary_key hash makes the particular column the primary key for the table
  #The nullable hash value is used to evaluate whether a column can have a null value or not

  create_table
  #create_table method creates the table with name from the to_table method and with the given properties above if it does not exist

  #Other methods available
end
```

## Racking up your Application

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-bebowe/grimm. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
