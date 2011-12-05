require 'rest_client'
require 'json'
require 'ruby-debug'
require 'digest/md5'

module SrcMap
  extend self
  
  API_ENDPOINT = 'http://www.sourcemap.com/services/'
  VIEW_ENDPOINT = 'http://www.sourcemap.com/embed/';
  
  API_VERSION = '1.0';
  
  @@apikey='440eede6883ef143dfc84b7c863b0777'
  @@apisecret='23dae9ed5fc0949d53440dd41236ce20'
  
  class << self
    
    def to_string
      "Sourcemap Api Client Version:" + API_VERSION
    end
    
    def available
      get()
    end
    
    def get_supplychain(id)
      get(['supplychains', id])
    end
    
    def create_supplychain(data)
      post('supplychains', data)
    end
  
    def update_supplychain(data, id)
      put(['supplychains', id], data)
    end
    
    ##
    # either send the limit and offset numeric params or
    # a search term string
    #
    def get_supplychains(*args)
      if(args[0] && args[0].is_a?(Numeric))
        limit = args[0]
        offset = 0 unless offset = args[1]
        get(['supplychains', "?l=#{limit}", "&o=#{offset}"])
      elsif(args[0] && args[0].is_a?(String))
        get(['search', "?q=#{args[0]}"])
      else
        raise "Invalid Arguments"          
      end
    end
    
  end
  
  
  private
  
  ##
  # service is a string array to be appended to the url
  #
  def get(service = [])
    begin    
      url = API_ENDPOINT + service.join('/')
      hdrs = auth_headers()
      puts "Headers: #{hdrs}"
      
      response = RestClient.get(url, hdrs)
      raise "request failed with #{response.code}" unless response.code == 200
      
      json_hash = JSON.parse(response)
      
    rescue RestClient::Exception => e
      error_hash = JSON.parse(e.response)
    end
  end
  
  def post(service, data={})
    begin 
      url = API_ENDPOINT + '/' + service
      hdrs = auth_headers()
      hdrs['Content-Type'] = 'application/json'
      puts "Headers: #{hdrs}"
      
      response = RestClient.post(url, data, hdrs)
      
      raise "request failed with #{response.code}" unless response.code == 201
      json_hsh = JSON.parse(response)
      raise "error: created missed from response" unless supplychain_path = json_hsh['created']
      supplychain_id = supplychain_path[supplychain_path.rindex('/')+1 .. -1]
    rescue RestClient::Exception => e
      error_hash = JSON.parse(e.response)
      puts error_hash
      nil
    end
  end

  def put(service, data={})
    begin 
      url = API_ENDPOINT + service.join('/')
      hdrs = auth_headers()
      hdrs['Content-Type'] = 'application/json'
      puts "Headers: #{hdrs}"
      
      response = RestClient.put(url, data, hdrs)
      
      raise "request failed with #{response.code}" unless response.code == 202
      json_hsh = JSON.parse(response)
      raise "error: success message missing from reponse" unless json_hsh['success']
      true
    rescue RestClient::Exception => e
      error_hash = JSON.parse(e.response)
      puts error_hash
      false
    end
  end  
  
  def auth_headers()
    headers = {}
    headers['X-Sourcemap-API-Key'] = @@apikey
    date = auth_date()
    headers['Date']= date
    api_token = auth_token(date)
    headers['X-Sourcemap-API-Token'] = api_token
    return headers
  end
  
  
  def auth_date(time = nil)
    unless time
      time = Time.now()
    end
    return DateTime.parse(time.to_s).rfc2822
  end
  
  def auth_token(date)
    puts "date: #{date}"
    Digest::MD5.hexdigest("%s-%s-%s"%[date,@@apikey, @@apisecret])
  end
  
  
end

