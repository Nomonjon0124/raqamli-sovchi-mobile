enum DiscoveryFilter {
  matches('matches'),
  recommended('recommended'),
  nearby('nearby'),
  representative('representative');

  const DiscoveryFilter(this.apiValue);

  final String apiValue;
}
