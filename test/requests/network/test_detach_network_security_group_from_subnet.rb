require File.expand_path '../../test_helper', __dir__

# Test class for Detach Network Security Group from Subnet Request
class TestDetachNetworkSecurityGroupFromSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @subnets = @network_client.subnets
  end

  def test_detach_network_security_group_from_subnet_success
    mocked_response = ApiStub::Requests::Network::Subnet.create_subnet_response(@network_client)
    @subnets.stub :create_or_update, mocked_response do
      assert_equal @service.detach_network_security_group_from_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network', '10.1.0.0/24', 'table-id'), mocked_response
    end
  end

  def test_detach_network_security_group_from_subnet_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @subnets.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.detach_network_security_group_from_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network', '10.1.0.0/24', 'table-id')
      end
    end
  end
end
