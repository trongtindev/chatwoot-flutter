import 'package:chatwoot/imports.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<dynamic> payload = [
    {
      'id': 1,
      'title': 'buyed',
      'description': 'buyed_description',
      'color': '#097D1E',
      'show_on_sidebar': true
    },
    {
      'id': 2,
      'title': 'refund',
      'description': 'refund_description',
      'color': '#FF0707',
      'show_on_sidebar': false
    },
  ];

  test('LabelInfo.fromJson', () async {
    final labels = payload.map(LabelInfo.fromJson).toList();

    expect(labels[0].id, 1);
    expect(labels[1].id, 2);

    expect(labels[0].title, 'buyed');
    expect(labels[1].title, 'refund');

    expect(labels[0].description, 'buyed_description');
    expect(labels[1].description, 'refund_description');

    expect(labels[0].color, HexColor.fromHex('#097D1E'));
    expect(labels[1].color, HexColor.fromHex('#FF0707'));

    expect(labels[0].show_on_sidebar, true);
    expect(labels[1].show_on_sidebar, false);
  });
}
