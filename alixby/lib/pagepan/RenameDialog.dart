import 'package:alixby/api/AliFile.dart';
import 'package:alixby/states/Global.dart';
import 'package:alixby/utils/Loading.dart';
import 'package:alixby/utils/MColors.dart';
import 'package:alixby/utils/MIcons.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:alixby/states/SettingState.dart';

// ignore: must_be_immutable
class RenameDialog extends StatelessWidget {
  // ignore: non_constant_identifier_names
  RenameDialog({Key? key, required this.box, required this.fileid, required String filename}) : super(key: key) {
    controller.text = filename;
  }

  String box = "";
  String fileid = "";

  final TextEditingController controller = TextEditingController();

  void onSubmitted(BuildContext context) {
    String dirname = controller.text;
    dirname = dirname.replaceAll('"', '').trim();
    var fcHide = Loading.showLoading();

    AliFile.apiRename(box, fileid, dirname).then((value) {
      fcHide();
      if (value == "success") {
        BotToast.showText(text: "重命名成功");
        Navigator.of(context).pop('ok');
        Future.delayed(Duration(milliseconds: 200), () {
          Global.getTreeState(box).pageRefreshNode();
        });
      } else {
        BotToast.showText(text: "重命名失败请重试");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: double.parse(context.watch<SettingState>().setting.textScale)),
            child: DefaultTextStyle(
              //1.设置文本默认样式
              style: TextStyle(color: MColors.textColor, fontFamily: "opposans"),
              child: Center(
                  child: Container(
                height: 200,
                width: 460,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: MColors.dialogBgColor,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.only(top: 8, right: 8, bottom: 8),
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Icon(MIcons.close, size: 18, color: MColors.textColor),
                              onTap: () => Navigator.of(context).pop('ok'),
                            ))),
                    Container(
                        child: Text("重命名",
                            style:
                                TextStyle(fontSize: 20, color: MColors.textColor, height: 0, fontFamily: "opposans"))),
                    Container(padding: EdgeInsets.only(top: 20)),
                    Container(
                      width: 380,
                      padding: EdgeInsets.only(top: 20),
                      child: Stack(
                        children: [
                          ConstrainedBox(
                              constraints: BoxConstraints(maxHeight: 60, maxWidth: 375),
                              child: TextField(
                                controller: controller,
                                maxLines: 1,
                                autocorrect: false,
                                enableSuggestions: false,
                                style: TextStyle(
                                    fontSize: 14, color: MColors.textColor, fontFamily: "opposans", height: 1),
                                cursorColor: MColors.inputBorderHover,
                                autofocus: true,
                                decoration: InputDecoration(
                                  helperText: "文件名不要有特殊字符：<>!:*?\\/.'\"",
                                  helperStyle:
                                      TextStyle(fontSize: 13, color: MColors.textColor, fontFamily: "opposans"),
                                  contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MColors.inputBorderHover,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: MColors.inputBorderColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                onSubmitted: (value) {
                                  onSubmitted(context);
                                },
                              )),
                          Positioned.directional(
                              textDirection: TextDirection.rtl,
                              start: 0,
                              child: ElevatedButton(
                                onPressed: () {
                                  onSubmitted(context);
                                },
                                child: Text("  重命名  "),
                                style: ButtonStyle(minimumSize: MaterialStateProperty.all(Size(0, 36))),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            )));
  }
}
