<script>
    import { onMount } from "svelte";
    let account = "";
    let yourNFTs = [
        {
            link: "https://raw.githubusercontent.com/Enterprise-NFT/nft-artifacts/main/EnterpriseNFTLogo.png",
            name: "Enterprise NFT Consulting",
            purchasingBalance: 2,
            currentValueInEth: 5,
        },
        {
            link: "https://raw.githubusercontent.com/Enterprise-NFT/nft-artifacts/main/EnterpriseNFTLogo.png",
            name: "Company XYZ NFT",
            purchasingBalance: 200,
            currentValueInEth: 5,
        },
    ];

    let newNFTs = [
        {
            link: "https://raw.githubusercontent.com/Enterprise-NFT/nft-artifacts/main/EnterpriseNFTLogo.png",
            name: "Enterprise NFT Consulting",
            purchasingBalance: 2,
            currentValueInEth: 5,
        },
        {
            link: "https://raw.githubusercontent.com/Enterprise-NFT/nft-artifacts/main/EnterpriseNFTLogo.png",
            name: "Company XYZ NFT",
            purchasingBalance: 200,
            currentValueInEth: 5,
        },
    ];

    function requestService() {
        alert(`requesting service is under construction`);
    }

    function enterApp() {
        if (typeof window.ethereum !== "undefined") {
            console.log("MetaMask is installed!");

            ethereum.request({ method: "eth_requestAccounts" });
        }
    }

    onMount(async () => {
        const accounts = await ethereum.request({
            method: "eth_requestAccounts",
        });
        account = accounts[0];
    });

    function buyNFT() {
        alert(`buying the NFT is under construction`);
    }

    function sellNFT() {
        alert(`selling the NFT is under construction`);
    }
</script>

<div class="account">
    {#if account !== ""}
        You are logged in via the following browserwallet: <p />
        {account}.
    {:else}
        <button on:click={enterApp}> Enter App </button>
    {/if}
</div>

<p><br /></p>

<h3>Your NFTs</h3>

<div class="list">
    <table>
        <tr>
            <th> Artifact </th>
            <th> Name </th>
            <th> ServiceBalance </th>
            <th> Request Service </th>
            <th> Current Value</th>
            <th> Sell NFT </th>
        </tr>
        {#each yourNFTs as nft}
            <tr>
                <td style="width: fit-content;">
                    <img src={nft.link} width="40" height="40" alt="" />
                </td>
                <td>
                    {nft.name}
                </td>
                <td>
                    {nft.purchasingBalance}
                </td>
                <td>
                    <button on:click={requestService}> Request Service </button>
                </td>

                <td>
                    {nft.currentValueInEth} ETH
                </td>

                <td>
                    <button on:click={sellNFT}> List for Sale </button>
                </td>
            </tr>
        {/each}
    </table>
</div>

<p><br /></p>

<h3>New NFTs</h3>

<div class="list">
    <table>
        <tr>
            <th> Artifact </th>
            <th> Name </th>
            <th> Current Value</th>
            <th> Buy NFT </th>
        </tr>
        {#each newNFTs as nft}
            <tr>
                <td style="width: fit-content;">
                    <img src={nft.link} width="40" height="40" alt="" />
                </td>
                <td>
                    {nft.name}
                </td>

                <td>
                    {nft.currentValueInEth} ETH
                </td>

                <td>
                    <button on:click={buyNFT}> Make an Offer </button>
                </td>
            </tr>
        {/each}
    </table>
</div>

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
