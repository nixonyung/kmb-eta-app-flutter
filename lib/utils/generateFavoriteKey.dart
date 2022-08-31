String generateFavoriteKey({
  required String route,
  required String bound,
  required String serviceType,
  required int index,
  required String stopId,
}) =>
    "${route}_${bound}_${serviceType}_${index}_${stopId}";


// generateFavoriteKey(
//   route: route,
//   bound: bound,
//   serviceType: serviceType,
//   index: index,
//   stopId: stopId,
// ),
