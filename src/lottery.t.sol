pragma solidity^0.4.19;

import "./lottery.sol";
import "ds-test/test.sol";

contract LotteryMock is Lottery {
    function LotteryMock(Token _token, Forum _forum) Lottery(_token, _forum) public {}
    function setRewardPool(uint256 _rewardPool) public {
        rewardPool = _rewardPool;
    }
}
contract LotteryTest is DSTest {
    Token token;
    Forum forum;
    LotteryMock lottery;
    function setUp() public {
        token = new Token(5);
        forum = new Forum();
        lottery = new LotteryMock(token, forum);
    }
    function test_reward() public {
        lottery.setRewardPool(5000);
        assertEq(lottery.reward(0), 2000);
        assertEq(lottery.reward(1), 1250);
        assertEq(lottery.reward(2), 1000);
        assertEq(lottery.reward(3), 500);
        assertEq(lottery.reward(4), 250);

        assertEq(lottery.rewardPool(),
            lottery.reward(0)
            + lottery.reward(1)
            + lottery.reward(2)
            + lottery.reward(3)
            + lottery.reward(4)
        );
    }

    function test_epoch() public {
        forum.post(0x0, 0x0);
        forum.post(0x0, 0x0);

        lottery.endEpoch();
        assertEq(lottery.payouts(0), 0);
        assertEq(lottery.epochPrior(), 0);
        assertEq(lottery.epochCurrent(), 3);

        lottery.vote(2);
        lottery.vote(1);
        lottery.endEpoch();
        assertEq(lottery.payouts(0), this);
        assertEq(lottery.payouts(1), this);
        assertEq(lottery.payouts(2), 0);
        assertEq(lottery.payouts(3), 0);
        assertEq(lottery.payouts(4), 0);
        assertEq(lottery.epochCurrent(), lottery.epochPrior());

        //lottery.claim(0);
        //lottery.claim(1);
    }
}