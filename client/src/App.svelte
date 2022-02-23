<script>
  import { fade } from "svelte/transition";
  import Dashboard from "./components/Dashboard.svelte";
  import Title from "./components/Title.svelte";
</script>

<body>
  <main transition:fade>
    <Title />
    <Dashboard />
  </main>
</body>

<style>
  body {
    background-color: black;
    background-size: cover;
    margin-left: 0 auto;
    margin-right: auto;
    width: 100%;
    min-width: 100%;
  }
  main {
    text-align: center;
  }
</style>
