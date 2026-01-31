import 'BaseLanguage.dart';
class LanguageVi extends BaseLanguage {
  @override
  String get lblCategory => "Thể loại";

  @override
  String get lblFavourite => "Dấu trang";

  @override
  String get lblPopular => "Sách phổ biến";

  @override
  String get lblLatest => "Sách mới nhất";

  @override
  String get lblFeatured => "Sách nổi bật";

  @override
  String get lblSuggested => "Sách đề xuất";

  @override
  String get lblAboutUs => "Về chúng tôi";

  @override
  String get lblPrivacyPolicy => "Chính sách bảo mật";

  @override
  String get lblTermsCondition => "Điều khoản và điều kiện";

  @override
  String get lblNoDataFound => "Không tìm thấy dữ liệu nào";

  @override
  String get lblNoInternet => "Internet của bạn không hoạt động";

  @override
  String get lblRateUs => "Đánh giá chúng tôi";

  @override
  String get lblDarkMode => "Chế độ tối";

  @override
  String get lblSystemDefault => "Mặc định hệ thống";

  @override
  String get lblLightMode => "Chế độ sáng";

  @override
  String get lblPushNotification => "Vô hiệu hóa thông báo đẩy";

  @override
  String get lblSearchBook => "Sách tìm kiếm";

  @override
  String get lblSetting => "Cài đặt";

  @override
  String get lblSeeMore => "Xem thêm";

  @override
  String get lblRemoveBookmark => "Bạn có chắc là bạn muốn xóa dấu trang?";

  @override
  String get lblTryAgain => "Vui lòng thử lại";

  @override
  String get lblReadBook => "Đọc sách";

  @override
  String get lblSelectTheme => "Chọn chủ đề";

  @override
  String get lblChooseTopic => "Chọn chủ đề";

  @override
  String get lblContinue => "Còn nữa";

  @override
  String get lblChooseTopicMsg => "Vui lòng chọn ít nhất 3 chủ đề";

  @override
  String get lblChooseTopicTitle => "Chọn danh mục quan tâm của bạn";

  @override
  String get lblChooseTopicDesc => "Chọn ba hoặc nhiều hơn.";

  @override
  String get lblCancel => "Hủy bỏ";

  @override
  String get lblYes => "Đúng";

  @override
  String get lblUrlEmpty => "URL trống";

  @override
  String get lblChooseTheme => "Chọn chủ đề ứng dụng của bạn";

  @override
  String get lblDisableNotification => "Bật/tắt thông báo đẩy";

  @override
  String get lblOthers => "Khác";

  @override
  String get lblBy => "Qua";

  @override
  String get lblAuthors => "Tác giả";

  @override
  String get lblAuthorsDes => "Tìm sách của bạn bởi các tác giả";

  @override
  String get lblAbout => "Về";

  @override
  String get lblBooksBy => "Xuất bản sách";

  @override
  String get lblDescription => "Sự miêu tả";

  @override
  String get lblRemove => "Tẩy";

  @override
  String get lblWalk1 => "Chào mừng bạn đến Sách điện tử Mighty";

  @override
  String get lblWalk1Desc => "Lorem Ipsum chỉ đơn giản là văn bản giả của ngành in và sắp chữ.";

  @override
  String get lblWalk2 => "Đọc tệp PDF";

  @override
  String get lblWalk2Desc => "Lorem Ipsum chỉ đơn giản là văn bản giả của ngành in và sắp chữ.";

  @override
  String get lblWalk3 => "Đánh dấu cuốn sách của bạn";

  @override
  String get lblWalk3Desc => "Lorem Ipsum chỉ đơn giản là văn bản giả của ngành in và sắp chữ.";

  @override
  String get lblGetStarted => "Bắt đầu";

  @override
  String get lblSkip => "Nhảy";

  @override
  String get lblLanguage => "Chọn ngôn ngữ Language";

  @override
  String get lblLanguageDesc => "Chọn ngôn ngữ của bạn";

  // YENİ EKLENENLER
  @override String get lblSearchAuthor => "Tìm tác giả";
  @override String get lblNoAuthorsFound => "Không tìm thấy tác giả";

  // AUTH STRINGS
  @override String get lblWelcomeBack => "Chào mừng trở lại!";
  @override String get lblLoginToContinue => "Đăng nhập để tiếp tục";
  @override String get lblEmail => "Email";
  @override String get lblEnterEmail => "Nhập email của bạn";
  @override String get lblPassword => "Mật khẩu";
  @override String get lblEnterPassword => "Nhập mật khẩu";
  @override String get lblRememberMe => "Ghi nhớ đăng nhập";
  @override String get lblForgotPassword => "Quên mật khẩu?";
  @override String get lblLogin => "Đăng nhập";
  @override String get lblOrContinueWith => "hoặc tiếp tục với";
  @override String get lblDontHaveAccount => "Chưa có tài khoản?";
  @override String get lblRegister => "Đăng ký";
  @override String get lblLoginSuccess => "Đăng nhập thành công!";
  @override String get lblLoginFailed => "Đăng nhập thất bại";
  @override String get lblComingSoon => "Sắp ra mắt!";
  @override String get lblCreateAccount => "Tạo tài khoản";
  @override String get lblRegisterToGetStarted => "Đăng ký để bắt đầu";
  @override String get lblFullName => "Họ và tên";
  @override String get lblEnterFullName => "Nhập họ và tên";
  @override String get lblPhone => "Điện thoại";
  @override String get lblEnterPhone => "Nhập số điện thoại";
  @override String get lblConfirmPassword => "Xác nhận mật khẩu";
  @override String get lblReEnterPassword => "Nhập lại mật khẩu";
  @override String get lblIAgreeToThe => "Tôi đồng ý với";
  @override String get lblTermsOfService => "Điều khoản dịch vụ";
  @override String get lblAnd => "và";
  @override String get lblPleaseAcceptTerms => "Vui lòng chấp nhận điều khoản";
  @override String get lblPasswordsDoNotMatch => "Mật khẩu không khớp";
  @override String get lblRegistrationSuccess => "Đăng ký thành công!";
  @override String get lblRegistrationFailed => "Đăng ký thất bại";
  @override String get lblAlreadyHaveAccount => "Đã có tài khoản?";
  @override String get lblVerifyCode => "Xác minh mã";
  @override String get lblNewPassword => "Mật khẩu mới";
  @override String get lblSuccess => "Thành công!";
  @override String get lblEnterEmailToReset => "Nhập email để đặt lại";
  @override String get lblSendCode => "Gửi mã";
  @override String get lblResetCodeSent => "Mã đã được gửi";
  @override String get lblSomethingWentWrong => "Đã xảy ra lỗi";
  @override String get lblPleaseEnterEmail => "Vui lòng nhập email";
  @override String get lblEnterCodeSentToEmail => "Nhập mã đã gửi";
  @override String get lblEnterVerificationCode => "Nhập mã xác minh";
  @override String get lblResendCode => "Gửi lại mã";
  @override String get lblVerify => "Xác minh";
  @override String get lblEnterNewPassword => "Nhập mật khẩu mới";
  @override String get lblConfirmNewPassword => "Xác nhận mật khẩu mới";
  @override String get lblPleaseEnterCode => "Vui lòng nhập mã";
  @override String get lblPleaseEnterPassword => "Vui lòng nhập mật khẩu";
  @override String get lblPasswordTooShort => "Mật khẩu ít nhất 6 ký tự";
  @override String get lblResetPassword => "Đặt lại mật khẩu";
  @override String get lblPasswordResetSuccess => "Đặt lại thành công!";
  @override String get lblBackToLogin => "Quay lại đăng nhập";
  @override String get lblProfile => "Hồ sơ";
  @override String get lblEditProfile => "Chỉnh sửa hồ sơ";
  @override String get lblUpdateYourInfo => "Cập nhật thông tin";
  @override String get lblChangePassword => "Đổi mật khẩu";
  @override String get lblUpdateYourPassword => "Cập nhật mật khẩu";
  @override String get lblYourBookmarks => "Xem dấu trang";
  @override String get lblNotifications => "Thông báo";
  @override String get lblManageNotifications => "Quản lý thông báo";
  @override String get lblHelpSupport => "Trợ giúp & Hỗ trợ";
  @override String get lblGetHelp => "Nhận trợ giúp";
  @override String get lblLogout => "Đăng xuất";
  @override String get lblLogoutConfirmation => "Bạn muốn đăng xuất?";
  @override String get lblLogoutSuccess => "Đăng xuất thành công";
  @override String get lblDeleteAccount => "Xóa tài khoản";
  @override String get lblDeleteAccountWarning => "Không thể hoàn tác!";
  @override String get lblEnterPasswordToConfirm => "Nhập mật khẩu để xác nhận";
  @override String get lblAccountDeleted => "Tài khoản đã xóa";
  @override String get lblDelete => "Xóa";
  @override String get lblNotLoggedIn => "Chưa đăng nhập";
  @override String get lblLoginToAccessProfile => "Đăng nhập để truy cập";
  @override String get lblBio => "Tiểu sử";
  @override String get lblBooksRead => "Đã đọc";
  @override String get lblBookmarks => "Dấu trang";
  @override String get lblFavorites => "Yêu thích";
  @override String get lblCurrentPassword => "Mật khẩu hiện tại";
  @override String get lblPasswordChangedSuccess => "Đổi mật khẩu thành công!";
  @override String get lblUpdate => "Cập nhật";
  @override String get lblEnterBio => "Giới thiệu về bạn...";
  @override String get lblSaveChanges => "Lưu thay đổi";
  @override String get lblProfileUpdated => "Cập nhật hồ sơ thành công!";
  @override String get lblAvatarUpdated => "Cập nhật ảnh thành công!";
  @override String get lblChoosePhoto => "Chọn ảnh";
  @override String get lblCamera => "Máy ảnh";
  @override String get lblGallery => "Thư viện";

  // Offline Reading / Downloads
  @override String get lblDownloads => "Downloads";
  @override String get lblOfflineLibrary => "Offline Library";
  @override String get lblYouHave => "You have";
  @override String get lblDownloadedBooks => "downloaded books";
  @override String get lblTapToStartReading => "Tap to start reading";
  @override String get lblNoDownloadedBooks => "No downloaded books found";
  @override String get lblDownloadToReadOffline => "Download books to read offline";
  @override String get lblRemoveDownloadTitle => "Remove Download?";
  @override String get lblRemoveDownloadMsg => "Are you sure you want to remove this book from offline storage?";
  @override String get lblDeleteBookTitle => "Delete Book?";
  @override String get lblDeleteBookMsg => "Are you sure you want to remove this book from downloads?";
  @override String get lblDownloadComplete => "Download Complete";
  @override String get lblDownloadFailed => "Download Failed";
  @override String get lblOfflineReadToast => "Start reading from your offline library.";
  @override String get lblErrorOpeningBook => "Error opening book. File might be corrupted.";
  @override String get lblUnknownTitle => "Unknown Title";
  @override String get lblDeviceResetByAdmin => "Your device has been reset by the administrator.";
  @override String get lblAccountSuspended => "Your account has been suspended. Please contact support.";
  @override String get lblGetPremiumToRead => "Get Premium to Read";
  @override String get lblYouArePremium => "You are a Premium Member";
  @override String get lblPremiumDesc => "Enjoy your exclusive benefits";
  
  // Support Screen
  @override String get lblSubject => "Subject";
  @override String get lblEnterSubject => "Enter subject";
  @override String get lblMessage => "Message";
  @override String get lblEnterMessage => "Enter your message";
  @override String get lblSend => "Send";
  @override String get lblMessageSent => "Your message has been sent successfully.";
  @override String get lblSending => "Sending...";
  @override String get lblFailedToSend => "Failed to send message. Please try again.";
}

