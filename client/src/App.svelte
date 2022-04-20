<script>
  import Connect from "./components/Connect.svelte";
  import OtherEnterpriseNfTs from "./components/OtherEnterpriseNFTs.svelte";
  import SelectEnterprise from "./components/SelectEnterprise.svelte";
  import Spinner from "./components/Spinner.svelte";
  import YourEnterpriseNfTs from "./components/YourEnterpriseNFTs.svelte";
  import { registeredEnterprises } from "./master-data.ts";

  let account = "";
  let provider = "";
  let myOffers;
  let nftsUnderManagement = [];
  let mode = "";
  let selectedEnterprise = {};
</script>

<main transition>
  <section id="main-content" class="s-styles">
  <div class="row narrow section-intro add-bottom text-center">
    <h1>Enterprise NFT Explorer</h1>

    <Connect bind:account bind:provider />

    {#if account !== ""}
      <SelectEnterprise
        {registeredEnterprises}
        {account}
        {provider}
        bind:nftsUnderManagement
        bind:mode
        bind:selectedEnterprise
        bind:myOffers
      />

      {#if mode === "readingFromBlockchain"}
        reading data from blockchain - this may take some seconds
        <Spinner />
      {/if}

      {#if mode === "ready"}
        <YourEnterpriseNfTs
          {registeredEnterprises}
          {account}
          {provider}
          {nftsUnderManagement}
          {selectedEnterprise}
        />

        <OtherEnterpriseNfTs
          {account}
          {provider}
          {nftsUnderManagement}
          {selectedEnterprise}
        />
      {/if}
    {/if}
  </div>
</section>
</main>

<style>
  main {
    text-align: center;
  }
</style>
