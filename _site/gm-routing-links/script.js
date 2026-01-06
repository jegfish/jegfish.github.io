let btnGenerate;
let inputDestinations;
let output;

// TODO: ? Make a testing function that will double check that Google Maps is
// not deleting any waypoints silently, to make sure we aren't putting too many
// waypoints into the URL? I feel like is mostly a test and see thing, since
// they document the waypoint limit, I think my manual tests are enough, but an
// automated test would make me a bit more comfortable and might not be that
// hard to setup.

// TODO: Button to copy the list of URLs to clipboard.
// Maybe individual buttons for each URL to copy it to clipboard, then one button for copying all of them.

// TODO: If supported by Google Maps, maybe have a way to set more human
// friendly names for places.  Can do so initially with parsing probably just
// fine unless locations have names that include my separator characters, but
// longer term a good UI would require a list creation UI where user can fill in
// a user friendly name if desired.
//
// Looks like that might not actually be a feature of the Google Maps URLs. You
// can use place IDs, but that seems like you need to lookup the IDs for
// specific locations on Google Maps, which might be difficult.

// Maybe TODO: Generate a URL that will directly link someone to a page that
// lists all these links, rather than having to send them multiple links.
// However that is extra complexity that is probably not worth it, at least to
// begin with. If this tool ends up being used a lot then I can look into ways
// to make it easier to use.

window.addEventListener("DOMContentLoaded", () => {
  btnGenerate = document.getElementById("generate");
  btnGenerate.onclick = handleBtnGenerate;

  inputDestinations = document.getElementById("input-destinations");
  output = document.getElementById("output");
}, false);

function generateUrls(input) {
  const locs = input.split("\n").filter((l) => l !== "");
  const chunks = makeChunks(locs, 10);
  console.log(chunks);
  const urls = chunks.map(makeMapUrl);
  return urls;
}

// Convert an array into an array of arrays up to the chunk size.
function makeChunks(arr, size) {
  let chunks = [];
  for (let i = 0; i < arr.length; i += size) {
    chunks.push(arr.slice(i, i + size))
  }
  return chunks;
}

function makeMapUrl(locs) {
  const baseUrl = "https://www.google.com/maps/dir/";
  let url = new URL(baseUrl);

  const destination = locs[locs.length - 1];
  const waypoints = locs.slice(0, locs.length - 1).join("|");
  const params = new URLSearchParams([
    ["api", "1"],
    ["travelmode", "driving"],
    ["destination", destination],
    ["waypoints", waypoints],
  ]);
  url.search = params.toString();

  return url;
}

function handleBtnGenerate() {
  let urls = generateUrls(inputDestinations.value);
  let i = 1;

  output.innerHTML = "";
  for (const url of urls) {
    const child = document.createElement("li");
    child.id = `link-${i}`;
    // const a = document.createElement("a");
    // a.target = "_blank";
    // a.href = url.href;
    // a.textContent = url.href;
    // child.appendChild(a);
    child.textContent = url.href;
    output.appendChild(child);
    i += 1;
  }
}