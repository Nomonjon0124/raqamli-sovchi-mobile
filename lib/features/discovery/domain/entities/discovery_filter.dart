enum DiscoveryFilter {
  matches('matches'),
  recommended('recommended'),
  nearby('nearby');

  const DiscoveryFilter(this.apiValue);

  final String apiValue;
}
