<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { depotABI } from "../abi-constants.ts";

    // export let account = "";
    export let provider;
    let depotContractAddress = "0x5C866EE38DB28f508E5FaDD17d3f1BBBdA11516a";
    let amount = 0;

    async function deposit() {
        const signer = await provider.getSigner();
        const tx = signer.sendTransaction({
            to: depotContractAddress,
            // data: offer.nftAddress,
            value: ethers.utils.parseEther("0.1").toString(),
        });

        console.log(tx);
    }

    async function withdraw() {
        const depotContract = await new ethers.Contract(
            depotContractAddress,
            depotABI,
            provider
        );
    }
</script>

<input type="number" bind:value={amount} />
<br />
<button on:click={deposit}> Deposit Amount </button>
<br />
<button on:click={withdraw}> Withdraw All </button>

<style>
</style>
