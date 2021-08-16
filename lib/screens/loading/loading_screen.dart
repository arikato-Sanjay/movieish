import 'package:flutter/material.dart';
import 'package:movieish/common/constant/size_constants.dart';
import 'package:movieish/screens/loading/loading_circle.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoadingCircle(
      size: AppSizes.size_200,
    );
  }
}
