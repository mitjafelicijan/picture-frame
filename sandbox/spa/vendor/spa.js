(function(window, document){

  window.spa = {
    placeholders: {},
    components: {},
    state: {
      data: {},
    },
    mount: async (props) => {
      console.log(props);
      if (props.hasOwnProperty('onMount')) {
        await props.onMount(props.props);
      }

      // const content = window.spa.components[props.component].content;
      // const placeholder = window.spa.placeholders[props.placeholder].element;
      // placeholder.innerHTML = content;
    },
    register: async (module, props) => {
      const componentName = module.currentScript.src.split('\\').pop().split('/').pop().replace('.js', '');
      // console.log('registring', componentName, 'with props', props);

      if (module.currentScript.hasAttribute('autoload')) {
        if (props.hasOwnProperty('onMount')) {
          await props.onMount();
        }
      }

      //window.spa.components[componentName] = {
      //  content: props.hasOwnProperty('onInit') ? await props.onInit() : null,
      //}
    },
  }

  for (const placeholder of document.querySelectorAll('layout [spa-placeholder]')) {
    window.spa.placeholders[placeholder.id] = {
      element: placeholder,
      data: {},
    };
  }

})(window, document);
