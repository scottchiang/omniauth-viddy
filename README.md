# OmniAuth Viddy Strategy

Strategy to authenticate with Viddy via OAuth2 in OmniAuth.

## Installation

`omniauth-viddy` is hosted through [RubyGems](http://rubygems.org/gems/omniauth-viddy).  Add to your `Gemfile`:

```ruby
gem "omniauth-viddy"
```
Then `bundle install`.

## Usage

Here's an example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :viddy, ENV["VIDDY_KEY"]
end
```

You can now access the OmniAuth Viddy OAuth2 URL: `/auth/viddy`

### Devise

For devise, you should also make sure you have an OmniAuth callback controller setup

```ruby
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def viddy
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_viddy_oauth(request.env["omniauth.auth"], current_user)

      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "viddy"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.viddy_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
  end
end
```

and bind to or create the user

```ruby
def self.find_for_viddy_oauth(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    unless user
        user = User.create(name: data["name"],
             email: data["email"],
             password: Devise.friendly_token[0,20]
            )
    end
    user
end
```
## Configuration

You can configure several options, which you pass in to the `provider` method via a hash:

## Auth Hash

Here's an example of an authentication hash available in the callback by accessing `request.env["omniauth.auth"]`:

```ruby
{
  "provider"=>"viddy",
  "uid"=>"1d3344aa-4a2f-430b-b48d-4dc4d3dcec2f",
  "info"=>{
    "full_name"=>"seanstavro",
    "username"=>"seanstavro",
    "profile"=>"http://www.viddy.com/seanstavro",
    "thumbnail"=>"http://cdn.viddy.com/images/users/thumb/1d3344aa-4a2f-430b-b48d-4dc4d3dcec2f_150x150.jpg?t=0",
    "profile_picture"=>"http://cdn.viddy.com/images/users/1d3344aa-4a2f-430b-b48d-4dc4d3dcec2f.jpg?t=0",
    "email"=>"sean@fullscreen.net",
    "name"=>"sean@fullscreen.net"
  },
  "credentials"=>{
    "token"=>"..."
  },
  "extra"=>{
    "user_info"=>{
      "username"=>"seanstavro",
      "profile"=>"http://www.viddy.com/seanstavro",
      "relationship_status"=>0,
      "following_count"=>41,
      "videos_count"=>0,
      "timestamp"=>13886861400000000,
      "thumbnail"=>{
        "url"=>"http://cdn.viddy.com/images/users/thumb/1d3344aa-4a2f-430b-b48d-4dc4d3dcec2f_150x150.jpg?t=0"
      },
      "email"=>"sean@fullscreen.net",
      "followers_count"=>5,
      "profile_picture"=>{
        "url"=>"http://cdn.viddy.com/images/users/1d3344aa-4a2f-430b-b48d-4dc4d3dcec2f.jpg?t=0"
      },
      "full_name"=>"seanstavro",
      "facebook_id"=>6411701,
      "unix_timestamp"=>1388686140,
      "id"=>"1d3344aa-4a2f-430b-b48d-4dc4d3dcec2f"
    }
  }
}
```

## License

Copyright (c) 2014 Sean Stavropoulos

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

