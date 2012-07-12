module Patento
  
  class Patent < Document
		
		def issue_date
			@issue_date ||= parse_date(:issue)
		end
		
		def intl_classification
			# Wow this was a pain
			@intl_classification ||= @html.css('#summarytable div.patent_bibdata').children[-7].text.match(/([A-Z0-9]{1,}\s[A-Z0-9]{1,})/)[1]
		end
		
		def backward_citations
			@backward_citations ||= parse_citations(:backward)
		end
		
  end
    
  
end