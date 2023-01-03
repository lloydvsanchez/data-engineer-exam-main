require 'yaml'
require 'json'
require 'fileutils'

class Transform
  def self.run(source_file)
    new(source_file).send(:perform)
  end

  private

  attr_accessor :source_file

  def initialize(source_file)
    @source_file = source_file
    fail 'missing source file' unless source_file
  end

  def perform
    body = JSON.parse(File.read(source_file))
    body.each do |place|
      next unless place.dig('global_pluscode')

      filename = build_filename(place.dig('global_pluscode'))
      append_entry(filename, place)
    end
  rescue Errno::ENOENT
    fail "Unknown source file - #{source_file}"
  end

  def build_filename(pluscode)
    [pluscode[0..4], pluscode[4..5], pluscode[6..7]].join('/') + '.json'
  end

  def append_entry(filename, place)
    FileUtils.mkdir_p(File.dirname(filename))
    File.open(filename, 'a') { |f| f.puts place.to_json }
  end
end

Transform.run(YAML.load_file('env')&.dig('source_file'))
