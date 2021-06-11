import 'package:bicycle_social_network/views/constants.dart';
import 'package:flutter/cupertino.dart';

class Slider {
  final String sliderImageUrl;
  final String sliderHeading;
  final String sliderSubHeading;
  final String skipBtn;

  Slider(
      {@required this.sliderImageUrl,
      @required this.sliderHeading,
      @required this.sliderSubHeading,
      this.skipBtn});
}

final sliderArrayList = [
    Slider(
        sliderImageUrl: 'Images/banner_1.png',
        sliderHeading: Constants.SLIDER_HEADING_1,
        sliderSubHeading: Constants.SLIDER_DESC,
        skipBtn: Constants.SKIP),                                                
    Slider(
        sliderImageUrl: 'Images/banner_2.jpg',
        sliderHeading: Constants.SLIDER_HEADING_2,
        sliderSubHeading: Constants.SLIDER_DESC,
        skipBtn: Constants.SKIP),
    Slider(
        sliderImageUrl: 'Images/banner_3.jpg',
        sliderHeading: Constants.SLIDER_HEADING_3,
        sliderSubHeading: Constants.SLIDER_DESC,
        skipBtn: ""),
  ];
