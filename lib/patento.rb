require 'nokogiri'
require 'net/http'

require 'patento/patent'
require 'patento/claim'

module Patento
#	class Downloader
	  def self.download_html(number)
	    Net::HTTP.get_response(URI.parse("http://www.google.com/patents/US#{number}")).body
	  end
#  end
end