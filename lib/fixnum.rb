# NB: Fixnum (and Bignum) are deprecated classes as of Ruby 3.2
# However, we are using a very old gem (https://github.com/pkorenev/rack-page_caching)
# which requires Fixnum to be defined

# rubocop:disable Lint/UnifiedInteger
class Fixnum < Integer
end
# rubocop:enable Lint/UnifiedInteger
