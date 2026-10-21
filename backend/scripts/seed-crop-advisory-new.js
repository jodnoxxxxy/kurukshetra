const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

async function seedNewCropAdvisory() {
  try {
    const credentialPath = path.join(__dirname, '../firebase-credentials.json');
    if (!fs.existsSync(credentialPath)) {
      console.error('firebase-credentials.json not found!');
      process.exit(1);
    }
    
    const credential = require(credentialPath);
    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert(credential)
      });
    }
    
    const db = admin.firestore();
    
    console.log('Seeding optimized crop_advisory dataset...');
    
    const crops = {
      rice: {
        "cropName": "Rice",
        "image": "https://i.imgur.com/1rice.jpg",
        "stages": [
          {
            "title": "Land Preparation",
            "startDay": 0,
            "endDay": 10,
            "tasks": [
              { "title": "Ploughing", "description": "Plough field 2-3 times for fine tilth", "image": "https://i.imgur.com/plough.jpg" },
              { "title": "Add Manure", "description": "Apply FYM 5 tons/hectare", "image": "https://i.imgur.com/manure.jpg" }
            ]
          },
          {
            "title": "Sowing",
            "startDay": 10,
            "endDay": 25,
            "tasks": [
              { "title": "Seed Treatment", "description": "Treat seeds with fungicide", "image": "https://i.imgur.com/seed.jpg" }
            ]
          },
          {
            "title": "Growth",
            "startDay": 25,
            "endDay": 80,
            "tasks": [
              { "title": "Irrigation", "description": "Maintain water level", "image": "https://i.imgur.com/water.jpg" }
            ]
          },
          {
            "title": "Harvest",
            "startDay": 100,
            "endDay": 130,
            "tasks": [
              { "title": "Harvest Crop", "description": "Harvest when grains mature", "image": "https://i.imgur.com/harvest.jpg" }
            ]
          }
        ]
      },
      maize: {
        "cropName": "Maize",
        "image": "https://i.imgur.com/maize.jpg",
        "stages": [
          {
            "title": "Land Preparation",
            "startDay": 0,
            "endDay": 7,
            "tasks": [
              { "title": "Tilling", "description": "Plough soil deeply", "image": "https://i.imgur.com/till.jpg" }
            ]
          },
          {
            "title": "Sowing",
            "startDay": 7,
            "endDay": 15,
            "tasks": [
              { "title": "Seed Sowing", "description": "Sow seeds at 5cm depth", "image": "https://i.imgur.com/sow.jpg" }
            ]
          },
          {
            "title": "Vegetative",
            "startDay": 15,
            "endDay": 60,
            "tasks": [
              { "title": "Top Dressing", "description": "Apply nitrogen fertilizer", "image": "https://i.imgur.com/fertilizer.jpg" }
            ]
          }
        ]
      },
      wheat: {
        "cropName": "Wheat",
        "image": "https://i.imgur.com/wheat.jpg",
        "stages": [
          {
            "title": "Land Preparation",
            "startDay": 0,
            "endDay": 10,
            "tasks": [
              { "title": "Field Preparation", "description": "Level and prepare soil", "image": "https://i.imgur.com/field.jpg" }
            ]
          },
          {
            "title": "Sowing",
            "startDay": 10,
            "endDay": 20,
            "tasks": [
              { "title": "Seed Drill", "description": "Use seed drill machine", "image": "https://i.imgur.com/drill.jpg" }
            ]
          },
          {
            "title": "Harvest",
            "startDay": 110,
            "endDay": 130,
            "tasks": [
              { "title": "Harvest Wheat", "description": "Harvest when golden", "image": "https://i.imgur.com/wheat2.jpg" }
            ]
          }
        ]
      },
      ragi: {
        "cropName": "Ragi",
        "image": "https://i.imgur.com/ragi.jpg",
        "stages": [
          {
            "title": "जमिनीची पूर्व मशागत व रोपवाटिका",
            "startDay": 0,
            "endDay": 10,
            "tasks": [
              { "title": "बियाणे प्रक्रिया", "description": "कार्बेन्डाझिम वापरून बीज प्रक्रिया करा", "image": "https://i.imgur.com/ragi1.jpg" }
            ]
          },
          {
            "title": "पुनर्लागवड",
            "startDay": 10,
            "endDay": 25,
            "tasks": [
              { "title": "रोप लावा", "description": "25-30 दिवसांची रोपे वापरा", "image": "https://i.imgur.com/ragi2.jpg" }
            ]
          },
          {
            "title": "पिक वाढीची अवस्था",
            "startDay": 25,
            "endDay": 60,
            "tasks": [
              { "title": "खत वापर", "description": "योग्य प्रमाणात खत द्या", "image": "https://i.imgur.com/ragi3.jpg" }
            ]
          }
        ]
      }
    };
    
    const batch = db.batch();
    for (const [key, cropData] of Object.entries(crops)) {
      const docRef = db.collection('crop_advisory').doc(key);
      batch.set(docRef, cropData);
    }
    
    await batch.commit();
    console.log('✅ Crop advisory data loaded into Firestore successfully.');
    
    process.exit(0);
  } catch (error) {
    console.error('Migration failed:', error);
    process.exit(1);
  }
}

seedNewCropAdvisory();