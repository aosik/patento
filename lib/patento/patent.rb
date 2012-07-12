module Patento
  
  class Patent
    
    attr_accessor :number, :html
    
    # Note: attributes are lazily evaluated
    def initialize(number, options = {})
      @number = number.to_s
			if options[:local_path]
				@html = Nokogiri::HTML(File.read(options[:local_path]))
			else
      	@html = Nokogiri::HTML(Patento.download_html(number))
			end
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

		def intl_classification
			# Wow this was a pain
			@intl_classification ||= @html.css('#summarytable div.patent_bibdata').children[-7].text.match(/([A-Z0-9]{1,}\s[A-Z0-9]{1,})/)[1]
		end
    
		def filing_date
			@filing_date ||= parse_date(:filing)
		end
		
		def issue_date
			@issue_date ||= parse_date(:issue)
		end
		
		def claims
			@claims ||= Claim.parse_claims(@html)
		end
		
		def backward_citations
			@backward_citations ||= parse_backward_citations
		end
		
		def independent_claims
			independent_claims = []
			claims.each do |c| 
				if c[:type] == :independent 
					independent_claims << c 
				end
			end
			return independent_claims
		end
    
    # Helpers

		def parse_backward_citations
			trs = @html.css('#patent_citations_v tr')
			trs.shift
			citations = []
			trs.each do |row|
				citations << {
					number: row.css('td')[0].css('a').text.gsub(/^US/, ''),
					filing: Date.parse(row.css('td')[1].text),
					issue: Date.parse(row.css('td')[2].text),
					assignee: row.css('td')[3].text,
					title: row.css('td')[4].text
				}
			end				
			return citations
		end

		def parse_date(type)
			nodes = @html.css('#metadata_v .patent_bibdata p').children
			index = (type == :filing ? 4 : 7)
			Date.parse(nodes[index].text)
		end

    def parse_bibdata_for_key(key)
      @matches = @html.css('#summarytable div.patent_bibdata a').to_a
      @matches.collect! { |link| link.text if link.attr('href').match(key) }     
      @matches.compact!
      @matches = @matches.first if @matches.count == 1
      return @matches
    end
    
  end
  
end

class String
	def trim
		self.gsub(/^\s|^\r|^\n/,'').gsub(/\s$|\r$|\n$/,'')
	end
	
	def is_preamble?
		self.match(/^\d*\.\s/) ? true : false
	end
	
	def is_independent?
		self.match(/\sclaim\s\d*\s/) ? true : false
	end
	
end