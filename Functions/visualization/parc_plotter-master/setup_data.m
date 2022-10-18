
%%

addpath(strcat(pwd,'/src/'))
addpath(strcat(pwd,'/data/'))
addpath(genpath(strcat(pwd,'/src/external/')))

%% load surface info and save as mat

mkdir([pwd '/data/fsaverage/mat/'])

%for fff = {'sphere','smoothwm','inflated_pre','inflated'} 
for fff = {'inflated'} 
   
    surfStruct = load_surfStruct([pwd '/data/'],'fsaverage',fff{1}) ;
    fileName = [pwd '/data/fsaverage/mat/fsaverage_',fff{1},'.mat' ] ;
    save(fileName,'surfStruct','-v7.3') ;
end

%% load annotations
    
% initialize a map
allAnnots = containers.Map ;

%% gordon
currName = 'gordon333dil' 
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

tmpAnnot.combo_table = tmpAnnot.LH.ct.table(2:end,:) ;
tmpAnnot.roi_ids = tmpAnnot.LH.ct.table(2:end,5) ;
tmpAnnot.combo_names = tmpAnnot.LH.ct.struct_names(2:end) ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% hcp
currName = 'hcp-mmp-b' 
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

reord = [182:361 2:181];
tmpAnnot.combo_table = tmpAnnot.LH.ct.table(reord,:) ;
tmpAnnot.roi_ids = tmpAnnot.LH.ct.table(reord,5) ;
tmpAnnot.combo_names = tmpAnnot.LH.ct.struct_names(reord) ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% nspn500 

currName = 'nspn500' 
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

tmpAnnot.combo_table = [ tmpAnnot.LH.ct.table(2:end,:) ; tmpAnnot.RH.ct.table(2:end,:) ] ;
tmpAnnot.roi_ids = [ tmpAnnot.LH.ct.table(2:end,5) ; tmpAnnot.RH.ct.table(2:end,5) ] ;
tmpAnnot.combo_names = ...
    [ cellfun(@(x)[ 'L_' x ],tmpAnnot.LH.ct.struct_names(2:end),'UniformOutput',false) ; ...
    cellfun(@(x)[ 'R_' x ],tmpAnnot.RH.ct.struct_names(2:end),'UniformOutput',false) ] ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% power

currName = 'power'
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

tmpAnnot.combo_table = tmpAnnot.LH.ct.table(2:end,:) ;
tmpAnnot.roi_ids = tmpAnnot.LH.ct.table(2:end,5) ;
tmpAnnot.combo_names = tmpAnnot.LH.ct.struct_names(2:end) ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% schaefer

for iii = [ 100 200 300 400 500 600 800 1000 ] 

    currName = ['schaefer' num2str(iii) '-yeo17']
    tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;
     
    tmpAnnot.combo_table = [ tmpAnnot.LH.ct.table(2:end,:) ; tmpAnnot.RH.ct.table(2:end,:) ] ;
    tmpAnnot.roi_ids = [ tmpAnnot.LH.ct.table(2:end,5) ; tmpAnnot.RH.ct.table(2:end,5) ] ;
    tmpAnnot.combo_names = [ tmpAnnot.LH.ct.struct_names(2:end) ; tmpAnnot.RH.ct.struct_names(2:end) ] ;
    
    tmpAnnot.LH.border = get_parc_borders(...
        tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
    tmpAnnot.RH.border = get_parc_borders(...
        tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

    allAnnots(currName) = tmpAnnot ;

end

%% yeodil17

currName = 'yeo17dil'
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

tmpAnnot.combo_table = tmpAnnot.LH.ct.table(2:end,:) ;
tmpAnnot.roi_ids = tmpAnnot.LH.ct.table(2:end,5) ;
tmpAnnot.combo_names = tmpAnnot.LH.ct.struct_names(2:end) ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% aparc

currName = 'aparc'
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

% need to add 1 to RH regions
tmpTable = zeros(size(tmpAnnot.RH.ct.table)) ;
% r + g*2^8 + b*2^16 + flag*2^24
tmpTable(:,1:4) = [ tmpAnnot.RH.ct.table(:,1) tmpAnnot.RH.ct.table(:,2)+1 ...
    tmpAnnot.RH.ct.table(:,3) tmpAnnot.RH.ct.table(:,4) ] ;
tmpTable(:,5) = tmpTable(:,1) + tmpTable(:,2)*2^8 + tmpTable(:,3)*2^16 ;

% now change the vals
new_rh_vec = zeros(length(tmpAnnot.RH.labs),1) ;
old_rh_labs = tmpAnnot.RH.ct.table(:,5) ;
for idx = 1:length(old_rh_labs)
    
    new_rh_vec(tmpAnnot.RH.labs==old_rh_labs(idx)) = tmpTable(idx,5) ;
end
tmpAnnot.RH.labs = new_rh_vec ;

tmpAnnot.combo_table = [ tmpAnnot.LH.ct.table(2:end,:) ; tmpTable(2:end,:) ] ;
tmpAnnot.roi_ids = [ tmpAnnot.LH.ct.table(2:end,5) ; tmpTable(2:end,5) ] ;
tmpAnnot.combo_names = ...
    [ cellfun(@(x)[ 'L_' x ],tmpAnnot.LH.ct.struct_names(2:end),'UniformOutput',false) ; ...
    cellfun(@(x)[ 'R_' x ],tmpAnnot.RH.ct.struct_names(2:end),'UniformOutput',false) ] ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% a2009

currName = 'aparc.a2009s'
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

% need to add 1 to RH regions
tmpTable = zeros(size(tmpAnnot.RH.ct.table)) ;
% r + g*2^8 + b*2^16 + flag*2^24
tmpTable(:,1:4) = [ tmpAnnot.RH.ct.table(:,1) tmpAnnot.RH.ct.table(:,2)+1 ...
    tmpAnnot.RH.ct.table(:,3) tmpAnnot.RH.ct.table(:,4) ] ;
tmpTable(:,5) = tmpTable(:,1) + tmpTable(:,2)*2^8 + tmpTable(:,3)*2^16 ;

% now change the vals
new_rh_vec = zeros(length(tmpAnnot.RH.labs),1) ;
old_rh_labs = tmpAnnot.RH.ct.table(:,5) ;
for idx = 1:length(old_rh_labs)
    
    new_rh_vec(tmpAnnot.RH.labs==old_rh_labs(idx)) = tmpTable(idx,5) ;
end
tmpAnnot.RH.labs = new_rh_vec ;

tmpAnnot.combo_table = [ tmpAnnot.LH.ct.table(2:end,:) ; tmpTable(2:end,:) ] ;
tmpAnnot.roi_ids = [ tmpAnnot.LH.ct.table(2:end,5) ; tmpTable(2:end,5) ] ;
tmpAnnot.combo_names = ...
    [ cellfun(@(x)[ 'L_' x ],tmpAnnot.LH.ct.struct_names(2:end),'UniformOutput',false) ; ...
    cellfun(@(x)[ 'R_' x ],tmpAnnot.RH.ct.struct_names(2:end),'UniformOutput',false) ] ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% BN atlas

currName = 'BN_Atlas'
tmpAnnot = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

tmpAnnot.combo_table = tmpAnnot.LH.ct.table(2:end,:) ;
tmpAnnot.roi_ids = tmpAnnot.LH.ct.table(2:end,5) ;
tmpAnnot.combo_names = tmpAnnot.LH.ct.struct_names(2:end) ;

tmpAnnot.LH.border = get_parc_borders(...
    tmpAnnot.LH.labs,surfStruct.LH.nbrs,0) ;
tmpAnnot.RH.border = get_parc_borders(...
    tmpAnnot.RH.labs,surfStruct.RH.nbrs,0) ;

allAnnots(currName) = tmpAnnot ;

%% save it

fileName = [pwd '/data/fsaverage/mat/fsaverage_annots.mat' ] ;
save(fileName,'allAnnots','-v7.3') ;
ls(fileName)
