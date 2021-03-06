require 'spec_helper'

describe 'ip_in_range' do
  # Basic functionality tests
  #################################################
  it 'should return true when the ip is contained in the range' do
    should run.with_params('192.168.100.12', '192.168.100.0/24').and_return(true)
  end

  it 'should return false when an ip is not in the range' do
    should run.with_params('10.10.10.10', '192.168.100.0/24').and_return(false)
  end

  # Invalid function call tests
  #################################################
  it 'should throw an ArgumentError unless called with 2 arguments' do
    expect { subject.call([1, 2, 3]) }.to raise_error(ArgumentError)
  end

  it 'should throw an ArgumentError with an invalid ip address' do
    expect { subject.call(['300.2.3.4', '192.168.100.0/24']) }.to raise_error(ArgumentError)
  end

  it 'Should throw an ArgumentError with an invalid ip range' do
    expect { subject.call(['192.168.100.12', '192.168.100.0/242']) }.to raise_error(ArgumentError)
  end
end
