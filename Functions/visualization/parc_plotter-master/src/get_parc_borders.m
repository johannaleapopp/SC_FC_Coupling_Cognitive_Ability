function [ border_weights ] = get_parc_borders(parc_weights,nbrs,fill_wei) 
% get edges of the parcellation
% do this by finding the edges that have homogeneous neighbors -> meaning
% that they are inside of a label area
%
% returns the borders with the weights of the original 

if nargin < 2
   error('need both parc and nbrs') 
end

if ~exist('fill_wei','var') || isempty(fill_wei)
    fill_wei = 1 ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

discard_list = ones(size(parc_weights,1),1) ;

% loop over all vertices
fprintf('finding broders...'); tic; 
for idx = 1:size(parc_weights,1)
    
    % get neighbor of vert idx
    get_nbrs = nbrs(idx,:) ;
    
    % discard 0's, which are nulls
    get_nbrs = get_nbrs(get_nbrs > 0) ;
    
    % get values for these neighbor vert
    get_vals = parc_weights(get_nbrs) ;
    
    % get number of unique vals of these verts
    uniq_sz = size(unique(get_vals),1) ;
    
    % if more than one unique val, keep this verts value by not discarding
    if uniq_sz > 1
        discard_list(idx) = 0 ;
    end
end
t=toc; fprintf('done (%0.2f sec)\n',t);

% copy the input weights 
border_weights = parc_weights .* 1 ;

% replace discarded vertices with fill weight
border_weights(logical(discard_list)) = fill_wei ;
