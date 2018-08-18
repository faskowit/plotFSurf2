%% recipe for plotting vals within parcels on a surface
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

%% get sum colors that are random

plotData_rand = struct() ;

% set unknown value
plotData_rand.wei_unkn = 0 ;

% let's randomly determine some weights

rand_wei = rand(annotData.nrois,1) ;
% change the first val to NaN
rand_wei(1) = -1 ;

plotData_rand.LH.wei = set_roi_vals(annotData.LH.labs,annotData.roi_ids,rand_wei) ;
plotData_rand.RH.wei = set_roi_vals(annotData.RH.labs,annotData.roi_ids,rand_wei) ;

%% get sum colors for annotation

% setup struct
plotData_annot = struct ;

% set unknown value
plotData_annot.wei_unkn = -1 ;

plotData_annot.LH.wei = set_roi_vals(annotData.LH.labs,annotData.roi_ids,1:annotData.nrois) ;
plotData_annot.RH.wei = set_roi_vals(annotData.RH.labs,annotData.roi_ids,1:annotData.nrois) ;

%% lets get the edges
% for fun 

for h = hemi
    plotData_rand.(h{:}).bord_wei = get_parc_borders(plotData_rand.(h{:}).wei,surfData.(h{:}).nbrs,0) ;    
end

%% viz the rand values

color_bins = 10 ;

% convert the wei to wei inds
all_wei = vals_2_dir_ind([ plotData_rand.LH.wei ; plotData_rand.RH.wei], color_bins, -1);
% add 2 so that we can add two colors to the color map below... like
% sliding all the values 'up' the colormap
all_wei(all_wei ~= -1) = all_wei(all_wei ~= -1) + 2 ;

% split up all_wei into left and right wei_ind
plotData_rand.LH.wei_ind = all_wei(1:length(plotData_rand.LH.wei)) ;
plotData_rand.RH.wei_ind = all_wei((length(plotData_rand.LH.wei)+1):end) ;

% lets put some borders in there, we'll make it 1st value in colormap
plotData_rand.LH.wei_ind(plotData_rand.LH.bord_wei ~= 0) = 1;
plotData_rand.RH.wei_ind(plotData_rand.RH.bord_wei ~= 0) = 1;

% make the medial wall grey, we'll make it 2nd value in colormap
plotData_rand.LH.wei_ind(plotData_rand.LH.wei_ind == -1) = 2;
plotData_rand.RH.wei_ind(plotData_rand.RH.wei_ind == -1) = 2;

figure
h = viz_views(surfData,plotData_rand.LH.wei_ind,plotData_rand.RH.wei_ind,'all','direct') ;

% set the colormap
cmap = [ 0 0 0 ; % black borders
        0.5 0.5 0.5 ; % grey medial wall
        brewermap(color_bins,'Spectral') ] ;
colormap(cmap)
