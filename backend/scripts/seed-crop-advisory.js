const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

async function seedCropAdvisory() {
  try {
    const credentialPath = path.join(__dirname, '../firebase-credentials.json');
    if (!fs.existsSync(credentialPath)) {
      console.error('firebase-credentials.json not found!');
      process.exit(1);
    }
    
    const credential = require(credentialPath);
    admin.initializeApp({
      credential: admin.credential.cert(credential)
    });
    
    const db = admin.firestore();
    
    console.log('Seeding massive realtime dataset...');
    
    // Dataset structure
    const cropAdvisoryData = {
      rice: {
        totalDays: 140,
        stages: [
          { name: "Land Preparation", startDay: 0, endDay: 30 },
          { name: "Sowing/Nursery", startDay: 31, endDay: 50 },
          { name: "Transplanting", startDay: 51, endDay: 60 },
          { name: "Vegetative Growth", startDay: 61, endDay: 100 },
          { name: "Reproductive Stage", startDay: 101, endDay: 130 },
          { name: "Harvesting", startDay: 131, endDay: 140 }
        ]
      },
      wheat: {
        totalDays: 130,
        stages: [
          { name: "Field Preparation", startDay: 0, endDay: 15 },
          { name: "Sowing", startDay: 16, endDay: 25 },
          { name: "Crown Root Initiation", startDay: 26, endDay: 45 },
          { name: "Jointing & Booting", startDay: 46, endDay: 80 },
          { name: "Flowering & Dough", startDay: 81, endDay: 100 },
          { name: "Maturation & Harvest", startDay: 101, endDay: 130 }
        ]
      },
      cotton: {
        totalDays: 160,
        stages: [
          { name: "Land Preparation", startDay: 0, endDay: 15 },
          { name: "Sowing", startDay: 16, endDay: 25 },
          { name: "Vegetative Phase", startDay: 26, endDay: 65 },
          { name: "Square Formation", startDay: 66, endDay: 85 },
          { name: "Flowering & Boll Dev", startDay: 86, endDay: 130 },
          { name: "Boll Opening & Harvest", startDay: 131, endDay: 160 }
        ]
      },
      maize: {
        totalDays: 110,
        stages: [
          { name: "Land Preparation", startDay: 0, endDay: 15 },
          { name: "Sowing", startDay: 16, endDay: 25 },
          { name: "Vegetative Phase", startDay: 26, endDay: 55 },
          { name: "Tasseling & Silking", startDay: 56, endDay: 75 },
          { name: "Grain Filling", startDay: 76, endDay: 100 },
          { name: "Harvesting", startDay: 101, endDay: 110 }
        ]
      },
      ragi: {
        totalDays: 120,
         stages: [
           { name: "जमिनीची पूर्व मशागत व रोपवाटिका", startDay: 0, endDay: 10 },
           { name: "पुनर्लागवड", startDay: 11, endDay: 25 },
           { name: "शाकीय वाढ / Tillering", startDay: 26, endDay: 60 },
           { name: "फुलोरा व दाणे भरणे", startDay: 61, endDay: 90 },
           { name: "काढणी", startDay: 91, endDay: 120 }
         ]
      }
    };
    
    // Stage writing
    const stagesBatch = db.batch();
    for (const [cropKey, data] of Object.entries(cropAdvisoryData)) {
      const docRef = db.collection('crop_stages').doc(cropKey);
      stagesBatch.set(docRef, {
        cropName: cropKey,
        totalDays: data.totalDays,
        stages: data.stages,
        updatedAt: new Date()
      });
    }
    await stagesBatch.commit();
    console.log('✅ Crop stages seeded.');
    
    // Core tasks writing
    console.log('Seeding daily tasks...');
    const tasksCollection = db.collection('crop_tasks');
    
    const tasks = [
      { crop: 'rice', day: 1, tasks: [{ title: 'Plough field', description: 'Plough the soil twice deeply to prepare the seedbed.', priority: 'HIGH' }] },
      { crop: 'rice', day: 31, tasks: [{ title: 'Nursery Sowing', description: 'Sow the seeds in the nursery bed today.', priority: 'HIGH' }] },
      { crop: 'rice', day: 65, tasks: [{ title: 'Top Dressing', description: 'Apply 50% of the urea top dressing.', priority: 'NORMAL' }] },
      
      { crop: 'wheat', day: 26, tasks: [{ title: 'Crown Root Irrigation', description: 'Critical stage for irrigation. Water immediately.', priority: 'HIGH' }] },
      { crop: 'wheat', day: 60, tasks: [{ title: 'Weed Control', description: 'Spray recommended herbicides if weeds are aggressive.', priority: 'MEDIUM' }] },
      
      { crop: 'ragi', day: 1, tasks: [{ title: 'बियाणे प्रक्रिया', description: 'कार्बेन्डाझिम वापरा', priority: 'HIGH' }] },
      { crop: 'ragi', day: 13, tasks: [{ title: 'रोप लावा', description: '25-30 दिवसांची रोपे वापरा', priority: 'HIGH' }] }
    ];
    
    const taskBatch = db.batch();
    for (const t of tasks) {
      const docRef = tasksCollection.doc(`${t.crop}_day_${t.day}`);
      taskBatch.set(docRef, {
        cropName: t.crop,
        day: t.day,
        tasks: t.tasks
      });
    }
    await taskBatch.commit();
    console.log('✅ Crop advisory data loaded into Firestore successfully.');
    
    process.exit(0);
  } catch (error) {
    console.error('Migration failed:', error);
    process.exit(1);
  }
}

seedCropAdvisory();