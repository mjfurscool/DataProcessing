/// Cubic spline interpolation methods
/// author: yizhou
import 'package:scidart/numdart.dart';
import 'dart:math';

/// Cubic interpolation using secondary derivatives
/// Argument
///   - x: List<dynamic>, currently only support double and int.
///   - v: List<dynamic>, only support double and int.
///   - xq: List<dynamic>, only support double and int. Assuming the xq is ordered;
/// return
///   - List<double>, the interpolation result of xq.
List<double> cubicSplineInterpolation(
    List<dynamic> x, List<dynamic> v, List<dynamic> xq) {
  // ans
  List<double> ans = [];

  // Matrix objects. Ease the calculation.
  Array2d M;
  Array2d R;
  Array2d P;

  // attributes of iMatrix
  int sizeMatrix = 4 * (x.length - 1);
  int fromValEqual = 0;
  int toValEqual = x.length - 1;
  int fromFirstDerivative = (x.length - 1) * 2;
  int toFirstDerivative = 3 * x.length - 4;
  int fromSecDerivative = 3 * x.length - 4;
  int toSecDerivative = 4 * x.length - 6;
  int nKnot1 = 4 * x.length - 6;
  int nKnot2 = 4 * x.length - 5;

  // iMatrix X params = response
  List<List<double>> iMatrix = [];
  List<List<double>> response = [];

  // initialize response vector
  for (int i = 0; i < 4 * (x.length - 1); i++) {
    response.add([0]);
  }
  for (int i = 0; i < x.length - 1; i++) {
    response[i * 2][0] = v[i];
    response[i * 2 + 1][0] = v[i + 1];
  }

  // initialize iMatrix
  for (int i = 0; i < 4 * (x.length - 1); i++) {
    List<double> tempRow = [];
    for (int j = 0; j < 4 * (x.length - 1); j++) {
      tempRow.add(0);
    }
    iMatrix.add(tempRow);
  }

  // filling up iMatrix
  // Filling up the value equality part
  for (int i = fromValEqual; i < toValEqual; i++) {
    for (int j = i * 4; j < (i + 1) * 4; j++) {
      int exp = j - i * 4;
      iMatrix[2 * i][j] = pow(x[i], exp);
      iMatrix[2 * i + 1][j] = pow(x[i + 1], exp);
    }
  }

  // Filling up the first derivatives
  for (int i = fromFirstDerivative; i < toFirstDerivative; i++) {
    for (int j = 4 * (i - 2 * (x.length - 1));
        j < 4 * (i - 2 * (x.length - 1) + 1);
        j++) {
      int exp = j - 4 * (i - 2 * (x.length - 1)) - 1;

      // first part
      iMatrix[i][j] = (exp + 1) * pow(x[i - fromFirstDerivative + 1], exp);
      if (exp < 0) {
        iMatrix[i][j] = 0;
      }

      // second part
      iMatrix[i][j + 4] = (exp + 1) * -pow(x[i - fromFirstDerivative + 1], exp);
      if (exp < 0) {
        iMatrix[i][j + 4] = 0;
      }
    }
  }

  // Filling up the second derivative part
  for (int i = fromSecDerivative; i < toSecDerivative; i++) {
    for (int j = 4 * (i - fromSecDerivative);
        j < 4 * (i - fromSecDerivative + 1);
        j++) {
      int exp = j - 4 * (i - fromSecDerivative) - 2;

      // first part
      if (exp < 0) {
        iMatrix[i][j] = 0;
      } else if (exp == 0) {
        iMatrix[i][j] = 2;
      } else {
        iMatrix[i][j] = 6 * x[i - fromSecDerivative + 1];
      }

      // second part
      if (exp < 0) {
        iMatrix[i][j + 4] = 0;
      } else if (exp == 0) {
        iMatrix[i][j + 4] = -2;
      } else {
        iMatrix[i][j + 4] = -6 * x[i - fromSecDerivative + 1];
      }
    }
  }

  // not-knot case
  iMatrix[nKnot1][2] = 2;
  iMatrix[nKnot1][3] = 6 * (x[0]);
  iMatrix[nKnot2][sizeMatrix - 2] = 2;
  iMatrix[nKnot2][sizeMatrix - 1] = 6 * (x[x.length - 1]);

  // Finished initializing the interpolation matrix. Convert them to Matrix objects
  M = new Array2d.empty();
  R = new Array2d.empty();

  // converting iMatrix
  for (List<double> row in iMatrix) {
    Array tempRow = new Array(row);
    M.add(tempRow);
  }

  // converting response
  for (List<double> row in response) {
    Array tempRow = new Array(row);
    R.add(tempRow);
  }
  P = matrixSolve(M, R); //  matrixDot(Minv, R);

  // Interpolating xq
  int counter = 0;
  for (int i = 0; i < xq.length; i++) {
    if (xq[i] > x[counter + 1] && counter < x.length - 2) {
      counter++;
    }
    double p1 = P.elementAt(counter * 4 + 0).elementAt(0);
    double p2 = P.elementAt(counter * 4 + 1).elementAt(0);
    double p3 = P.elementAt(counter * 4 + 2).elementAt(0);
    double p4 = P.elementAt(counter * 4 + 3).elementAt(0);
    ans.add(p1 + p2 * pow(xq[i], 1) + p3 * pow(xq[i], 2) + p4 * pow(xq[i], 3));
  }

  return ans;
}
