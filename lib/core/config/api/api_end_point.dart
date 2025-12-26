class ApiEndPoint {
  static const baseUrl = "http://206.162.244.172:5001/api/v1/";
  static const imageUrl = "http://206.162.244.172:5001";
  static const socketUrl = "http://206.162.244.172:5001";

  static const signUp = "user";
  static const verifyEmail = "auth/verify-email";
  static const signIn = "auth/login";
  static const forgotPassword = "auth/forget-password";
  static const verifyOtp = "users/verify-otp";
  static const resetPassword = "auth/reset-password";
  static const contracAndSupport = "users/reset-password";
  static const subscriptionPlan = "subscription/subscribe";
  static const changePassword = "auth/change-password";
  static const resumeData = "resume";
  static const user = "user/profile";
  static const job_all = "job-post/feed/user";
  static const banner = "spotlight";
  static const notifications = "notifications";
  static const Categorys = "job-category";
  static const job_post = "job-post/feed";
  static const recomended = "job-post/recommended";
  static const privacyPolicies = "disclaimer";
  static const termsOfServices = "terms-and-conditions";
  static const favourite = "favourite";
  static const chats = "chats";
  static const chat = "chat";
  static const messages = "messages";
  static const message = "message";
}
