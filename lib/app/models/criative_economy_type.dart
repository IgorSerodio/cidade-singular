enum CriativeEconomyType {
  from,
  ARTS,
  CRAFTS,
  FILM,
  DESIGN,
  GASTRONOMY,
  LITERATURE,
  MUSIC,
}

extension CriativeEconomyTypeExtension on CriativeEconomyType {
  String get value {
    switch (this) {
      case CriativeEconomyType.ARTS:
        return "Artes Midiáticas";
      case CriativeEconomyType.CRAFTS:
        return "Artesanato";
      case CriativeEconomyType.DESIGN:
        return "Design";
      case CriativeEconomyType.FILM:
        return "Cinema";
      case CriativeEconomyType.GASTRONOMY:
        return "Gastronomia";
      case CriativeEconomyType.LITERATURE:
        return "Literatura";
      case CriativeEconomyType.MUSIC:
        return "Música";
      default:
        return "Não definido";
    }
  }

  operator [](String key) => (name) {
    switch (name) {
      case 'ARTS':
        return CriativeEconomyType.ARTS;
      case 'CRAFTS':
        return CriativeEconomyType.CRAFTS;
      case 'DESIGN':
        return CriativeEconomyType.DESIGN;
      case 'FILM':
        return CriativeEconomyType.FILM;
      case 'GASTRONOMY':
        return CriativeEconomyType.GASTRONOMY;
      case 'LITERATURE':
        return CriativeEconomyType.LITERATURE;
      case 'MUSIC':
        return CriativeEconomyType.MUSIC;
      default:
        return null;
    }
  }(key);
}
