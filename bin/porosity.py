#!/usr/bin/python3

"""
Estimating number of beads given a target porosity and average bead radius
"""

PI = 3.1415927

r_bead = 5.305e-5 ## Based on diameters.txt extracted from 15k packing

vol_bead = 4 * PI * r_bead**3 / 3

target_por = 0.4074

dx_column = 5e-4
dy_column = 5e-4
dz_column = 155e-4

vol_column = dx_column * dy_column * dz_column

n_beads  = (1 - target_por) * vol_column / vol_bead

print(n_beads)
