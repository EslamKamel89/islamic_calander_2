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
        return 'anullarSolar';
      case EclipseEnum.hybridSolar:
        return 'hybridSolar';
      case EclipseEnum.partialLunar:
        return 'partialLunar';
      case EclipseEnum.partialSolar:
        return 'partialSolar';
      case EclipseEnum.penumbralLunar:
        return 'penumbralLunar';
      case EclipseEnum.totalUmbralLunar:
        return 'totalUmbralLunar';
      case EclipseEnum.totalSolar:
        return 'totalSolar';
    }
  }

  String toFullString() {
    switch (this) {
      case EclipseEnum.anullarSolar:
        return 'Annular Solar';
      case EclipseEnum.hybridSolar:
        return 'Hybrid (Annular/Total) Solar';
      case EclipseEnum.partialLunar:
        return 'Partial (Unbral) Lunar';
      case EclipseEnum.partialSolar:
        return 'Partial Solar';
      case EclipseEnum.penumbralLunar:
        return 'Penumbral Lunar';
      case EclipseEnum.totalUmbralLunar:
        return 'Total (Umbral) Lunar';
      case EclipseEnum.totalSolar:
        return 'Total Sular';
    }
  }
}
