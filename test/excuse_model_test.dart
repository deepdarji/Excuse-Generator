import 'package:flutter_test/flutter_test.dart';
import 'package:excuse_generator/models/excuse_model.dart';

void main() {
  // This is the main test group
  group('ExcuseModel Tests', () {
    // We will use this model in the tests
    late ExcuseModel model;

    // This runs before every test
    setUp(() {
      model = ExcuseModel();
    });

    test('should make excuse for one category', () {
      model.setCategory('Work'); // choose category
      model.generateExcuse(); // make excuse
      expect(model.currentExcuse, isNotEmpty); // check not empty
      expect(model.currentExcuse, isA<String>()); // check is string
    });

    test('should make excuse for all categories', () {
      model.setCategory('All'); // choose all
      model.generateExcuse();
      expect(model.currentExcuse, isNotEmpty);
    });

    test('should show message for wrong category', () {
      model.setCategory('Invalid'); // wrong one
      model.generateExcuse();
      expect(model.currentExcuse, 'No excuses found for this category!');
    });

    test('should keep All if wrong category is given', () {
      model.setCategory('Invalid');
      expect(model.currentCategory, 'All');
    });

    test('should add excuse to history', () {
      model.generateExcuse();
      expect(model.history.length, 1); // one item added
      expect(model.history[0], model.currentExcuse); // same as current
    });
  });
}
