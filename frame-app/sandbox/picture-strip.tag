<pf-picture-strip>

  <ul>
    <li each={ picture in state.pictures }>
      <img src="{ picture.blob }" onclick="{ resetValue }" alt="{ picture.filename }">
    </li>
  </ul>

  <script>
    export default {
      state: {
        db: null,
        pictures: []
      },
      async onBeforeMount(props, state) {
        this.state.db = new Dexie('picture-frame');
        this.state.db.version(1).stores({
          pictures: '++id, filename, blob, date',
          config: '++id, key, value',
        });
      },
      async onMounted() {
        this.state.pictures = await this.state.db.pictures.toArray();
        this.update();
      },
      async onUpdated() { },

      async resetValue(evt) {
        console.log(evt.target)
      },
    }
  </script>

  <style scoped>
    :host {
      display: block;
      position: fixed;
      left: 0;
      bottom: 0;
      right: 0;
      background: red;
    }

    ul {
      list-style-type: none;
      padding: 0 10px;
      margin: 0;
      overflow-x: scroll;
      white-space: nowrap;
    }

    ul li {
      display: inline-block;
    }

    ul li img {
      height: 100px;
      width: 100px;
      padding: 10px;
      object-fit: cover;
      cursor: pointer;
      border-radius: 5px;
    }
  </style>

</pf-picture-strip>
