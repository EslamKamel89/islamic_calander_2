import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:islamic_calander_2/core/extensions/context-extensions.dart';
import 'package:islamic_calander_2/core/widgets/sizer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ShareAppWidget extends StatelessWidget {
  const ShareAppWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('SHARE_APP'.tr(),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
              'SHARE_APP_DESCRIPTION'.tr(),
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
              // width: double.infinity,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: () {
                      SharePlus.instance.share(
                        ShareParams(
                            text:
                                'https://play.google.com/store/apps/details?id=com.gaztec.islamic_calander'),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(color: context.primaryColor, shape: BoxShape.circle),
                      child: Icon(MdiIcons.android, size: 40, color: Colors.white),
                    )),
                const Sizer(
                  width: 30,
                ),
                InkWell(
                    onTap: () {
                      SharePlus.instance.share(
                        ShareParams(
                            text:
                                'https://apps.apple.com/us/app/eternal-islamic-calendar/id6738862001'),
                      );
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(color: context.primaryColor, shape: BoxShape.circle),
                      child: Icon(MdiIcons.appleIos, size: 40, color: Colors.white),
                    )),
              ],
            )
          ],
        ));
  }
}
