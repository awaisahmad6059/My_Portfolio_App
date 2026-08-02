import 'package:flutter_test/flutter_test.dart';
import 'package:aak/core/constants/chat_strings.dart';
import 'package:aak/data/ai/chat_engine.dart';
import 'package:aak/data/ai/chat_intent.dart';

void main() {
  const engine = ChatEngine();

  group('intent detection', () {
    test('greets', () {
      expect(engine.detect('Assalam-o-Alaikum!'), ChatIntent.greeting);
      expect(engine.detect('hi there'), ChatIntent.greeting);
    });

    test('asks who Awais is', () {
      expect(engine.detect('Who is Awais Ahmad?'), ChatIntent.whoIs);
      expect(engine.detect('Tell me about AAK'), ChatIntent.whoIs);
    });

    test('asks about skills', () {
      expect(engine.detect('What are his skills?'), ChatIntent.skills);
    });

    test('asks about education', () {
      expect(engine.detect('Tell me about his education'), ChatIntent.education);
      expect(engine.detect('What did he study?'), ChatIntent.education);
    });

    test('asks about projects', () {
      expect(engine.detect('What projects has he built?'), ChatIntent.projects);
    });

    test('asks about services', () {
      expect(engine.detect('What services does he offer?'), ChatIntent.services);
    });

    test('asks for contact details', () {
      expect(engine.detect('What is his email?'), ChatIntent.contactEmail);
      expect(engine.detect('whatsapp number?'), ChatIntent.contactPhone);
      expect(engine.detect('How can I contact him?'), ChatIntent.howToHire);
    });

    test('detects assistant identity', () {
      expect(engine.detect('Are you ChatGPT?'), ChatIntent.assistantIdentity);
      expect(engine.detect('Who are you?'), ChatIntent.assistantIdentity);
    });

    test('falls back to out of scope for unrelated questions', () {
      expect(
        engine.detect('What is the capital of France?'),
        ChatIntent.outOfScope,
      );
      expect(
        engine.detect('Who won the cricket world cup?'),
        ChatIntent.outOfScope,
      );
    });

    test('falls back to not found for gibberish', () {
      expect(engine.detect('zzz xyz qqq'), ChatIntent.notFound);
    });
  });

  group('answers', () {
    test('refuses unrelated questions politely', () {
      expect(
        engine.answer('What is the weather in London?'),
        ChatStrings.refusalMessage,
      );
    });

    test('does not guess unknown facts', () {
      expect(
        engine.answer('zzz xyz qqq'),
        ChatStrings.notFoundMessage,
      );
    });

    test('answers who-is with real facts', () {
      final answer = engine.answer('Who is Awais Ahmad?');
      expect(answer, contains('Awais Ahmad'));
      expect(answer, contains('Software Developer'));
    });

    test('answers skills question', () {
      final answer = engine.answer('What are his skills?');
      expect(answer, contains('Flutter'));
      expect(answer, contains('Android'));
    });

    test('answers education question', () {
      final answer = engine.answer('Tell me about his education');
      expect(answer, contains('COMSATS'));
      expect(answer, contains('Computer Science'));
    });

    test('answers projects question', () {
      final answer = engine.answer('What projects has he built?');
      expect(answer, contains('TicTacToe'));
    });

    test('answers services question', () {
      final answer = engine.answer('What services does he offer?');
      expect(answer, contains('Flutter App Development'));
      expect(answer, contains('Shopify'));
    });

    test('answers email question with real email', () {
      final answer = engine.answer('What is his email?');
      expect(answer, contains('kamyana786138@gmail.com'));
    });

    test('answers phone question with real number', () {
      final answer = engine.answer('whatsapp number?');
      expect(answer, contains('+923267733647'));
    });
  });
}
