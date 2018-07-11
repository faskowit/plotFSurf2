function [ vals ] = set_roi_vals(vertexVec,roiIDs,roiVals,unknownVal)

if nargin < 3
   error('need at least three args') 
end

if ~isvector(vertexVec)
    error('input should be vector')
end
if ~isvector(roiIDs)
    error('input should be vector')
end
if ~isvector(roiVals)
    error('input should be vector')
end

if length(roiIDs) ~= length(roiVals)
    error('roiVals must be same legnth as roiIDs')
end

if ~exist('unknownVal','var') || isempty(unknownVal)
    unknownVal = -1 ; 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numRois = length(roiIDs) ;

% initialize with unknown val
vals = ones(length(vertexVec),1) .* unknownVal;

for idx = 1:numRois

    % get the indices of the vertexVec for a specific roiID
    vals(vertexVec == roiIDs(idx)) = roiVals(idx);
end
