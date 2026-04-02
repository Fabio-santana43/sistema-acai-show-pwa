const CACHE_NAME = 'acaishow-v2';
const URLS_TO_CACHE = [
  './Sistema-completo-fabio-certo.html',
  './manifest.json',
  './icon-192.svg',
  './icon-512.svg',
  './icon-192.png',
  './icon-512.png',
  './logo-acai.png',
  './wood-pattern.png'
];

// Instala e coloca os assets essenciais no cache
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(URLS_TO_CACHE))
  );
  self.skipWaiting();
});

// Ao ativar, limpa caches antigos (muda o nome do cache para forçar atualização)
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(keys => Promise.all(
      keys.map(k => { if (k !== CACHE_NAME) return caches.delete(k); })
    ))
  );
  self.clients.claim();
});

// Estratégia cache-first, com fallback para fetch e cache dinamico
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      if (response) return response;
      return fetch(event.request).then(fetchResponse => {
        return caches.open(CACHE_NAME).then(cache => {
          try { cache.put(event.request, fetchResponse.clone()); } catch (e) { /* put pode falhar para requests cross-origin */ }
          return fetchResponse;
        });
      });
    }).catch(() => caches.match('./Sistema-completo-fabio-certo.html'))
  );
});
