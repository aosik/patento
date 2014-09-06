module Patento

  class Claim
    attr_accessor :number, :type, :preamble, :body

    def self.from_hash(hash)
      claim = Claim.new
      claim.number = hash[:number]
      claim.type = hash[:type]
      claim.preamble = hash[:preamble]
      claim.body = hash[:body]
      return claim
    end

    def self.extract_all(number, options ={})
      if options[:local_path]
        html = Nokogiri::HTML(File.read(options[:local_path]))
      else
        html = Nokogiri::HTML(Patento.download_html(number))
      end
      parse_claims(html)
    end
    
    def self.parse_claims(html)
      hash = parse_claims_from_html(html)
      formatted_claims = []
      hash.each do |hash|
        formatted_claims << Claim.from_hash(hash)
      end
      return formatted_claims
    end

    def self.parse_claims_from_html(html)
      elements = html.at_css('#patent_claims_v').children
      claims = []
      index  = -1
      elements.each do |element|
        next if element.children.empty?
        if element.text.is_preamble?
          index += 1
          claims[index] = {
            number: index + 1,
            type: (element.text.match(/\sclaim\s\d*\s/) ? :dependent : :independent),
            preamble: element.text.gsub(/^\d*\.\s/,''),
            body: []
          }
        else
          claims[index][:body] = parse_dl(element)
        end
      end
      return claims
    end

    def self.parse_dl(element)
      elements = []
      index = 0
      element.children.each do |e|
        unless e.css('dl').empty? # nested elements
          elements[index-1] = [elements[index-1]]
          elements[index-1] << parse_dl(e.css('dl')) # god i hate recursion
        else # plain ol elements
          elements << e.text
          index += 1
        end
      end
      elements
    end
  end
end
