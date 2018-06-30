function [ surfData ] = read_surfStruct(fileName,hemi,inStruct)

if nargin < 2 
   error('need at least filename and hemi (LH or RH)') 
end

if ~strcmp(hemi,'LH') && ~strcmp(hemi,'RH')
      disp(hemi) 
error('hemi must be either LH or RH') 
end

if ~exist('inStruct','var') || isempty(inStruct)
    surfData = struct() ; 
else
    surfData = inStruct ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [vertex_coords, faces, magic] = read_surf(fname)
[surfData.(hemi).coords,surfData.(hemi).faces] = read_surf(fileName) ;

% add 1 to face indices, because we'll 1 index instead of 0 index
surfData.(hemi).faces = surfData.(hemi).faces(:,1:3) + 1 ;

% add sizes
surfData.(hemi).nverts = size(surfData.(hemi).coords,1) ;
surfData.(hemi).nfaces = size(surfData.(hemi).faces,1) ;

% get neighbors
surfData.(hemi) = fs_find_neighbors(surfData.(hemi)) ;
