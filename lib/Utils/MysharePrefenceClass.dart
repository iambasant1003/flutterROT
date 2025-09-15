
import 'package:loan112_app/Utils/Debugprint.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MySharedPreferences {
  static const setLoginData = 'logInData';
  static const isPermissionGiven = 'permissionGiven';
  static const userSessionDataNode = 'userSessionDataNode';
  static const userSessionDataPhp = "useSessionDataPhp";
  static const savePhpOtpModel = 'savePhpOtpModel';
  static const saveLeadId = 'saveLeadId';
  static const saveCustomerDetails = "saveCustomerDetails";
  static const setNotificationTokenData = "saveNotificationToken";
  static const contactUsEmail = "contactUsEmail";
  static const chatUsNumber = "chatUsNumber";
  static const callUsNumber = "callUsNumber";
  static const isEnhanceKey = "isEnhance";
  static const appsFlyerKeyset = "appsFlyerKey";


  static Future<SharedPreferences> _getPreferences() async {
    return SharedPreferences.getInstance();
  }



  static Future<void> setPermissionStatus(bool permission) async {
    bool data = permission;
    final prefs = await _getPreferences();
    await prefs.setBool(isPermissionGiven, data);
  }

  static Future<bool> getPermissionStatus() async {
    final prefs = await _getPreferences();
    bool? isPermission = prefs.getBool(isPermissionGiven);

    if (isPermission != null) {
      return isPermission;
    } else {
      return false;
    }
  }


  static Future<void> setLogInPIn(String logInPIN) async {
    String data = logInPIN;
    final prefs = await _getPreferences();
    await prefs.setString(setLoginData, data);
  }

  static Future<String> getLogInPIn() async {
    final prefs = await _getPreferences();
    String? loginPIN = prefs.getString(setLoginData);

    if (loginPIN != null) {
      return loginPIN;
    } else {
      return "";
    }
  }

  static Future<void> setContactUsEmail(String email) async {
    String data = email;
    final prefs = await _getPreferences();
    await prefs.setString(contactUsEmail, data);
  }

  static Future<String> getContactUsEmail() async {
    final prefs = await _getPreferences();
    String? email = prefs.getString(contactUsEmail);

    if (email != null) {
      return email;
    } else {
      return "";
    }
  }


  static Future<void> setAppsFlyerKey(String appFlyerKey) async {
    String data = appFlyerKey;
    final prefs = await _getPreferences();
    await prefs.setString(appsFlyerKeyset, data);
  }

  static Future<String> getAppsFlyerKey() async {
    final prefs = await _getPreferences();
    String? appFlyerKey = prefs.getString(appsFlyerKeyset);

    if (appFlyerKey != null) {
      return appFlyerKey;
    } else {
      return "";
    }
  }

  static Future<void> setChatUsNumber(String chatNumber) async {
    String data = chatNumber;
    final prefs = await _getPreferences();
    await prefs.setString(chatUsNumber, data);
  }

  static Future<String> getChatUsNumber() async {
    final prefs = await _getPreferences();
    String? chatNumber = prefs.getString(chatUsNumber);

    if (chatNumber != null) {
      return chatNumber;
    } else {
      return "";
    }
  }

  static Future<void> setCallUsNumber(String callNumber) async {
    String data = callNumber;
    final prefs = await _getPreferences();
    await prefs.setString(callUsNumber, data);
  }

  static Future<String> getCallUsNumber() async {
    final prefs = await _getPreferences();
    String? callNumber = prefs.getString(callUsNumber);

    if (callNumber != null) {
      return callNumber;
    } else {
      return "";
    }
  }







  static Future<void> setLeadId(String leadId) async {
    String data = leadId;
    final prefs = await _getPreferences();
    DebugPrint.prt("Save Lead Id $leadId");
    await prefs.setString(saveLeadId, data);
  }

  static Future<String> getLeadId() async {
    final prefs = await _getPreferences();
    String? leadId = prefs.getString(saveLeadId);

    if (leadId != null) {
      return leadId;
    } else {
      return "";
    }
  }


  static Future<void> setEnhanceKey(String enhanceKey) async {
    String data = enhanceKey;
    final prefs = await _getPreferences();
    await prefs.setString(isEnhanceKey, data);
  }

  static Future<String> getEnhanceKey() async {
    final prefs = await _getPreferences();
    String? enhanceData = prefs.getString(isEnhanceKey);

    if (enhanceData != null) {
      return enhanceData;
    } else {
      return "";
    }
  }


  static Future<void> setNotificationToken(String notificationToken) async {
    String data = notificationToken;
    final prefs = await _getPreferences();
    await prefs.setString(setNotificationTokenData, data);
  }

  static Future<String> getNotificationData() async {
    final prefs = await _getPreferences();
    String? notificationToken = prefs.getString(setNotificationTokenData);

    if (notificationToken != null) {
      return notificationToken;
    } else {
      return "";
    }
  }


  static Future<void> setPhpOTPModel(String userdata) async {
    String data = userdata;
    final prefs = await _getPreferences();
    await prefs.setString(savePhpOtpModel, data);
  }

  static Future<dynamic> getPhpOTPModel() async {
    final prefs = await _getPreferences();
    String? otpModel = prefs.getString(savePhpOtpModel);

    if (otpModel != null) {
      return otpModel;
    } else {
      return null;
    }
  }


  static Future<void> setUserSessionDataNode(String userdata) async {
    String data = userdata;
    final prefs = await _getPreferences();
    await prefs.setString(userSessionDataNode, data);
  }

  static Future<dynamic> getUserSessionDataNode() async {
    final prefs = await _getPreferences();
    String? loginPIN = prefs.getString(userSessionDataNode);

    if (loginPIN != null) {
      return loginPIN;
    } else {
      return null;
    }
  }


  static Future<void> setUserSessionDataPhp(String userdata) async {
    String data = userdata;
    final prefs = await _getPreferences();
    await prefs.setString(userSessionDataPhp, data);
  }

  static Future<dynamic> getUserSessionDataPhp() async {
    final prefs = await _getPreferences();
    String? loginPIN = prefs.getString(userSessionDataPhp);

    if (loginPIN != null) {
      return loginPIN;
    } else {
      return null;
    }
  }

  static Future<void> setCustomerDetails(String customerData) async {
    String data = customerData;
    final prefs = await _getPreferences();
    await prefs.setString(saveCustomerDetails, data);
    DebugPrint.prt("Data Saved Customer Profile");
  }

  static Future<dynamic> getCustomerDetails() async {
    final prefs = await _getPreferences();
    String? customerDetails = prefs.getString(saveCustomerDetails);
     DebugPrint.prt("Get Customer Details $customerDetails");
    if (customerDetails != null) {
      return customerDetails;
    } else {
      return null;
    }
  }







  static Future<bool> logOutFunctionData() async {
    final prefs = await _getPreferences();
    final removedLogin = await prefs.remove(setLoginData);
    final removedNode = await prefs.remove(userSessionDataNode);
    final removedPhp = await prefs.remove(userSessionDataPhp);
    final removedOtp = await prefs.remove(savePhpOtpModel);
    final removeCustomerDetails = await prefs.remove(saveCustomerDetails);
    final removeCallUsNumber = await prefs.remove(callUsNumber);
    final removeChatUsNumber = await prefs.remove(chatUsNumber);
    final removeEmailUsNumber = await prefs.remove(contactUsEmail);

    return removedLogin || removedNode || removedPhp || removedOtp || removeCustomerDetails
    || removeEmailUsNumber || removeChatUsNumber || removeCallUsNumber;
  }


}
