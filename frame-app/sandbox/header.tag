<pf-header>
  <p>{ message }</p>

  <script>
    export default {
      onMounted() {
        console.log('test2');
        this.message = 'header!!!!'
        this.update()
      },
      onUpdated() {
        console.log('test3');
      }
    }
  </script>
</pf-header>
