// backend/src/services/warehouse.service.js

/**
 * WAREHOUSE & STORAGE SERVICE
 * Manages warehouse/storage facility discovery, booking, and tracking
 * 
 * Features: Location-based search, capacity management, pricing, real-time availability
 */

class WarehouseService {
  constructor() {
    // Warehouse database (simulated, normally from actual database/API)
    this.WAREHOUSES = [
      {
        id: 'wh-001',
        name: 'Grain Silo Complex - Pune',
        location: { lat: 18.5204, lng: 73.8567 },
        address: 'NH48, Yavat, Pune, Maharashtra',
        type: 'Grain Storage',
        totalCapacity: 5000, // Metric Tons
        currentOccupancy: 3500,
        availableCapacity: 1500,
        storageTypes: ['Silo', 'Warehouse', 'Cold Storage'],
        facilities: ['Weighing Scale', 'Cleaning Unit', 'Drying Facility', 'Security'],
        pricePerTonPerMonth: 150,
        minStoragePeriod: 1, // months
        maxStoragePeriod: 12,
        crops: ['Rice', 'Maize', 'Wheat', 'Sorghum'],
        rating: 4.5,
        reviews: 24,
        contact: '+91-9876543210',
        operatingHours: '6:00 AM - 8:00 PM'
      },
      {
        id: 'wh-002',
        name: 'Cold Storage - Mumbai Agricultural Market',
        location: { lat: 19.076, lng: 72.8479 },
        address: 'APMC Market, Vashi, Navi Mumbai',
        type: 'Cold Storage (4°C)',
        totalCapacity: 2000,
        currentOccupancy: 1200,
        availableCapacity: 800,
        storageTypes: ['Cold Room', 'Controlled Atmosphere'],
        facilities: ['Temperature Control', 'Humidity Control', 'Rapid Cooling', 'Fumigation'],
        pricePerTonPerMonth: 300,
        minStoragePeriod: 1,
        maxStoragePeriod: 6,
        crops: ['Vegetables', 'Fruits', 'Flowers', 'Spices'],
        rating: 4.8,
        reviews: 52,
        contact: '+91-9876543211',
        operatingHours: '24/7'
      },
      {
        id: 'wh-003',
        name: 'Multi-commodity Storage - Indore',
        location: { lat: 22.7196, lng: 75.8577 },
        address: 'Transport Nagar, Indore, Madhya Pradesh',
        type: 'General Warehouse',
        totalCapacity: 8000,
        currentOccupancy: 6200,
        availableCapacity: 1800,
        storageTypes: ['Open Floor', 'Covered Storage', 'Partitioned'],
        facilities: ['Forklift Available', 'Loading Dock', 'Insurance Available', 'CCTV'],
        pricePerTonPerMonth: 120,
        minStoragePeriod: 1,
        maxStoragePeriod: 12,
        crops: ['All Crops'],
        rating: 4.3,
        reviews: 38,
        contact: '+91-9876543212',
        operatingHours: '7:00 AM - 10:00 PM'
      },
      {
        id: 'wh-004',
        name: 'Organic Storage Hub - Bangalore',
        location: { lat: 12.9716, lng: 77.5946 },
        address: 'Agricultural Park, Domlur, Bangalore',
        type: 'Organic Certified Storage',
        totalCapacity: 1500,
        currentOccupancy: 900,
        availableCapacity: 600,
        storageTypes: ['Organic Room', 'Segregated Storage'],
        facilities: ['Organic Certification', 'Dedicated Handling', 'Testing Lab', 'Compliance Docs'],
        pricePerTonPerMonth: 250,
        minStoragePeriod: 1,
        maxStoragePeriod: 12,
        crops: ['All Organic Certified Crops'],
        rating: 4.9,
        reviews: 18,
        contact: '+91-9876543213',
        operatingHours: '8:00 AM - 6:00 PM'
      },
      {
        id: 'wh-005',
        name: 'Spice & Dry Goods Storage - Delhi',
        location: { lat: 28.7041, lng: 77.1025 },
        address: 'Mandi Road, Okhla, New Delhi',
        type: 'Specialized Storage',
        totalCapacity: 3000,
        currentOccupancy: 2100,
        availableCapacity: 900,
        storageTypes: ['Fumigated Room', 'Pest-proof Storage'],
        facilities: ['Fumigation', 'Pest Control', 'Quality Testing', 'Grading Unit'],
        pricePerTonPerMonth: 200,
        minStoragePeriod: 1,
        maxStoragePeriod: 8,
        crops: ['Spices', 'Pulses', 'Seeds', 'Nuts'],
        rating: 4.6,
        reviews: 41,
        contact: '+91-9876543214',
        operatingHours: '6:00 AM - 9:00 PM'
      }
    ];

    // Booking database
    this.BOOKINGS = [];
  }

  /**
   * Find warehouses near location with filters
   * 
   * @param {Object} input - Search parameters
   * @param {number} input.latitude - User latitude
   * @param {number} input.longitude - User longitude
   * @param {number} input.quantity - Storage quantity needed (metric tons)
   * @param {number} input.duration - Storage duration (months)
   * @param {string} input.crop - Crop type to store
   * @param {number} input.radius - Search radius in km
   * @returns {Array} - List of suitable warehouses
   */
  searchWarehouses(input) {
    this.validateInput(input);

    const nearby = [];

    this.WAREHOUSES.forEach(warehouse => {
      // Check if warehouse can accommodate
      if (warehouse.availableCapacity < input.quantity) {
        return; // Skip if not enough capacity
      }

      // Check if crop is supported
      if (!warehouse.crops.includes('All Crops') && !warehouse.crops.includes(input.crop)) {
        return; // Skip if crop not supported
      }

      // Check if storage period is within limits
      if (input.duration < warehouse.minStoragePeriod || input.duration > warehouse.maxStoragePeriod) {
        return; // Skip if duration not supported
      }

      // Calculate distance
      const distance = this.calculateDistance(
        input.latitude,
        input.longitude,
        warehouse.location.lat,
        warehouse.location.lng
      );

      if (distance > (input.radius || 100)) {
        return; // Skip if too far
      }

      // Calculate total cost
      const totalCost = wareho.pricePerTonPerMonth * input.quantity * input.duration;

      nearby.push({
        ...warehouse,
        distance: distance.toFixed(2),
        totalCost: totalCost,
        costPerTon: warehouse.pricePerTonPerMonth,
        suitabilityScore: this.calculateSuitability(warehouse, input),
        availabilityStatus: this.getAvailabilityStatus(warehouse),
        booking: {
          minQuantity: 1,
          maxQuantity: warehouse.availableCapacity,
          recommendedQuantity: Math.min(input.quantity, warehouse.availableCapacity)
        }
      });
    });

    // Sort by suitability and distance
    return nearby.sort((a, b) => {
      if (b.suitabilityScore !== a.suitabilityScore) {
        return b.suitabilityScore - a.suitabilityScore;
      }
      return parseFloat(a.distance) - parseFloat(b.distance);
    });
  }

  /**
   * Validate search input
   */
  validateInput(input) {
    const errors = [];

    if (typeof input.latitude !== 'number' || input.latitude < -90 || input.latitude > 90) {
      errors.push('Valid latitude required (-90 to 90)');
    }

    if (typeof input.longitude !== 'number' || input.longitude < -180 || input.longitude > 180) {
      errors.push('Valid longitude required (-180 to 180)');
    }

    if (typeof input.quantity !== 'number' || input.quantity <= 0 || input.quantity > 10000) {
      errors.push('Quantity must be 1-10000 metric tons');
    }

    if (typeof input.duration !== 'number' || input.duration <= 0 || input.duration > 12) {
      errors.push('Duration must be 1-12 months');
    }

    if (!input.crop || input.crop.trim() === '') {
      errors.push('Crop type is required');
    }

    if (errors.length > 0) {
      throw new Error(`Validation Error: ${errors.join(', ')}`);
    }
  }

  /**
   * Calculate distance between two points (Haversine formula)
   */
  calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth's radius in km
    const dLat = (lat2 - lat1) * (Math.PI / 180);
    const dLon = (lon2 - lon1) * (Math.PI / 180);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(lat1 * (Math.PI / 180)) * Math.cos(lat2 * (Math.PI / 180)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  /**
   * Calculate warehouse suitability score (0-100)
   */
  calculateSuitability(warehouse, input) {
    let score = 0;

    // Capacity match (30 points)
    const capacityRatio = input.quantity / warehouse.availableCapacity;
    score += Math.min(30, (1 - capacityRatio) * 30);

    // Rating (20 points)
    score += (warehouse.rating / 5) * 20;

    // Price competitiveness (20 points)
    const avgPrice = 180;
    const priceRatio = warehouse.pricePerTonPerMonth / avgPrice;
    score += Math.max(0, (2 - priceRatio) * 20);

    // Special features (15 points)
    const specialFeatures = warehouse.facilities.length;
    score += Math.min(15, (specialFeatures / 5) * 15);

    // Crop specialization (15 points)
    if (warehouse.crops.includes(input.crop) || warehouse.crops.includes('All Crops')) {
      score += 15;
    }

    return Math.round(Math.min(100, score));
  }

  /**
   * Get availability status
   */
  getAvailabilityStatus(warehouse) {
    const occupancyPercent = (warehouse.currentOccupancy / warehouse.totalCapacity) * 100;

    if (occupancyPercent < 50) return 'High Availability';
    if (occupancyPercent < 75) return 'Good Availability';
    if (occupancyPercent < 90) return 'Limited Availability';
    return 'Almost Full';
  }

  /**
   * Book storage space
   * 
   * @param {Object} input - Booking details
   * @param {string} input.warehouseId - Warehouse ID
   * @param {string} input.farmerId - Farmer ID
   * @param {number} input.quantity - Quantity to store (metric tons)
   * @param {number} input.duration - Storage duration (months)
   * @param {Date} input.storageStartDate - When storage starts
   * @returns {Object} - Booking confirmation
   */
  bookStorage(input) {
    const warehouse = this.WAREHOUSES.find(w => w.id === input.warehouseId);
    if (!warehouse) {
      throw new Error('Warehouse not found');
    }

    if (warehouse.availableCapacity < input.quantity) {
      throw new Error(`Only ${warehouse.availableCapacity} MT available in this warehouse`);
    }

    const bookingId = `BOOK-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;
    const totalCost = warehouse.pricePerTonPerMonth * input.quantity * input.duration;
    const storageEndDate = new Date(input.storageStartDate);
    storageEndDate.setMonth(storageEndDate.getMonth() + input.duration);

    const booking = {
      bookingId,
      warehouseId: input.warehouseId,
      warehouseName: warehouse.name,
      farmerId: input.farmerId,
      quantity: input.quantity,
      duration: input.duration,
      storageStartDate: input.storageStartDate,
      storageEndDate: storageEndDate.toISOString().split('T')[0],
      totalCost: totalCost,
      costBreakdown: {
        basePrice: warehouse.pricePerTonPerMonth,
        quantityRate: warehouse.pricePerTonPerMonth * input.quantity,
        newTotalCost: totalCost,
        taxes: Math.round(totalCost * 0.05),
        finalCost: Math.round(totalCost * 1.05)
      },
      status: 'Confirmed',
      paymentStatus: 'Pending',
      insuranceOption: {
        available: true,
        cost: Math.round(totalCost * 0.02),
        coverage: 'Full coverage against theft and natural calamities'
      },
      trackingId: bookingId,
      confirmationDate: new Date().toISOString().split('T')[0],
      termsAccepted: true
    };

    // Update warehouse occupancy
    warehouse.currentOccupancy += input.quantity;
    warehouse.availableCapacity -= input.quantity;

    // Store booking
    this.BOOKINGS.push(booking);

    return {
      success: true,
      booking: booking,
      nextSteps:  [
        '1. Make payment for booking confirmation',
        '2. Arrange transportation to warehouse',
        '3. Get entry and unloading assistance from warehouse',
        '4. Receive storage receipt and tracking code',
        '5. Monitor stock online anytime'
      ],
      insuranceRecommendation: 'Consider insurance for risk protection'
    };
  }

  /**
   * Get booking details and tracking
   */
  getBookingDetails(bookingId) {
    const booking = this.BOOKINGS.find(b => b.bookingId === bookingId);
    if (!booking) {
      throw new Error('Booking not found');
    }

    const warehouse = this.WAREHOUSES.find(w => w.id === booking.warehouseId);

    return {
      ...booking,
      warehouse: {
        name: warehouse.name,
        address: warehouse.address,
        contact: warehouse.contact,
        operatingHours: warehouse.operatingHours
      },
      tracking: {
        status: 'Stored',
        lastUpdate: new Date().toISOString(),
        temperature: '25°C (Ambient)',
        humidity: '60-70%',
        condition: 'Good'
      },
      withdrawalProcess: [
        'Submit withdrawal request 3 days prior',
        'Arrange transportation',
        'Take delivery with warehouse staff',
        'Get final receipt'
      ],
      estimatedWithdrawalDate: booking.storageEndDate,
      renewal: {
        available: true,
        message: 'Can extend storage for additional duration'
      }
    };
  }

  /**
   * Get price comparison of nearby warehouses
   */
  getPriceComparison(input) {
    const nearby = this.searchWarehouses(input);

    const comparison = nearby.map(wh => ({
      name: wh.name,
      pricePerTonPerMonth: wh.pricePerTonPerMonth,
      totalCost: wh.totalCost,
      estimatedCost: wh.totalCost * 1.05, // Including taxes
      rating: wh.rating,
      distance: `${wh.distance} km`,
      facilities: wh.facilities.slice(0, 3),
      availableCapacity: Math.min(input.quantity, wh.availableCapacity)
    }));

    return {
      quantity: input.quantity,
      duration: input.duration,
      crop: input.crop,
      warehouses: comparison,
      averagePrice: (comparison.reduce((sum, w) => sum + w.pricePerTonPerMonth, 0) / comparison.length).toFixed(0),
      recommendation: comparison[0]?.name || 'No suitable warehouse found'
    };
  }

  /**
   * Withdraw storage
   */
  withdrawStorage(bookingId) {
    const booking = this.BOOKINGS.find(b => b.bookingId === bookingId);
    if (!booking) {
      throw new Error('Booking not found');
    }

    const warehouse = this.WAREHOUSES.find(w => w.id === booking.warehouseId);
    warehouse.currentOccupancy -= booking.quantity;
    warehouse.availableCapacity += booking.quantity;

    booking.status = 'Withdrawn';

    return {
      success: true,
      message: 'Storage withdrawn successfully',
      bookingId: bookingId,
      withdrawnQuantity: booking.quantity,
      withdrawnDate: new Date().toISOString().split('T')[0],
      refund: booking.costBreakdown.finalCost
    };
  }
}

module.exports = new WarehouseService();
