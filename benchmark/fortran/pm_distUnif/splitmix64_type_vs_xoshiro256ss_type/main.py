#!/usr/bin/env python

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np

import os
dirname = os.path.basename(os.getcwd()) 

fontsize = 14

df = pd.read_csv("main.out", delimiter = ",")
colnames = list(df.columns.values)

df = pd.read_csv("main.out")

####################################################################################################################################
#### Plot the runtimes.
####################################################################################################################################

ax = plt.figure(figsize = 1.25*np.array([6.4,4.6]), dpi = 200)
ax = plt.subplot()

for colname in colnames:
    plt.hist( np.log10(df[colname].values)
            , histtype = "stepfilled"
           #, density = True
            , alpha = 0.7
           #, bins = 30
            )

plt.xticks(fontsize = fontsize)
plt.yticks(fontsize = fontsize)
ax.set_xlabel("$\log_{10}$ ( Runtime [ seconds ] )", fontsize = fontsize)
ax.set_ylabel("Count", fontsize = fontsize)
#ax.set_title(" vs. ".join(colnames[1:])+"\nLower is better.", fontsize = fontsize)
#ax.set_xscale("log")
#ax.set_yscale("log")
plt.minorticks_on()
plt.grid(visible = True, which = "both", axis = "both", color = "0.85", linestyle = "-")
ax.tick_params(axis = "y", which = "minor")
ax.tick_params(axis = "x", which = "minor")
ax.legend   ( colnames
           #, loc='center left'
           #, bbox_to_anchor=(1, 0.5)
            , fontsize = fontsize
            )

plt.tight_layout()
plt.savefig("benchmark." + dirname + ".runtime.png")

####################################################################################################################################
#### Plot the runtime ratios.
####################################################################################################################################

ax = plt.figure(figsize = 1.25*np.array([6.4,4.6]), dpi = 200)
ax = plt.subplot()

for colname in colnames[1:]:
    plt.hist( np.log10(df[colname].values / df[colnames[0]].values)
            , histtype = "stepfilled"
           #, density = True
            , alpha = 0.7
           #, bins = 30
            )
ax.legend   ( colnames[1:]
           #, loc='center left'
           #, bbox_to_anchor=(1, 0.5)
            , fontsize = fontsize
            )

plt.xticks(fontsize = fontsize)
plt.yticks(fontsize = fontsize)
ax.set_title("Runtime Ratio Comparison. Lower means faster.\nLower than 1 means faster than {}().".format(colnames[0]), fontsize = fontsize)
ax.set_xlabel(r"$\log_{{10}}$ ( Runtime Ratio ) w.r.t. {}".format(colnames[0]), fontsize = fontsize)
ax.set_ylabel("Count", fontsize = fontsize)
plt.minorticks_on()
plt.grid(visible = True, which = "both", axis = "both", color = "0.85", linestyle = "-")
ax.tick_params(axis = "y", which = "minor")
ax.tick_params(axis = "x", which = "minor")

plt.tight_layout()
plt.savefig("benchmark." + dirname + ".runtime.ratio.png")