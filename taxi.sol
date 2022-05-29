//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./globvars.sol";

contract taxi is globvars {
    event rideRequested(string _from , string _to , uint indexed _id);
    event rideCancelled(uint indexed _id);

    function requestRide(string memory _from , string memory _to , uint _amount ) public notADriver(msg.sender) notACustomer(msg.sender) returns(uint _id){
        
        ride memory Ride;
        Ride.customer = msg.sender;
        Ride.from = _from;
        Ride.to = _to;
        Ride.amount = _amount;
        Ride.status = Status.Requested;

        rides.push(Ride);
        isCustomerRightNow[msg.sender] = true;

        _id = (rides.length -1) ;
        emit rideRequested(_from, _to, _id);
    }

    function cancelRide(uint _id) public {
        require(rides[_id].status == Status.Requested , "Ride is ongoing rightNow, cannot cancel");
        require(rides[_id].customer == msg.sender , "You are not the customer");

        rides[_id].status = Status.Canceled;
        isCustomerRightNow[msg.sender] = false;
        emit rideCancelled(_id);
    }

    
    function AcceptOffer(uint _id ) public notADriver(msg.sender) notACustomer(msg.sender) {
        require(rides[_id].status == Status.Requested , "ride not avaliable right now");
        rides[_id].status = Status.Accepted;
        rides[_id].driver = msg.sender;
        isDriverRightNow[msg.sender] = true;
    }

    function startRide(uint _id) public {
        require(rides[_id].status == Status.Accepted , "Ride is not in accepted state");
        require(rides[_id].driver == msg.sender ,"You are not the driver for this ride");

        rides[_id].status = Status.Ongoing;
    }

    function finishRideAsDriver(uint _id , uint rating) public {
        require(rides[_id].driver == msg.sender ,"You are not the driver for this ride");
        require(rides[_id].status == Status.Completed , "Ride is not in completed state");
        require(rating <= 100 , "Rating range not correct");


        isDriverRightNow[msg.sender] = false;
        
        userInfo[msg.sender].tripsCompletedAsDriver += 1;
        userInfo[rides[_id].customer].ratingAsCustomer = ((userInfo[rides[_id].customer].ratingAsCustomer * (userInfo[rides[_id].customer].tripsCompletedAsCustomer - 1)) +
                                                            rating ) / ((userInfo[rides[_id].customer].tripsCompletedAsCustomer)) ;

    }

    function finishRideAsCustomer(uint _id , uint rating) public {
        require(rides[_id].customer == msg.sender ,"You are not the customer for this ride");
        require(rides[_id].status == Status.Ongoing , "Ride is not in ongoing state");
        require(rating <= 100 , "Rating range not correct");

        isCustomerRightNow[msg.sender] = false;
        rides[_id].status = Status.Completed;

        userInfo[msg.sender].tripsCompletedAsCustomer += 1;
        userInfo[rides[_id].driver].ratingAsDriver = ((userInfo[rides[_id].driver].ratingAsDriver * userInfo[rides[_id].driver].tripsCompletedAsDriver) +
                                                            rating ) / ((userInfo[rides[_id].driver].tripsCompletedAsDriver) + 1) ;


    }

}