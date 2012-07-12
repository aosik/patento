module Patento
  
  class Patent
    
    attr_accessor :number
    
    # Note: attributes are lazily evaluated
    def initialize(number)
      @number = number.to_s
      @html = Nokogiri::HTML(Patent.download_html(number))
    end
    
    # Attributes
    def title
      @title ||= @html.css('.main-title').text.split(' - ')[1]
    end
    
    def abstract
      @abstract ||= @html.css('.patent_abstract_text').text
    end
    
    def inventors
      @inventors ||= parse_bibdata_for_key('q=ininventor:')
    end
    
    def assignee
      @assignee ||= parse_bibdata_for_key('q=inassignee:')
    end
    
    def us_classifications
      @us_classifications ||= parse_bibdata_for_key('q=http://www.uspto.gov/web/patents/classification/')
    end
    
    
    # Helpers
    def parse_bibdata_for_key(key)
      @matches = @html.css('#summarytable div.patent_bibdata a').to_a
      @matches.collect! { |link| link.text if link.attr('href').match(key) }     
      @matches.compact!
      @matches = @matches.first if @matches.count == 1
      return @matches
    end
    
    
    
    # Class Methods
    def self.download_html(number)
      Net::HTTP.get_response(URI.parse("http://www.google.com/patents/US#{number}")).body
    end
    
  end
  
end