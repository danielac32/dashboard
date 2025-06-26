

String getDisplayName(String? section) {
  if (section == null) {
    return 'Sin nombre'; // O algún valor predeterminado
  }
  return section
      .toLowerCase()
      .replaceAll('_', ' ')
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}