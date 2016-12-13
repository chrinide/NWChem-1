#!/bin/bash
#### Bash script for NWChem's compilation on Centos 6.x & 7.x Linux distributions.
#### Written by Rangsiman Ketkaew, Master degree student in Chemistry, CCRU, Thammasat U., Thailand.
#### (2) set environment & path to nwchem

# ----------------------------- #
# Determine the local storage path for the install files. (e.g., /usr/local/nwchem).
# Make directories

  mkdir /usr/local/nwchem/
  mkdir /usr/local/nwchem/bin
  mkdir /usr/local/nwchem/data

# ----------------------------- #
# Copy binary

  cp $NWCHEM_TOP/bin/${NWCHEM_TARGET}/nwchem /usr/local/nwchem/bin
  cd /usr/local/nwchem/bin 
  chmod 755 nwchem

# ----------------------------- #
# Set links to data files (binaries, basis sets, force fields, etc.)

  cd $NWCHEM_TOP/src/basis
  cp -r libraries /usr/local/nwchem/data

  cd $NWCHEM_TOP/src/
  cp -r data /usr/local/nwchem

  cd $NWCHEM_TOP/src/nwpw
  cp -r libraryps /usr/local/nwchem/data

echo "# ----------------- Done ----------------- #"
echo "# ------- Try to run a sample file ------- #"