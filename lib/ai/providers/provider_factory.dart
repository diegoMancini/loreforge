import 'base_provider.dart';
import 'anthropic_provider.dart';
import 'openai_provider.dart';
import 'deepseek_provider.dart';
import 'mock_provider.dart';
import 'provider_router.dart';

/// Builds a [ProviderRouter] from user-configured API keys.
///
/// Called when starting a new adventure — reads keys from the settings
/// model and creates provider instances for each configured service.
ProviderRouter createRouter({
  String? anthropicKey,
  String? openaiKey,
  String? deepseekKey,
  String preferred = 'auto',
}) {
  final providers = <String, AIProvider>{};

  if (anthropicKey != null && anthropicKey.isNotEmpty) {
    providers['anthropic'] = AnthropicProvider(anthropicKey);
  }
  if (openaiKey != null && openaiKey.isNotEmpty) {
    providers['openai'] = OpenAIProvider(openaiKey);
  }
  if (deepseekKey != null && deepseekKey.isNotEmpty) {
    providers['deepseek'] = DeepSeekProvider(deepseekKey);
  }

  // Fall back to mock when no real providers are configured (dev mode).
  if (providers.isEmpty) {
    providers['mock'] = MockProvider();
  }

  return ProviderRouter(providers, preferred: preferred);
}
