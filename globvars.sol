//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract globvars{

// stores the information about a user 
    struct user{
        uint tripsCompletedAsCustomer;   // number of trips completed as customer
        uint ratingAsCustomer;          // rating given by drivers out of 100
        uint tripsCompletedAsDriver;    // number of trips completed as driver
        uint ratingAsDriver;            // rating given by customers out of 100
    }

// stores the information about a ride
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

    mapping (address => user) public  userInfo;    // mapping of user information to their address
    ride[] public rides;                            // array of all the rides till now

    mapping (address => bool) public isDriverRightNow;          // mapping to check if the address is working as driver currently
    mapping (address => bool) public isCustomerRightNow;          // mapping to check if the address is working as customer currently


    modifier notADriver(address _account) {
        require(isDriverRightNow[_account] == false , "You are currently active as driver");
        _;
    } 

    modifier notACustomer(address _account) {
        require(isCustomerRightNow[_account] == false , "You are already active as customer");
        _;
    } 

}