'use strict';

function type(el, text, callback) {
  const arr = text.split('');
  const interval = setInterval(() => {
    const next = arr.shift();

    if (next == null) {
      clearInterval(interval);
      callback();
      return;
    }

    el.innerHTML += next;
  }, 150);
}

function typewriter(content, callback) {
  const typewriterNode = content.querySelector('#typewriter');

  if (typewriterNode == null) {
    callback();
    return;
  }

  const text = typewriterNode.innerHTML;
  const article = document.querySelector('main article');
  const writeNode = document.createElement('h1');
  writeNode.innerHTML = '> ';
  article.appendChild(writeNode);

  type(writeNode, text, callback);
}

async function go(resource) {
  const article = document.querySelector('main article');
  article.innerHTML = '';

  const response = await fetch(resource);
  if (response.status === 404) {
    go('/html/404.html');
    return;
  }
  if (!response.ok) {
    const err = await response.error();
    console.error(err);
    return;
  }
  const text = await response.text()
  const wrapper = document.createElement('div');
  wrapper.className = "";
  wrapper.innerHTML = text;

  typewriter(wrapper, () => {
    document.querySelector('main article').appendChild(wrapper);
  });
}

if (/^\/?$/.test(window.location.pathname)) {
  go('/html/landing.html');
} else {
  go('/html' + window.location.pathname + '.html');
}
