<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { erc721ABI, fiduciaryABI } from "../abi-constants.ts";

    import { onMount } from "svelte";

    let fiduciaryContractAddress = "0x104F8EF85899E154425AA1CA3cCfB3032aeb5bc1";

    let erc721Contract;
    let erc721ContractWithSigner;
    let erc721ToBeTransferredContract;
    let erc721ToBeTransferredContractWithSigner;

    let targetWallet;
    let nftToBeTransferredAddress;

    let nftAddressesUnderManagement = [];
    let nftsUnderManagement = [];
    let ready = false;

    let account = "";
    let provider;

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

            await getNFTInfosAboutMyOwnNFTs();
        }
    }

    async function getNFTInfosAboutMyOwnNFTs() {
        const fiduciarySmartContract = await new ethers.Contract(
            fiduciaryContractAddress,
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

<div class="account">
    {#if account !== ""}
        You are logged in via the following browserwallet: <p />
        {account}.
    {:else}
        <button on:click={connectToBrowserWallet}>Connect Browserwallet</button>
    {/if}
</div>

<p><br /></p>
<p><br /></p>
<h3>Your JPM Enterprise NFTs</h3>

{#if ready}
    {#each nftsUnderManagement as nftUnderManagement}
        {#if nftUnderManagement.owner === account}
            <div class="list">
                <table>
                    <tr>
                        <th> Artifact </th>
                        <th> Name </th>
                        <th> Purchase Right 1</th>
                        <th> Purchase Right 2 </th>
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

    <input
        type="text"
        bind:value={targetWallet}
        placeholder="...enter target wallet"
    />
    <p><br /></p>
    <input
        type="text"
        bind:value={nftToBeTransferredAddress}
        placeholder="...enter nft address to be transferred"
    />
    <p><br /></p>
    <button on:click={transfer}> Transfer Now </button>
{/if}
<p><br /></p>

<h3>JPM Enterprise NFTs</h3>
{#if ready}
    {#each nftsUnderManagement as nftUnderManagement}
        {#if nftUnderManagement.owner !== account}
            <div class="list">
                <table>
                    <tr>
                        <th> Artifact </th>
                        <th> Name </th>
                        <th> Purchase Right 1</th>
                        <th> Purchase Right 2 </th>
                        <th> Owner</th>
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

                        {#if nftUnderManagement.owner === account}
                            <td> You </td>
                        {:else}
                            <td> {nftUnderManagement.owner} </td>
                        {/if}

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

    <input
        type="text"
        bind:value={targetWallet}
        placeholder="...enter target wallet"
    />
    <p><br /></p>
    <input
        type="text"
        bind:value={nftToBeTransferredAddress}
        placeholder="...enter nft address to be transferred"
    />
    <p><br /></p>
    <button on:click={transfer}> Transfer Now </button>
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
