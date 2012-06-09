require 'geokit'
module Geokit
  module Geocoders
    class GoogleGeocoder3 < Geocoder
      def self.do_geocode(address, options = {})
        bias_str = options[:bias] ? construct_bias_string_from_options(options[:bias]) : ''
        address_str = address.is_a?(GeoLoc) ? address.to_geocodeable_s : address
        #use CGI.escape instead of Geokit::Inflector::url_escape
        url ="http://maps.google.com/maps/api/geocode/json?sensor=false&address=#{CGI.escape(address_str)}#{bias_str}"
        res = self.call_geocoder_service(url)
        return GeoLoc.new if !res.is_a?(Net::HTTPSuccess)
        json = res.body
        # escape results of json
        logger.debug "Google geocoding. Address: #{address}. Result: #{CGI.escape(json)}"
        return self.json2GeoLoc(json, address)
      end
    end
  end
end
