import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class ImageUtil {
  Future<XFile?> getImage({required BuildContext context, required ImageSource imageSource}) {
    return ImagePicker().pickImage(
        source: imageSource,
        maxHeight: 1024,
        maxWidth: 1024
    ).then((file) {
      if (file != null) {
        return preview(context: context, file: file);
      } else {
        return null;
      }
    });
  }

  void viewImage({
    required BuildContext context,
    required String imgUrl
  }) {
    showDialog(
        context: context,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0)
            ),
            backgroundColor: const Color(0xFF828282),
            insetPadding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  color: Colors.black,
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      '닫기',
                      style: TextStyle(
                          color: const Color(0xFFBCBCBC),
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500
                      ),
                    ),
                  )
                ),
                Flexible(
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: imgUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Future<XFile?> preview({
    required BuildContext context, required XFile file
  }) async {

    return await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0)
          ),
          backgroundColor: const Color(0xFF828282),
          insetPadding: EdgeInsets.zero,
          child: Column(
            children: [
              Container(
                color: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text(
                        '취소',
                        style: TextStyle(
                          color: const Color(0xFFBCBCBC),
                          fontSize: 16.sp,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500
                        ),
                      )
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text(
                          '선택',
                          style: TextStyle(
                              color: const Color(0xFFBCBCBC),
                              fontSize: 16.sp,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500
                          ),
                        )
                    )
                  ],
                ),
              ),
              Flexible(
                child: Image.file(File(file.path)),
              ),
            ],
          ),
        );
      }
    ).then((result) {
      return result ? file : null;
    });
  }
}