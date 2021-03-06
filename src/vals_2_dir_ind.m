function [ dir_ind ] = vals_2_dir_ind(val_vec,num_bins,val_unkwn,val_range)
% vals to inds
%
% J.Faskowitz
% Indiana University
% Computational Cognitive Neurosciene Lab
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
    valid_val = val_vec(~isnan(val_vec));
elseif isinf(val_unkwn) % unknown val is Inf
    valid_val = val_vec(~isinf(val_vec)); 
else % unknown val is a number (perhaps -9 or -9999)
    valid_val = val_vec(val_vec ~= val_unkwn);
end

% check if we will trim data
if ~exist('val_range','var') || isempty(val_range)
    upper_lim = max(valid_val) ;
    lower_lim = min(valid_val) ;
else
    upper_lim = val_range(2) ;
    lower_lim = val_range(1) ;
end

% trim data
trim_val = valid_val .* 1 ;
trim_val(trim_val > upper_lim) = upper_lim ;
trim_val(trim_val < lower_lim) = lower_lim ;

% get the edges of the bins, number of bins equal to how many cmap entries
% there are; this way, each bin represents one color
[~,hist_edges] = histcounts(trim_val,num_bins) ;

% assign each vertex datapoint into a bin
tmp_ind = discretize(trim_val,hist_edges) ;

% copy the input vals
dir_ind = val_vec .* 1 ;

% in places where not unknown val, put the inds 
if isnan(val_unkwn)
    dir_ind(~isnan(val_vec)) = tmp_ind ;
elseif isinf(val_unkwn)
    dir_ind(~isinf(val_vec)) = tmp_ind ; 
else
    % check if val unknown within range
    if val_unkwn <= max(tmp_ind) && val_unkwn >= min(tmp_ind)
        error('unknown value in the range of dir inds; not good')
    end
    
    dir_ind(val_vec ~= val_unkwn) = tmp_ind ;
end

