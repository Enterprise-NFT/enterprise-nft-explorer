<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { erc721ABI, fiduciaryABI } from "../abi-constants.ts";
    import { onMount } from "svelte";
    import Spinner from "./Spinner.svelte";

    export let registeredEnterprises;
    export let account = "";
    export let provider;

    let erc721Contract;
    let userOwnsAtLeastOne = false;
    let nftAddressesUnderManagement = [];
    let nftsUnderManagement = [];
    let ready = false;
    let selected = {};

    async function getNFTInfos() {
        const fiduciarySmartContract = await new ethers.Contract(
            selected.fiduciaryContractAddress,
            fiduciaryABI,
            provider
        );

        nftAddressesUnderManagement =
            await fiduciarySmartContract.getNFTsUnderManagement();

        for (const nftAddressUnderManagement of nftAddressesUnderManagement) {
            let nftUnderManagement = {};
            erc721Contract = await new ethers.Contract(
                nftAddressUnderManagement,
                erc721ABI,
                provider
            );

            nftUnderManagement.address = nftAddressUnderManagement;
            nftUnderManagement.name = await erc721Contract.name();
            nftUnderManagement.owner = (
                await erc721Contract.owner()
            ).toLowerCase();

            if (nftUnderManagement.owner === account) {
                userOwnsAtLeastOne = true;
            }

            nftUnderManagement.purchaseRight1Status =
                await erc721Contract.getPurchaseRight1Status();

            nftUnderManagement.purchaseRight2Status =
                await erc721Contract.getPurchaseRight2Status();

            nftsUnderManagement.push(nftUnderManagement);
        }
        ready = true;
    }

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
</script>

<p><br /></p>

{#if account !== ""}
    <h3>In which company are you interested in?</h3>
    <!-- <select value={selected} on:change={() => getNFTInfos}> -->
    <select bind:value={selected} on:change={getNFTInfos}>
        {#each registeredEnterprises as registeredEnterprise}
            <option value={registeredEnterprise}>
                {registeredEnterprise.name}
            </option>
        {/each}
    </select>
{/if}
<p><br /></p>

{#if !ready && selected.name !== undefined}
    <Spinner />
{/if}

{#if ready && userOwnsAtLeastOne}
    <h3>Your JPM Enterprise NFTs</h3>
    {#each nftsUnderManagement as nftUnderManagement}
        {#if nftUnderManagement.owner === account}
            <div class="list">
                <table>
                    <tr>
                        <th> Artifact </th>
                        <th> Name </th>
                        <th> Development Service Purchase Right</th>
                        <th> Consulting Service Purchase Right </th>
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
                    </tr>
                </table>
            </div>
        {/if}
    {/each}

    <p><br /></p>
    <p><br /></p>
{/if}
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
