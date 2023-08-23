


class UserData {
  static int userId = 0;
  static String userNickname = '';
  static String userEmail = '';
  static String userImageUrl = '';
  static String? userPhoneNumber = '';
  static String? userDateJoin = '';
  static String? userDateStart = '';
  static String? userDateEnd = '';
  static String? userTier = '';
  static String? userDocumentId = '';
  static String? userEtc = '';
}

class UserToken {
  static bool hasToken = false;
}

class TagList {
 static List<String> tagList = ['계약전', '계약후', '소개', '지인'];
}