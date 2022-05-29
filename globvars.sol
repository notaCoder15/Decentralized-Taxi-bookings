//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract globvars{

    struct user{
        uint tripsCompletedAsCustomer;
        uint ratingAsCustomer;
        uint tripsCompletedAsDriver;
        uint ratingAsDriver;
    }

    struct ride {
        address customer;
        string from;
        string to;
        uint amount;
        Status status;
        address driver;
    }

    enum Status {
        Requested,
        Accepted,
        Canceled,
        Ongoing,
        Completed
    }

    mapping (address => user) public  userInfo;
    ride[] public rides;

    mapping (address => bool) public isDriverRightNow;
    mapping (address => bool) public isCustomerRightNow;


    modifier notADriver(address _account) {
        require(isDriverRightNow[_account] == false , "You are currently active as driver");
        _;
    } 

    modifier notACustomer(address _account) {
        require(isCustomerRightNow[_account] == false , "You are already active as customer");
        _;
    } 

}