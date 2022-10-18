function [ vals ] = vals_2_nodes(vertexVec,nodeID,dataVec)

if nargin < 3
   error('need at least three args') 
end

if ~isvector(vertexVec)
    error('input should be vector')
end
if ~isvector(nodeID)
    error('input should be vector')
end
if ~isvector(dataVec)
    error('input should be vector')
end

if length(nodeID) ~= length(dataVec)
    error(['nodeVal not same len dataVec: ' ...
        num2str(length(nodeID)) ' ' num2str(length(dataVec))])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numRois = length(nodeID) ;

% initialize with NaN val
vals = nan(length(vertexVec),1);

for idx = 1:numRois

    % get the indices of the vertexVec for a specific roiID
    vals(vertexVec == nodeID(idx)) = dataVec(idx);
end