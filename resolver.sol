
contract ENS {
    function owner(bytes32 node) constant returns (address);
    function resolver(bytes32 node) constant returns (Resolver);
    function ttl(bytes32 node) constant returns (uint64);
    function setOwner(bytes32 node, address owner);
    function setSubnodeOwner(bytes32 node, bytes32 label, address owner);
    function setResolver(bytes32 node, address resolver);
    function setTTL(bytes32 node, uint64 ttl);
}

contract Resolver {
    function addr(bytes32 node) constant returns (address);
}

contract ProtocolResolver {
    ENS ens;
    mapping(bytes32 => ProtocolRecord) records;
    
    struct ProtocolRecord {
        address owner;
        bytes value;
    }
    
    function ProtocolResolver(address _ens) public
    {
        ens = ENS(_ens);
    }
    
    function setValue(bytes32 _host, bytes _value) payable {
        require(msg.sender == ens.owner(_host));
        
        address owner = records[_host].owner;
        if (owner != msg.sender) {
            records[_host].owner = msg.sender;
        }
        records[_host].value = _value;
    }
    
    function getValue(bytes32 _host) public constant returns(bytes)
    {
        ProtocolRecord rec = records[_host];
        
        // Check if record value is set by current host owner for security reasons.
        require(rec.owner == ens.owner(_host));
        
        return rec.value;
    }
}
