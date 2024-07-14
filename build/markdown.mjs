#!/usr/bin/env node

// import {Marked} from "marked";
// import {markedHighlight} from "marked-highlight";
// import hljs from 'highlight.js';
// const marked = new Marked(
//   markedHighlight({
//     langPrefix: 'hljs language-',
//     highlight(code, lang, info) {
//       const language = hljs.getLanguage(lang) ? lang : 'plaintext';
//       return hljs.highlight(code, { language }).value;
//     }
//   })
// );

import {marked} from "marked";
import fs from 'fs';

marked.use({ gfm: true });
console.log(marked.parse(fs.readFileSync(0, "utf-8")));
