require "httparty"

module Klout

  class Request
    include HTTParty
  end

  class Score
    attr_accessor :users
    def initialize(response)
      self.users = []
      response["users"].each do |user|
        self.users << User.new(user)
      end
    end
  end

  class User
    attr_accessor :kscore, :twitter_screen_name, :twitter_id, :score
    def initialize(user)
      user.each {|name, value| send("#{name}=", value)}
    end
  end

  class Client
    attr_accessor :key

    def initialize(key)
      self.key = key
    end

    def score(usernames)
      options = {:users => usernames, :key => self.key}
      response = Request.get("http://api.klout.com/1/klout.json", :query => options)
      if response.code == 200
        Score.new(response)
      else
        raise "#{response.code} #{response.message}"
      end
    end

    def show(usernames)
      options = {:users => usernames, :key => self.key}
      response = Request.get("http://api.klout.com/1/users/show.json", :query => options)
      if response.code == 200
        Score.new(response)
      else
        raise "#{response.code} #{response.message}"
      end
    end

  end

end
