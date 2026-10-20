// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get re_auth_required => 'إعادة المصادقة مطلوبة';

  @override
  String get security_logout_email_phone_change =>
      'لضمان أمان حسابك، تم تسجيل خروجك. إذا تم تغيير عنوان البريد الإلكتروني أو رقم الهاتف، يرجى تسجيل الدخول مرة أخرى باستخدام بيانات الاعتماد المحدثة.';

  @override
  String get security_logout_password_change =>
      'لضمان أمان حسابك، تم تسجيل خروجك. إذا تم تغيير كلمة المرور، يرجى تسجيل الدخول مرة أخرى باستخدام بيانات الاعتماد المحدثة.';

  @override
  String get auth_mode_using => 'أنت تستخدم حالياً';

  @override
  String get auth_mode_email_verification =>
      'سنرسل رمز تحقق (OTP) إلى بريدك الإلكتروني الجديد للتحقق.';

  @override
  String get auth_mode_mobile_verification =>
      'سنرسل رمز تحقق (OTP) إلى رقم هاتفك الجديد للتحقق.';

  @override
  String get no_matching_record_found => 'لم يتم العثور على سجلات مطابقة';

  @override
  String get no_matching_record_found_sub_title =>
      'نأسف لإبلاغك أنه في هذا الوقت لا توجد أسباب متاحة. نحن ندرك مدى خيبة الأمل التي قد يسببها ذلك.';

  @override
  String get server_bug_error =>
      'عذراً! يبدو أننا وجدنا خطأ في نظامنا، نرجو قبول اعتذارنا عن أي إزعاج قد تسبّب به ذلك. يعمل فريقنا بجد لحل المشكلة وضمان استئناف خدماتنا في أقرب وقت ممكن.';

  @override
  String get email_verification_reset_password =>
      'أدخل بريدك الإلكتروني وسنرسل لك رمز تحقق لإعادة تعيين كلمة المرور';

  @override
  String get identity_verified =>
      'تم التحقق من هويتك! قم بتعيين كلمة مرور جديدة';

  @override
  String get mobile_verification_reset_password =>
      'أدخل رقم هاتفك وسنرسل لك رمز تحقق لإعادة تعيين كلمة المرور';

  @override
  String get type => 'النوع';

  @override
  String get single_selection => 'اختيار فردي';

  @override
  String get multi_selection => 'اختيار متعدد';

  @override
  String get price => 'السعر';

  @override
  String get choose_addons => 'اختر الإضافات';

  @override
  String get security_concern_notice =>
      'أمان حسابك مهم بالنسبة لنا، ونوصي بالتواصل مع فريق الدعم فوراً إذا كانت لديك أي مخاوف.';

  @override
  String get did_not_received_otp_code_resend => 'لم تستلم الرمز؟ أعد الإرسال';

  @override
  String get no_order_error_title => 'لا توجد طلبات، لا مشكلة!';

  @override
  String get no_order_error_one => 'نأسف لإبلاغك أنه في هذا الوقت لا توجد';

  @override
  String get no_order_error_two =>
      'طلبات متاحة للتوصيل. نحن نتفهم مدى خيبة الأمل، خاصة عندما تتطلع للحصول على وجبة لذيذة تصل إلى باب منزلك.';

  @override
  String get edit_profile => 'تعديل الملف الشخصي';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get light_mode => 'الوضع الفاتح';

  @override
  String get notification_sound => 'صوت الإشعارات';

  @override
  String get more => 'المزيد';

  @override
  String get choose_language => 'اختر اللغة';

  @override
  String get about => 'حول';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get terms_and_condition => 'الشروط والأحكام';

  @override
  String get refund_policy => 'سياسة الاسترجاع';

  @override
  String get shipping_policy => 'سياسة الشحن';

  @override
  String get cancellation_policy => 'سياسة الإلغاء';

  @override
  String get help => 'المساعدة';

  @override
  String get faqs => 'الأسئلة الشائعة';

  @override
  String get send_feedback => 'إرسال ملاحظات';

  @override
  String get report_emergency => 'الإبلاغ عن حالة طارئة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get your_profile => 'ملفك الشخصي';

  @override
  String get app_settings => 'إعدادات التطبيق';

  @override
  String get alert_pref => 'التنبيهات والتفضيلات';

  @override
  String get change_email => 'تغيير البريد الإلكتروني';

  @override
  String get change_mobile => 'تغيير رقم الهاتف';

  @override
  String get delete_account => 'حذف الحساب';

  @override
  String get update_password => 'تحديث كلمة المرور';

  @override
  String get login_title => 'تسجيل الدخول';

  @override
  String get welcome_to => 'مرحباً بك في';

  @override
  String get forgot_password_title => 'نسيت كلمة المرور';

  @override
  String get forgot_your_password_title => 'هل نسيت كلمة المرور؟';

  @override
  String get network_error_title => 'مشاكل في الشبكة';

  @override
  String get network_error_sub_title =>
      'إذا كنت تستخدم شبكة Wi-Fi أو بيانات الهاتف، تأكد من تفعيلها على جهازك. اذهب إلى إعدادات الجهاز وقم بتشغيل Wi-Fi أو بيانات الهاتف، ثم اختر الشبكة المناسبة واتصل بها.';

  @override
  String get try_again => 'حاول مرة أخرى';

  @override
  String get maintenance_error_title => 'نعتذر عن الإزعاج';

  @override
  String get maintenance_error_sub_title =>
      'نقوم حالياً بأعمال صيانة مجدولة لتحسين خدماتنا. نعتذر عن أي إزعاج قد يسببه ذلك. شكراً لصبرك. إذا كانت لديك مشاكل عاجلة، يرجى التواصل مع فريق الدعم على';

  @override
  String get or => 'أو';

  @override
  String get not_found_error_title => 'محتوى غير موجود';

  @override
  String get not_found_error_sub_title =>
      'إذا كانت هناك روابط على موقع تشير إلى صفحات غير موجودة، فقد يواجه المستخدمون خطأ 404 عند محاولة الوصول إليها.';

  @override
  String get server_error_title => '500 خطأ داخلي في الخادم';

  @override
  String get server_error_sub_title =>
      'هذه رسالة خطأ عامة تشير إلى مشكلة غير محددة في الخادم. قد يكون السبب إعدادات خاطئة، أو زيادة الحمل على الخادم، أو أخطاء برمجية.';

  @override
  String get food_list => 'قائمة الطعام';

  @override
  String get update_stock_detail => 'تحديث تفاصيل المخزون';

  @override
  String get add_variation => 'إضافة تنويع';

  @override
  String get update_variation => 'تحديث التنويع';

  @override
  String get add_option => 'إضافة خيار';

  @override
  String get update_option => 'تحديث الخيار';

  @override
  String get search_country => 'ابحث عن الدولة';

  @override
  String get verification_code => 'رمز التحقق';

  @override
  String get orders => 'الطلبات';

  @override
  String get order_detail => 'تفاصيل الطلب';

  @override
  String get error => 'خطأ';

  @override
  String get login_back => 'تسجيل الدخول مرة أخرى';

  @override
  String get ok_understand_btn => 'حسناً، فهمت';

  @override
  String get update_required => 'مطلوب تحديث';

  @override
  String get new_version_one => 'إصدار جديد';

  @override
  String get new_version_two => 'من التطبيق متاح. يرجى التحديث للمتابعة.';

  @override
  String get update_now => 'حدّث الآن';

  @override
  String get success => 'تم بنجاح';

  @override
  String get ok_thank_you_btn => 'حسناً، شكراً لك!';

  @override
  String get food => 'الطعام';

  @override
  String get account => 'الحساب';

  @override
  String get form_required => 'مطلوب';

  @override
  String get form_password_required =>
      'مطلوب - يرجى التأكد من أن كلمة المرور المدخلة صالحة';

  @override
  String get form_confirm_password_required =>
      'مطلوب - يرجى التأكد من أن التأكيد صالح ويتطابق';

  @override
  String get form_first_name => 'الاسم الأول';

  @override
  String get form_last_name => 'اسم العائلة';

  @override
  String get form_your_email => 'بريدك الإلكتروني';

  @override
  String get form_your_name => 'اسمك';

  @override
  String get form_country_code => 'الرمز';

  @override
  String get form_your_mobile_number => 'رقم هاتفك المحمول';

  @override
  String get form_feedback => 'أدخل ملاحظاتك';

  @override
  String get form_email => 'البريد الإلكتروني';

  @override
  String get form_mobile => 'الهاتف المحمول';

  @override
  String get form_password => 'كلمة المرور';

  @override
  String get form_confirm_password => 'تأكيد كلمة المرور';

  @override
  String get form_name => 'الاسم';

  @override
  String get form_short_description => 'وصف قصير';

  @override
  String get form_select_addons => 'اختر الإضافات';

  @override
  String get form_item_stock => 'مخزون العنصر';

  @override
  String get form_stock_type => 'نوع المخزون';

  @override
  String get form_variation_type => 'نوع الاختلاف';

  @override
  String get form_variation_title => 'عنوان الاختلاف';

  @override
  String get form_min_option_to_select => 'الحد الأدنى للاختيار';

  @override
  String get form_max_option_to_select => 'الحد الأقصى للاختيار';

  @override
  String get form_option_name => 'اسم الخيار';

  @override
  String get form_option_price => 'سعر الخيار';

  @override
  String get form_option_stock => 'مخزون الخيار';

  @override
  String get choose_from => 'اختر من';

  @override
  String get gallery => 'المعرض';

  @override
  String get camera => 'الكاميرا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get update_profile => 'تحديث الملف الشخصي';

  @override
  String get share_experience_feedback =>
      'أخبرنا بتجربتك مع التطبيق واقترح أي تحسينات. ملاحظاتك تساعدنا على خدمتك بشكل أفضل!';

  @override
  String get submit_feedback => 'إرسال الملاحظات';

  @override
  String get report_emergency_notice =>
      'يرجى استخدام هذه الصفحة للإبلاغ عن الحوادث أو الطوارئ الخطيرة فقط. للاستفسارات المتعلقة بالطلبات، يرجى التواصل مع دعم المحادثة.';

  @override
  String get submit_message => 'إرسال الرسالة';

  @override
  String get report_emergency_notice_title =>
      'يرجى استخدام هذا النموذج حصريًا لحالات الطوارئ المتعلقة بالحوادث أو الإساءة. للاستفسارات عن الطلبات أو الأسئلة العامة الأخرى، يرجى التواصل معنا عبر بوابة الدعم.';

  @override
  String get profile_info => 'معلومات الملف الشخصي';

  @override
  String get update_bio => 'قم بتحديث اسمك، سيرتك الذاتية، وصورة ملفك الشخصي';

  @override
  String get choose_reminders => 'اختر كيف تستقبل التحديثات والتذكيرات';

  @override
  String get user_account => 'حساب المستخدم';

  @override
  String get manage_login_creds_to_remove_account =>
      'إدارة بيانات تسجيل الدخول أو حذف الحساب';

  @override
  String get device_access => 'الوصول إلى الجهاز';

  @override
  String get access_permission_settings =>
      'تحكم في الوصول إلى الموقع، الكاميرا، والمزيد من إعدادات هاتفك';

  @override
  String get change_password => 'تغيير كلمة المرور';

  @override
  String get newsletters => 'النشرات الإخبارية';

  @override
  String get newsletters_sub_title =>
      'ابقَ على اطلاع بآخر الأخبار والتحديثات والقصص من عالم الطعام.';

  @override
  String get promo_offer => 'العروض والترويجات';

  @override
  String get promo_offer_sub_title =>
      'احصل على تنبيهات حول العروض الحصرية، الخصومات، والترويجات الخاصة المصممة لك.';

  @override
  String get push => 'إشعارات دفع';

  @override
  String get whatsapp => 'واتساب';

  @override
  String get social_alerts => 'تنبيهات النشاط الاجتماعي';

  @override
  String get social_alerts_sub_title =>
      'سيتم إعلامك عندما يتابعك شخص ما أو يتفاعل مع منشوراتك ومراجعاتك.';

  @override
  String get order_purchases => 'الطلبات والمشتريات';

  @override
  String get order_purchases_sub_title =>
      'تتبع تحديثات طلباتك، تفاصيل العضوية، وتأكيدات الحجز.';

  @override
  String get account_updates => 'تحديثات الحساب الهامة';

  @override
  String get account_updates_sub_title =>
      'استلم تنبيهات مهمة عن حالة حسابك، أمانه، أو التغييرات في الشروط.';

  @override
  String get update_pref => 'تحديث التفضيلات';

  @override
  String get verify => 'تحقق';

  @override
  String get sure_to_delete_account => 'هل أنت متأكد أنك تريد حذف حسابك؟';

  @override
  String get sure_to_delete_account_sub_title =>
      'هذا الإجراء دائم ولا يمكن التراجع عنه. سيتم حذف جميع بياناتك بما في ذلك سجل الطلبات، الاشتراكات، رصيد المحفظة، العناوين المحفوظة، وطرق الدفع بشكل دائم.';

  @override
  String get yes_delete_btn => 'نعم، احذف';

  @override
  String get email_otp_login_title =>
      'أدخل بريدك الإلكتروني ورمز التحقق لتسجيل الدخول. استمتع بتجربة تسجيل دخول سلسة للحصول على أشهى الأطباق!';

  @override
  String get remember_me_lbl => 'تذكرني';

  @override
  String get social_sign_in => 'تسجيل الدخول بحساب اجتماعي';

  @override
  String get apple_sign_in => 'Apple';

  @override
  String get please_wait_progress => 'يرجى الانتظار....';

  @override
  String get google_sign_in => 'Google';

  @override
  String get facebook_sign_in => 'Facebook';

  @override
  String get email_password_login_title =>
      'أدخل بريدك الإلكتروني وكلمة المرور لتسجيل الدخول. استمتع بتجربة تسجيل دخول سلسة للحصول على أشهى الأطباق!';

  @override
  String get forgot_password_btn => 'هل نسيت كلمة المرور؟';

  @override
  String get login_btn => 'تسجيل الدخول';

  @override
  String get mobile_otp_login_title =>
      'أدخل رقم هاتفك المحمول ورمز التحقق لتسجيل الدخول. استمتع بتجربة تسجيل دخول سلسة للحصول على أشهى الأطباق!';

  @override
  String get mobile_password_login_title =>
      'أدخل رقم هاتفك المحمول وكلمة المرور لتسجيل الدخول. استمتع بتجربة تسجيل دخول سلسة للحصول على أشهى الأطباق!';

  @override
  String get in_stock => 'متوفر';

  @override
  String get food_variation => 'اختلافات الطعام';

  @override
  String get add_new_variation => 'إضافة اختلاف جديد';

  @override
  String get submit => 'إرسال';

  @override
  String get required_field => 'مطلوب';

  @override
  String get title => 'العنوان';

  @override
  String get min_qty => 'الكمية الدنيا';

  @override
  String get max_qty => 'الكمية القصوى';

  @override
  String get options => 'خيارات';

  @override
  String get save => 'حفظ';

  @override
  String get add_new_option => 'إضافة خيار جديد';

  @override
  String get stock => 'المخزون';

  @override
  String get unlimited => 'غير محدود';

  @override
  String get verification_code_sent_to => 'تم إرسال رمز التحقق إلى';

  @override
  String get check_sms_box_verification =>
      'يرجى التحقق من صندوق الرسائل النصية وإدخال رمز التحقق أدناه لتأكيد رقم هاتفك.';

  @override
  String get check_main_box_verification =>
      'يرجى التحقق من صندوق الوارد وإدخال رمز التحقق أدناه لتأكيد عنوان بريدك الإلكتروني.';

  @override
  String get regular_order => 'طلب عادي';

  @override
  String get pos_order => 'طلب نقاط البيع';

  @override
  String get table_order => 'طلب على الطاولة';

  @override
  String get table_no => 'رقم الطاولة';

  @override
  String get cooking_instruction => 'تعليمات الطهي';

  @override
  String get prepare_order => 'تحضير الطلب';

  @override
  String get complete_order => 'إكمال الطلب';

  @override
  String get regular_order_no => 'رقم الطلب العادي';

  @override
  String get pos_order_no => 'رقم طلب نقاط البيع';

  @override
  String get order_ref => 'مرجع الطلب';

  @override
  String get date => 'التاريخ';

  @override
  String get order_details => 'تفاصيل الطلب';

  @override
  String get sorry_for_deleting_account =>
      'نحن آسفون لرؤيتك تغادر! سيؤدي حذف حسابك إلى إزالة بياناتك الشخصية، وسجل الطلبات، والعناوين المحفوظة، وطرق الدفع، والتفضيلات بشكل دائم من نظامنا.';

  @override
  String get verification_failed => 'فشل التحقق';

  @override
  String get please_wait_loader => 'يرجى الانتظار';

  @override
  String get profile_updated => 'تم تحديث الملف الشخصي';

  @override
  String get avatar_uploaded => 'تم رفع الصورة الرمزية';

  @override
  String get feedback_saved => 'تم حفظ ملاحظاتك';

  @override
  String get report_saved => 'تم حفظ تقريرك';

  @override
  String get pref_updated => 'تم تحديث التفضيلات';

  @override
  String get email_updated => 'تم تحديث البريد الإلكتروني';

  @override
  String get mobile_number_updated => 'تم تحديث رقم الجوال';

  @override
  String get account_deleted => 'تم حذف الحساب!';

  @override
  String get password_updated => 'تم تحديث كلمة المرور';

  @override
  String get food_updated => 'تم تحديث الطعام!';

  @override
  String get otp_sent => 'تم إرسال رمز التحقق';

  @override
  String get order_preparing => 'يتم تجهيز الطلب';

  @override
  String get order_completed => 'تم إكمال الطلب';

  @override
  String get delete_reason_one => 'هذا الإجراء دائم ولا يمكن التراجع عنه.';

  @override
  String get delete_reason_two =>
      'سيتم محو جميع عمليات التسليم السابقة، وسجل الرحلات، وسجلات الأداء بشكل دائم.';

  @override
  String get delete_reason_three =>
      'ستفقد الوصول إلى أي مهام توصيل أو جداول نشطة.';

  @override
  String get delete_reason_four =>
      'سيتم مصادرة أي أرباح معلقة أو مكافآت أو رصيد في المحفظة.';

  @override
  String get delete_reason_five =>
      'سيتم حذف مناطق التوصيل المحفوظة، وتفضيلات المسار، وحالة التوفر الخاصة بك.';

  @override
  String get delete_reason_six =>
      'سيتم حذف تفاصيل البنك أو بيانات الدفع المخزنة بشكل دائم.';

  @override
  String get delete_reason_seven =>
      'لن تتلقى بعد الآن إشعارات حول طلبات التوصيل أو تحديثات المنصة.';

  @override
  String get delete_reason_eight =>
      'سيتم إلغاء تنشيط ملف تعريف التوصيل وبيانات تسجيل الدخول الخاصة بك.';

  @override
  String get delete_reason_nine =>
      'لن تكون كشوف الأرباح وفواتير الرحلات متاحة للتنزيل بعد الآن.';

  @override
  String get dd_unlimited_stock => 'مخزون غير محدود';

  @override
  String get dd_limited_stock => 'مخزون محدود';

  @override
  String get dd_daily_limit => 'حد يومي';

  @override
  String get dd_yes => 'نعم';

  @override
  String get dd_no => 'لا';

  @override
  String get dd_male => 'ذكر';

  @override
  String get dd_female => 'أنثى';

  @override
  String get dd_other => 'آخر';

  @override
  String get dd_not_disclose => 'أفضل عدم الإفصاح';

  @override
  String get dd_report_accident => 'الإبلاغ عن حادث';

  @override
  String get dd_report_incident => 'الإبلاغ عن واقعة';

  @override
  String get tab_new_order => 'جديد (##dynamic##)';

  @override
  String get tab_preparing_order => 'قيد التحضير (##dynamic##)';

  @override
  String get tab_completed_order => 'مكتمل (##dynamic##)';

  @override
  String get server_not_found_error => 'غير موجود';

  @override
  String get server_please_authenticate_error => 'الرجاء تسجيل الدخول';

  @override
  String get server_forbidden_error => 'ممنوع';

  @override
  String get server_already_exist_error => 'موجود بالفعل';

  @override
  String get server_incorrect_email_or_password_error =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة';

  @override
  String get server_unauthorized_error => 'غير مصرح';

  @override
  String get server_account_blocked_error => 'تم حظر الحساب';

  @override
  String get server_incorrect_phone_or_password_error =>
      'رقم الهاتف أو كلمة المرور غير صحيحة';

  @override
  String get server_password_reset_failed_error =>
      'فشل في إعادة تعيين كلمة المرور';

  @override
  String get server_email_verification_failed_error =>
      'فشل في التحقق من البريد الإلكتروني';

  @override
  String get server_item_already_exist_in_cart_error =>
      'العنصر موجود بالفعل في السلة';

  @override
  String get server_something_went_wrong_error => 'حدث خطأ ما';

  @override
  String get server_addon_not_available_error => 'إحدى الإضافات غير متوفرة';

  @override
  String get server_variation_not_available_error => 'إحدى الخيارات غير متوفرة';

  @override
  String get server_already_created_error => 'تم الإنشاء بالفعل';

  @override
  String get server_coupon_already_redemeed_error =>
      'تم استخدام القسيمة بالفعل';

  @override
  String get server_bogo_failed_error =>
      'الرجاء إضافة عنصر آخر لتفعيل عرض BOGO';

  @override
  String get server_coupon_limit_crossed_error => 'تم تجاوز حد القسيمة';

  @override
  String get server_already_requested_error => 'تم الطلب بالفعل';

  @override
  String get server_limit_crossed_error => 'تم تجاوز الحد';

  @override
  String get server_wallet_find_error => 'غير قادر على العثور على المحفظة';

  @override
  String get server_wallet_balance_error =>
      'أموال غير كافية: مبلغ السحب يتجاوز رصيدك المتاح';

  @override
  String get server_email_smtp_error =>
      'غير قادر على الاتصال بخادم البريد الإلكتروني. تأكد من تكوين خيارات SMTP';

  @override
  String get server_already_saved_error => 'تم الحفظ بالفعل';

  @override
  String get server_favourite_error => 'العنصر موجود بالفعل في قائمة المفضلة';

  @override
  String get server_already_hidden_error => 'مخفي بالفعل';

  @override
  String get server_another_deliveryman_accepted_order_error =>
      'قام عامل توصيل آخر بقبول الطلب';

  @override
  String get server_invalid_deliveryman_error => 'عامل التوصيل غير صالح';

  @override
  String get server_already_assigned_error => 'تم التعيين بالفعل';

  @override
  String get server_wrong_otp_error => 'رمز التحقق غير صحيح';

  @override
  String get server_verification_failed_error => 'فشل التحقق';

  @override
  String get server_credentials_error => 'بيانات الاعتماد غير موجودة';

  @override
  String get server_cart_not_found_error => 'عنصر السلة غير موجود';

  @override
  String get server_purchase_not_found_error => 'عملية الشراء غير موجودة';

  @override
  String get server_wallet_not_found_error => 'المحفظة غير موجودة';

  @override
  String get server_no_user_found_email_error =>
      'لم يتم العثور على مستخدم بهذا البريد الإلكتروني';

  @override
  String get server_no_user_found_mobile_number_error =>
      'لم يتم العثور على مستخدم بهذا الرقم';

  @override
  String get server_email_already_taken_error =>
      'البريد الإلكتروني مستخدم بالفعل';

  @override
  String get server_phone_already_taken_error => 'رقم الهاتف مستخدم بالفعل';

  @override
  String get server_account_already_created_error => 'تم إنشاء الحساب بالفعل';

  @override
  String get server_user_not_found_error => 'المستخدم غير موجود';

  @override
  String get server_driver_not_found_error => 'السائق غير موجود';

  @override
  String get server_detail_not_found_error => 'التفاصيل غير موجودة';

  @override
  String get server_restaurant_not_found_error => 'المطعم غير موجود';

  @override
  String get server_clear_cash_outlet_error =>
      'يرجى تصفية المبلغ النقدي قبل حذف الحساب من حسابك ومن الفرع';

  @override
  String get server_clear_cash_restaurant_error =>
      'يرجى تصفية المبلغ النقدي قبل حذف الحساب';

  @override
  String get server_deliveryman_not_found_error => 'عامل التوصيل غير موجود';

  @override
  String get server_waiter_not_found_error => 'النادل غير موجود';

  @override
  String get server_kitchen_not_found_error => 'مالك المطبخ غير موجود';

  @override
  String get server_already_taken_error => 'تم استخدامه بالفعل';

  @override
  String get server_file_not_found_error => 'الملف غير موجود';

  @override
  String get server_validation_failed_error => 'فشل التحقق';

  @override
  String get server_invalid_file_type_error => 'نوع الملف غير صالح';

  @override
  String get server_select_file_upload_error => 'يرجى اختيار ملف للتحميل!';

  @override
  String get server_account_not_found_error => 'الحساب غير موجود';

  @override
  String get server_contact_admin_error => 'حدث خطأ ما، يرجى الاتصال بالمسؤول';

  @override
  String get server_address_missing_errir => 'العنوان مفقود';

  @override
  String get server_home_delivery_disabled_error => 'التوصيل المنزلي معطل';

  @override
  String get server_self_pickup_disabled_error => 'الاستلام الذاتي معطل';

  @override
  String get server_instant_order_disabled_error => 'الطلب الفوري معطل';

  @override
  String get server_schedule_order_disabled_error => 'الطلب المجدول معطل';

  @override
  String get server_schedule_date_is_invalid_error => 'تاريخ الجدولة غير صالح';

  @override
  String get server_can_not_deliver_to_address_error =>
      'لا يمكن توصيل الطلب إلى هذا العنوان';

  @override
  String get server_coupon_wallet_can_not_use_same_error =>
      'عذراً! لقد قمت بتطبيق قسيمة خصم. لا يمكنك استخدام رصيد المحفظة مع قسيمة في نفس الوقت';

  @override
  String get server_invalid_coupon_not_available_error =>
      'عذراً، هذه القسيمة غير متوفرة لك';

  @override
  String get server_food_is_not_available_error => 'إحدى الأطعمة غير متوفرة';

  @override
  String get server_empty_cart_error => 'السلة فارغة';

  @override
  String get server_addon_variation_not_available_error =>
      'إحدى الإضافات أو الخيارات غير متوفرة';

  @override
  String get server_pos_permmission_error => 'تم رفض صلاحية نقاط البيع';

  @override
  String get server_no_trial_subscription_package_error =>
      'عذراً! لقد قمت باختيار باقة تجريبية، وهي غير متوفرة حالياً، يرجى اختيار طريقة دفع';

  @override
  String get server_table_order_permission_error => 'تم رفض صلاحية طلب الطاولة';

  @override
  String get server_invalid_slot_error => 'الفترة الزمنية غير صالحة';

  @override
  String get server_max_upload_size_error =>
      'الحد الأقصى لحجم الملف هو ##dynamic## ميغابايت';

  @override
  String get server_min_cart_error =>
      'عذراً، يتطلب حد أدنى قدره ##dynamic## في السلة';

  @override
  String get server_min_amount_error =>
      'يرجى ملاحظة أن الحد الأدنى لقيمة الطلب هو ##dynamic## للمتابعة';

  @override
  String get server_out_of_stock_error =>
      'عذراً، ##dynamic## غير متوفر حالياً ولا يمكن إضافته إلى طلبك';

  @override
  String get bloc_something_went_wrong => 'حدث خطأ ما';

  @override
  String get bloc_add_options => 'يرجى إضافة خيارات';

  @override
  String get terms_and_conditions => 'الشروط والأحكام';

  @override
  String get cookies => 'كوكيز التطبيق';

  @override
  String get frequently_asked_questions => 'الأسئلة الشائعة';

  @override
  String get dining_help => 'مساعدة تناول الطعام';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get mark_all_read => 'تحديد الكل كمقروء';

  @override
  String get empty_data =>
      'يبدو أن هذا البئر جاف. لا توجد بيانات هنا! يبدو أننا وصلنا إلى منطقة فارغة! لا توجد بيانات لعرضها هنا.';

  @override
  String get system_error_one =>
      'عذرًا! يبدو أن خطأ غير متوقع قد حدث. تم إخطار فريقنا ويعمل بجد لحل المشكلة. نعتذر عن أي إزعاج قد تسببت به. شكرًا لك على صبرك وتفهمك.';

  @override
  String get undestand_and_go_back => 'حسنًا، فهمت، عُد إلى الخلف';
}
