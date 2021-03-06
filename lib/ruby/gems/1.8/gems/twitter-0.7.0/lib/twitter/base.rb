module Twitter
  class Base
    extend Forwardable
    
    def_delegators :client, :get, :post, :put, :delete
    
    attr_reader :client
    
    def initialize(client)
      @client = client
    end
    
    # Options: since_id, max_id, count, page, since
    def friends_timeline(query={})
      perform_get('/statuses/friends_timeline.json', :query => query)
    end
    
    # Options: id, user_id, screen_name, since_id, max_id, page, since
    def user_timeline(query={})
      perform_get('/statuses/user_timeline.json', :query => query)
    end
    
    def status(id)
      perform_get("/statuses/show/#{id}.json")
    end
    
    # Options: in_reply_to_status_id
    def update(status, query={})
      perform_post("/statuses/update.json", :body => {:status => status}.merge(query))
    end
    
    # Options: since_id, max_id, since, page
    def replies(query={})
      perform_get('/statuses/replies.json', :query => query)
    end
    
    def status_destroy(id)
      perform_post("/statuses/destroy/#{id}.json")
    end
    
    # Options: id, user_id, screen_name, page
    def friends(query={})
      perform_get('/statuses/friends.json', :query => query)
    end
    
    # Options: id, user_id, screen_name, page
    def followers(query={})
      perform_get('/statuses/followers.json', :query => query)
    end
    
    def user(id, query={})
      perform_get("/users/show/#{id}.json", :query => query)
    end
    
    # Options: since, since_id, page
    def direct_messages(query={})
      perform_get("/direct_messages.json", :query => query)
    end
    
    # Options: since, since_id, page
    def direct_messages_sent(query={})
      perform_get("/direct_messages/sent.json", :query => query)
    end
    
    def direct_message_create(user, text)
      perform_post("/direct_messages/new.json", :body => {:user => user, :text => text})
    end
    
    def direct_message_destroy(id)
      perform_post("/direct_messages/destroy/#{id}.json")
    end
    
    def friendship_create(id, follow=false)
      body = {}
      body.merge!(:follow => follow) if follow
      perform_post("/friendships/create/#{id}.json", :body => body)
    end
    
    def friendship_destroy(id)
      perform_post("/friendships/destroy/#{id}.json")
    end
    
    def friendship_exists?(a, b)
      perform_get("/friendships/exists.json", :query => {:user_a => a, :user_b => b})
    end
    
    # Options: id, user_id, screen_name
    def friend_ids(query={})
      perform_get("/friends/ids.json", :query => query, :mash => false)
    end
    
    # Options: id, user_id, screen_name
    def follower_ids(query={})
      perform_get("/followers/ids.json", :query => query, :mash => false)
    end
    
    def verify_credentials
      perform_get("/account/verify_credentials.json")
    end
    
    # Device must be sms, im or none
    def update_delivery_device(device)
      perform_post('/account/update_delivery_device.json', :body => {:device => device})
    end
    
    # One or more of the following must be present:
    #   profile_background_color, profile_text_color, profile_link_color, 
    #   profile_sidebar_fill_color, profile_sidebar_border_color
    def update_profile_colors(colors={})
      perform_post('/account/update_profile_colors.json', :body => colors)
    end
    
    def rate_limit_status
      perform_get('/account/rate_limit_status.json')
    end
    
    # One or more of the following must be present:
    #   name, email, url, location, description
    def update_profile(body={})
      perform_post('/account/update_profile.json', :body => body)
    end
    
    # Options: id, page
    def favorites(query={})
      perform_get('/favorites.json', :query => query)
    end
    
    def favorite_create(id)
      perform_post("/favorites/create/#{id}.json")
    end
    
    def favorite_destroy(id)
      perform_post("/favorites/destroy/#{id}.json")
    end
    
    def enable_notifications(id)
      perform_post("/notifications/follow/#{id}.json")
    end
    
    def disable_notifications(id)
      perform_post("/notifications/leave/#{id}.json")
    end
    
    def block(id)
      perform_post("/blocks/create/#{id}.json")
    end
    
    def unblock(id)
      perform_post("/blocks/destroy/#{id}.json")
    end
    
    def help
      perform_get('/help/test.json')
    end
    
    def list_create(list_owner_username, options)
      perform_post("/#{list_owner_username}/lists.json", :body => {:user => list_owner_username}.merge(options))
    end
    
    def list_update(list_owner_username, slug, options)
      perform_put("/#{list_owner_username}/lists/#{slug}.json", :body => options)
    end
    
    def list_delete(list_owner_username, slug)
      perform_delete("/#{list_owner_username}/lists/#{slug}.json")
    end
    
    def lists(list_owner_username=nil)
      path = "http://api.twitter.com/1"
      path += "/#{list_owner_username}" if list_owner_username
      path += "/lists.json"
      perform_get(path)
    end
    
    def list(list_owner_username, slug)
      perform_get("/#{list_owner_username}/lists/#{slug}.json")
    end
    
    def list_timeline(list_owner_username, slug)
      perform_get("/#{list_owner_username}/lists/#{slug}/statuses.json")
    end
    
    def memberships(list_owner_username)
      perform_get("/#{list_owner_username}/lists/memberships.json")
    end
    
    def list_members(list_owner_username, slug)
      perform_get("/#{list_owner_username}/#{slug}/members.json")
    end
    
    def list_add_member(list_owner_username, slug, new_id)
      perform_post("/#{list_owner_username}/#{slug}/members.json", :body => {:id => new_id})
    end
    
    def list_remove_member(list_owner_username, slug, id)
      perform_delete("/#{list_owner_username}/#{slug}/members.json", :body => {:id => id})
    end
    
    def is_list_member?(list_owner_username, slug, id)
      perform_get("/#{list_owner_username}/#{slug}/members/#{id}.json").error.nil?
    end
    
    def list_subscribers(list_owner_username, slug)
      perform_get("/#{list_owner_username}/#{slug}/subscribers.json")
    end
    
    def list_subscribe(list_owner_username, slug)
      perform_post("/#{list_owner_username}/#{slug}/subscribers.json")
    end
    
    def list_unsubscribe(list_owner_username, slug)
      perform_delete("/#{list_owner_username}/#{slug}/subscribers.json")
    end
    
    private
      def perform_get(path, options={})
        Twitter::Request.get(self, path, options)
      end
      
      def perform_post(path, options={})
        Twitter::Request.post(self, path, options)
      end
      
      def perform_put(path, options={})
        Twitter::Request.put(self, path, options)
      end
      
      def perform_delete(path, options={})
        Twitter::Request.delete(self, path, options)
      end
  end
end