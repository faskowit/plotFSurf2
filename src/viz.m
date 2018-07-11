function [ fig_hand ] = viz(surfStructHemi,wei,viewAngle,cmapStr)

if nargin < 3
    error('need three args')
end

if ~exist('cmapStr','var') || isempty(cmapStr)
   cmapStr = 'direct';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fig_hand = patch('faces',surfStructHemi.faces,...
                'vertices',[surfStructHemi.coords(:,1) ...
                            surfStructHemi.coords(:,2) ...
                            surfStructHemi.coords(:,3)],...
                'facevertexcdata',wei,...
                'facecolor','flat', ...
                'edgecolor','none');
view(gca,3)
axis equal
axis off
view(viewAngle,0)
material dull
camlight headlight
lighting gouraud

% cmapping
fig_hand.CDataMapping = cmapStr; 