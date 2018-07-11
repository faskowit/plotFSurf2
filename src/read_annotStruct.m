function [ annotData ] = read_annotStruct(fileName,hemi,inStruct)

if nargin < 2 
   error('need at least filename and hemi (LH or RH)') 
end

if ~strcmp(hemi,'LH') && ~strcmp(hemi,'RH')
    error('hemi must be either LH or RH') 
end

if ~exist('inStruct','var') || isempty(inStruct)
    annotData = struct() ; 
else
    annotData = inStruct ;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% function [vertices, label, colortable] = read_annotation(filename, varargin)
[annotData.(hemi).verts, annotData.(hemi).labs,annotData.(hemi).ct ] = ...
    read_annotation(fileName) ;

% add 1 to verts to remind ourselves that this was 0 indexed
annotData.(hemi).verts = annotData.(hemi).verts + 1;
