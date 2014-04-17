require 'uri'
require 'cgi'
require 'bitcoin-cigs'

class Bitid

  SCHEME = 'bitid'
  PARAM_NONCE = 'x'
  SIGNATURE_HEADER = "Bitcoin Signed Message:\n"

  attr_accessor :nonce, :callback, :signature, :uri

  def initialize hash={}
    @nonce = hash[:nonce]
    @callback = URI(hash[:callback])
    @signature = hash[:signature]
    @address = hash[:address]
    @uri = hash[:uri].nil? ? build_uri : URI(hash[:uri])
  end

  def uri_valid?
    params = CGI::parse(@uri.query)
    !@uri.nil? && @uri.scheme == SCHEME && @uri.host == @callback.host && @uri.path == @callback.path && !params[PARAM_NONCE][0].nil?
  rescue
  end

  def signature_valid?
    BitcoinCigs.verify_message(@address, @signature, message)
  end

  def qrcode
    "http://chart.apis.google.com/chart?cht=qr&chs=300x300&chl=" + CGI::escape(message)
  end

  def nonce
    CGI::parse(@uri.query)[PARAM_NONCE][0]
  end

  def message
    SIGNATURE_HEADER + @uri.to_s
  end

  def callback
    @callback
  end

  private

  def build_uri
    uri = @callback
    uri.scheme = SCHEME
    uri.query = URI.encode_www_form({PARAM_NONCE => @nonce})
    uri
  end
end