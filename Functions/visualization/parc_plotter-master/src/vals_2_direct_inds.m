function [ dir_ind, outRange ] = vals_2_direct_inds(dataVec,num_bins,val_unkwn,val_range)
% vals to inds
%
% J.Faskowitz
% Indiana University
% Computational Cognitive Neuroscience Lab
% See LICENSE file for license

if nargin < 2
    error('need at least 2 args')
end

if ~exist('val_unkwn','var') || isempty(val_unkwn)
    val_unkwn = NaN ;
end

if exist('val_range','var') && ~isempty(val_range)
    if val_range(2) < val_range(1)
        error('range should be in [ low high ] format')
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% put all weights in one vec, get rid of unknown vlaues 
if isnan(val_unkwn) % unknown val is NaN
    valid_val = dataVec(~isnan(dataVec));
elseif isinf(val_unkwn) % unknown val is Inf
    valid_val = dataVec(~isinf(dataVec)); 
else % unknown val is a number (perhaps -9 or -9999)
    valid_val = dataVec(dataVec ~= val_unkwn);
end

% check if we will trim data
if ~exist('val_range','var') || isempty(val_range)
    upper_lim = max(valid_val) ;
    %disp(['max: ' num2str(upper_lim) ])
    lower_lim = min(valid_val) ;
    %disp(['minnnn: ' num2str(lower_lim) ])
else
    upper_lim = val_range(2) ;
    lower_lim = val_range(1) ;
end

% disp(['max: ' num2str(upper_lim) ])
% disp(['minnnn: ' num2str(lower_lim) ])

% % trim data
trim_val = valid_val .* 1 ;

up_lim_ind = valid_val >= upper_lim ;
low_lim_ind = valid_val <= lower_lim ;

trim_val(up_lim_ind) = upper_lim ;
trim_val(low_lim_ind) = lower_lim ;

% % get the edges of the bins, number of bins equal to how many cmap entries
% % there are; this way, each bin represents one color
% [~,hist_edges] = histcounts(trim_val,num_bins) ;
hist_edges = linspace(lower_lim,upper_lim,num_bins+1); % same as above, but
% also works when lims are not in range of data

% assign each vertex datapoint into a bin
tmp_ind = discretize(trim_val,hist_edges) ;
 
% copy the input vals
dir_ind = dataVec .* 1 ;

% in places where not unknown val, put the inds 
if isnan(val_unkwn)
    dir_ind(~isnan(dataVec)) = tmp_ind ;
elseif isinf(val_unkwn)
    dir_ind(~isinf(dataVec)) = tmp_ind ; 
else
    % check if val unknown within range
    if val_unkwn <= max(tmp_ind) && val_unkwn >= min(tmp_ind)
        error('unknown value in the range of dir inds; not good')
    end
    
    dir_ind(dataVec ~= val_unkwn) = tmp_ind ;
end

outRange = [ lower_lim upper_lim ] ;
