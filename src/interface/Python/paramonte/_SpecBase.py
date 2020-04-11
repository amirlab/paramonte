#**********************************************************************************************************************************
#**********************************************************************************************************************************
#
#  ParaMonte: plain powerful parallel Monte Carlo library.
#
#  Copyright (C) 2012-present, The Computational Data Science Lab
#
#  This file is part of ParaMonte library. 
#
#  ParaMonte is free software: you can redistribute it and/or modify
#  it under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation, version 3 of the License.
#
#  ParaMonte is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Lesser General Public License for more details.
#
#  You should have received a copy of the GNU Lesser General Public License
#  along with ParaMonte.  If not, see <https://www.gnu.org/licenses/>.
#
#**********************************************************************************************************************************
#**********************************************************************************************************************************

import os as _os
import numpy as _np
import sys as _sys
_sys.path.append(_os.path.dirname(__file__))

_delim = ","

####################################################################################################################################
#### SpecBase specification type-checking class
####################################################################################################################################

class _SpecBase():

    def sampleSize(self,sampleSize):
        if isinstance(sampleSize,(float,int)):
            return "sampleSize=" + str(sampleSize) + _delim
        else:
            raise TypeError("The input specification, sampleSize, must be of type float or int.")

    def randomSeed(self,randomSeed):
        if isinstance(randomSeed,int):
            return "randomSeed=" + str(randomSeed) + _delim
        else:
            raise TypeError("The input specification, randomSeed, must be of type int.")

    def description(self,description):
        if isinstance(description,str):
            hasSingleQuote = "'" in description
            hasDoubleQuote = '"' in description
            if hasSingleQuote:
                if hasDoubleQuote:
                    raise TypeError ( "The input specification, description, cannot contain both single-quote and double-quote characters. "
                                    + "Use only one type of quotation marks in your input string. description = "
                                    + description 
                                    )
                else:
                    return "description=" + '"' + description + '"' + _delim
            else:
                return "description=" + "'" + description + "'" + _delim
        else:
            raise TypeError("The input specification, description, must be of type str.")

    def outputFileName(self,outputFileName):
        if isinstance(outputFileName,str):
            return "outputFileName=" + "'" + outputFileName + "'" + _delim
        else:
            raise TypeError("The input specification, outputFileName, must be of type str.")

    def outputDelimiter(self,outputDelimiter):
        if isinstance(outputDelimiter,str):
            return "outputDelimiter=" + "'" + str(outputDelimiter) + "'" + _delim
        else:
            raise TypeError("The input specification, outputDelimiter, must be of type str.")

    def chainFileFormat(self,chainFileFormat):
        if isinstance(chainFileFormat,str):
            return "chainFileFormat=" + "'" + str(chainFileFormat) + "'" + _delim
        else:
            raise TypeError("The input specification, chainFileFormat, must be of type str.")

    def variableNameList(self,variableNameList):
        if isinstance(variableNameList,(list,tuple)):
            return "variableNameList=" + _delim.join("'{0}'".format(_) for _ in list(variableNameList)) + _delim
        else:
            raise TypeError("The input specification, variableNameList, must be either a list or tuple of ndim or less elements, each element of which must be of type str.")

    def restartFileFormat(self,restartFileFormat):
        if isinstance(restartFileFormat,str):
            return "restartFileFormat=" + "'" + str(restartFileFormat) + "'" + _delim
        else:
            raise TypeError("The input specification, restartFileFormat, must be of type str.")

    def outputColumnWidth(self,outputColumnWidth):
        if isinstance(outputColumnWidth,int):
            return "outputColumnWidth=" + str(outputColumnWidth) + _delim
        else:
            raise TypeError("The input specification, outputColumnWidth, must be of type int.")

    def outputRealPrecision(self,outputRealPrecision):
        if isinstance(outputRealPrecision,int):
            return "outputRealPrecision=" + str(outputRealPrecision) + _delim
        else:
            raise TypeError("The input specification, outputRealPrecision, must be of type int.")

    def silentModeRequested(self,silentModeRequested):
        if isinstance(silentModeRequested,bool):
            return "silentModeRequested=" + str(silentModeRequested) + _delim
        else:
            raise TypeError("The input specification, silentModeRequested, must be of type bool (True or False).")

    def domainLowerLimitVec(self,domainLowerLimitVec):
        if isinstance(domainLowerLimitVec,(list,tuple,_np.ndarray)):
            return "domainLowerLimitVec=" + str(_np.array(list(domainLowerLimitVec)).flatten()).strip('[]') + _delim
        else:
            raise TypeError("The input specification, domainLowerLimitVec, must be a list, tuple, or numpy vector of ndim or less elements of type float.")

    def domainUpperLimitVec(self,domainUpperLimitVec):
        if isinstance(domainUpperLimitVec,(list,tuple,_np.ndarray)):
            return "domainUpperLimitVec=" + str(_np.array(list(domainUpperLimitVec)).flatten()).strip('[]') + _delim
        else:
            raise TypeError("The input specification, domainUpperLimitVec, must be a list, tuple, or numpy vector of ndim or less elements of type float.")

    def parallelizationModel(self,parallelizationModel):
        if isinstance(parallelizationModel,str):
            return "parallelizationModel=" + "'" + str(parallelizationModel) + "'" + _delim
        else:
            raise TypeError("The input specification, parallelizationModel, must be of type str.")

    def progressReportPeriod(self,progressReportPeriod):
        if isinstance(progressReportPeriod,int):
            return "progressReportPeriod=" + str(progressReportPeriod) + _delim
        else:
            raise TypeError("The input specification, progressReportPeriod, must be of type int.")

    def targetAcceptanceRate(self,targetAcceptanceRate):
        if isinstance(targetAcceptanceRate,float):
            return "targetAcceptanceRate=" + str(targetAcceptanceRate) + _delim
        else:
            raise TypeError("The input specification, targetAcceptanceRate, must be of type float.")

    def mpiFinalizeRequested(self,mpiFinalizeRequested):
        if isinstance(mpiFinalizeRequested,bool):
            return "mpiFinalizeRequested=" + str(mpiFinalizeRequested) + _delim
        else:
            raise TypeError("The input specification, mpiFinalizeRequested, must be of type bool (True or False).")

    def maxNumDomainCheckToWarn(self,maxNumDomainCheckToWarn):
        if isinstance(maxNumDomainCheckToWarn,int):
            return "maxNumDomainCheckToWarn=" + str(maxNumDomainCheckToWarn) + _delim
        else:
            raise TypeError("The input specification, maxNumDomainCheckToWarn, must be of type int.")

    def maxNumDomainCheckToStop(self,maxNumDomainCheckToStop):
        if isinstance(maxNumDomainCheckToStop,int):
            return "maxNumDomainCheckToStop=" + str(maxNumDomainCheckToStop) + _delim
        else:
            raise TypeError("The input specification, maxNumDomainCheckToStop, must be of type int.")

    def interfaceType(self):
        return "interfaceType=" + "'Python " + _sys.version + "'" + _delim

####################################################################################################################################
#### generate output filename
####################################################################################################################################

def _genOutputFileName(methodName):
    from datetime import datetime as _dt
    dt = _dt.now()
    return  methodName + "_run_" \
            + "{:04d}".format(dt.year) + "{:02d}".format(dt.month) + "{:02d}".format(dt.day) + "_"  \
            + "{:02d}".format(dt.hour) + "{:02d}".format(dt.minute) + "{:02d}".format(dt.second) + "_" \
            + "{:03d}".format(round(dt.microsecond/1000))

####################################################################################################################################
