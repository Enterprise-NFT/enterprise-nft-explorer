<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { erc721ABI } from "../abi-constants.ts";
    import { onMount } from "svelte";
    import { UnitConverter } from "https://deno.land/x/units/mod-ethereum-blockchain.ts";

    export let account = "";
    export let provider;
    export let nftsUnderManagement = [];
    export let myNFTsUnderManagement = [];
    export let selectedEnterprise;

    let erc721Contract;
    let ready = false;

    onMount(async () => {
        for (const nft of nftsUnderManagement) {
            if (nft.owner.toLowerCase() === account) {
                myNFTsUnderManagement.push(nft);
            }
        }
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

        const ownerFormatted = ethers.utils.getAddress(ownerOfThisNFT);

        await erc721ContractWithSigner.acceptHighestOffer();
    }
</script>

<div class="row add-bottom">
    <div class="col-twelve">
        {#if myNFTsUnderManagement.length > 0}
            <h3>Your {selectedEnterprise.name} NFTs</h3>
            {#each myNFTsUnderManagement as nftUnderManagement}
                <div class="table-responsive">
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
                                <button on:click={requestService1}>
                                    Execute
                                </button>
                            </td>
                            <td>
                                <br />
                                {nftUnderManagement.purchaseRight2Status} <br />
                                <button on:click={requestService2}>
                                    Execute
                                </button>
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
            {/each}
        {/if}
    </div>
</div>

<style>
</style>
