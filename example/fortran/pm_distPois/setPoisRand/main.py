#!/usr/bin/env python

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import glob
import sys

linewidth = 2
fontsize = 17

marker ={ "CK" : "-"
        , "IK" : "."
        , "RK" : "-"
        }
xlab =  { "CK" : "Poisson Random Value ( real/imaginary components )"
        , "IK" : "Poisson Random Value ( integer-valued )"
        , "RK" : "Poisson Random Value ( real-valued )"
        }
legends =   [ r"$\lambda = 0.1$"
            , r"$\lambda = 1.0$"
            , r"$\lambda = 4.0$"
            , r"$\lambda = 11.$"
            ]     

for kind in ["IK", "CK", "RK"]:

    pattern = "*."+kind+".txt"
    fileList = glob.glob(pattern)
    if len(fileList) == 1:

        df = pd.read_csv(fileList[0], delimiter = " ", header = None)

        fig = plt.figure(figsize = 1.25*np.array([6.4,4.8]), dpi = 200)
        ax = plt.subplot()

        for j in range(len(df.values[0,:]) - 1):
            if kind == "CK":
                plt.hist( df.values[:,j]
                        , histtype = "stepfilled"
                        , alpha = 0.5
                        , bins = 75
                        )
            else:
                plt.hist( df.values[:,j]
                        , histtype = "stepfilled"
                        , alpha = 0.5
                        , bins = 75
                        )
                ax.legend   ( legends
                            , fontsize = fontsize
                            )
        plt.xticks(fontsize = fontsize - 2)
        plt.yticks(fontsize = fontsize - 2)
        ax.set_xlabel(xlab[kind], fontsize = 17)
        ax.set_ylabel("Count", fontsize = 17)
        ax.set_title("Histograms of {} Poisson random values".format(len(df.values[:,0])), fontsize = 17)

        plt.grid(visible = True, which = "both", axis = "both", color = "0.85", linestyle = "-")
        ax.tick_params(axis = "y", which = "minor")
        ax.tick_params(axis = "x", which = "minor")

        plt.savefig(fileList[0].replace(".txt",".png"))

    elif len(fileList) > 1:

        sys.exit("Ambiguous file list exists.")