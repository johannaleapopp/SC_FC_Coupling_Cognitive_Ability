function [surfStruct] = load_surfStruct(dataDir,surfStr,surfAppear)

if nargin<3
   surfAppear='inflated';
end

% initialize
surfStruct = struct();

% load freesurfer average surface
if strcmp(surfStr,'fsaverage')
    for hemiStr = { 'LH' 'RH' }

        hemi=hemiStr{1}; disp(['reading surface: ' hemi])
 
        % fetch appropriate file from data source
        fileName=[dataDir '/fsaverage/surf/' lower(hemi) '.' surfAppear ];
        
        % function [vertex_coords, faces, magic] = read_surf(fname)
        [surfStruct.(hemi).coords,surfStruct.(hemi).faces] = read_surf(fileName) ;
        % add 1 to face indices, because we'll 1 index instead of 0 index
        surfStruct.(hemi).faces = surfStruct.(hemi).faces(:,1:3) + 1 ;
        % add sizes
        surfStruct.(hemi).nverts = size(surfStruct.(hemi).coords,1) ;
        surfStruct.(hemi).nfaces = size(surfStruct.(hemi).faces,1) ;
        % get neighbors
        surfStruct.(hemi) = fs_find_neighbors(surfStruct.(hemi)) ;      
    end
else
   error('specified surface not available yet') 
end
