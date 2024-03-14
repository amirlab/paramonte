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
xlab =  { "CK" : "CDF ( real/imaginary components )"
        , "IK" : "CDF ( integer-valued )"
        , "RK" : "CDF ( real-valued )"
        }
legends =   [ r"$\alpha = -.5, x_{min} = +3., x_{max} = +\infty$"
            , r"$\alpha = -2., x_{min} = +3., x_{max} = +\infty$"
            , r"$\alpha = -.5, x_{min} = +3., x_{max} = +8$"
            , r"$\alpha = -2., x_{min} = +3., x_{max} = +8$"
            ]

for kind in ["IK", "CK", "RK"]:

    pattern = "*."+kind+".txt"
    fileList = glob.glob(pattern)
    if len(fileList) == 1:

        df = pd.read_csv(fileList[0], delimiter = ", ")

        fig = plt.figure(figsize = 1.25*np.array([6.4,4.8]), dpi = 200)
        ax = plt.subplot()

        if kind == "CK":
            plt.plot( df.values[:,0]
                    , df.values[:,1:5]
                    , marker[kind]
                    , linewidth = linewidth
                   #, color = "r"
                    )
            plt.plot( df.values[:,1]
                    , df.values[:,1:5]
                    , marker[kind]
                    , linewidth = linewidth
                   #, color = "blue"
                    )
        else:
            plt.plot( df.values[:,0]
                    , df.values[:,1:]
                    , marker[kind]
                    , linewidth = linewidth
                   #, color = "r"
                    )
            ax.legend   ( legends
                        , fontsize = fontsize - 5
                        )

        plt.xticks(fontsize = fontsize - 2)
        plt.yticks(fontsize = fontsize - 2)
        ax.set_xlabel(xlab[kind], fontsize = 17)
        ax.set_ylabel("Quantile Function", fontsize = 17)
        #ax.set_xscale("log")
        #ax.set_yscale("log")
        ax.set_ylim([3, 10])

        plt.grid(visible = True, which = "both", axis = "both", color = "0.85", linestyle = "-")
        ax.tick_params(axis = "y", which = "minor")
        ax.tick_params(axis = "x", which = "minor")

        plt.tight_layout()
        plt.savefig(fileList[0].replace(".txt",".png"))

    elif len(fileList) > 1:

        sys.exit("Ambiguous file list exists.")