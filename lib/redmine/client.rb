require 'nokogiri'
require 'open-uri'

module Redmine
  class Client
    include Redmine::Debug

    NAMESPACE = { "atom" => "http://www.w3.org/2005/Atom" }
    attr_accessor :key, :domain, :protocol

    def initialize(options = {})
      options = {
        :key      => nil,
        :domain   => nil,
        :protocol => "http",
        :debug    => true
      }.merge(options)

      @debug    = options[:debug]
      @key      = options[:key]
      @domain   = options[:domain]
      @protocol = options[:protocol]

      debug "[CLIENT]" do
        puts options
      end
    end

    def my_issues(limit = nil)
      projects = {}

      doc.xpath('//atom:entry', NAMESPACE ).each do |e|
        id = e.xpath('.//atom:id', NAMESPACE).first.content.split("/").last
        raw_title = e.xpath('.//atom:title', NAMESPACE).first.content
        regex = /([^-]*) - (.*)/
        match = raw_title.match(regex)
        project = match[1]
        title   = match[2]


        projects[project] ||= []
        projects[project] << {
          :id => id,
          :title => title
        }
      end

      debug "[URL]" do
        puts issues_url
      end

      return projects
    end

    def doc
      @doc ||= Nokogiri::XML(open(issues_url))
    end

    def reset
      @doc = nil
    end

    private
    def base_url
      "#{protocol}://#{domain}/"
    end

    def issues_url
      "#{base_url}issues.atom?assigned_to_id=me&key=#{key}&set_filter=1&sort=priority%3Adesc%2Cupdated_on%3Adesc"
    end
  end
end

