import 'getBoundary.dart';

List findLowTroughs(List a, {double mindistance}) {
  //modify from scidart.findPeaks
  var N = a.length - 2;
  List ix = []; //ix -- index
  List ax = []; // ax -- value
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
  var boundary = get_peaks_boundary(ax);
  var ix_final = [];
  var ax_final = [];
  for (int i = 0; i < ax.length; i++) {
    //remove high troughs
    if (ax[i] <= boundary[i]) {
      ix_final.add(ix[i]);
      ax_final.add(ax[i]);
    }
  }
  return [ix_final, ax_final];
}
