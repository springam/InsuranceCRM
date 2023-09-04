


class UserData {
  static int userId = 0;
  static String userNickname = '';
  static String userEmail = '';
  static String userImageUrl = '';
  static String userPhoneNumber = '';
  static String userDateJoin = '';
  static String userDateStart = '';
  static String userDateEnd = '';
  static String userTier = '';
  static String userDocumentId = '';
  static String userEtc = '';
  static String userCompany = '';
  static String userTeam = '';
}

class UserToken {
  static bool hasToken = false;
}

class TagList {
 static List<String> tagList = ['계약전', '계약후', '소개', '지인'];
}

class ThemeList {
  static List<String> themeList = ['월초', '생일', '안부', '결혼', '계절', '연휴', '맨 처음', '계약후', '보상후', '내 메시지', '다른사람 메시지'];
}
