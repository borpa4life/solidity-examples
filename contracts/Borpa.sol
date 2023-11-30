// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token/oft/v1/OFT.sol";

contract Borpa is OFT {
    uint8 private _crossChainTaxRate;
    // Operator is only allowed to modify tax rates
    address private _operator;

    constructor(address _layerZeroEndpoint) OFT("Borpa", "Borpa", _layerZeroEndpoint) {
        _mint(msg.sender, 100_000_000 * 1e18);
        _operator = msg.sender;
    }

    function setCrossChainTax(uint8 _taxRate) external{
        require(msg.sender == _operator);
        require(_taxRate <= 20);
        _crossChainTaxRate = _taxRate;
    }

    function _creditTo(uint16, address _toAddress, uint _amount) internal override returns(uint) {
        uint256 tax = _amount * _crossChainTaxRate / 100;
        _mint(owner(), tax);
        _mint(_toAddress, _amount - tax);
        return _amount;
    }

    function setOperator(address _newOperator) external{
        require(msg.sender == _operator);
        _operator = _newOperator;
    }
}