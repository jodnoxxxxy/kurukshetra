const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

class MarketService {
  // Record market price
  async recordPrice(priceData) {
    if (!priceData.cropName || !priceData.price) {
      throw new Error('cropName and price are required');
    }

    try {
      const marketPrice = await prisma.marketPrice.create({
        data: {
          cropName: priceData.cropName,
          price: priceData.price,
          unit: priceData.unit || 'per_kg',
          location: priceData.location,
          trend: priceData.trend || 'STABLE',
          source: priceData.source,
          quality: priceData.quality
        }
      });

      return marketPrice;
    } catch (error) {
      throw new Error(`Failed to record price: ${error.message}`);
    }
  }

  // Get all market prices
  async getAllPrices(filters = {}) {
    try {
      const prices = await prisma.marketPrice.findMany({
        where: filters,
        orderBy: { recordedAt: 'desc' }
      });

      return prices;
    } catch (error) {
      throw new Error(`Failed to fetch market prices: ${error.message}`);
    }
  }

  // Get price by crop name
  async getPriceByCrop(cropName) {
    try {
      const prices = await prisma.marketPrice.findMany({
        where: {
          cropName: {
            contains: cropName,
            mode: 'insensitive'
          }
        },
        orderBy: { recordedAt: 'desc' },
        take: 10
      });

      return prices;
    } catch (error) {
      throw new Error(`Failed to fetch prices: ${error.message}`);
    }
  }

  // Get latest prices
  async getLatestPrices(limit = 20) {
    try {
      const prices = await prisma.marketPrice.findMany({
        orderBy: { recordedAt: 'desc' },
        take: limit
      });

      return prices;
    } catch (error) {
      throw new Error(`Failed to fetch latest prices: ${error.message}`);
    }
  }

  // Get price trends
  async getPriceTrends(cropName) {
    try {
      const prices = await prisma.marketPrice.findMany({
        where: {
          cropName: {
            contains: cropName,
            mode: 'insensitive'
          }
        },
        orderBy: { recordedAt: 'desc' },
        take: 30
      });

      if (prices.length === 0) {
        return { message: 'No price data available' };
      }

      const avgPrice = prices.reduce((sum, p) => sum + p.price, 0) / prices.length;
      const minPrice = Math.min(...prices.map(p => p.price));
      const maxPrice = Math.max(...prices.map(p => p.price));
      const latestPrice = prices[0].price;

      const trendDirection = latestPrice > avgPrice ? 'UP' : latestPrice < avgPrice ? 'DOWN' : 'STABLE';

      return {
        cropName,
        avgPrice: Math.round(avgPrice * 100) / 100,
        minPrice,
        maxPrice,
        latestPrice,
        trendDirection,
        dataPoints: prices.length,
        lastUpdated: prices[0].recordedAt
      };
    } catch (error) {
      throw new Error(`Failed to get price trends: ${error.message}`);
    }
  }

  // Get price forecast (simple average based on trend)
  async getPriceForecast(cropName) {
    try {
      const prices = await prisma.marketPrice.findMany({
        where: {
          cropName: {
            contains: cropName,
            mode: 'insensitive'
          }
        },
        orderBy: { recordedAt: 'desc' },
        take: 7
      });

      if (prices.length < 2) {
        return { message: 'Insufficient data for forecast' };
      }

      const avgPrice = prices.reduce((sum, p) => sum + p.price, 0) / prices.length;
      const recentTrend = (prices[0].price - prices[prices.length - 1].price) / prices.length;
      const forecastPrice = avgPrice + recentTrend;

      return {
        cropName,
        currentPrice: prices[0].price,
        forecastedPrice: Math.round(forecastPrice * 100) / 100,
        trend: recentTrend > 0 ? 'INCREASE' : recentTrend < 0 ? 'DECREASE' : 'STABLE',
        confidence: 'MEDIUM',
        daysAhead: 1
      };
    } catch (error) {
      throw new Error(`Failed to get forecast: ${error.message}`);
    }
  }

  // Search prices by location
  async getPricesByLocation(location) {
    try {
      const prices = await prisma.marketPrice.findMany({
        where: {
          location: {
            contains: location,
            mode: 'insensitive'
          }
        },
        orderBy: { recordedAt: 'desc' },
        take: 20
      });

      return prices;
    } catch (error) {
      throw new Error(`Failed to fetch prices by location: ${error.message}`);
    }
  }

  // Get market statistics
  async getMarketStatistics() {
    try {
      const totalRecords = await prisma.marketPrice.count();
      
      const uniqueCrops = await prisma.marketPrice.findMany({
        select: { cropName: true },
        distinct: ['cropName']
      });

      const avgPrice = await prisma.marketPrice.aggregate({
        _avg: { price: true },
        _min: { price: true },
        _max: { price: true }
      });

      return {
        totalPriceRecords: totalRecords,
        uniqueCrops: uniqueCrops.length,
        averagePrice: Math.round(avgPrice._avg.price * 100) / 100,
        minPrice: avgPrice._min.price,
        maxPrice: avgPrice._max.price
      };
    } catch (error) {
      throw new Error(`Failed to get statistics: ${error.message}`);
    }
  }
}

module.exports = new MarketService();
