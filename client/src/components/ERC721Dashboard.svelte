<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { erc721ABI, fiduciaryABI } from "../abi-constants.ts";

    import { afterUpdate } from "svelte";
    import { onMount } from "svelte";

    let erc721Contract;
    let erc721ContractWithSigner;
    let erc721ToBeTransferredContract;
    let erc721ToBeTransferredContractWithSigner;

    let targetWallet;
    let nftToBeTransferredAddress;
    let userOwnsAtLeastOne = false;
    let nftAddressesUnderManagement = [];
    let nftsUnderManagement = [];
    let ready = false;

    let account = "";
    let provider;
    let selected = "";

    let registeredEnterprises = [
        { name: "", fiduciaryContractAddress: "" },
        {
            name: "Jan Patrick Michael Development (JPM Development)",
            fiduciaryContractAddress:
                "0x104F8EF85899E154425AA1CA3cCfB3032aeb5bc1",
        },
        { name: "Company 2 (Comp 2)", fiduciaryContractAddress: "" },
        { name: "Company 3 (Comp 2)", fiduciaryContractAddress: "" },
    ];

    // afterUpdate(() => {
    //     alert("hier");
    // });

    async function connectToBrowserWallet() {
        if (typeof window.ethereum === "undefined") {
            alert("You need to install a browserwallet like metamask.io.");
        } else {
            const accounts = await ethereum.request({
                method: "eth_requestAccounts",
            });
            account = accounts[0];
            provider = new ethers.providers.Web3Provider(
                window.ethereum,
                "any"
            );

            // await getNFTInfos();
        }
    }

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
            // const signer = await provider.getSigner();
            // const erc721ContractWithSigner = erc721Contract.connect(signer);
            // nftUnderManagement.owner = await erc721ContractWithSigner.owner();

            nftUnderManagement.purchaseRight1Status =
                await erc721Contract.getPurchaseRight1Status();

            nftUnderManagement.purchaseRight2Status =
                await erc721Contract.getPurchaseRight2Status();

            nftsUnderManagement.push(nftUnderManagement);
        }
        ready = true;
    }

    function refreshNFTData() {
        // if (account !== "") {
        //         purchaseRight1Status =
        //             await erc721Contract.getPurchaseRight1Status();
        //         purchaseRight2Status =
        //             await erc721Contract.getPurchaseRight2Status();
        //     }
    }
    onMount(async () => {
        // const result = ethers.Wallet.createRandom();
        // console.log(result);
        setInterval(async () => {
            refreshNFTData();
        }, 3 * 1000);
    });

    function buyNFT() {
        alert(`buying the NFT`);
    }

    function sellNFT() {
        alert(`selling an NFT`);
    }

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

    async function transfer() {
        const signer = await provider.getSigner();

        erc721ToBeTransferredContract = await new ethers.Contract(
            nftToBeTransferredAddress,
            erc721ABI,
            provider
        );

        erc721ToBeTransferredContractWithSigner =
            erc721ToBeTransferredContract.connect(signer);

        await erc721ToBeTransferredContractWithSigner.transferOwnership(
            targetWallet
        );
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

<div class="account">
    {#if account !== ""}
        You are logged in via the following browserwallet: <p />
        {account}.
    {:else}
        <button on:click={connectToBrowserWallet}>Connect Browserwallet</button>
    {/if}
</div>

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

{#if ready}
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
                            {#if nftUnderManagement.owner === account}
                                <button on:click={sellNFT}>
                                    List for Sale
                                </button>
                            {:else}
                                <button on:click={sellNFT}> Make Offer </button>
                            {/if}
                        </td>
                    </tr>
                </table>
            </div>
        {/if}
    {/each}

    <p><br /></p>
    <p><br /></p>
{/if}

<style>
    .list,
    .account {
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
