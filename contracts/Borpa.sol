// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token/oft/v1/OFT.sol";

contract Borpa is OFT {
    uint256 public crossChainTaxRate;
    // Operator is only allowed to modify tax rates
    address private _operator;

    constructor(address _layerZeroEndpoint) OFT("Borpa", "BORPA", _layerZeroEndpoint) {
        _mint(msg.sender, 100_000_000 * 1e18);
        _operator = msg.sender;
    }

    function setCrossChainTax(uint256 _taxRate) external{
        require(msg.sender == _operator);
        // 20% Max
        require(_taxRate <= 200);
        crossChainTaxRate = _taxRate;
    }

    function _creditTo(uint16, address _toAddress, uint _amount) internal override returns(uint) {
        uint256 tax = _amount * crossChainTaxRate / 1000;
        _mint(_operator, tax);
        _mint(_toAddress, _amount - tax);
        return _amount;
    }

    function setOperator(address _newOperator) external{
        require(msg.sender == _operator);
        _operator = _newOperator;
    }
}