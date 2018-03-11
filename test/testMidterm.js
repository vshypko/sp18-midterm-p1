'use strict';

/* Add the dependencies you're testing */
const Queue = artifacts.require("./Queue.sol");
const Token = artifacts.require("./Token.sol");
const Crowdsale = artifacts.require("./Crowdsale.sol");

contract('testMidterm', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */
	const args = {};
	const addresses = {first: "0x594fa8cf6dbe7c59b56fca5bd499124bb347f87d",
					   second: "0xc4a21f9a38b813b2c8e3f2e01c8d7547a99ed2b7",
					   third: "0xb6bec03d08dc57d492ab3143494f59ca2187dbdc",
					   fourth: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819",
					   fifth: "0x594fa8cf6dbe7c59b56fca5bd499124bb347f87d",
					   sixth: "0xc4a21f9a38b813b2c8e3f2e01c8d7547a99ed2b7"};
	let queue, token, crowdsale;

	/* Do something before every `describe` method */
	beforeEach(async function() {
        queue = await Queue.new();
		crowdsale = await Crowdsale.new();
	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguments and
	 * assert statements
	 */
	describe('~Queue tests~', function() {
		it("Empty queue", async function() {
			assert.equal(await queue.empty(), true);
			assert.equal(await queue.qsize(), 0);
		});
		it("Enqueue/Dequeue", async function() {
			await queue.enqueue(addresses.first);
			assert.equal(await queue.empty(), false);
			assert.equal(await queue.qsize(), 1);
			assert.equal(await queue.getFirst(), addresses.first);

			await queue.enqueue(addresses.second);
			assert.equal(await queue.qsize(), 2);
			assert.equal(await queue.getFirst(), addresses.first);

			await queue.enqueue(addresses.third);
			assert.equal(await queue.qsize(), 3);
			assert.equal(await queue.getFirst(), addresses.first);

			await queue.enqueue(addresses.fourth);
			assert.equal(await queue.qsize(), 4);
			assert.equal(await queue.getFirst(), addresses.first);

			await queue.enqueue(addresses.fifth);
			assert.equal(await queue.qsize(), 5);
			assert.equal(await queue.getFirst(), addresses.first);

			await queue.enqueue(addresses.sixth);
			assert.equal(await queue.qsize(), 5);
			assert.equal(await queue.getFirst(), addresses.first);

			await queue.dequeue();
			assert.equal(await queue.qsize(), 4);
			assert.equal(await queue.getFirst(), addresses.second);

			await queue.dequeue();
			assert.equal(await queue.qsize(), 3);
			assert.equal(await queue.getFirst(), addresses.third);

			await queue.dequeue();
			assert.equal(await queue.qsize(), 2);
			assert.equal(await queue.getFirst(), addresses.fourth);

			await queue.dequeue();
			assert.equal(await queue.empty(), false);
			assert.equal(await queue.qsize(), 1);
			assert.equal(await queue.getFirst(), addresses.fifth);

			await queue.dequeue();
			assert.equal(await queue.empty(), true);
			assert.equal(await queue.qsize(), 0);

			await queue.enqueue(addresses.sixth);
			assert.equal(await queue.empty(), false);
			assert.equal(await queue.qsize(), 1);
			assert.equal(await queue.getFirst(), addresses.sixth);
		});
	});

	describe('~Crowdsale tests~', function() {
		it("Crowdsale", async function() {
			let queue = crowdsale.queue;
			// assert.equal(await queue.empty(), true); // ??? TypeError: queue.empty is not a function
		});
	});
});
