require 'yaml'
require 'uri'
require 'net/http'
require 'json'

class Extract
  def self.run(params)
    new(params).send(:perform)
  end

  private

  attr_accessor :lat, :lng, :api_key, :source_file, :places

  def initialize(params)
    @places      = []
    %w(lat lng api_key source_file).each do |k|
      val = params[k]
      fail "#{k} missing parameter" if val.nil?
      instance_variable_set("@#{k}", val)
    end
  end

  def perform
    api_call
    write
  end

  def api_call(page_token = nil)
    params = build_params(page_token)

    data = generic_call(params)
    store(data["results"])
    api_call(data["next_page_token"]) if data["next_page_token"]
  end

  def build_params(page_token = nil)
    params = { key: api_key }
    if page_token
      params.merge!({ page_token: page_token})
    else
      params.merge!({ location: [lat, lng].join(','),
                      radius:   2000,
                      type:     'restaurant' })
    end
  end

  def url
    'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
  end

  def generic_call(params)
    uri = URI(url)
    uri.query = URI.encode_www_form(params)
    res = Net::HTTP.get_response(uri)
    res.is_a?(Net::HTTPSuccess) ? ::JSON.parse(res.body) : nil
  end

  def store(arr)
    return unless arr

    arr.each { |e| places << relevant_info(e)  }
  end

  def write
    Dir.mkdir 'var'
  rescue Errno::EEXIST
    #do nothing
  ensure
    puts "Output: #{source_file}"
    File.write(source_file, places.to_json)
  end

  def relevant_info(element)
    {
      name:            element.dig('name'),
      place_id:        element.dig('place_id'),
      location:        element.dig('geometry', 'location').values.join(','),
      global_pluscode: element.dig('plus_code', 'global_code'),
      vicinity:        element.dig('vicinity')
    }
  end
end

y = YAML.load_file('env')
params = y.dig('map')
params.merge!({ 'source_file' => y.dig('source_file') })

Extract.run(params)
