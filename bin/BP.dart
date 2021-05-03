// Algorithm reference: Monitoring of Blood Pressure Using
// Photoplethysmographic (PPG) Sensor with
// Aromatherapy Diffusion

import 'dart:ffi';

import 'package:scidart/numdart.dart';
import 'package:scidarttest/algorithm/findTopPeaks.dart';
import 'package:scidarttest/algorithm/sgfilter.dart';

List getPTT(List PPG, List ECG) {
  var PPG_peaks = findTopPeaks(PPG);
  var ECG_peaks = findTopPeaks(ECG);
  var PTT_list = [];
  for (int i = 0; i < ECG_peaks.length; i++) {
    var PTT = ECG_peaks[i][0] - PPG_peaks[i][0];
    PTT_list.add(PTT);
  }
  return PTT_list;
}

double calculateSBP(double BPMave, double PTTave) {
  var SBP;

  if (PTTave >= 300 && PTTave <= 499) {
    SBP = 103.8 - 0.0777 * BPMave + 0.02449 * PTTave;
  } else if (PTTave >= 500 && PTTave <= 599) {
    SBP = -1891 +
        30.88 * BPMave +
        2.829 * PTTave -
        0.07119 * pow(BPMave, 2) -
        0.03785 * PTTave * BPMave +
        0.0004076 * pow(PTTave, 2);
  } else if (PTTave >= 600 && PTTave <= 680) {
    SBP = 183.3 - 1.329 * BPMave + 0.0848 * PTTave;
  } else if (PTTave >= 681) {
    SBP = 206.7 - 1.067 * BPMave - 0.007432 * PTTave;
  }
  print('Systolic Blood Presure: ${SBP}');
  return SBP;
}

double calculateDBP(double BPMave, double PTTave) {
  var DBP;

  if (PTTave >= 300 && PTTave <= 499) {
    DBP = 55.96 - 0.02912 * BPMave + 0.02302 * PTTave;
  } else if (PTTave >= 500 && PTTave <= 690) {
    DBP = 96.77 - 0.589 * BPMave + 0.04313 * PTTave;
  } else if (PTTave >= 691) {
    DBP = 111.3 - 0.4669 * BPMave - 0.006415 * PTTave;
  }
  print('Diastolic Blood Presure: ${DBP}');
  return DBP;
}

void main() {
  SgFilter filter = new SgFilter(4, 11);

  var fs = 100; // collecting frequency may need to be modified
  List SBP_list = [];

  print("Test single input");
  var BPMave = 80.0;
  var PTTave = 400.0;
  var SBP = calculateSBP(BPMave, PTTave);
  var DBP = calculateDBP(BPMave, PTTave);
  var MAP = (SBP + 2 * (DBP)) / 3;
  print('Mean Arterial Pressure: ${MAP}');

  //test

  print("Test list input");
  var input_list = [
    [80.0, 400.0],
    [78.0, 689.0]
  ]; //[BPM, PTT]
  for (var input in input_list) {
    var BPMave = input[0];
    var PTTave = input[1];
    var SBP = calculateSBP(BPMave, PTTave);
    var DBP = calculateDBP(BPMave, PTTave);
    var MAP = (SBP + 2 * (DBP)) / 3;
    print('Mean Arterial Pressure: ${MAP}');
  }
}
