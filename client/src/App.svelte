<script>
  import { fade } from "svelte/transition";
  import ERC721Dashboard from "./components/ERC721Dashboard.svelte";
  import Title from "./components/Title.svelte";
</script>

<div>
  <body>
    <main transition:fade>
      <Title />
      <ERC721Dashboard />
    </main>
  </body>
</div>

<style>
  div {
    background-color: black;
    background-size: cover;
  }
  body {
    background-color: black;
    background-size: cover;
    margin-left: 0 auto;
    margin-right: auto;
    width: 100%;
    min-width: 100%;
    height: 100%;
    min-height: 100%;
  }
  main {
    text-align: center;
  }
</style>
