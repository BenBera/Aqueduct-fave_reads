import 'package:fave_reads/model/read.dart';

import 'harness/app.dart';

void main() {
  final harness = Harness()..install();

  setUp(() async {
    final readQuery = Query<Read>(harness.application.channel.context)
      ..values.title = 'Take a Break'
      ..values.author = 'BenTera'
      ..values.year = 2007
      ..values.description = 'It Healthy to have a break';
    await readQuery.insert();
  });

  // function provided by the Matcher library for testing
  // eg hasLength, everyElement({}), everyElemen(partial()),
  test('GET/reads returns a 200 OK', () async {
    final response = await harness.agent.get('/reads');
    expectResponse(response, 200,
        body: everyElement(partial({
          'id': greaterThan(0),
          'title': isString,
          'author': isString,
          'description': isString,
          // 'year': isInteger,
          // 'detail': isString
        })));
  });

  test('GET/reads/:id returns a single read', () async {
    final response = await harness.agent.get('/reads/1');
    expectResponse(response, 200, body: {
      'id': 1,
      'title': 'Take a Break',
      'author': 'BenTera',
      'description': 'It Healthy to have a break',
      'year': 2007,
      'detail': 'Take a Break by BenTera'
    });
  });

  test('GET/reads/2 returns a 404 response', () async {
    final response = await harness.agent.get('/reads/2');
    expectResponse(response, 404, body: "Item not found.");
  });

  test('POST/reads create a new read', () async {
    final response = await harness.agent.post('/reads', body: {
      "title": "Coming Home second Edition with the Examples",
      "author": "Benra",
      "description": "TIts a new Home",
      "year": 2011
    });
    expectResponse(response, 200, body: {
      "id": 2,
      "title": "Coming Home second Edition with the Examples",
      "author": "Benra",
      "description": "TIts a new Home",
      "year": 2011,
      "detail": "Coming Home second Edition with the Examples by Benra"
    });
  });

  test('PUT/reads/:id updates a read', () async {
    final response = await harness.agent.put('/reads/1', body: {
      "title": "The dying Horse Will never cry",
      "author": "TAkenBenra",
      "description": "The Mistry You Never Knew",
      "year": 2000,
    });
    expectResponse(response, 200, body: {
      "id": 1,
      "title": "The dying Horse Will never cry",
      "author": "TAkenBenra",
      "description": "The Mistry You Never Knew",
      "year": 2000,
      "detail": "The dying Horse Will never cry by TAkenBenra"
    });
  });

  test('PUT/reads/2 returns 404 response', () async {
    final response = await harness.agent.put('/reads/2', body: {
      "title": "The dying Horse Will never cry",
      "author": "TAkenBenra",
      "description": "The Mistry You Never Knew",
      "year": 2000,
    });
    expectResponse(response, 404, body: "Item not found.");
  });

  test('DELETE/reads/:id deletes a read', () async {
    final response = await harness.agent.delete('/reads/1');
    expectResponse(response, 200, body: 'Deleted read. 1 items');
  });
  test('DELETE/reads/2 returns a 404 response', () async {
    final response = await harness.agent.delete('/reads/2');
    expectResponse(response, 404, body: "Item not found.");
  });
}
