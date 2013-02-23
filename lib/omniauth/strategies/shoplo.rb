# oa-oauth/lib/omniauth/strategies/shoplo.rb
require 'omniauth/oauth'
require 'multi_json'

module OmniAuth
  module Strategies
    #
    # Authenticate to Rdio via OAuth and retrieve basic user information.
    # Usage:
    #    use OmniAuth::Strategies::Rdio, 'consumerkey', 'consumersecret'
    #
    class Shoplo < OmniAuth::Strategies::OAuth
	    	def auth_hash
	  OmniAuth::Utils.deep_merge(super, {
	    'uid'       => user_hash['key'],
	    'user_info' => user_info,
	    'extra'     => { 'user_hash' => user_hash }
	  })
		end

	def user_info
	  user = user_hash
	  {
	    'nickname'   => user['username'],
	    'first_name' => user['firstName'],
	    'last_name'  => user['lastName'],
	    'name'       => "#{user['firstName']} #{user['lastName']}"
	  }
	end


	def auth_hash
	  OmniAuth::Utils.deep_merge(super, {
	    'uid'       => user_hash['key'],
	    'user_info' => user_info,
	    'extra'     => { 'user_hash' => user_hash }
	  })
	end

	def user_info
	  user = user_hash
	  {
	    'nickname'   => user['username'],
	    'first_name' => user['firstName'],
	    'last_name'  => user['lastName'],
	    'name'       => "#{user['firstName']} #{user['lastName']}"
	  }
	end

	def user_hash
	  @user_hash ||= MultiJson.decode(@access_token.post("http://api.shoplo.com/services/shop", {
	    :method => 'currentUser',
	    :extras => 'username'
	  }).body)['result']
	end

  end
  
  end
end