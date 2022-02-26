<script>
    let selected;
    let registeredEnterprises = ["company 1", "company 2", "company 3"];
    function getNFTInfos() {
        alert("ok");
    }
</script>

<select value={selected} on:change={getNFTInfos}>
    {#each registeredEnterprises as registeredEnterprise}
        <option value={registeredEnterprise}>
            {registeredEnterprise.name}
        </option>
    {/each}
</select>
