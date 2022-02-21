import { opine, serveStatic } from "https://deno.land/x/opine@2.1.2/mod.ts";

const app = opine();
const pathToAssets = `${Deno.cwd()}/frontend/docs`
const pathToIndexHTML = `${pathToAssets}/index.html`

app.use(serveStatic(pathToAssets))

app.get("/", function (req, res) {
    res.sendFile(pathToIndexHTML);
});

const port = Deno.args[0]
app.listen(
    port,
    () => console.log(`server has started on http://localhost:${port} 🚀`),
);