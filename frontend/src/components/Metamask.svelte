<script>
    import { onMount } from "svelte";

    let account;

    function enterApp() {
        alert("drink");
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
</script>

<button on:click={enterApp}> Enter App </button>

<p><br /></p>

{account}

<style>
</style>
