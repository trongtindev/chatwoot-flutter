import '/imports.dart';

class AssistantGenerativePrompt {}

class AssistantGenerativeResult {}

abstract class AssistantProvider {
  Future<Result<AssistantGenerativeResult>> generative();
}
