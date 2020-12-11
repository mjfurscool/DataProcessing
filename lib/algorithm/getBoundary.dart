import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

List get_peaks_boundary(List peaks) {
  List boundary_list = [];
  double boundary_y;
  boundary_list.add((peaks[0] + 2 * peaks[1] + peaks[2]) / 4);
  int n = peaks.length - 3;
  for (int i = 0; i <= n; i++) {
    boundary_y = (peaks[i] + 2 * peaks[i + 1] + peaks[i + 2]) / 4;
    boundary_list.add(boundary_y);
  }
  boundary_list.add((peaks[n] + 2 * peaks[n + 1] + peaks[n + 2]) / 4);
  return boundary_list;
}
