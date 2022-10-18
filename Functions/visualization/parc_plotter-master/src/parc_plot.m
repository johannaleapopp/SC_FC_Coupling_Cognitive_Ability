function [h] = parc_plot(...
    surfStruct,annotMap,annotName,dataVec,... % required args
    varargin)
    %cMap,border,viewStr,viewCmap) % opt args
% function to plot some parcellations and some data in those parcs

%   varargin        value
%   ~~~~~~~~        ~~~~~
%
%   'cMap'          colormap (N x 3)
%   'border'        add grey boarder around parcels (bool)
%   'viewStr'       str opts: 'all' 'lh:lat' 'lh:med' 'rh:lat' 'rh:med'
%   'viewCamp'      plot additional plot to render colormap (bool)
%   'valRange'      restrict plotting to this value range ([ low high ])
%   'newFig'        open a new fig or not (true)


if nargin < 4
   error('minimally needs the first four args') 
end

%% input parsting

p = inputParser ;
% addParameter(p,paramName,defaultVal)
addParameter(p,'cMap',brewermap(100,'Spectral'))
addParameter(p,'border',1)
addParameter(p,'valRange',[])
addParameter(p,'viewStr','all')
addParameter(p,'viewcMap',[])
addParameter(p,'newFig',1)
parse(p, varargin{:})
p.Results

%% setup stuff

% make sure data is column
dataVec = dataVec(:) ;

% first load up the annotation 
annotStruct = annotMap(annotName) ;

% add middle area color, grey
cMap = [ 0.5 0.5 0.5 ; p.Results.cMap ] ;

%% do your thing

% init a sturct to help org
plotStruct = struct() ;

% num nodes
% numNode = length(annotStruct.combo_names) ;
numBins = size(cMap,1)-1 ;

% vals_2_nodes(vertexVec,nodeID,dataVec)
plotStruct.LH.nodeVals = ...
    vals_2_nodes(annotStruct.LH.labs,annotStruct.roi_ids,dataVec) ;
plotStruct.RH.nodeVals = ...
    vals_2_nodes(annotStruct.RH.labs,annotStruct.roi_ids,dataVec) ;

% convert values into color map inds
[allNodesCmapInd, figRange] = vals_2_direct_inds(...
    [plotStruct.LH.nodeVals ; plotStruct.RH.nodeVals], numBins, NaN, p.Results.valRange) ;

% move up the inds for the background
allNodesCmapInd = allNodesCmapInd +1 ;

plotStruct.LH.nodeCmapInd = allNodesCmapInd(1:length(annotStruct.LH.labs));
plotStruct.RH.nodeCmapInd = allNodesCmapInd((length(annotStruct.LH.labs)+1):end);

% replace NaN with 1
plotStruct.LH.nodeCmapInd(isnan(plotStruct.LH.nodeCmapInd))=1;
plotStruct.RH.nodeCmapInd(isnan(plotStruct.RH.nodeCmapInd))=1;

%% plot borders?

if p.Results.border
    plotStruct.LH.nodeCmapInd(annotStruct.LH.border>0) = 1 ;
    plotStruct.RH.nodeCmapInd(annotStruct.RH.border>0) = 1 ;
end

%% plot it

if p.Results.newFig ; figure ; end
aa = gca ;
cla(aa,'reset') % clear current axis
set(aa, 'visible', 'off')

h = viz_views(surfStruct,...
    plotStruct.LH.nodeCmapInd,...
    plotStruct.RH.nodeCmapInd,...
    p.Results.viewStr,'direct') ;
colormap(cMap)

if p.Results.viewcMap
    % another figure just for colormap?
    figure
    imagesc(dataVec)
    colormap(cMap(2:end,:)); colorbar
    caxis(figRange)
    axis off
    colorbar('southoutside')
    colorbar('northoutside')
    colorbar('westoutside')
end
