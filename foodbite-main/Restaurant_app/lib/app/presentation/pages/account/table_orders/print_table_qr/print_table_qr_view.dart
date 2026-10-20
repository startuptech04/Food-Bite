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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_skeleton_ui/flutter_skeleton_ui.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:screenshot/screenshot.dart';
import 'package:vendor/app/core/config/assets_url.dart';
import 'package:vendor/app/core/models/bluetooth_paired_devices_model.dart';
import 'package:vendor/app/core/models/bluetooth_permission_interface_model.dart';
import 'package:vendor/app/core/models/restaurant_table_qr_detail_model.dart';
import 'package:vendor/app/presentation/pages/account/table_orders/print_table_qr/bloc/print_table_qr_bloc.dart';
import 'package:vendor/app/presentation/styles/app_style.dart';
import 'package:vendor/app/presentation/styles/dashed_border_widget.dart';
import 'package:vendor/app/presentation/styles/error_dialog.dart';
import 'package:vendor/app/presentation/styles/theme.dart';
import 'package:flutter/foundation.dart' show Uint8List, kIsWeb;
import 'package:image/image.dart' as spanshot_img;
import 'package:vendor/app/presentation/styles/cache_network_widget/cache_network_widget_view.dart';
import 'package:vendor/app/services/qr_code_generator.dart';
import 'package:vendor/gen/l10n/app_localizations.dart';

class PrintTableQrScreen extends StatelessWidget {
  final int capacity;
  final String id;
  final bool status;
  final int tableNumber;
  const PrintTableQrScreen({super.key, required this.capacity, required this.id, required this.status, required this.tableNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PrintTableQrBloc()..add(PrintTableQrInitialEvent(capacity: capacity, id: id, status: status, tableNumber: tableNumber)),
      child: const PrintTableQrView(),
    );
  }
}

class PrintTableQrView extends StatefulWidget {
  const PrintTableQrView({super.key});

  @override
  State<PrintTableQrView> createState() => _PrintTableQrViewState();
}

class _PrintTableQrViewState extends State<PrintTableQrView> {
  ScreenshotController screenshotController = ScreenshotController();
  List<BluetoothInfo>? platformList;

  Future<PermissionInterfaceModel> getPrintPermission() async {
    PermissionInterfaceModel permissionStatus = PermissionInterfaceModel(name: '', status: true);
    if (!await requestPermission(Permission.location)) {
      permissionStatus.name = 'location';
      permissionStatus.status = false;
      return permissionStatus;
    }
    if (!await requestPermission(Permission.bluetooth)) {
      permissionStatus.name = 'bluetooth';
      permissionStatus.status = false;
      return permissionStatus;
    }
    if (!await requestPermission(Permission.bluetoothConnect)) {
      permissionStatus.name = 'bluetooth_connect';
      permissionStatus.status = false;
      return permissionStatus;
    }
    if (!await requestPermission(Permission.bluetoothScan)) {
      permissionStatus.name = 'bluetooth_scan';
      permissionStatus.status = false;
      return permissionStatus;
    }
    return permissionStatus;
  }

  Future<bool> requestPermission(Permission permissionType) async {
    await permissionType.request();
    PermissionStatus permissionStatus = await permissionType.status;
    return !permissionStatus.isDenied;
  }

  Future<void> getBluetoothDevices() async {
    if (!kIsWeb) {
      getPrintPermission().then((permission) async {
        if (permission.status!) {
          final List<BluetoothInfo> bluetoothDevicesList = await PrintBluetoothThermal.pairedBluetooths;
          fetchedDevices(bluetoothDevicesList);
        } else {
          errorOnPermission(permission.name!);
        }
      });
    }
  }

  void errorOnPermission(String permissionName) {
    context.read<PrintTableQrBloc>().add(PrintTableQrPermissionFailedEvent(permission: permissionName));
  }

  void fetchedDevices(List<BluetoothInfo> devices) {
    context.read<PrintTableQrBloc>().add(PrintTableQrDeviceFetchedEvent(devices: devices));
    isDeviceConnected(false);
  }

  Future<void> connectBluetoothDevice(String address) async {
    final bool connected = await PrintBluetoothThermal.connect(macPrinterAddress: address);
    if (connected && address != 'none') {
      isDeviceConnected(true);
    } else {
      isDeviceConnected(false);
    }
  }

  Future<void> disconnectBluetoothDevice() async {
    if (!kIsWeb) {
      await PrintBluetoothThermal.disconnect;
    }
  }

  void isDeviceConnected(bool connected) {
    context.read<PrintTableQrBloc>().add(PrintTableQrChangeConnectionEvent(isConnected: connected));
  }

  void isPrintingStarted(bool isPrinting) {
    context.read<PrintTableQrBloc>().add(PrintTableQrPrintingProcessEvent(isPrinting: isPrinting));
  }

  Future onPrintInvoice(Uint8List screenshotImg) async {
    List<int> imgToBytes = await convertImgToBytes(screenshotImg);
    await PrintBluetoothThermal.writeBytes(imgToBytes);
    isPrintingStarted(false);
  }

  Future<List<int>> convertImgToBytes(Uint8List screenshot) async {
    final String contentWidth = context.read<PrintTableQrBloc>().state.contentWidth;
    List<int> bytes = [];
    final spanshot_img.Image? image = spanshot_img.decodeImage(screenshot);
    spanshot_img.Image snapshot = spanshot_img.copyResize(image!, width: contentWidth == '58mm' ? 384 : 576, interpolation: spanshot_img.Interpolation.average);
    final detail = await CapabilityProfile.load();
    final byteGenerator = Generator(contentWidth == '58mm' ? PaperSize.mm58 : PaperSize.mm80, detail);

    bytes += byteGenerator.image(snapshot);
    bytes += byteGenerator.feed(2);
    bytes += byteGenerator.cut();
    return bytes;
  }

  @override
  void initState() {
    super.initState();
    disconnectBluetoothDevice();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return BlocConsumer<PrintTableQrBloc, PrintTableQrState>(
      listener: (context, state) {
        if (state.status.isFailure || state.status.isCustomError) {
          showErrorDialog(context, state.alertMessage.toString(), state.extraMessage.toString(), state.statusCode);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            title: Text(translate.print_table_qr),
            centerTitle: true,
            actions: [IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(Icons.close))],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: ThemeProvider.scaffoldPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (state.status.isLoading) ...[
                  const PrintTableQrLoadingView(),
                ] else if (state.status.isFailure) ...[
                  const PrintTableQrErrorView(),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.pair_bluetooth_devices, style: kAppLblMediumFontRegular(context)),
                            kAppSpacerVertical(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                                    ),
                                    child: DropdownButton<BluetoothPairedDevicesModel>(
                                      underline: const SizedBox(),
                                      isExpanded: true,
                                      value: state.selectedDevice,
                                      dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                      style: kAppLblMediumFontRegular(context),
                                      items: state.paired.map((BluetoothPairedDevicesModel item) {
                                        return DropdownMenuItem<BluetoothPairedDevicesModel>(value: item, child: Text(kAppDDTranslate(context, item.name.toString())));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        context.read<PrintTableQrBloc>().add(PrintTableQrConnectDeviceEvent(device: newValue!));
                                        connectBluetoothDevice(newValue.mac!);
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: () {
                                      getBluetoothDevices();
                                    },
                                    icon: Icon(Icons.refresh_rounded),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      kAppSpacerHorizontal(width: 10),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(translate.print_size, style: kAppLblMediumFontRegular(context)),
                            kAppSpacerVertical(height: 5),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 5),
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(color: Theme.of(context).canvasColor, width: 1),
                              ),
                              child: DropdownButton<String>(
                                underline: const SizedBox(),
                                isExpanded: true,
                                value: state.contentWidth,
                                dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                                style: kAppLblMediumFontRegular(context),
                                items: ['58mm', '88mm'].map((String item) {
                                  return DropdownMenuItem<String>(value: item, child: Text(item.toString()));
                                }).toList(),
                                onChanged: (newValue) {
                                  context.read<PrintTableQrBloc>().add(PrintTableQrContentWidthEvent(width: newValue!));
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  kAppSpacerVertical(height: 10),
                  PrintTableQrPrintWidget(contentWidth: state.contentWidth, qrPrintUrl: state.qrPrintUrl, tableNumber: state.tableNumber, model: state.model, screenshotController: screenshotController),
                ],
              ],
            ),
          ),
          bottomNavigationBar: state.status.isFailure || state.status.isLoading
              ? SafeArea(child: const SizedBox())
              : SafeArea(
                  child: SizedBox(
                    height: 50,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: state.isConnected && !state.isPrinting
                                    ? () {
                                        isPrintingStarted(true);
                                        screenshotController
                                            .capture(pixelRatio: 3.0, delay: const Duration(microseconds: 100))
                                            .then((Uint8List? capturedImage) {
                                              onPrintInvoice(capturedImage!);
                                            })
                                            .catchError((error) {
                                              isPrintingStarted(false);
                                            });
                                      }
                                    : null,
                                style: kAppElevatedButtonStyle(context, disabledColor: Theme.of(context).disabledColor, bgColor: Theme.of(context).primaryColor, foreColor: Theme.of(context).scaffoldBackgroundColor, height: 50),
                                child: state.isPrinting ? Text(translate.printing_progress) : Text(translate.print_qr_code),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}

class PrintTableQrPrintWidget extends StatelessWidget {
  final String contentWidth;
  final int tableNumber;
  final String qrPrintUrl;
  final RestaurantTableQRDetailModel model;
  final ScreenshotController screenshotController;
  const PrintTableQrPrintWidget({super.key, required this.contentWidth, required this.qrPrintUrl, required this.tableNumber, required this.model, required this.screenshotController});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Container(
        width: contentWidth == '58mm' ? 260 : 380, // -20 for padding // 240 = 58mm // 360 = 88mm
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Theme.of(context).disabledColor, width: 2),
          shape: BoxShape.rectangle,
          color: Colors.white,
        ),
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CacheNetworkImageWidget(width: 50.0, height: 50.0, imageUrl: model.detail!.logo!),
                    kAppSpacerVertical(height: 10),
                    Text(model.detail!.name!, textAlign: TextAlign.center, style: kAppInvoiceRegular(context)),
                  ],
                ),
              ),
              kAppSpacerVertical(height: 10),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Text("${translate.table_number} : $tableNumber".toUpperCase(), textAlign: TextAlign.center, style: kAppInvoiceBold(context))],
                ),
              ),
              kAppSpacerVertical(height: 20),
              Center(child: QrCodeGenerator(qrData: qrPrintUrl)),
              kAppSpacerVertical(height: 20),
              InvoiceDividerDashedLine(),
              kAppSpacerVertical(height: 10),
              Center(
                child: Text(translate.scan_qr_code_to_place_order, textAlign: TextAlign.center, style: kAppInvoiceRegular(context)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrintTableQrLoadingView extends StatelessWidget {
  const PrintTableQrLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 30, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
                const SizedBox(width: 5),
                SkeletonLine(style: SkeletonLineStyle(height: 8, width: 64, borderRadius: BorderRadius.circular(8))),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonLine(
                  style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 1.5, borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
        const SizedBox(height: 20),
        SkeletonLine(
          style: SkeletonLineStyle(height: 50, width: double.infinity, borderRadius: BorderRadius.circular(8)),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(10, (index) {
              return SkeletonAvatar(
                style: SkeletonAvatarStyle(width: 80, height: 30, padding: const EdgeInsets.symmetric(horizontal: 5), borderRadius: BorderRadius.circular(8)),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: ThemeProvider.lightDisabledColor, width: 1.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          SkeletonLine(
                            style: SkeletonLineStyle(height: 10, width: MediaQuery.of(context).size.width / 2, borderRadius: BorderRadius.circular(8)),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                              const SizedBox(width: 10),
                              SkeletonLine(style: SkeletonLineStyle(height: 25, width: 25, borderRadius: BorderRadius.circular(8))),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: SkeletonAvatar(style: SkeletonAvatarStyle(width: 80, height: 80, borderRadius: BorderRadius.circular(10))),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class PrintTableQrErrorView extends StatelessWidget {
  const PrintTableQrErrorView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations translate = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        children: [
          kAppSpacerVertical(height: 10),
          Image.asset(AssetsUrl.imageURL.homeEmpty, height: 256, width: 256, fit: BoxFit.fitWidth),
          kAppSpacerVertical(height: 10),
          Text(translate.error, textAlign: TextAlign.center, style: kAppLblMediumFontRegular(context)),
        ],
      ),
    );
  }
}
