window.spa.register(document, {

  onInit: async () => {
  },

  onMount: async (props) => {
    console.log(props)
    return `<p>header</p>`;
  },

});
