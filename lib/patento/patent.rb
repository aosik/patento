module Patento
  
  class Patent < Document

		# Note: attributes are lazily evaluated
    def initialize(number, options = {})
      @number = number.to_s
			if options[:local_path]
				@html = Nokogiri::HTML(File.read(options[:local_path]))
			else
      	@html = Nokogiri::HTML(Patento.download_html(number))
			end
    end

  end
    
  
end