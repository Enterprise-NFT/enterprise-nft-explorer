<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";

    import { erc721ABI, fiduciaryABI } from "../abi-constants.ts";

    export let nftsUnderManagement = [];
    export let account = "";
    export let selected;
    export let provider;

    let offer = {
        nftAddress: "",
        bid: 0,
    };
    // let bid = 0;

    async function makeOffer(nftAddress) {
        offer.nftAddress = nftAddress;
        alert(
            `I'll make an offer over ${offer.bid} Ether regarding ${offer.nftAddress}`
        );

        // const fiduciarySmartContract = await new ethers.Contract(
        //     selected.fiduciaryContractAddress,
        //     fiduciaryABI,
        //     provider
        // );

        const signer = await provider.getSigner();
        // const fiduciarySmartContractWithSigner =
        //     fiduciarySmartContract.connect(signer);

        // await fiduciarySmartContractWithSigner.makeOffer();

        const tx = signer.sendTransaction({
            to: selected.fiduciaryContractAddress,
            // data: offer.nftAddress,
            value: ethers.utils.parseEther(offer.bid.toString()).toString(),
        });

        console.log(tx);
    }
</script>

<h3>JPM Enterprise NFTs</h3>
{#each nftsUnderManagement as nftUnderManagement}
    {#if nftUnderManagement.owner !== account}
        <div class="list">
            <table>
                <tr>
                    <th> Artifact </th>
                    <th> Name </th>
                    <th> Owner</th>
                    <th> Highest Bid </th>
                    <th> Action </th>
                </tr>
                <tr>
                    <td style="width: fit-content;">
                        <img
                            src="https://raw.githubusercontent.com/Enterprise-NFT/nft-artifacts/main/EnterpriseNFTLogo.png"
                            width="40"
                            height="40"
                            alt=""
                        />
                    </td>
                    <td> {nftUnderManagement.name} </td>

                    {#if nftUnderManagement.owner === account}
                        <td> You </td>
                    {:else}
                        <td> {nftUnderManagement.owner} </td>
                    {/if}

                    <td> 0.5 Ether </td>

                    <td>
                        <input type="number" bind:value={offer.bid} /> <br />
                        <button
                            on:click={makeOffer(nftUnderManagement.address)}
                        >
                            Make Offer
                        </button>
                    </td>
                </tr>
            </table>
        </div>
    {/if}
{/each}

<style>
    .list {
        padding-top: 2em;
        color: white;
    }

    h3 {
        color: turquoise;
        font-size: 40px;
        font-weight: 200;
    }
    table {
        align-items: center;
        width: 100;
        margin-left: auto;
        margin-right: auto;
    }
    td,
    th {
        border: 1px solid white;
    }

    button {
        margin-top: 1em;
        margin-bottom: 1em;
        margin-left: 1em;
        margin-right: 1em;
    }
</style>
