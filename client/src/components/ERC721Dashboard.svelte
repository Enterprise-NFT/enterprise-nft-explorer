<script>
    import { ethers } from "https://cdn.skypack.dev/ethers";
    import { erc721AllInOneABI } from "../abi-constants.ts";

    import { onMount } from "svelte";

    let contractAddress = "0xc5e961ad6019c42cafd7609f3517be5cd0f767d8";
    let erc721AllInOneContract;
    let erc721AllInOneContractWithSigner;

    let purchaseRight1Status = "";
    let purchaseRight2Status = "";

    let account = "";
    let provider;

    async function requestService1() {
        const signer = await provider.getSigner();
        const erc721AllInOneContractWithSigner =
            erc721AllInOneContract.connect(signer);

        await erc721AllInOneContractWithSigner.executePurchaseRight1();
    }

    async function requestService2() {
        const signer = await provider.getSigner();
        const erc721AllInOneContractWithSigner =
            erc721AllInOneContract.connect(signer);

        await erc721AllInOneContractWithSigner.executePurchaseRight2();
    }

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

            erc721AllInOneContract = await new ethers.Contract(
                contractAddress,
                erc721AllInOneABI,
                provider
            );

            purchaseRight1Status =
                await erc721AllInOneContract.getPurchaseRight1Status();
            purchaseRight2Status =
                await erc721AllInOneContract.getPurchaseRight2Status();
        }
    }

    onMount(async () => {
        // const result = ethers.Wallet.createRandom();
        // console.log(result);
        setInterval(async () => {
            if (account !== "") {
                purchaseRight1Status =
                    await erc721AllInOneContract.getPurchaseRight1Status();
                purchaseRight2Status =
                    await erc721AllInOneContract.getPurchaseRight2Status();
            }
        }, 3 * 1000);
    });

    function buyNFT() {
        alert(`buying the NFT`);
    }

    function sellNFT() {
        alert(`selling an NFT`);
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
{#if purchaseRight1Status !== ""}
    <h3>Your JPM Enterprise NFTs</h3>

    <div class="list">
        <table>
            <tr>
                <th> Artifact </th>
                <th> Name </th>
                <th> Purchase Right 1</th>
                <th> Purchase Right 2 </th>
                <th> Current Value</th>
                <th> Sell NFT </th>
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
                <td> JPM Enterprise NFT </td>
                <td>
                    <br />
                    {purchaseRight1Status} <br />
                    <button on:click={requestService1}> Execute </button>
                </td>
                <td>
                    <br />
                    {purchaseRight2Status} <br />
                    <button on:click={requestService2}> Execute </button>
                </td>

                <td> 1 ETH </td>

                <td>
                    <button on:click={sellNFT}> Sell </button>
                </td>
            </tr>
        </table>
    </div>
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
