//Author : muhyun-kim
//Modified : 2023/06/08
//Function : QRコードでパートナーを追加する画面

import 'package:couple_share_schedule/screens/partner_add_screen.dart';
import 'package:couple_share_schedule/widgets/modal_widget/qr_code_bottom_modal.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class MobileScannerScreen extends StatefulWidget {
  const MobileScannerScreen({super.key, required String partnerUid});

  @override
  State<MobileScannerScreen> createState() => _MobileScannerScreenState();
}

class _MobileScannerScreenState extends State<MobileScannerScreen> {
  bool _isCapturing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: _isCapturing
                ? MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        setState(() {
                          _isCapturing = false;
                        });
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Barcode found!'),
                            content: Text(barcodes.first.rawValue!),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PartnerAddScreen(
                                        partnerUid: barcodes.first.rawValue!,
                                      ),
                                    ),
                                  );
                                  setState(() {
                                    _isCapturing = true;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          SizedBox(
            child: TextButton(
              onPressed: () {
                QrCodeBottomModal.show(context);
              },
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.qr_code_outlined,
                      ),
                      SizedBox(width: 7),
                      Text(
                        "QRコード表示",
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        "QRコードをスキャンしてペアを追加できます。",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
