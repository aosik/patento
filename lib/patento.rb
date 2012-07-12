require 'nokogiri'
require 'net/http'

require 'patento/document'
require 'patento/patent'
require 'patento/publication'
require 'patento/claim'

module Patento
#	class Downloader
	  def self.download_html(number)
	    Net::HTTP.get_response(URI.parse("http://www.google.com/patents/US#{number}")).body
	  end
#  end
end

# Some quick string regex helpers 
class String
	# identifies if the text contains "N. ..." where N is the claim number
	def is_preamble?
		self.match(/^\d*\.\s/) ? true : false
	end	

	# identifiers if the text has " claim N " in it
	# note this is not foolproof since some claims aren't worded this way (few, but some)
	def is_independent?
		self.match(/\sclaim\s\d*\s/) ? true : false
	end
end