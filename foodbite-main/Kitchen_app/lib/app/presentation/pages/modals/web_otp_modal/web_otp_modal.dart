/*
 * FoodBite – Multi Restaurant Food Delivery App
 * (NodeJS, MongoDB, Angular & Flutter)
 *
 * Copyright © 2026 Elitecanyon InfoTech (https://www.elitecanyon.com/)
 * Licensed under the Envato Market License.
 *
 * Unauthorized redistribution, resale, or publication
 * of this source code on GitHub or any public repository
 * is strictly prohibited.
 *
 * This file may contain embedded identifiers and watermarks
 * for ownership verification and license enforcement.
 */

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitchen/app/core/config/api_endpoints.dart';
import 'package:kitchen/app/core/config/api_request_service.dart';
import 'package:kitchen/app/presentation/pages/modals/web_otp_modal/bloc/web_otp_modal_bloc.dart';
import 'package:kitchen/app/presentation/styles/app_style.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WebOtpModalScreen extends StatelessWidget {
  final String otpId;
  final String locale;
  const WebOtpModalScreen({super.key, required this.otpId, required this.locale});

  @override
  Widget build(BuildContext context) {
    return WebOtpModalView(otpId: otpId, locale: locale);
  }
}

class WebOtpModalView extends StatefulWidget {
  final String otpId;
  final String locale;
  const WebOtpModalView({super.key, required this.otpId, required this.locale});

  @override
  State<WebOtpModalView> createState() => _WebOtpModalViewState();
}

class _WebOtpModalViewState extends State<WebOtpModalView> {
  bool isLoading = true;
  bool recallAPI = true;
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    context.read<WebOtpModalBloc>().add(WebOtpModalInitialEvent(otpId: widget.otpId, locale: widget.locale));
    final WebViewController controller = WebViewController();

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {
            checkCallback(context, url);
          },
          onPageFinished: (String url) {
            checkCallback(context, url);
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            checkCallback(context, request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.message)));
        },
      )
      ..loadRequest(Uri.parse('${ApiRequestService.baseUrl}${ApiEndPoints.v1request.webOTPVerification}${widget.locale}/${widget.otpId}'));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WebOtpModalBloc, WebOtpModalState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop({'action': true, 'success': true, 'id': state.otpId, 'dummyOTP': state.dummyOTP});
        } else if (state.status.isFailed) {
          Navigator.of(context).pop({'action': false, 'success': false, 'id': state.otpId, 'dummyOTP': state.dummyOTP});
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                WebViewWidget(controller: _controller),
                isLoading ? kAppCenterCircularProgress(context) : const Stack(),
              ],
            ),
          ),
        );
      },
    );
  }

  void checkCallback(BuildContext context, String callback) {
    try {
      if (recallAPI == true) {
        if (callback.contains('success') || callback.contains('failed')) {
          setState(() {
            recallAPI = false;
          });
          final bool isSuccess = callback.contains('success') ? true : false;
          FocusScope.of(context).requestFocus(FocusNode());
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          String dummyOTP = '000000';
          final uri = Uri.parse(callback);
          final queryParams = uri.queryParameters;
          if (queryParams.isNotEmpty && queryParams.containsKey('auth')) {
            dummyOTP = uri.queryParameters['auth']!.toString();
          }
          context.read<WebOtpModalBloc>().add(WebOtpModalResponseEvent(isSuccess: isSuccess, dummyOTP: dummyOTP));
        }
      }
    } catch (e, stacktrace) {
      context.read<WebOtpModalBloc>().add(WebOtpModalResponseEvent(isSuccess: false, dummyOTP: '000000'));
      if (!kIsWeb) {
        FirebaseCrashlytics.instance.recordError(e, stacktrace);
      }
    }
  }
}
// DONE //