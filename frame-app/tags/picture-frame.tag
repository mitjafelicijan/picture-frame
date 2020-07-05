<pictureFrame>

  <ul>
    <li each={ picture in state.pictures }>
      <img src="{ picture.blob }" onclick="{ showFullImage }" alt="{ picture.filename }">
    </li>
  </ul>

  <main if="{ state.featured }">
    <img src="{ state.featured }">
  </main>

  <script>

    export default {
      async loadImageStripFromDatabase() {
        let pictures = await db.pictures.toArray();
        if (pictures.length > 0) {
          this.update({
            pictures: pictures.reverse(),
            featured: pictures[0].blob || null,
          });
        }
      },

      async onMounted() {
        this.loadImageStripFromDatabase();
        const existingDeviceID = await db.config.where('key').equals('deviceID').toArray();
        deviceID = existingDeviceID[0].value;

        window.peer.on('connection', async (conn) => {
          conn.on('data', async (data) => {
            if (data.filetype.includes('image')) {
              console.log('==>', data)

              await db.pictures.add({
                filename: data.filename,
                blob: data.blob,
                date: new Date(),
              });

              //route.router.push(`${pathPrefix}#/picture-frame`);

              this.loadImageStripFromDatabase();
            }
          });
        });
      },

      async onUpdated(props, state) {
        //this.loadImageStripFromDatabase();
        //this.picture.blob = evt.target.src
      },

      async showFullImage(evt) {
        this.update({ featured: evt.target.src });
        //this.picture.blob = evt.target.src
      },
    }
  </script>

  <style scoped>
    :host {
      display: block;
    }

    ul {
      position: fixed;
      left: 0;
      bottom: 0;
      right: 0;
      list-style-type: none;
      padding: 0 10px;
      margin: 0;
      overflow-x: scroll;
      white-space: nowrap;
      /* opacity: 100%; */
    }

    ul li {
      display: inline-block;
    }

    ul li img {
      height: 100px;
      width: 100px;
      margin: 10px;
      object-fit: cover;
      cursor: pointer;
      border-radius: 5px;
    }

    main {
      position: fixed;
      left: 0;
      right: 0;
      top: 0;
      bottom: 150px;
    }

    main img {
      object-fit: contain;
      width: 100%;
      height: 100%;
      border: none;
    }
  </style>

</pictureFrame>
