// import * as Tone from '/node_modules/tone/build/Tone.js';
// import * as Tone from 'tone';

let DEBUG = true;

function debug(...args) {
  if (DEBUG) {
    console.log(...args);
  }
}

let googleUser;

// const logOut = document.querySelector("logOutBtn");

// logOut.addEventListener("click", (e) => {
//   firebase.auth().signOut().then(() => {
//     window.location = 'signIn.html';
//   }).catch((error) => {
//     // An error happened.
//   });
// });
// const viewLoopsBtn = document.querySelector("#viewLoopsBtn");
// const changeInstrumentBtn = document.querySelector("#changeInstrumentBtn")
// const changeInstModal = document.querySelector("#changeInstModal");
// const viewLoopsModal = document.querySelector("#viewLoopsModal");
// const closeLoops = document.querySelector("#closeLoopsBtn");
// const closeInst = document.querySelector("#closeInstBtn");

// viewLoopsBtn.addEventListener("click", (e) => {
//   viewLoopsModal.classList.add("is-active");
// });

// changeInstrumentBtn.addEventListener("click", (e) => {
//   changeInstModal.classList.add("is-active");
// });

// const closeInstModal = () =>{
//   changeInstModal.classList.remove('is-active');
//   }
  
//   const closeLoopsModal = () =>{
//     viewLoopsModal.classList.remove('is-active');
//   }
  

// closeLoops.addEventListener("click", (e) => {
//   console.log("clicked");
//   closeLoopsModal();
// });

// closeInst.addEventListener("click", (e) => {
//   console.log("clicked");
//   closeInstModal();
// });



// window.onload = (event) => {
//   // Use this to retain user state between html pages.
//   firebase.auth().onAuthStateChanged(function(user) {
//     if (user) {
//     console.log('Logged in as: ' + user.displayName);
//     googleUser = user;
//     } else {
//     // If not logged in, navigate back to login page.
//     window.location = 'index.html'; 
//     };
//   });
// };

// const soundMap = {
//   "KeyQ": "", "KeyW": "", "KeyE": "", "KeyR": "", "KeyT": "", "KeyY": "", "KeyU": "", "KeyI": "", "KeyO": "", "KeyP": "",
//   "KeyA": "", "KeyS": "", "KeyD": "", "KeyF": "", "KeyG": "", "KeyH": "", "KeyJ": "", "KeyK": "", "KeyL": "",
//   "KeyZ": "", "KeyX": "", "KeyC": "", "KeyV": "", "KeyB": "", "KeyN": "", "KeyM": "",
// };

const soundMap = {
  "KeyW": {note: "C#4", on: false}, "KeyE": {note: "D#4", on: false}, "KeyT": {note: "F#4", on: false}, "KeyY": {note: "G#4", on: false}, "KeyU": {note: "A#4", on: false}, "KeyO": {note: "C#5", on: false}, "KeyP": {note: "D#5", on: false},
  "KeyA": {note: "C4", on: false}, "KeyS": {note: "D4", on: false}, "KeyD": {note: "E4", on: false}, "KeyF": {note: "F4", on: false}, "KeyG": {note: "G4", on: false}, "KeyH": {note: "A4", on: false}, "KeyJ": {note: "B4", on: false}, "KeyK": {note: "C5", on: false}, "KeyL": {note: "D5", on: false},
  "KeyZ": {note: "C2", on: false}, "KeyX": {note: "D2", on: false}, "KeyC": {note: "E2", on: false}, "KeyV": {note: "F2", on: false}, "KeyB": {note: "G2", on: false}, "KeyN": {note: "A2", on: false}, "KeyM": {note: "B2", on: false},
};

// Make virtual keyboard clickable/tappable
const virtKeys = document.querySelectorAll(".column.button");
for (let e of virtKeys) {
  if (e.id.includes("Key") && soundMap[e.id] !== undefined) {
    e.innerHTML += ` <span class="small">${soundMap[e.id].note}</span>`;
  }
  e.addEventListener("mousedown", () => {
    playKey(e.id);
  });
  e.addEventListener("mouseup", () => {
    stopKey(e.id);
  });
}

// const soundMap = {
//   "KeyW": "C#4", "KeyE": "D#4", "KeyT": "E#4", "KeyY": "F#4", "KeyU": "G#4", "KeyO": "D#5", "KeyP": "C#5",
//   "KeyA": "C4", "KeyS": "D4", "KeyD": "E4", "KeyF": "F4", "KeyG": "G4", "KeyH": "A4", "KeyJ": "B4", "KeyK": "C5", "KeyL": "D4",
//   "KeyZ": "", "KeyX": "", "KeyC": "", "KeyV": "", "KeyB": "", "KeyN": "", "KeyM": "",
// };

function isDrum(keycode) {
  return /^Key[ZXCVBNM]$/.test(keycode);
}

const mainSynth = new Tone.PolySynth(Tone.Synth).toDestination();
const drum = new Tone.PluckSynth().toDestination();

const now = Tone.now();

function playKey(keycode) {
  if (soundMap[keycode] === undefined || soundMap[keycode].on) {
    return;
  }
  let synth = mainSynth;
  if (isDrum(keycode)) {
    synth = drum;
  }
  const virtkey = document.querySelector(`#${keycode}`);
  highlightKey(virtkey);
  // const synth = new Tone.Synth().toDestination();
  // synth.triggerAttackRelease("C4", "8n");
  // const now = Tone.now();
  console.log("activeVoices:", synth.activeVoices);
  console.log("maxPolyphony:", synth.maxPolyphony);
  // if (synth.activeVoices >= synth.maxPolyphony) {
  //   synth.releaseAll(now);
  // }
  synth.triggerAttack(soundMap[keycode].note);
  soundMap[keycode].on = true;
}

function stopKey(keycode) {
  if (soundMap[keycode] === undefined) {
    return;
  }
  const virtkey = document.querySelector(`#${keycode}`);
  unhighlightKey(virtkey);
  // const now = Tone.now();
  if (!isDrum(keycode)) {
    mainSynth.triggerRelease(soundMap[keycode].note, "+0");
  }
  soundMap[keycode].on = false;
  // synth.releaseAll("+0");
}

function highlightKey(elem) {
  elem.classList.add("mybox");
  // console.log(elem);
}

function unhighlightKey(elem) {
  elem.classList.remove("mybox");
}

// function pitchUp() {
// if(keycode == '40'){
//   const upOctave = new Tone.PitchShift([pitch]);
//   pitchShift.pitch = -12;
// }

// };

// function pitchDown() {
// if(keycode == '39'){

// }

// }

// function loopKeyO(elem) {

// }

// const btn = document.querySelector("#startaudio");
// btn.addEventListener("click", (e) => {
//   console.log("hello");
//   const synth = new Tone.Synth().toDestination();
//   synth.triggerAttackRelease("C4", "8n");
// });

document.addEventListener("keydown", (e) => {
  debug("keydown:", e.code);
  playKey(e.code);
});

document.addEventListener("keyup", (e) => {
  debug("keyup:", e.code);
  stopKey(e.code);
});