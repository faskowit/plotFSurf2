%% recipe for plotting an annotation on a surface
% Indiana University
% Computational Cognitive Neurosciene Lab
% See LICENSE file for license

clc 
clearvars

addpath(strcat(pwd,'/src/'))
addpath(genpath(strcat(pwd,'/src/external/')))

%% read in the data using FreeSurfer matlab funcs
% put data into struct for organization

% hemi strings
hemi = { 'LH' 'RH' } ;

% setup struct
surfData = struct();

% making struct with these entries
%   nverts: number of vertices
%   nfaces: number of faces (triangles)
%   faces:  vertex numbers for each face (3 corners)
%   coords: x,y,z coords for each vertex

for h = hemi

    surfData.(h{:}).fileStr = [ pwd '/example_data/fsaverage/surf/' lower(h{:}) '.inflated'] ;
    
    % func to read data into struct, will get surfData.LH and surfDace.RH
    surfData = read_surfStruct(surfData.(h{:}).fileStr,h{:},surfData) ;

end

%% get annotation info
% hopefully it is a well-formed annot file

% setup struct
annotData = struct();

for h = hemi

    annotData.(h{:}).fileStr = [ '/home/jfaskowi/JOSHSTUFF/projects/yeo17dil/' lower(h{:}) '.yeo17dil.annot' ] ;

    % func to read data into struct
    annotData = read_annotStruct(annotData.(h{:}).fileStr,h{:},annotData) ;
    
end

% get the total number of rois, which we just need to read as the height of
% either of the annot color tables
annotData.nrois = size(annotData.LH.ct.table,1) ;

% the unique ids for each
annotData.roi_ids = annotData.LH.ct.table(:,5) ;

%% get sum colors for annotation

% setup struct
plotData_annot = struct ;

% set unknown value
plotData_annot.wei_unkn = -1 ;

plotData_annot.LH.wei = set_roi_vals(annotData.LH.labs,annotData.roi_ids,1:annotData.nrois) ;
plotData_annot.RH.wei = set_roi_vals(annotData.RH.labs,annotData.roi_ids,1:annotData.nrois) ;

%% viz the annot

figure
h = viz_views(surfData,plotData_annot.LH.wei,plotData_annot.RH.wei,'lh:lat') ;

% add the colormap
colormap(annotData.LH.ct.table(:,1:3) ./ 255)






