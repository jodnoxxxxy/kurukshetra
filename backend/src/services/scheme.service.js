// backend/src/services/scheme.service.js

/**
 * GOVERNMENT SCHEMES SERVICE
 * Matches farmers with applicable government schemes and programs
 * 
 * Covers: PM-KISAN, Crop Insurance, Subsidies, Loans, Infrastructure
 */

class SchemeService {
  constructor() {
    // Government schemes database
    this.SCHEMES = [
      {
        id: 'pm-kisan',
        name: 'PM-KISAN',
        fullName: 'Pradhan Mantri Kisan Samman Nidhi',
        description: 'Direct income support to farmers',
        benefit: 2000,
        benefitUnit: 'rupees per 2 months (6000/year)',
        maxBenefit: 6000,
        eligibility: {
          landSize: { min: 0.001, max: 2 }, // hectares in this tier
          age: { min: 18, max: null },
          income: null,
          state: 'All States'
        },
        documents: ['Land Record', 'Aadhar Card', 'Bank Account'],
        applicationProcess: ['Online at pmkisan.gov.in', 'Or visit Patwari/Lekhpal'],
        benefitsPerYear: 3 // Number of installments
      },
      {
        id: 'crop-insurance',
        name: 'PMFBY',
        fullName: 'Pradhan Mantri Fasal Bima Yojana',
        description: 'Crop insurance scheme for loss due to natural calamities',
        benefit: 'Variable',
        benefitUnit: 'Coverage up to 100% of loss',
        maxBenefit: null,
        eligibility: {
          landSize: { min: 0.01, max: null },
          age: { min: 18, max: null },
          income: null,
          crops: '*All crops*'
        },
        premiumRate: {
          kharif: '2%',
          rabi: '1.5%',
          summer: '5%'
        },
        documents: ['Land Record', 'Crop Receipt', 'Aadhar'],
        applicationProcess: ['Through bank/CSC', 'Sowing notification to agriculture dept'],
        coverage: ['Crop failure', 'Loss due to natural calamities', 'Weather conditions']
      },
      {
        id: 'mission-organic',
        name: 'PMKSY-OM',
        fullName: 'Pradhan Mantri Krishi Sinchayee Yojana - On-Farm Water Use Efficiency',
        description: 'Subsidy for groundwater conservation and efficient irrigation',
        benefit: 4000,
        benefitUnit: 'rupees per hectare (up to 50% subsidy)',
        maxBenefit: 50000,
        eligibility: {
          landSize: { min: 0.25, max: 4 },
          age: null,
          income: null,
          irrigationMethod: ['Drip/Sprinkler required']
        },
        documents: ['Land Record', 'Water source certificate', 'Scheme documentation'],
        applicationProcess: ['District Agriculture Office', 'Online portal'],
        benefits: ['Drip irrigation subsidy', 'Sprinkler system support', 'Training programs']
      },
      {
        id: 'soil-health-card',
        name: 'Soil Health Card Scheme',
        fullName: 'Soil Helath Card Scheme',
        description: 'Free soil testing and nutrient management card',
        benefit: 'Free',
        benefitUnit: 'Free soil test and prescription',
        maxBenefit: null,
        eligibility: {
          landSize: { min: 0, max: null },
          age: null,
          income: null,
          state: 'All States'
        },
        documents: ['Land Record'],
        applicationProcess: ['District Agriculture Office', 'Soil Testing Lab'],
        components: ['Free soil testing', 'Nutrient recommendations', 'Organic matter suggestions']
      },
      {
        id: 'agricultural-loan',
        name: 'Agricultural Loans (KCC)',
        fullName: 'Kisan Credit Card Scheme',
        description: 'Credit facility for agricultural activities',
        benefit: 'Variable',
        benefitUnit: 'Loan amount upto 5x land value',
        maxBenefit: null,
        eligibility: {
          landSize: { min: 0.01, max: null },
          age: { min: 18, max: 65 },
          cibil: 'Min 650 score',
          income: 'No minimum'
        },
        interestRate: '4% (with subsidy)',
        documents: ['Land Record', 'Income Proof', 'Bank Statements'],
        applicationProcess: ['Nearest Bank', 'Online (Some banks)'],
        repaymentPeriod: '3-8 years'
      },
      {
        id: 'farm-machinery-subsidy',
        name: 'SMAM',
        fullName: 'Sub-Mission on Agricultural Mechanization',
        description: 'Subsidy for purchase of farm equipment',
        benefit: 4000,
        benefitUnit: 'rupees (40-50% subsidy on equipment)',
        maxBenefit: 60000,
        eligibility: {
          landSize: { min: 0.5, max: null },
          age: { min: 18, max: null },
          equipment: ['Tractors', 'Harvesters', 'Seeders', 'Sprayers']
        },
        documents: ['Land Record', 'Quote from dealer', 'SC/ST certificate (if applicable)'],
        applicationProcess: ['District Agriculture Office', 'Authorized dealers'],
        benefits: ['Machinery purchase subsidy', 'Custom hiring support']
      },
      {
        id: 'beekeeping-subsidy',
        name: 'Beekeeping Subsidy',
        fullName: 'Integrated Beekeeping Development Scheme',
        description: 'Support for bee farming as supplementary income',
        benefit: 3000,
        benefitUnit: 'rupees per colony (up to 50% subsidy)',
        maxBenefit: 30000,
        eligibility: {
          landSize: { min: 0.1, max: null },
          age: { min: 18, max: 65 },
          training: 'Must have beekeeping training'
        },
        documents: ['Land Record', 'Training certificate', 'Bank Account'],
        applicationProcess: ['District Animal Husbandry Office', 'Cooperative'],
        benefits: ['Hive & equipment subsidy', 'Training', 'Market linkage']
      },
      {
        id: 'organic-farming',
        name: 'Organic Farming Scheme',
        fullName: 'Scheme for Promotion of Organic Farming',
        description: 'Support for transitioning to organic farming',
        benefit: 5000,
        benefitUnit: 'rupees per hectare (per year for 3 years)',
        maxBenefit: 15000,
        eligibility: {
          landSize: { min: 0.5, max: null },
          certification: 'Must pursue organic certification',
          commitment: '3-year commitment'
        },
        documents: ['Land Record', 'Organic farming plan', 'PGS/3rd party cert'],
        applicationProcess: ['Agriculture Department', 'Organic Certification bodies'],
        benefits: ['Certification subsidy', 'Training', 'Input material support']
      },
      {
        id: 'storage-subsidy',
        name: 'Warehouse Subsidy',
        fullName: 'Agricultural Infrastructure Development Cess Fund Scheme',
        description: 'Support for warehouse construction',
        benefit: 5000,
        benefitUnit: 'rupees per sqm (up to 50% cost)',
        maxBenefit: 250000,
        eligibility: {
          landSize: { min: 1, max: null },
          storageArea: { min: 100, max: 5000 } // sqm
        },
        documents: ['Land Record', 'Building plan', 'PWD approval'],
        applicationProcess: ['District Agriculture Office'],
        benefits: ['Warehouse construction subsidy', 'Post-harvest management support']
      },
      {
        id: 'vegetable-mission',
        name: 'Vegetable Mission',
        fullName: 'Horticulture Mission for North-East & Himalayan States',
        description: 'Support for high-value crop cultivation',
        benefit: 4000,
        benefitUnit: 'rupees per hectare (up to 50% subsidy)',
        maxBenefit: 50000,
        eligibility: {
          landSize: { min: 0.25, max: 2 },
          crops: ['Vegetables', 'Fruits', 'Spices'],
          region: ['NE States', 'Himalayan states']
        },
        documents: ['Land Record', 'Crop plan', 'Bank Account'],
        applicationProcess: ['State Horticulture Office'],
        benefits: ['Input subsidy', 'Training', 'Market linkage']
      }
    ];
  }

  /**
   * Find matching schemes based on farmer profile
   * 
   * @param {Object} input - Farmer details
   * @param {number} input.landSize - Farm size in hectares
   * @param {number} input.age - Farmer age
   * @param {string} input.state - State name
   * @param {string} input.crop - Current crop
   * @param {boolean} input.interested - Interest in scheme categories
   * @returns {Array} - Matching schemes with details
   */
  findMatchingSchemes(input) {
    this.validateInput(input);

    const matching = [];
    let score = 0;

    this.SCHEMES.forEach(scheme => {
      // Check eligibility criteria
      const landMatch = this.checkLandSize(input.landSize, scheme.eligibility.landSize);
      const ageMatch = this.checkAge(input.age, scheme.eligibility.age);
      const regionMatch = this.checkRegion(input.state, scheme.eligibility.state);
      const cropMatch = this.checkCrop(input.crop, scheme);

      if (landMatch && ageMatch && regionMatch && cropMatch) {
        score = (landMatch ? 25 : 0) + (ageMatch ? 25 : 0) + (regionMatch ? 25 : 0) + (cropMatch ? 25 : 0);

        matching.push({
          schemeId: scheme.id,
          name: scheme.name,
          fullName: scheme.fullName,
          description: scheme.description,
          benefit: scheme.benefit,
          benefitUnit: scheme.benefitUnit,
          maxBenefit: scheme.maxBenefit,
          priority: this.calculatePriority(scheme, input),
          matchScore: score,
          ...scheme
        });
      }
    });

    // Sort by priority and match score
    return matching.sort((a, b) => {
      const priorityOrder = { High: 1, Medium: 2, Low: 3 };
      if (priorityOrder[a.priority] !== priorityOrder[b.priority]) {
        return priorityOrder[a.priority] - priorityOrder[b.priority];
      }
      return b.matchScore - a.matchScore;
    });
  }

  /**
   * Validate input
   */
  validateInput(input) {
    const errors = [];

    if (typeof input.landSize !== 'number' || input.landSize < 0 || input.landSize > 1000) {
      errors.push('Land size must be 0-1000 hectares');
    }

    if (input.age && (typeof input.age !== 'number' || input.age < 18 || input.age > 120)) {
      errors.push('Age must be 18-120 years');
    }

    if (!input.state || input.state.trim() === '') {
      errors.push('State is required');
    }

    if (!input.crop || input.crop.trim() === '') {
      errors.push('Crop type is required');
    }

    if (errors.length > 0) {
      throw new Error(`Validation Error: ${errors.join(', ')}`);
    }
  }

  /**
   * Check land size eligibility
   */
  checkLandSize(userSize, schemeRange) {
    if (!schemeRange.min && !schemeRange.max) return true; // No restriction
    return userSize >= schemeRange.min && (!schemeRange.max || userSize <= schemeRange.max);
  }

  /**
   * Check age eligibility
   */
  checkAge(userAge, schemeRange) {
    if (!schemeRange || (!schemeRange.min && !schemeRange.max)) return true;
    if (!userAge) return true; // Allow if not provided
    return userAge >= (schemeRange.min || 0) && (!schemeRange.max || userAge <= schemeRange.max);
  }

  /**
   * Check region/state eligibility
   */
  checkRegion(state, schemeRegion) {
    if (!schemeRegion || schemeRegion === 'All States') return true;
    return state.toLowerCase() === schemeRegion.toLowerCase();
  }

  /**
   * Check crop eligibility
   */
  checkCrop(crop, scheme) {
    if (!scheme.eligibility.crops || scheme.eligibility.crops === '*All crops*') return true;
    return scheme.eligibility.crops.some(c => c.toLowerCase() === crop.toLowerCase());
  }

  /**
   * Calculate scheme priority for farmer
   */
  calculatePriority(scheme, input) {
    if (input.landSize < 1 && scheme.id === 'pm-kisan') return 'High';
    if (input.landSize < 0.5 && scheme.id === 'agricultural-loan') return 'Medium';
    if (scheme.id === 'crop-insurance') return 'High';
    return 'Medium';
  }

  /**
   * Get detailed scheme information
   */
  getSchemeDetails(schemeId) {
    const scheme = this.SCHEMES.find(s => s.id === schemeId);
    if (!scheme) {
      throw new Error(`Scheme '${schemeId}' not found`);
    }

    return {
      ...scheme,
      detailedInfo: this.getDetailedInfo(schemeId),
      stepsToApply: this.getApplicationSteps(schemeId),
      commonErrors: this.getCommonMistakes(schemeId),
      contactInfo: this.getContactInfo(schemeId)
    };
  }

  /**
   * Get detailed scheme benefits
   */
  getDetailedInfo(schemeId) {
    const details = {
      'pm-kisan': {
        overview: 'Direct income support to small and marginal farmers',
        implementation: 'Triennial income support',
        targetBeneficiaries: '12 crore farmers',
        duration: 'Continuous',
        amountPerBeneficiary: '2000 every 4 months'
      },
      'crop-insurance': {
        overview: 'Comprehensive crop insurance coverage',
        implementation: 'During crop season',
        coverage: 'Yield loss due to natural calamities',
        claimProcess: 'Direct to bank account'
      },
      'agricultural-loan': {
        overview: 'Flexible credit for farm operations',
        implementation: 'Continuous availability',
        advantages: ['Low interest with subsidy', 'Simple procedure', 'Long repayment period'],
        specialFeatures: ['Can cover crop loans', 'Term loans', 'Personal accidents covered']
      }
    };

    return details[schemeId] || {};
  }

  /**
   * Get application steps
   */
  getApplicationSteps(schemeId) {
    const steps = {
      'pm-kisan': [
        '1. Visit pmkisan.gov.in or nearby CSC',
        '2. Register with Aadhar and Mobile number',
        '3. Fill land details and bank account info',
        '4. Submit documents',
        '5. Verification and approval',
        '6. First installment in 2-3 months'
      ],
      'crop-insurance': [
        '1. Get crop receipt from Patwari',
        '2. Approach bank/CSC during sowing',
        '3. Pay premium (farmer share ~ 600-800 per hectare)',
        '4. Get insurance certificate',
        '5. Keep records of sowing',
        '6. Report loss to agriculture dept if claim needed'
      ],
      'agricultural-loan': [
        '1. Approach bank with KCC application',
        '2. Submit land record and ID proof',
        '3. Get property valuation',
        '4. Loan approval in 2-3 weeks',
        '5. Disbursal to bank account',
        '6. Plan repayment schedule'
      ]
    };

    return steps[schemeId] || [];
  }

  /**
   * Get common mistakes to avoid
   */
  getCommonMistakes(schemeId) {
    const mistakes = {
      'pm-kisan': [
        'Not registering on portal in time',
        'Providing wrong bank details',
        'Not updating land records',
        'Missing deadlines for updates'
      ],
      'crop-insurance': [
        'Not getting official crop receipt',
        'Late notification of crop loss',
        'Not maintaining proper records',
        'Claiming without evidence'
      ]
    };

    return mistakes[schemeId] || [];
  }

  /**
   * Get relevant contact information
   */
  getContactInfo(schemeId) {
    return {
      helpline: '1800-1800-9999',
      website: 'www.pmkisan.gov.in (for PM-KISAN)',
      localContact: 'District Agriculture Officer, Block Development Officer',
      nearestOffice: 'Check government website for nearest CSC or agriculture office'
    };
  }

  /**
   * Calculate estimated benefits over period
   */
  calculateEstimatedBenefits(schemeId, duration) {
    const scheme = this.SCHEMES.find(s => s.id === schemeId);
    if (!scheme || !scheme.maxBenefit) {
      return 'Variable or one-time benefit';
    }

    return {
      scheme: scheme.name,
      totalBenefit: scheme.maxBenefit * duration,
      perYear: scheme.maxBenefit,
      duration: `${duration} year(s)`,
      note: 'Actual amount may vary based on implementation'
    };
  }
}

module.exports = new SchemeService();
