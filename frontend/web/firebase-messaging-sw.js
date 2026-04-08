importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

// Initialize Firebase in the service worker
firebase.initializeApp({
  apiKey: "AIzaSyChGJflcV-92gza2-oROwaJMTraMbBSNF8",
  authDomain: "kurukshetra-9d993.firebaseapp.com",
  projectId: "kurukshetra-9d993",
  storageBucket: "kurukshetra-9d993.firebasestorage.app",
  messagingSenderId: "851759895243",
  appId: "1:851759895243:web:e6ebee442f3d6194b1414e"
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function (payload) {
  console.log('Received background message', payload);

  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png',
    data: payload.data || {}
  };

  return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Handle notification clicks
self.addEventListener('notificationclick', function (event) {
  event.notification.close();
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function (clientList) {
      for (let i = 0; i < clientList.length; i++) {
        const client = clientList[i];
        if (client.url === '/' && 'focus' in client) {
          return client.focus();
        }
      }
      if (clients.openWindow) {
        return clients.openWindow('/');
      }
    })
  );
});
