class GlobalState {
  static bool isLoggedIn = false; // 로그인 상태
  static Map<String, dynamic>? userInfo; // 사용자 정보
  static int selectedIndex = 1; // Page Index
  static String? patientId = "";
}