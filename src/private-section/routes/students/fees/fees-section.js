export class FeesSection {
    configureRouter(config) {
        config.map(routes);
    }
}
export let routes = [
    { route: "/", name: "fees", moduleId: "./fees", title: "" },
    { route: "/:fee_id", name: "fee", moduleId: "./fee", title: "" },
]