require 'nokogiri'
require 'open-uri'

require_relative 'entry'

module OStatus

  # This class represents an OStatus Feed object.
  class Feed
    def initialize(url, access_token, author, entries)
      @url = url
      @access_token = access_token
      @author = author
      @entries = entries
    end

    # Creates a new Feed instance given by the atom feed located at 'url'
    # and optionally using the OAuth::AccessToken given.
    def Feed.from_url(url, access_token = nil)
      Feed.new(url, access_token, nil, nil)
    end

    # Creates a new Feed instance that contains the information given by
    # the various instances of author and entries.
    def Feed.from_data(author, entries)
      Feed.new(nil, nil, author, entries)
    end

    # This method will return a String containing the actual content of
    # the atom feed. It will make a network request (through OAuth if
    # an access token was given) to retrieve the document if necessary.
    def atom
      if @access_token == nil
        # simply open the url
        open(@url).read
      elsif @url != nil
        # open the url through OAuth
        @access_token.get(@url).body
      else
        # build the atom file from internal information
      end
    end

    # Returns an OStatus::Author that will parse the author information
    # within the Feed.
    def author
      return @author unless @author == nil

      xml = Nokogiri::XML::Document.parse(self.atom)

      author_xml = xml.at_css('author')
      OStatus::Author.new(author_xml)
    end

    # This method gives you an array of OStatus::Entry instances for 
    # each entry listed in the feed.
    def entries
      return @entries unless @entries == nil

      xml = Nokogiri::XML::Document.parse(self.atom)
      entries_xml = xml.css('entry')

      entries_xml.map do |entry|
        OStatus::Entry.new(entry)
      end
    end
  end
end
