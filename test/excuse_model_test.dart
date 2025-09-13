import 'package:flutter_test/flutter_test.dart';
import 'package:excuse_generator/models/excuse_model.dart';

void main() {
  group('ExcuseModel Tests', () {
    late ExcuseModel model;

    setUp(() {
      model = ExcuseModel();
    });

    test('Generate excuse for specific category', () {
      model.setCategory('Work');
      model.generateExcuse();
      expect(model.currentExcuse, isNotEmpty);
      expect(model.currentExcuse, isA<String>());
    });

    test('Generate excuse for All categories', () {
      model.setCategory('All');
      model.generateExcuse();
      expect(model.currentExcuse, isNotEmpty);
    });

    test('Handle non-existent category', () {
      model.setCategory('Invalid');
      model.generateExcuse();
      expect(model.currentExcuse, 'No excuses found for this category!');
    });

    test('Category setter ignores invalid categories', () {
      model.setCategory('Invalid');
      expect(model.currentCategory, 'All');
    });

    test('Add to history', () {
      model.generateExcuse();
      expect(model.history.length, 1);
      expect(model.history[0], model.currentExcuse);
    });
  });
}
