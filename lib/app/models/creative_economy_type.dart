enum CreativeEconomyType {
  from,
  ARTS,
  CRAFTS,
  FILM,
  DESIGN,
  GASTRONOMY,
  LITERATURE,
  MUSIC,
}

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

  operator [](String key) => (name) {
    switch (name) {
      case 'ARTS':
        return CreativeEconomyType.ARTS;
      case 'CRAFTS':
        return CreativeEconomyType.CRAFTS;
      case 'DESIGN':
        return CreativeEconomyType.DESIGN;
      case 'FILM':
        return CreativeEconomyType.FILM;
      case 'GASTRONOMY':
        return CreativeEconomyType.GASTRONOMY;
      case 'LITERATURE':
        return CreativeEconomyType.LITERATURE;
      case 'MUSIC':
        return CreativeEconomyType.MUSIC;
      default:
        return null;
    }
  }(key);
}
