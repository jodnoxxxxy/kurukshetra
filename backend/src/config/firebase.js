  const admin = require('firebase-admin');
const path = require('path');
const config = require('./index');

let firebaseApp;

/**
 * Initialize Firebase Admin SDK
 * Supports both credential file and environment variables
 */
function initializeFirebase() {
  try {
    // Check if Firebase is already initialized
    if (firebaseApp) {
      return firebaseApp;
    }

    const firebaseConfig = {
      projectId: process.env.FIREBASE_PROJECT_ID,
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
      privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
    };

    // Validate required Firebase credentials
    if (!firebaseConfig.projectId || !firebaseConfig.clientEmail || !firebaseConfig.privateKey) {
      console.warn('⚠️  Firebase credentials not fully configured via environment variables');
      console.warn('   Using Firebase Realtime DB or Firestore will require proper configuration');
      
      // Try to load from credential file if environment variables not set
      const credentialPath = path.join(__dirname, '../../firebase-credentials.json');
      try {
        const credential = require(credentialPath);
        firebaseApp = admin.initializeApp({
          credential: admin.credential.cert(credential),
        });
      } catch (err) {
        console.warn('   Firebase credential file not found at:', credentialPath);
        // Fallback for development without Firebase credentials
        console.warn('⚠️  Proceeding WITHOUT Firebase. Some features will be mocked or non-functional.');
        firebaseApp = {
          auth: () => ({
            createUser: async (u) => ({ uid: 'mock_uid_' + Date.now(), ...u }),
            deleteUser: async () => {},
            revokeRefreshTokens: async () => {},
          }),
          firestore: () => ({
            collection: (name) => ({
              doc: (id) => ({
                set: async () => {},
                get: async () => ({ exists: true, data: () => ({}) }),
                update: async () => {},
                collection: () => ({
                  doc: () => ({ set: async () => {}, get: async () => ({ exists: true, data: () => ({}) }) }),
                  where: () => ({ get: async () => ({ empty: true, docs: [] }) }),
                }),
              }),
              where: () => ({
                where: () => ({ get: async () => ({ empty: true, docs: [] }) }),
                get: async () => ({ empty: true, docs: [] }),
                orderBy: () => ({ limit: () => ({ get: async () => ({ empty: true, docs: [] }) }) }),
              }),
            }),
          }),
          messaging: () => ({
            send: async () => 'mock_msg_id',
            sendMulticast: async () => ({ successCount: 0 }),
          }),
        };
        return firebaseApp;
      }
    } else {
      // Initialize with environment variables
      firebaseApp = admin.initializeApp({
        credential: admin.credential.cert(firebaseConfig),
      });
    }

    console.log('✅ Firebase Admin SDK initialized');
    return firebaseApp;
  } catch (error) {
    console.error('❌ Error initializing Firebase:', error.message);
    return null;
  }
}

/**
 * Get Firebase authentication instance
 */
function getAuth() {
  const app = initializeFirebase();
  if (!app) {
    throw new Error('Firebase not initialized');
  }
  return app.auth ? app.auth() : admin.auth(app);
}

/**
 * Get Firebase Firestore instance
 */
function getFirestore() {
  const app = initializeFirebase();
  if (!app) {
    throw new Error('Firebase not initialized');
  }
  return app.firestore ? app.firestore() : admin.firestore(app);
}

/**
 * Get Firebase Realtime Database instance
 */
function getDatabase() {
  const app = initializeFirebase();
  if (!app) {
    throw new Error('Firebase not initialized');
  }
  return app.database ? app.database() : admin.database(app);
}

/**
 * Get Firebase Cloud Messaging instance
 */
function getMessaging() {
  const app = initializeFirebase();
  if (!app) {
    throw new Error('Firebase not initialized');
  }
  return app.messaging ? app.messaging() : admin.messaging(app);
}

/**
 * Create a custom JWT token for testing
 */
async function createCustomToken(uid, additionalClaims = {}) {
  try {
    const auth = getAuth();
    const token = await auth.createCustomToken(uid, additionalClaims);
    return token;
  } catch (error) {
    console.error('Error creating custom token:', error);
    throw error;
  }
}

/**
 * Verify a Firebase ID token
 */
async function verifyIdToken(token) {
  try {
    const auth = getAuth();
    const decodedToken = await auth.verifyIdToken(token);
    return decodedToken;
  } catch (error) {
    console.error('Error verifying ID token:', error);
    throw error;
  }
}

/**
 * Create a new Firebase user
 */
async function createFirebaseUser(email, password, displayName = '') {
  try {
    const auth = getAuth();
    const userRecord = await auth.createUser({
      email,
      password,
      displayName,
      emailVerified: false,
    });
    return userRecord;
  } catch (error) {
    console.error('Error creating Firebase user:', error);
    throw error;
  }
}

/**
 * Delete a Firebase user
 */
async function deleteFirebaseUser(uid) {
  try {
    const auth = getAuth();
    await auth.deleteUser(uid);
    console.log(`Firebase user ${uid} deleted`);
  } catch (error) {
    console.error('Error deleting Firebase user:', error);
    throw error;
  }
}

/**
 * Send notification via Firebase Cloud Messaging
 */
async function sendNotification(deviceToken, title, body, data = {}) {
  try {
    if (!config.FCM_ENABLED) {
      console.warn('⚠️  FCM is disabled. Configure FIREBASE_PROJECT_ID to enable.');
      return null;
    }

    const messaging = getMessaging();
    const message = {
      notification: {
        title,
        body,
      },
      data,
      token: deviceToken,
    };

    const response = await messaging.send(message);
    console.log('✅ Notification sent:', response);
    return response;
  } catch (error) {
    console.error('Error sending notification:', error);
    throw error;
  }
}

/**
 * Send multicast notification (to multiple devices)
 */
async function sendMulticastNotification(deviceTokens, title, body, data = {}) {
  try {
    if (!config.FCM_ENABLED) {
      console.warn('⚠️  FCM is disabled. Configure FIREBASE_PROJECT_ID to enable.');
      return null;
    }

    const messaging = getMessaging();
    const message = {
      notification: {
        title,
        body,
      },
      data,
    };

    const response = await messaging.sendMulticast({
      ...message,
      tokens: deviceTokens,
    });

    console.log(`✅ Notifications sent to ${response.successCount} devices`);
    return response;
  } catch (error) {
    console.error('Error sending multicast notification:', error);
    throw error;
  }
}

module.exports = {
  initializeFirebase,
  getAuth,
  getFirestore,
  getDatabase,
  getMessaging,
  createCustomToken,
  verifyIdToken,
  createFirebaseUser,
  deleteFirebaseUser,
  sendNotification,
  sendMulticastNotification,
};
