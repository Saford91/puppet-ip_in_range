module Puppet::Parser::Functions

  require 'ipaddr'

  newfunction(:ip_in_range, :type => :rvalue, :arity => 2, :doc =>
    "ip_in_range returns true if the ipaddress is within the CIDR
    usage: ip_in_range(<IPv4 Address>, <IPv4 CIDR>)


    $valid_ip = ip_in_range('10.10.10.53', '10.10.10.0/24') # $valid_ip == true

    # or in a condidtional

    if ip_in_range($ipaddress, '10.10.200.0/24') == true {
      notify { 'Do subnet based resources here': }
    }

    ") do |args|

    unless (args.length == 2)
      raise ArgumentError, ("ip_in_range(): wrong number of arguments (#{args.length} must be 2)")
    end

    # load in the ip validation function from puppetlabs-stdlib
    unless Puppet::Parser::Functions.function('is_ip_address')
      raise Puppet::ParseError, "ip_in_range(): requires the puppetlabs-stdlib functions"
    end

    unless function_is_ip_address( [ args[0] ] )
      error = 'is an invalid ip address'
      raise ArgumentError, "ip_in_range(): [#{args[0]}] #{error}"
    end

    if args[1].is_a? Array
      args[1].each do |ipaddress|
        unless function_is_ip_address( [ ipaddress ] )
          error = 'is an invalid ip address'
          raise ArgumentError, "ip_in_range(): [#{ipaddress}] #{error}"
        end
      end
    else
      unless function_is_ip_address( [ args[1] ] )
        error = 'is an invalid ip address'
        raise ArgumentError, "ip_in_range(): [#{args[1]}] #{error}"
      end
    end
    # Now we're done with the boilerplate do the actual check

    begin
      ip = IPAddr.new( args[0] )
      inRange = false
      if args[1].kind_of?(Array)
        args[1].each do |ipaddress|
          range = IPAddr.new(ipaddress)
          if range.include?( ip )
            inRange = true
          end
        end
      else
        range = IPAddr.new( args[1] )
        inRange = range.include?( ip )
      end
    rescue ArgumentError => e
      raise ArgumentError, "ip_in_range(): #{e.to_s}"
    end

    return inRange
  end
end
