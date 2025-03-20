enum CreativeEconomyType {
  ARTS,
  CRAFTS,
  FILM,
  DESIGN,
  GASTRONOMY,
  LITERATURE,
  MUSIC,
}

final Map<String, CreativeEconomyType> creativeTypeFromString =  {
  for(var type in CreativeEconomyType.values)
    type.name: type,
};

extension CreativeEconomyTypeExtension on CreativeEconomyType {

  String get value {
    switch (this) {
      case CreativeEconomyType.ARTS:
        return "Artes Midiáticas";
      case CreativeEconomyType.CRAFTS:
        return "Artesanato";
      case CreativeEconomyType.DESIGN:
        return "Design";
      case CreativeEconomyType.FILM:
        return "Cinema";
      case CreativeEconomyType.GASTRONOMY:
        return "Gastronomia";
      case CreativeEconomyType.LITERATURE:
        return "Literatura";
      case CreativeEconomyType.MUSIC:
        return "Música";
      default:
        return "Não definido";
    }
  }
}
