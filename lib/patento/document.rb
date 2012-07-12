module Patento
	class Document
		
		attr_accessor :number, :html
    
    # Attributes
    def title
      @title ||= @html.css('.main-title').text.split(' - ')[1]
    end
    
    def abstract
      @abstract ||= @html.css('.patent_abstract_text').text
    end
    
    def inventors
      @inventors ||= parse_bibdata_links_for_url_match('q=ininventor:')
    end
    
    def assignee
      @assignee ||= parse_bibdata_links_for_url_match('q=inassignee:')
    end
    
    def us_classifications
      @us_classifications ||= parse_bibdata_links_for_url_match('q=http://www.uspto.gov/web/patents/classification/')
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
			@backward_citations ||= parse_citations(:backward)
		end
		
		def forward_citations
			@forward_citations ||= parse_citations(:forward)
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

		def parse_citations(type)
			container = (type == :backward ? '#patent_citations_v tr' : '#patent_referenced_by_v tr')
			trs = @html.css(container)
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

    def parse_bibdata_links_for_url_match(pattern)
      @matches = @html.css('#summarytable div.patent_bibdata a').to_a
      @matches.collect! { |link| link.text if link.attr('href').match(pattern) }     
      @matches.compact!
      @matches = @matches.first if @matches.count == 1
      return @matches
    end
    
	end
end