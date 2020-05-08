window.spa.register(document, {

  onInit: async () => {
    console.log('add from database');
  },

  onMount: async () => {

    window.spa.mount({
      component: 'header',
      placeholder: 'header',
      props: {
        name: 'mitja',
        age: 35,
      }
    });

    window.spa.mount({
      component: 'picture-strip',
      placeholder: 'picture-strip',
    });

  },

});
