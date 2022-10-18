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
                'facevertexcdata',single(wei),...
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
fig_hand.CDataMapping = cmapStr ;

%% notes
% fffile='white_avg';
% [aa,bb] = read_surf(['/geode2/soft/hps/rhel7/freesurfer/6.0.0/freesurfer/subjects/fsaverage/surf/rh.' fffile]) ;
% fh = patch('faces',bb+1,'vertices',[ aa(:,1) aa(:,2) aa(:,3) ], 'facecolor', 'flat', 'edgecolor','none','facevertexcdata',ones(length(bb),1)) ; view(gca,3); axis equal; axis off ; view(90,0); material dull; camlight headlight; lighting gouraud ; 
