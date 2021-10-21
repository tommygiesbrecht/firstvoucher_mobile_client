import 'dart:io';
import 'dart:typed_data';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:firstvoucher_mobile_client/core/env.dart';
import 'package:firstvoucher_mobile_client/core/services/error/network_error_snackbar.dart';
import 'package:firstvoucher_mobile_client/core/services/models/voucher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:http/http.dart';
import 'package:open_settings/open_settings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class PdfViewWidget extends StatefulWidget {
  final Voucher voucher;

  PdfViewWidget({required this.voucher});

  @override
  State<StatefulWidget> createState() => PdfViewState();
}

class PdfViewState extends State<PdfViewWidget> {
  bool _isLoadingPdf = true;
  bool _isDownloadingPdf = false;

  PDFDocument? document;

  @override
  void initState() {
    super.initState();
    _initDocument();
  }

  Future<void> _initDocument() async {
    try {
      document = await PDFDocument.fromURL(_getPdfUrl());
    } on SocketException {
      showNetworkError(context);
    } finally {
      setState(() {
        _isLoadingPdf = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gutschein'),
        actions: [
          Visibility(
            visible: _isDownloadingPdf,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !_isDownloadingPdf,
            child: IconButton(
              onPressed: () => _sendEmail(),
              icon: Icon(Icons.email_outlined),
            ),
          ),
          Visibility(
            visible: !_isDownloadingPdf,
            child: IconButton(
              onPressed: () => _sendWhatsAppMessage(),
              icon: Icon(Icons.share),
            ),
          ),
        ],
      ),
      body: Center(
        child: _isLoadingPdf
            ? Center(child: CircularProgressIndicator())
            : _pdfView(),
      ),
    );
  }

  Widget _pdfView() {
    return document == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Einlösungen konnten nicht geladen werden.'),
                ),
                ElevatedButton.icon(
                  onPressed: () => {
                    OpenSettings.openWIFISetting(),
                  },
                  icon: Icon(Icons.wifi),
                  label: Text('Netwerkeinstellungen öffnen'),
                ),
              ],
            ),
          )
        : PDFViewer(document: document!);
  }

  String _getPdfUrl() {
    return '${Environment.BASE_URL}/voucher/${widget.voucher.guid}.pdf';
  }

  Future<void> _sendWhatsAppMessage() async {
    File? file = await _downloadVoucher();

    if (file == null) {
      return;
    }

    Share.shareFiles(['${file.path}'], text: 'Great picture');
  }

  Future<void> _sendEmail() async {
    File? file = await _downloadVoucher();

    if (file == null) {
      return;
    }

    final Email email = Email(
      body: 'Hallo liebe/r Kunde/in,\n im Anhang finden Sie Ihren Gutschein.',
      subject: Environment.APP_NAME,
      attachmentPaths: [file.path],
      isHTML: false,
    );
    await FlutterEmailSender.send(email);
  }

  Future<File?> _downloadVoucher() async {
    setState(() {
      _isDownloadingPdf = true;
    });
    try {
      final Response responseData = await get(Uri.parse(_getPdfUrl()));
      Uint8List uint8list = responseData.bodyBytes;
      var buffer = uint8list.buffer;
      ByteData byteData = ByteData.view(buffer);
      var tempDir = await getTemporaryDirectory();
      File file =
          await File('${tempDir.path}/Gutschein-${widget.voucher.code}.pdf')
              .writeAsBytes(buffer.asUint8List(
                  byteData.offsetInBytes, byteData.lengthInBytes));
      return file;
    } on SocketException catch (e) {
      return null;
    } finally {
      setState(() {
        _isDownloadingPdf = false;
      });
    }
  }
}
