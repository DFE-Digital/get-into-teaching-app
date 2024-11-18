# NB: we are using a very old gem (https://github.com/pkorenev/rack-page_caching)
# which requires the deprecated Fixnum class - this is a patch to switch Fixnum --> Integer

module Rack
  class PageCaching
    module Utils
      def self.gzip_level(gzip)
        case gzip
        when Symbol
          Zlib.const_get(gzip.to_s.upcase)
        when Integer
          gzip
        else
          false
        end
      end
    end
  end
end
