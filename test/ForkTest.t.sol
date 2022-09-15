// SPDX-License-Identifier: AGPLv3
pragma solidity 0.8.16;

import "forge-std/Test.sol";
import "@superfluid-finance/ethereum-contracts/contracts/upgradability/UUPSProxiable.sol";

contract ForkTest is Test {

    constructor () {
        vm.createSelectFork("https://mainnet.optimism.io");
    }

    function testUpgradeAgain() public {
        address MULTISIG_GOV_OWNER = 0xb9349347fcC0318137e6143A01c6582C072Fb581;
        address OP_GOV = 0x0170FFCC75d178d426EBad5b1a31451d00Ddbd0D;
        address GOV_NEW_LOGIC = 0x9B815f3B8a0cE0CeD76Bb652f4B9E9a473d1DD04;

        vm.startPrank(MULTISIG_GOV_OWNER);

        UUPSProxiable govProxiable = UUPSProxiable(OP_GOV);
        address prevGov = govProxiable.getCodeAddress();
        assertTrue(prevGov != address(0));

        govProxiable.updateCode(GOV_NEW_LOGIC);
        assertEq(govProxiable.getCodeAddress(), GOV_NEW_LOGIC);

        govProxiable.updateCode(prevGov);
        assertEq(govProxiable.getCodeAddress(), prevGov);

        vm.stopPrank();
    }
}

