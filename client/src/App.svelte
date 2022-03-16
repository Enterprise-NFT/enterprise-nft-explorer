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
  let ready = false;
  let selected;
</script>

<main transition>
  <h1>Enterprise NFT Explorer</h1>

  <Connect bind:account bind:provider />

  {#if account !== ""}
    <SelectEnterprise
      {registeredEnterprises}
      {account}
      {provider}
      bind:nftsUnderManagement
      bind:ready
      bind:selected
      bind:myOffers
    />

    {#if !ready && selected !== undefined && selected.name !== ""}
      <Spinner />
    {/if}

    {#if ready}
      <YourEnterpriseNfTs
        {registeredEnterprises}
        {account}
        {provider}
        {nftsUnderManagement}
      />

      <OtherEnterpriseNfTs
        {account}
        {provider}
        {nftsUnderManagement}
        {selected}
      />
    {/if}
  {/if}
</main>

<style>
  h1 {
    color: #40e0d0;
    font-size: 60px;
    font-weight: 300;
    margin-top: 0px;
    padding-top: 7vh;
  }

  main {
    background-color: black;
    text-align: center;
    height: 2000px;
    margin-top: 0px;
    padding-top: 0px;
  }

  :global(body) {
    /* this will apply to <body> */
    position: 0;
    position: relative;
    margin-left: 0px;
    padding-left: 0px;
    margin-right: 0px;
    padding-right: 0px;
    margin-top: 0px;
    padding-top: 0px;
    margin-bottom: 0px;
    padding-bottom: 0px;
    height: 100%;
    min-height: 100%;
  }
</style>
