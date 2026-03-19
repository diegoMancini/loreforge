import 'base_provider.dart';

/// Categorizes agent tasks for smart provider routing.
enum AITask {
  /// Scene narrative prose — quality matters most.
  sceneWriting,

  /// Story blueprint generation — needs structured reasoning.
  blueprintGeneration,

  /// Player choice generation — structured output, cheaper task.
  choiceGeneration,

  /// Pacing / director analysis — analytical, cheap.
  pacingAnalysis,

  /// Consistency validation — simple check, cheap.
  consistencyCheck,

  /// Visual asset selection — simple classification, cheap.
  visualDirection,

  /// World state updates — structured output, cheap.
  worldStateUpdate,

  /// Story context summarisation — analytical, cheap.
  contextSummary,
}

/// Routes AI tasks to the best available provider.
///
/// When [preferred] is `'auto'` (the default), high-quality tasks like scene
/// writing are routed to Claude or GPT-4o, while cheaper analytical tasks go
/// to DeepSeek. If only one provider is configured, everything routes there.
class ProviderRouter {
  final Map<String, AIProvider> _providers;
  final String preferred;

  ProviderRouter(this._providers, {this.preferred = 'auto'});

  /// Whether at least one real provider is available.
  bool get hasAnyProvider => _providers.isNotEmpty;

  /// Returns the best provider for [task] based on routing rules.
  AIProvider providerFor(AITask task) {
    // User explicitly chose a provider — honour that for everything.
    if (preferred != 'auto' && _providers.containsKey(preferred)) {
      return _providers[preferred]!;
    }

    if (_providers.isEmpty) {
      throw StateError('No AI providers configured.');
    }

    // Smart routing: quality-sensitive tasks → best model, others → cheapest.
    switch (task) {
      case AITask.sceneWriting:
      case AITask.blueprintGeneration:
        return _providers['anthropic'] ??
            _providers['openai'] ??
            _providers.values.first;

      case AITask.choiceGeneration:
      case AITask.pacingAnalysis:
      case AITask.consistencyCheck:
      case AITask.visualDirection:
      case AITask.worldStateUpdate:
      case AITask.contextSummary:
        return _providers['deepseek'] ??
            _providers.values.first;
    }
  }

  /// Returns a provider different from [failed], or `null` if no fallback
  /// is available.
  AIProvider? fallbackFor(AIProvider failed) {
    for (final p in _providers.values) {
      if (p.name != failed.name) return p;
    }
    return null;
  }
}
