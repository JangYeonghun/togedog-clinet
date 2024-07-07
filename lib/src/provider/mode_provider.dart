import 'package:flutter_riverpod/flutter_riverpod.dart';

// riverpod 1. 설정 (= provider ChangeNotifierProvider)
final modeProvider = StateNotifierProvider<ModeNotifier, bool>((ref) {
  return ModeNotifier();
});

// riverpod 2. 상태 관리 StateNotifier<int> (= provider ChangeNotifier)
class ModeNotifier extends StateNotifier<bool> {
  ModeNotifier() : super(true);

  void setMode(bool mode) => state = mode;

  void disposeValues() => state = true;
}
