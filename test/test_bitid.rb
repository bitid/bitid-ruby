require 'test/unit'
require 'bitid'

class TestBitid < Test::Unit::TestCase

  def setup
    @nonce = "fe32e61882a71074"
    @callback = "http://localhost:3000/callback"
    @uri = "bitid://localhost:3000/callback?x=fe32e61882a71074"
    @address = "1HpE8571PFRwge5coHiFdSCLcwa7qetcn"
    @signature = "H1cDvRY+UbKNbwlHuS6rJ9376C7RF7NxYB6fZTNEOQo4/UFXezcK0uv1+3/fejJJAMKrnkGEo1Ue00pWB8Gu9SQ="
  end

  def test_build_uri
    bitid = Bitid.new(nonce:@nonce, callback:@callback)
    
    assert !bitid.uri.nil?
    assert_equal "bitid", bitid.uri.scheme
    assert_equal "localhost", bitid.uri.host
    assert_equal 3000, bitid.uri.port
    assert_equal "/callback", bitid.uri.path

    params = CGI::parse(bitid.uri.query)
    assert_equal @nonce, params['x'].first
  end

  def test_build_qrcode
    bitid = Bitid.new(nonce:@nonce, callback:@callback)

    uri_encoded = CGI::escape(bitid.message)
    assert_equal "http://chart.apis.google.com/chart?cht=qr&chs=300x300&chl=#{uri_encoded}", bitid.qrcode
  end

  def test_build_message
    bitid = Bitid.new(nonce:@nonce, callback:@callback)

    assert_match /\ABitcoin Signed Message\:\nbitid\:\/\/localhost\:3000\/callback\?x=/, bitid.message
  end

  def test_verify_uri
    bitid = Bitid.new(address:@address, uri:@uri, signature:@signature, callback:@callback)
    assert bitid.uri_valid?
  end

  def test_fail_uri_verification_if_bad_uri
    bitid = Bitid.new(address:@address, uri:'garbage', signature:@signature, callback:@callback)
    assert !bitid.uri_valid?
  end

  def test_fail_uri_verification_if_bad_scheme
    bitid = Bitid.new(address:@address, uri:'http://localhost:3000/callback?x=fe32e61882a71074', signature:@signature, callback:@callback)
    assert !bitid.uri_valid?
  end

  def test_fail_uri_verification_if_invalid_callback_url
    bitid = Bitid.new(address:@address, uri:'site.com/callback?x=fe32e61882a71074', signature:@signature, callback:@callback)
    assert !bitid.uri_valid?
  end

  def test_verify_signature
    bitid = Bitid.new(address:@address, uri:@uri, signature:@signature, callback:@callback)
    assert bitid.signature_valid?
  end

  def test_fail_verification_if_invalid_signature
    bitid = Bitid.new(address:@address, uri:@uri, signature:"garbage", callback:@callback)
    assert !bitid.signature_valid?
  end

  def test_fail_verification_if_signature_text_doesnt_match
    bitid = Bitid.new(address:@address, uri:@uri, signature:"H4/hhdnxtXHduvCaA+Vnf0TM4UqdljTsbdIfltwx9+w50gg3mxy8WgLSLIiEjTnxbOPW9sNRzEfjibZXnWEpde4=", callback:@callback)
    assert !bitid.signature_valid?
  end

  def test_extract_nonce
    bitid = Bitid.new(address:@address, uri:@uri, signature:@signature, callback:@callback)
    assert_equal "fe32e61882a71074", bitid.nonce
  end  
end