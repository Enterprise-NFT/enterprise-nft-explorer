<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { erc721ABI } from "../abi-constants.ts";
    import { onMount } from "svelte";
    import Spinner from "./Spinner.svelte";
    import { UnitConverter } from "https://deno.land/x/units/mod-ethereum-blockchain.ts";

    export let account = "";
    export let provider;
    export let nftsUnderManagement = [];

    let erc721Contract;
    let userOwnsAtLeastOne = false;
    let nftAddressesUnderManagement = [];
    let ready = false;
    let selected = {};

    onMount(async () => {
        setInterval(async () => {
            // getNFTInfos();
        }, 5 * 1000);
    });

    async function requestService1() {
        const signer = await provider.getSigner();
        const erc721ContractWithSigner = erc721Contract.connect(signer);

        await erc721ContractWithSigner.executePurchaseRight1();
    }

    async function requestService2() {
        const signer = await provider.getSigner();
        const erc721ContractWithSigner = erc721Contract.connect(signer);

        await erc721ContractWithSigner.executePurchaseRight2();
    }

    async function acceptOffer(nftAddress) {
        erc721Contract = await new ethers.Contract(
            nftAddress,
            erc721ABI,
            provider
        );

        const ownerOfThisNFT = await erc721Contract.owner();

        const signer = await provider.getSigner();
        const erc721ContractWithSigner = erc721Contract.connect(signer);

        // const ownerFormatted = web3.utils.toChecksumAddress(ownerOfThisNFT);
        const ownerFormatted = ethers.utils.getAddress(ownerOfThisNFT);

        // alert(
        //     `I'll accept the highest offer for ${nftAddress} - the owner is: ${ownerOfThisNFT} - ${ownerFormatted}`
        // );
        await erc721ContractWithSigner.acceptHighestOffer();
    }
</script>

<p><br /></p>

<p><br /></p>

{#if !ready && selected.name !== undefined}
    <Spinner />
{/if}

<h3>Your JPM Enterprise NFTs</h3>
{#each nftsUnderManagement as nftUnderManagement}
    {#if nftUnderManagement.owner.toLowerCase() === account}
        <div class="list">
            <table>
                <tr>
                    <th> Artifact </th>
                    <th> Name </th>
                    <th> Development Service Purchase Right</th>
                    <th> Consulting Service Purchase Right </th>
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
                    <td>
                        <br />
                        {nftUnderManagement.purchaseRight1Status} <br />
                        <button on:click={requestService1}> Execute </button>
                    </td>
                    <td>
                        <br />
                        {nftUnderManagement.purchaseRight2Status} <br />
                        <button on:click={requestService2}> Execute </button>
                    </td>
                    <td>
                        <br /> Highest Bid: {UnitConverter.convert(
                            "Wei",
                            nftUnderManagement.highestOffer.amount,
                            "Ether"
                        )} Ether
                        <br />
                        {#if nftUnderManagement.highestOffer.amount > 0.0000000001}
                            <button
                                on:click={acceptOffer(
                                    nftUnderManagement.address
                                )}
                            >
                                Accept
                            </button>
                        {/if}
                    </td>
                </tr>
            </table>
        </div>
    {/if}
{/each}

<p><br /></p>
<p><br /></p>
<p><br /></p>

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
