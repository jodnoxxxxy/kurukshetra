enum SoilType {
  alluvial('Alluvial'),
  black('Black'),
  red('Red'),
  laterite('Laterite'),
  arid('Arid'),
  mountain('Mountain');

  final String label;
  const SoilType(this.label);
}

enum WaterAvailability {
  low('Low'),
  medium('Medium'),
  high('High');

  final String label;
  const WaterAvailability(this.label);
}

enum Season {
  kharif('Kharif'),
  rabi('Rabi'),
  summer('Summer');

  final String label;
  const Season(this.label);
}
