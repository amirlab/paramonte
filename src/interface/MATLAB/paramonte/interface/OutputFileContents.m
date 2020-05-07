classdef OutputFileContents < dynamicprops
%   This is the OutputFileContents class for generating instances 
%   of ParaMonte output file contents. The ParaMonte read* methods
%   return an object or a list of objects of class OutputFileContents.
%
%   Constructor Parameters
%   ----------------------
%       file
%           full path to the file containing the sample/chain.
%       delimiter
%           the delimiter used in the sample/chain file, which 
%           must be provided by the user.
%       fileType
%           The type of the file to be parsed:
%           "chain", "sample", "progress", "report", "restart"
%       mpiEnabled
%           boolean value indicating weather the code is being run in parallel
%
%   Attributes
%   ----------
%
%   The attributes of the constructed object depend on the type of the file being parsed:
%
%       Sample/Chain files
%       ------------------
%       file
%           full path to the file containing the sample/chain.
%       delimiter
%           the delimiter used in the sample/chain file, which 
%           must be provided by the user.
%       ndim
%           the inferred number of dimensions of the domain of the 
%           objective function for which the simulation has been performed.
%       count
%           number of points (states) in the sample/chain file. 
%           This is essentially, the number of rows in the file 
%           minus one (representing the header line).
%       [df]
%           if the input file contents is structured in a format that
%           could be read as a MATLAB Table, then the contents of the file
%           will be stored in the form of a MATLAB Table in this property, 
%           hence called 'df'.
%
%   Returns
%   -------
%       OutputFileContents
%
%   ----------------------------------------------------------------------

    properties(Access = public)
        file = [];
        delimiter = [];
        %count = [];
        %stats = [];
        %ndim = [];
        %df = [];
    end

    properties(Hidden)
        offset = [];
        Err
    end

    %*******************************************************************************************************************************
    %*******************************************************************************************************************************

    methods (Access = public)

        %***************************************************************************************************************************
        %***************************************************************************************************************************

        function self = OutputFileContents  ( file ...
                                            , fileType ...
                                            , delimiter ...
                                            , methodName ...
                                            , mpiEnabled ...
                                            , markovChainRequested ...
                                            , Err ...
                                            )

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% data
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            self.Err = Err;
            self.file = file;
            self.delimiter = delimiter;

            self.Err.marginTop = 0;
            self.Err.marginBot = 0;
            self.Err.msg = "reading file contents... "; self.Err.note();
            timer = Timer_class();
            timer.tic()

            d = importdata  ( self.file ...
                            ..., "delimiter", self.delimiter ...
                            );
            if isfield(d,"colheaders")
                colheadersLen = length(d.colheaders);
            else
                self.Err.marginTop = 1;
                self.Err.marginBot = 1;
                self.Err.msg    = "The structure of the file """ + self.file + """ does not match a " + methodName + " " + fileType + "file. " ...
                                + "Verify the contents of this file before attempting to read this file.";
                self.Err.abort();
            end
            for icol = 1:colheadersLen
                if strcmp(d.colheaders{icol},"SampleLogFunc")
                    break
                end
            end
            self.offset = icol + 1; % index of the first variable
            prop="ndim"; if ~any(strcmp(properties(self),prop)); self.addprop(prop); end
            self.ndim   = colheadersLen - self.offset + 1;
            prop="count"; if ~any(strcmp(properties(self),prop)); self.addprop(prop); end
            self.count  = length(d.data(:,1));

            if markovChainRequested
                cumSumWeight = cumsum(d.data(:,self.offset-2));
                if cumSumWeight(end) > self.count % it is indeed a compact chain
                    dMarkov = zeros( cumSumWeight(end) , self.ndim + self.offset - 1 );
                    istart = 1;
                    for irow = 1:self.count
                        iend = cumSumWeight(irow);
                        for i = istart:iend
                            dMarkov(i,:) = d.data(irow,:);
                        end
                        istart = iend + 1;
                    end
                    d.data = dMarkov;
                    self.count = cumSumWeight(end);
                elseif cumSumWeight(end) < self.count % there is something wrong about this chain output file
                    self.Err.marginTop = 1;
                    self.Err.marginBot = 1;
                    self.Err.msg    = "The internal contents of the file """ + self.file + """ does not match a " + methodName + " " + fileType + "file. " ...
                                    + "In particular, the SampleWeight data column in this file appears to contain values that are either non-positive or non-integer.";
                    self.Err.abort();
                end
            end

            prop="df"; if ~any(strcmp(properties(self),prop)); self.addprop(prop); end
            self.df = array2table(d.data,'VariableNames',d.colheaders);

            updateUser([]);

            if mpiEnabled
                self.Err.marginTop = 0;
                self.Err.marginBot = 1;
                self.Err.msg = "ndim = " + string(self.ndim) + ", count = " + string(self.count);
                self.Err.note();
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% statistics
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            prop="stats"; if ~any(strcmp(properties(self),prop)); self.addprop(prop); end

            self.stats = struct();

            % add chain cormat

            updateUser("computing the sample correlation matrix...");
            self.stats.cormat = CorCovMat   ( self.df ...
                                            , self.offset:self.offset+self.ndim-1 ...
                                            , "pearson" ... method
                                            , [] ... rows
                                            , self.Err ...
                                            );
            updateUser([]);

            % add chain covmat

            updateUser("computing the sample covariance matrix...");
            self.stats.covmat = CorCovMat   ( self.df ...
                                            , self.offset:self.offset+self.ndim-1 ...
                                            , [] ... method
                                            , [] ... rows
                                            , self.Err ...
                                            );
            updateUser([]);

            % add chain autocorr

            updateUser("computing the sample autocorrelation...");
            self.stats.autocorr = AutoCorr  ( self.df ...
                                            , self.offset-1:self.offset+self.ndim-1 ...
                                            , [] ... rows
                                            , self.Err ...
                                            );
            updateUser([]);

            %self.stats.maxLogFunc = getMax(self.df,"SampleLogFunc");

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%% graphics
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            prop="plot"; if ~any(strcmp(properties(self),prop)); self.addprop(prop); end
            self.plot = struct();

            for plotType = ["line","line3","scatter","scatter3","lineScatter","lineScatter3","histogram","histogram2","histfit","grid"]
                %updateUser("generating " + plotType + " plot...");
                self.resetPlot(plotType,"hard");
                updateUser([]);
            end
            self.plot.reset = @self.resetPlot;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            function updateUser(msg)
                if isempty(msg)
                    timer.toc();
                    self.Err.msg = "done in " + sprintf("%.6f",string(timer.delta)) + " seconds."; self.Err.note();
                else
                    self.Err.msg = msg; self.Err.note();
                    timer.toc();
                end
            end

        end % constructor

    end % methods (Access = public)

    %*******************************************************************************************************************************
    %*******************************************************************************************************************************

    methods (Access = public, Hidden)

        %***************************************************************************************************************************
        %***************************************************************************************************************************

        function resetPlot(self,varargin)

            resetTypeIsHard = false;
            requestedPlotTypeList = [];
            plotTypeList = ["line","scatter","lineScatter","line3","scatter3","lineScatter3","histogram","histogram2","histfit","grid"];
            lenVariableNames = length(self.df.Properties.VariableNames);

            if nargin==1
                requestedPlotTypeList = plotTypeList;
            else
                argOne = string(varargin{1});
                if length(argOne)==1 && strcmpi(argOne,"hard")
                    requestedPlotTypeList = plotTypeList;
                    resetTypeIsHard = true;
                else
                    for requestedPlotTypeCell = varargin{1}
                        if isa(requestedPlotTypeCell,"cell")
                            requestedPlotType = string(requestedPlotTypeCell{1});
                        else
                            requestedPlotType = string(requestedPlotTypeCell);
                        end
                        plotTypeNotFound = true;
                        for plotTypeCell = plotTypeList
                            plotType = string(plotTypeCell{1});
                            if strcmp(plotType,requestedPlotType)
                                requestedPlotTypeList = [ requestedPlotTypeList , plotType ];
                                plotTypeNotFound = false;
                                break;
                            end
                        end
                        if plotTypeNotFound
                            error   ( newline ...
                                    + "The input plot-type argument, " + varargin{1} + ", to the resetPlot method" + newline ...
                                    + "did not match any plot type. Possible plot types include:" + newline ...
                                    + "line, lineScatter." + newline ...
                                    );
                        end
                    end
                end
            end

            if nargin==3 && strcmpi(varargin{2},"hard"); resetTypeIsHard = true; end

            if resetTypeIsHard
                resetTypeIsHard = true;
                msgPrefix = "creating the ";
                msgSuffix = " plot object from scratch...";
            else
                msgPrefix = "reseting the properties of the ";
                msgSuffix = " plot...";
            end

            self.Err.marginTop = 0;
            self.Err.marginBot = 0;

            for requestedPlotTypeCell = requestedPlotTypeList

                requestedPlotType = string(requestedPlotTypeCell);
                requestedPlotTypeLower = lower(requestedPlotType);

                self.Err.msg = msgPrefix + requestedPlotType + msgSuffix;
                self.Err.note();

                plotName = "";

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                is3d = false;
                if contains(requestedPlotTypeLower,"3")
                    is3d = true;
                end

                % line

                if strcmp(requestedPlotTypeLower,"line") || strcmp(requestedPlotTypeLower,"line3")
                    plotName = "line"; if is3d; plotName = plotName + "3"; end
                    if resetTypeIsHard
                        self.plot.(plotName) = LineScatterPlot( self.df, plotName );
                    else
                        self.plot.(plotName).reset();
                    end
                    self.plot.(plotName).ycolumns = self.df.Properties.VariableNames(self.offset);%:end);
                    self.plot.(plotName).ccolumns = "SampleLogFunc";
                    self.plot.(plotName).gca_kws.xscale = "linear";
                    self.plot.(plotName).plot_kws.enabled = false;
                    self.plot.(plotName).plot_kws.linewidth = 1;
                    self.plot.(plotName).surface_kws.enabled = true;
                    self.plot.(plotName).surface_kws.linewidth = 1;
                end

                % scatter / scatter3

                if strcmp(requestedPlotTypeLower,"scatter") || strcmp(requestedPlotTypeLower,"scatter3")
                    plotName = "scatter"; if is3d; plotName = plotName + "3"; end
                    if resetTypeIsHard
                        self.plot.(plotName) = LineScatterPlot( self.df, plotName );
                    else
                        self.plot.(plotName).reset();
                    end
                    self.plot.(plotName).ccolumns = "SampleLogFunc";
                    self.plot.(plotName).ycolumns = self.df.Properties.VariableNames(self.offset);%:end);
                    self.plot.(plotName).gca_kws.xscale = "linear";
                    self.plot.(plotName).scatter_kws.size = 10;
                end

                % lineScatter / lineScatter3

                if strcmp(requestedPlotTypeLower,"linescatter") || strcmp(requestedPlotTypeLower,"linescatter3")
                    plotName = "lineScatter"; if is3d; plotName = plotName + "3"; end
                    if resetTypeIsHard
                        self.plot.(plotName) = LineScatterPlot( self.df, plotName );
                    else
                        self.plot.(plotName).reset();
                    end
                    self.plot.(plotName).surface_kws.enabled = false;
                    self.plot.(plotName).ccolumns = "SampleLogFunc";
                    self.plot.(plotName).ycolumns = self.df.Properties.VariableNames(self.offset);%:end);
                    self.plot.(plotName).gca_kws.xscale = "linear";
                    if is3d
                        self.plot.(plotName).plot_kws.color = [200 200 200 75] / 255;
                    else
                        self.plot.(plotName).plot_kws.linewidth = 1;
                        self.plot.(plotName).plot_kws.color = uint8([200 200 200 100]);
                        self.plot.(plotName).scatter_kws.size = 20;
                    end
                end

                % 3d

                if is3d
                    if self.ndim==1
                        self.plot.(plotName).xcolumns = {};
                        self.plot.(plotName).ycolumns = self.df.Properties.VariableNames(self.offset);
                    else
                        self.plot.(plotName).xcolumns = self.df.Properties.VariableNames(self.offset);
                        self.plot.(plotName).ycolumns = self.df.Properties.VariableNames(self.offset+1);
                    end
                    self.plot.(plotName).zcolumns = "SampleLogFunc";
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % hist / hist2 / histfit

                isHist = strcmp(requestedPlotTypeLower,"histogram");
                isHist2 = strcmp(requestedPlotTypeLower,"histogram2");
                isHistfit = strcmp(requestedPlotTypeLower,"histfit");
                if isHist || isHist2 || isHistfit
                    if resetTypeIsHard
                        self.plot.(requestedPlotTypeLower) = HistPlot( self.df, requestedPlotTypeLower );
                    else
                        self.plot.(requestedPlotTypeLower).reset();
                    end
                    if isHist
                        self.plot.(requestedPlotTypeLower).xcolumns = self.df.Properties.VariableNames(self.offset); %:self.offset+2);
                        self.plot.(requestedPlotTypeLower).histogram_kws.facealpha = 0.6;
                        self.plot.(requestedPlotTypeLower).histogram_kws.facecolor = "auto";
                        self.plot.(requestedPlotTypeLower).histogram_kws.edgecolor = "none";
                    else
                        self.plot.(requestedPlotTypeLower).xcolumns = self.df.Properties.VariableNames(self.offset);
                        if isHist2
                            self.plot.(requestedPlotTypeLower).ycolumns = self.df.Properties.VariableNames(self.offset-1);
                        end
                    end
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                % grid

                isGrid = strcmp(requestedPlotTypeLower,"grid");
                if isGrid
                    %self.plot.(requestedPlotTypeLower).columns = string(self.df.Properties.VariableNames(self.offset:end));
                    if resetTypeIsHard
                        endIndx = min(lenVariableNames,self.offset+4);
                        self.plot.(requestedPlotTypeLower) = GridPlot( self.df, self.df.Properties.VariableNames(self.offset-1:endIndx));
                    else
                        self.plot.(requestedPlotTypeLower).reset();
                    end
                    self.plot.(requestedPlotTypeLower).ccolumn = string(self.df.Properties.VariableNames(self.offset-1));
                end

                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            end

        end

        %***************************************************************************************************************************
        %***************************************************************************************************************************

    end % methods (Access = public)

    %*******************************************************************************************************************************
    %*******************************************************************************************************************************

    methods (Hidden, Static)
        % These methods have been implemented to override the default 'handle' class methods,
        % so that they won't pop-up after pressing 'Tab' button.
        function addlistener    ();  end
        function delete         ();  end
        function findobj        ();  end
        function findprop       ();  end
        function valid          ();  end
        function listener       ();  end
        function notify         ();  end
    end

    %*******************************************************************************************************************************
    %*******************************************************************************************************************************

end % classdef OutputFileContents < handle