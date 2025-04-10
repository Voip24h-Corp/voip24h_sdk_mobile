enum GraphRoute {
  // call
  CallLog('call/history'),
  Record('call/recording'),

  // customer
  Contact('contact'),
  AddContact('contact'),
  UpdateContact('contact'),
  DeleteContact('contact');

  final String value;

  const GraphRoute(this.value);
}
