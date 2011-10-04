require 'rubygems'
require 'gapps_openid'
require 'test/fixtures'
require 'test/unit'

class DiscoveryTest < Test::Unit::TestCase

  def test_parse_certs_valid
    xml = Fixtures.read_file('google-site-xrds.xml')
    certs = OpenID::SimpleSign.parse_certificates(REXML::Document.new(xml))
    assert(certs.length == 2, "Expected 2 certificates")
  end

  def test_parse_no_certs
    xml = Fixtures.read_file('missing-signature.xml')
    certs = OpenID::SimpleSign.parse_certificates(REXML::Document.new(xml))
    assert(certs.length == 0)
  end
  
  def test_parse_malformed_certs
    xml = Fixtures.read_file('malformed-cert.xml')
    begin
      certs = OpenID::SimpleSign.parse_certificates(REXML::Document.new(xml))
      assert(false, "Expected parse_certificates to fail")
    rescue
    end
  end
  
  def test_validate_chain
    xml = Fixtures.read_file('google-site-xrds.xml')
    certs = OpenID::SimpleSign.parse_certificates(REXML::Document.new(xml))
    assert(certs.length == 2, "Expected 2 certificates")
    assert(OpenID::SimpleSign.valid_chain?(certs), "Cert chain should be valid")
  end

  def test_validate_broken_chain
    xml = Fixtures.read_file('broken-chain.xml')
    certs = OpenID::SimpleSign.parse_certificates(REXML::Document.new(xml))    
    assert(!OpenID::SimpleSign.valid_chain?(certs), "Cert chain should not be valid")
  end
  
  def test_verify_signature_ok
    xml = Fixtures.read_file('google-site-xrds.xml')
    authority = OpenID::SimpleSign.verify(xml,"P6K9C29tTKAJ3NZb9fYZ65vrkt7FUqiZS1Xf5N36yO4mePjaDtcwObCgVeNSYmyIk3qVv1g5zILSAbci+PDLdrpLBobH5PgSzLPXjPXURxEeCl7GOAM1ncEn6DF1eyItMDRPdYpKk0o+tEOUV6hhZhzlH5J1hHIFh2g8YO9eswU=")
    assert( authority == "hosted-id.google.com", "Invalid authority")
  end

  def test_verify_bad_signature
    xml = Fixtures.read_file('google-site-xrds.xml')
    begin
      OpenID::SimpleSign.verify(xml,"AGYbbl99vk2GoK4+HEBPuu6buV5YWMtX2fk5TNNTiMweXC+bibnJ6KqSqMVKz6IjB3S9ONbnTUdntJhdmlqQ0Or9nTRjCPNz/bkEQ3/l0NOP4DMVbx5yhzp2QeZ86MNy9biD+Z6HsHl49X3puB8zBQ7vG2mIrJ+jE/cNZwCPNio=")
      assert(false, "Expected no authority")
    rescue
    end
  end

end
