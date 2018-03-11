pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
    /* State variables */
    uint8 size = 5;
    uint8 numOfPeople;
    uint frontTimeLimit;
    uint frontTimer;
    address[5] queue;
    mapping (address => uint8) addressPosition;

    /* Add events */
    event EjectFront(address ejectedAddress);

    /* Add constructor */
    function Queue () public {
        numOfPeople = 0;
        frontTimeLimit = 5 minutes;
    }

    /* Returns the number of people waiting in line */
    function qsize() constant returns(uint8) {
        return numOfPeople;
    }

    /* Returns whether the queue is empty or not */
    function empty() constant returns(bool) {
        return numOfPeople == 0;
    }

    /* Returns the address of the person in the front of the queue */
    function getFirst() constant returns(address) {
        return queue[0];
    }

    /* Allows `msg.sender` to check their position in the queue */
    function checkPlace() constant returns(uint8) {
        return addressPosition[msg.sender];
    }

    /* Allows anyone to expel the first person in line if their time
     * limit is up */
    function checkTime() {
        address toEject = getFirst();
        if ((frontTimer + frontTimeLimit) < now) {
            dequeue();
        }
        EjectFront(toEject);
    }

    /* Removes the first person in line; either when their time is up or when
    * they are done with their purchase */
    function dequeue() {
        if (numOfPeople > 0) {
        	delete addressPosition[queue[0]];
	        delete queue[0];
	        numOfPeople--;

	        for (uint i = 0; i < numOfPeople; i++) {
	            queue[i] = queue[i+1];
	            addressPosition[queue[i]]--;
	        }

	        frontTimer = now;
        }
    }

    /* Places `addr` in the first empty position in the queue */
    function enqueue(address addr) {
    	if (numOfPeople < size) {
    		queue[numOfPeople] = addr;
	        addressPosition[addr] = numOfPeople;
	        numOfPeople++;

	        if (addressPosition[addr] == 0) {
	            frontTimer = now;
	        }
    	}
    }
}
