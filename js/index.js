import { Elm } from '../src/Main.elm';

const basePath = new URL(document.baseURI).pathname;

Elm.Main.init({
  node: document.querySelector('main'),
  flags: { basePath },
});
