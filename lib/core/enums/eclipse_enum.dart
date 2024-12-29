enum EclipseEnum {
  anullarSolar,
  hybridSolar,
  partialLunar,
  partialSolar,
  penumbralLunar,
  totalUmbralLunar,
  totalSolar,
}

extension EclipseEnumExtension on EclipseEnum {
  String toShortString() {
    switch (this) {
      case EclipseEnum.anullarSolar:
        return 'Annular Solar';
      // return 'anullar';
      case EclipseEnum.hybridSolar:
        return 'Hybrid (Annular/Total) Solar';
      // return 'hybrid';
      case EclipseEnum.partialLunar:
        return 'Partial (Umbral) Lunar';
      // return 'partial';
      case EclipseEnum.partialSolar:
        return 'Partial Solar';
      // return 'partialSolar';
      case EclipseEnum.penumbralLunar:
        return 'Penumbral Lunar';
      // return 'penumbral';
      case EclipseEnum.totalUmbralLunar:
        return 'Total (Umbral) Lunar';
      // return 'totalUmbralLunar';
      case EclipseEnum.totalSolar:
        return 'Total Solar';
      // return 'total';
    }
  }

  String toFullString() {
    switch (this) {
      case EclipseEnum.anullarSolar:
        return 'Annular Solar';
      case EclipseEnum.hybridSolar:
        return 'Hybrid (Annular/Total) Solar';
      case EclipseEnum.partialLunar:
        return 'Partial (Umbral) Lunar';
      case EclipseEnum.partialSolar:
        return 'Partial Solar';
      case EclipseEnum.penumbralLunar:
        return 'Penumbral Lunar';
      case EclipseEnum.totalUmbralLunar:
        return 'Total (Umbral) Lunar';
      case EclipseEnum.totalSolar:
        return 'Total Solar';
    }
  }
}
