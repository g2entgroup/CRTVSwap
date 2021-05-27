// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Collection.sol";

contract CollectionFactory is Ownable {
    mapping(address => address) internal collectionowner;
    address[] public collections;

    /** =================== mutative function =================== */
    function create(
        string memory _name,
        string memory _symbol,
        string memory _baseuri,
        address _owner
        ISuperfluid host,
        IConstantFlowAgreementV1 cfa,
        ISuperToken acceptedToken
    ) external returns (address) {
        require( _owner != address(0), "you must set a address");
        Collection collectionaddress = new Collection(_owner,_name,_symbol,_baseuri,host,cfa,acceptedToken);
        collectionowner[address(collectionaddress)] = _owner;
        collections.push(address(collectionaddress));
        emit createNFTContract( _name, _symbol, address(collectionaddress));
        return address(collectionaddress);
    }


    /** =================== view =================== */
    function getlength() external view returns (uint){
        return collections.length;
    }

    function getcollection(address nftaddress) external view returns (address) {
        return collectionowner[nftaddress];
    }


    /** =================== event =================== */
    event createNFTContract(string indexed name, string indexed symbol,address indexed collectionaddress);

}