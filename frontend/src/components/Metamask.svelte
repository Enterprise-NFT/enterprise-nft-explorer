<script>
    function enterApp() {
        alert("drink");
        if (typeof window.ethereum !== "undefined") {
            alert("MetaMask is installed!");
        }
    }
</script>

<button on:click={enterApp}> Enter App </button>

<style>
</style>
