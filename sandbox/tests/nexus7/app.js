const debug = document.getElementById('debug');
const refresh = document.getElementById('refresh');
const video = document.querySelector('video');

refresh.addEventListener('click', (evt) => {
  window.location.reload();
})

function log (message) {
  debug.value += message + '\n';
  console.log(message);
}

if (!('indexedDB' in window)) {
  log('Indexed DB: FAILURE');
} else {
  log('Indexed DB: OK');
}

if (typeof localStorage !== 'undefined') {
  log('Local Storage: OK');
} else {
  log('Local Storage: FAILURE');
}

if (typeof sessionStorage !== 'undefined') {
  log('Session Storage: OK');
} else {
  log('Session Storage: FAILURE');
}

try {
  //new Peer()
} catch (error) {
  log(error.stack)
}


const constraints = {
  video: true
};

const captureVideoButton = document.querySelector('.capture-button');
captureVideoButton.onclick = function() {
  navigator.mediaDevices
    .getUserMedia(constraints)
    .then(handleSuccess)
    .catch(handleError);
};


function handleSuccess(stream) {
  video.srcObject = stream;
}
function handleError(err) {
  console.log(err)
}
