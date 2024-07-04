import 'package:flutter_riverpod/flutter_riverpod.dart';

// riverpod 1. 설정 (= provider ChangeNotifierProvider)
final bottomNavigationProvider = StateNotifierProvider<BottomNavigationNotifier, int>((ref) {
  return BottomNavigationNotifier();
});

// riverpod 2. 상태 관리 StateNotifier<int> (= provider ChangeNotifier)
class BottomNavigationNotifier extends StateNotifier<int> {
  BottomNavigationNotifier() : super(0);

  void setIndex(int index) => state = index;

  void disposeValues() => state = 0;
}
