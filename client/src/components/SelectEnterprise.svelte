<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { erc721ABI, fiduciaryABI } from "../abi-constants.ts";

    export let registeredEnterprises;
    export let selected = {};
    export let account = "{}";
    export let provider;
    export let ready = false;
    export let nftsUnderManagement = [];

    let nftAddressesUnderManagement = [];
    let erc721Contract;
    let userOwnsAtLeastOne = false;

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
</script>

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

<style>
</style>
