# LDPC
Code developed for my master's thesis on LDPCs. Mainly original code, except the input and output Alist functions, and also the AR4JA folders.

This repository is meant mainly for replicability purposes - it is not organized very well.

## How to cite:

If you find something useful, please cite my master's thesis: T. Ortega, "[Low Density Parity Check codes](https://scholar.google.com/citations?user=YElSNAIAAAAJ&hl=en&oi=sra)," Universitat Politècnica de Catalunya, 2021.

## Main folders of interest

### gap_code

Contains ``incidence_matrix_GQ.gap``, the GAP script to obtain point-line incidence matrices of different GQs.

### graph_tests

Contains several functions that could be of interest. For example:
+ ``girth_of_H`` computes the girth of a binary code from a parity-check matrix.
+ ``H2adjacency`` converts a parity-check matrix to an adjacency matrix.
+ ``plot_Tanner_and_H`` plots the Tanner graph and parity-check matrix shape.

### matlab_codes
+ ``BIAWGN_capacity`` numerically accurate BI-AWGN capacity calculator.
+ ``generate_regular_H`` generates a random regular parity-check matrix.
+ ``systematic_form`` transforms a parity-check matrix to systematic (or standard) form, with the convention H = [I P].
