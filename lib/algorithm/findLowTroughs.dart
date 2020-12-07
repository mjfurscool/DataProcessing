import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

List findLowTroughs(Array a, {double mindistance}) {
  //modify from scidart.findPeaks
  var N = a.length - 2;
  Array ix = Array.empty(); //ix -- index
  Array ax = Array.empty(); // ax -- value
  ix.add(0);
  ax.add(0);
  if (mindistance != null) {
    for (int i = 1; i <= N; i++) {
      if (a[i - 1] >= a[i] && a[i] <= a[i + 1]) {
        if (i - ix.last > mindistance) {
          //mindistance between two peaks
          ix.add(i.toDouble());
          ax.add(a[i]);
        }
      }
    }
  } else {
    for (int i = 1; i <= N; i++) {
      if (a[i - 1] >= a[i] && a[i] <= a[i + 1]) {
        ix.add(i.toDouble());
        ax.add(a[i]);
      }
    }
  }
  ix.remove(0);
  ax.remove(0);
  return [ix, ax];
}
