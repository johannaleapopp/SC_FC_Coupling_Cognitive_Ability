function [annotStruct] = load_annotStruct(dataDir,surfName,annotName)

for hemiStr = { 'LH' 'RH' }

    hemi=hemiStr{1}; disp(['reading annot for: ' hemi])

    % fetch appropriate file from data source
    fileName=[dataDir '/',surfName,'/label/' lower(hemi) '.' annotName '.annot' ];

    if ~isfile(fileName)
       error(['cannot read file name:' fileName]) 
    end
    
    % function [vertices, label, colortable] = read_annotation(filename, varargin)
    [annotStruct.(hemi).verts, annotStruct.(hemi).labs,annotStruct.(hemi).ct ] = ...
        read_annotation(fileName) ;

    % add 1 to verts to remind ourselves that this was 0 indexed
    annotStruct.(hemi).verts = annotStruct.(hemi).verts + 1;
    
end
