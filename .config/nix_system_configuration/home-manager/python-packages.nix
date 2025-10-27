{ pkgs }:

pkgs.python3.withPackages (p: with p; [
  jupyter
  matplotlib
  numpy
  opencv4
  pylint
  pyyaml
  scikit-learn
  setuptools
])
