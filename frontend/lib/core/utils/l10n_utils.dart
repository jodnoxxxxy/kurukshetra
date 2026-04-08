import 'package:flutter/material.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class L10nUtils {
  static String translateCrop(BuildContext context, String cropKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (cropKey) {
      case 'wheat': return l10n.wheat;
      case 'rice': return l10n.rice;
      case 'maize': return l10n.maize;
      case 'gram': return l10n.gram;
      case 'blackGram': return l10n.blackGram;
      case 'greenGram': return l10n.greenGram;
      case 'soybean': return l10n.soybean;
      case 'groundnut': return l10n.groundnut;
      case 'sunflower': return l10n.sunflower;
      case 'tomato': return l10n.tomato;
      case 'onion': return l10n.onion;
      case 'potato': return l10n.potato;
      case 'apple': return l10n.apple;
      case 'banana': return l10n.banana;
      case 'jute': return l10n.jute;
      case 'cotton': return l10n.cotton;
      case 'mustard': return l10n.mustard;
      case 'paddy': return l10n.rice; // Paddy is same as Rice in localization
      case 'sugarcane': return l10n.sugarcane;
      case 'ragi': return l10n.ragi;
      case 'bajra': return l10n.bajra;
      case 'jowar': return l10n.jowar;
      case 'pulses': return l10n.pulses;
      default: return cropKey;
    }
  }

  static String translateCropName(BuildContext context, String cropKey) => translateCrop(context, cropKey);

  static String translateCategory(BuildContext context, String categoryKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (categoryKey) {
      case 'categoryCereals': return l10n.categoryCereals;
      case 'categoryPulses': return l10n.categoryPulses;
      case 'categoryOilseeds': return l10n.categoryOilseeds;
      case 'categoryVegetables': return l10n.categoryVegetables;
      case 'categoryFruits': return l10n.categoryFruits;
      default: return categoryKey;
    }
  }

  static String translateWeatherCondition(BuildContext context, String conditionKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (conditionKey.toLowerCase()) {
      case 'partly cloudy': return l10n.partlyCloudy;
      case 'sunny':
      case 'clear': return l10n.sunny;
      case 'cloudy':
      case 'overcast': return l10n.cloudy;
      case 'rainy':
      case 'showers':
      case 'drizzle': return l10n.rainy;
      case 'stormy': return l10n.rainy; // Could have specific l10n for stormy if available
      case 'hot and dry': return l10n.hotAndDry;
      default: return conditionKey;
    }
  }

  static String translateOrganicStatus(BuildContext context, String statusKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (statusKey.toLowerCase()) {
      case 'not certified': return l10n.notCertified;
      case 'certified': return l10n.certified;
      case 'pending': return l10n.organicPending;
      default: return statusKey;
    }
  }

  static String translatePest(BuildContext context, String pestKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (pestKey.toLowerCase()) {
      case 'aphids': return l10n.aphids;
      case 'stem borer': return l10n.stemBorer;
      case 'leaf blight': return l10n.leafBlight;
      default: return pestKey;
    }
  }

  static String translatePestCategory(BuildContext context, String categoryKey) {
    final l10n = AppLocalizations.of(context)!;
    switch (categoryKey.toLowerCase()) {
      case 'leaf pests': return l10n.leafPests;
      case 'stem pests': return l10n.stemPests;
      case 'fungal diseases': return l10n.fungalDiseases;
      default: return categoryKey;
    }
  }

  static String translateSoilStatus(BuildContext context, String status) {
    final l10n = AppLocalizations.of(context)!;
    switch (status.toLowerCase()) {
      case 'low': return l10n.lowStatus;
      case 'medium': return l10n.mediumStatus;
      case 'high': return l10n.highStatus;
      case 'acidic': return l10n.acidicStatus;
      case 'alkaline': return l10n.alkalineStatus;
      case 'neutral': return l10n.neutralStatus;
      default: return status;
    }
  }

  static String translateSoilHealthLabel(BuildContext context, String label) {
    final l10n = AppLocalizations.of(context)!;
    switch (label.toLowerCase()) {
      case 'healthy': return l10n.healthyLabel;
      case 'moderate': return l10n.moderateLabel;
      case 'poor': return l10n.poorLabel;
      default: return label;
    }
  }

  static String translateNotificationType(BuildContext context, String type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type.toLowerCase()) {
      case 'weather': return l10n.weatherAlert;
      case 'pest': return l10n.pestRiskAlert;
      case 'market': return l10n.marketPriceAlert;
      case 'scheme': return l10n.governmentSchemeUpdate;
      case 'order': return l10n.orderUpdate;
      default: return type;
    }
  }
}
