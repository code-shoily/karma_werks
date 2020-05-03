let Hooks = {}
Hooks.SessionHook = {
    mounted() {
        let form = this.el;
        form.submit()
    }
}

export default Hooks;