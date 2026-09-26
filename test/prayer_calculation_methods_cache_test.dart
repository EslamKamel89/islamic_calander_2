import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_calander_2/core/api_service/api_consumer.dart';
import 'package:islamic_calander_2/core/globals/calc_method_settings.dart';
import 'package:islamic_calander_2/core/service_locator/service_locator.dart';

class _ControlledApi implements ApiConsumer {
  final requests = <Completer<dynamic>>[];

  @override
  Future<dynamic> get(String path,
      {Object? data, Map<String, dynamic>? queryParameter}) {
    final request = Completer<dynamic>();
    requests.add(request);
    return request.future;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('shares decoded futures, retries failures, and retains success',
      () async {
    final api = _ControlledApi();
    serviceLocator.registerSingleton<ApiConsumer>(api);
    addTearDown(() => serviceLocator.reset());

    final first = fetchPrayerCalculationMethodsByCountry();
    final concurrent = fetchPrayerCalculationMethodsByCountry();
    expect(identical(first, concurrent), isTrue);
    expect(api.requests, hasLength(1));
    api.requests.single.completeError(StateError('Network unavailable'));
    expect(await first, isEmpty);
    expect(await concurrent, isEmpty);

    final malformed = fetchPrayerCalculationMethodsByCountry();
    expect(api.requests, hasLength(2));
    api.requests.last.complete('not JSON');
    expect(await malformed, isEmpty);

    final retry = fetchPrayerCalculationMethodsByCountry();
    final sharedRetry = fetchPrayerCalculationMethodsByCountry();
    expect(identical(retry, sharedRetry), isTrue);
    expect(api.requests, hasLength(3));
    api.requests.last.complete('{"US":"islamicSocietyNorthAmerica"}');
    expect(await retry, {'US': 'islamicSocietyNorthAmerica'});
    expect(await sharedRetry, {'US': 'islamicSocietyNorthAmerica'});

    final cached = fetchPrayerCalculationMethodsByCountry();
    expect(identical(cached, retry), isTrue);
    expect(await cached, {'US': 'islamicSocietyNorthAmerica'});
    expect(api.requests, hasLength(3));
  });
}
