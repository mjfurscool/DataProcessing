import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

List linear_interp(int x1, double y1, int x2, double y2) {
  var N = x2 - x1;
  var x;
  var y;
  Array result_y = Array.empty(); //
  for (int i = 0; i < N; i++) {
    x = x1 + i;
    y = (x - x1) * (y2 - y1) / (x2 - x1) + y1;
    result_y.add(y);
  }
  return result_y;
} //

void main() {
  var l = linear_interp(1, 2, 3, 4);
  print(l);
}
