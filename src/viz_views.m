function [ fig_hand ] = viz_views(surfStruct,LH_wei,RH_wei,plotViewStr)

if ~exist('plotViewStr','var') || isempty(plotViewStr)
    plotViewStr = 'all'; % weight for unknown vertices
end 

if ~ismember(plotViewStr, {'all' 'lh:lat' 'lh:med' 'rh:lat' 'rh:med'})
    error('invalid "plotView" variable')
end
  
% check the weights
if ~isempty(LH_wei) && ~isvector(LH_wei)
    error('LH_wei must be a vector')
end
if ~isempty(RH_wei) && ~isvector(RH_wei)
    error('RH_wei must be a vector')
end

%% viz it

% viz
% function [ fig_hand ] = viz(surfStructHemi,wei,viewAngle)

% Left Hemisphere
if strcmp(plotViewStr,'all')
    subplot(221)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'lh:lat')

    fig_hand = viz(surfStruct.LH,LH_wei,-90) ; 
end

if strcmp(plotViewStr,'all')
    subplot(223)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'lh:med')

    fig_hand = viz(surfStruct.LH,LH_wei,90) ;     
end

% Right Hemisphere
if strcmp(plotViewStr,'all')
    subplot(222)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'rh:lat')
    fig_hand = viz(surfStruct.RH,RH_wei,90) ;     
end

if strcmp(plotViewStr,'all')
    subplot(224)
end
if strcmp(plotViewStr,'all') || strcmp(plotViewStr,'rh:med')

    fig_hand = viz(surfStruct.RH,RH_wei,-90) ;     
end
