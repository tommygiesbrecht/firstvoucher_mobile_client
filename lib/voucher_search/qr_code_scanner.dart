import 'dart:io';

import 'package:firstvoucher_mobile_client/core/env.dart';
import 'package:firstvoucher_mobile_client/core/services/first_voucher_api.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:firstvoucher_mobile_client/voucher_detail/vocher_detail_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrCodeScannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QrCodeScannerState();
}

class QrCodeScannerState extends State {
  final FirstVoucherApi _firstVoucherApi = FirstVoucherApi();

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Gutschein scannen'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            icon: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                print(snapshot.data);
                                if (snapshot.hasData &&
                                    (snapshot.data as bool)) {
                                  return Icon(Icons.flash_off);
                                } else {
                                  return Icon(Icons.flash_on);
                                }
                              },
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: IconButton(
                            onPressed: () async {
                              await controller?.flipCamera();
                              setState(() {});
                            },
                            icon: FutureBuilder(
                              future: controller?.getCameraInfo(),
                              builder: (context, snapshot) {
                                bool isFront =
                                    snapshot.hasData && (snapshot.data as CameraFacing) ==
                                        CameraFacing.front;
                                if (!isFront) {
                                  return Icon(Icons.camera_front_outlined);
                                } else {
                                  return Icon(Icons.camera_rear_outlined);
                                }
                              },
                            )),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      result = scanData;
      String url = '${Environment.BASE_URL}/check/';
      String? voucherId = result?.code.substring(url.length);
      print(voucherId);
      if ((result?.code.startsWith(url) ?? false) && voucherId != null) {
        controller.pauseCamera();
        Voucher voucher = await _firstVoucherApi.fetchVoucher(voucherId);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => VoucherDetailWidget(
              voucher: voucher,
            ),
          ),
          (Route<dynamic> route) => route.isFirst,
        );
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
