clc ; close all ; clearvars

%%

fileName = [pwd '/data/fsaverage/mat/fsaverage_annots.mat' ] ;
load(fileName,'allAnnots') ;

surfStruct = load_surfStruct([pwd '/data/'],'fsaverage','inflated') ;

%% the 7 and 17 network names

% which is actually 8 with TempPar.. but we include that in Default...
names7 = { 'Vis' 'SomMot' 'DorsAttn' ...
    'SalVentAttn' 'Limbic' 'Cont' 'Default' 'TempPar' } ;

names17 = { 'VisCent' 'VisPeri' 'SomMotA' 'SomMotB' ...
    'DorsAttnA' 'DorsAttnB' 'SalVentAttnA' 'SalVentAttnB' ...
    'Limbic_OFC' 'Limbic_TempPole' 'ContA' 'ContB' 'ContC' ...
    'DefaultA' 'DefaultB' 'DefaultC' 'TempPar' } ;

%% lets get the schaefer200-yeo17

sch200 = allAnnots('schaefer200-yeo17') ;

%% make the 7 and 17 lists, using the names 

nn = sch200.combo_names ; 

list7 = zeros(length(nn),1) ;
for idx = 1:7
    list7(contains(nn,[ 'H_' names7{idx}])) = idx ;
end
% and the correction for limbic 
list7(contains(nn,[ 'H_' names7{8}])) = 7 ;

list17 = zeros(length(nn),1) ;
for idx = 1:length(names17)
    list17(contains(nn,[ 'H_' names17{idx}])) = idx ;
end

%% now convert

% make a new combo table
new_combo_7 = zeros(7,5) ;
for idx = 1:7
    tmpind = find(list7==idx) ;
    f_tmpInd = tmpind(1) ; 
    new_combo_7(idx,:) = sch200.combo_table(f_tmpInd,:) ;
end

% change the color for default
tmpind = find(list7==7) ;
f_tmpInd = tmpind(20) ; 
new_combo_7(7,:) = sch200.combo_table(f_tmpInd,:) ;

new_combo_17 = zeros(17,5) ;
for idx = 1:17
    tmpind = find(list17==idx) ;
    f_tmpInd = tmpind(1) ; 
    new_combo_17(idx,:) = sch200.combo_table(f_tmpInd,:) ;
end


%% now remap the values
LH_newLabs_7 = zeros(size(sch200.LH.labs)) ;
RH_newLabs_7 = zeros(size(sch200.RH.labs)) ;
LH_newLabs_17 = zeros(size(sch200.LH.labs)) ;
RH_newLabs_17 = zeros(size(sch200.RH.labs)) ;
for idx = 1:length(sch200.roi_ids)

    currId = sch200.roi_ids(idx) ;
    
    ctInd_7 = list7(idx) ;
    ctInd_17 = list17(idx) ;

    LH_newLabs_7(sch200.LH.labs==currId) = new_combo_7(ctInd_7,5) ;
    RH_newLabs_7(sch200.RH.labs==currId) = new_combo_7(ctInd_7,5) ;

    LH_newLabs_17(sch200.LH.labs==currId) = new_combo_17(ctInd_17,5) ;
    RH_newLabs_17(sch200.RH.labs==currId) = new_combo_17(ctInd_17,5) ;

end

%% get struct yeo7

currName = ['schaefer' num2str(200) '-yeo17']
yeo7Struct = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

yeo7Struct.combo_table = new_combo_7 ;
yeo7Struct.roi_ids = new_combo_7(:,5) ;
yeo7Struct.combo_names = names7(1:7) ;

% replace labs
yeo7Struct.LH.labs = LH_newLabs_7 ;
yeo7Struct.RH.labs = RH_newLabs_7 ;

yeo7Struct.LH.border = get_parc_borders(...
    yeo7Struct.LH.labs,surfStruct.LH.nbrs,0) ;
yeo7Struct.RH.border = get_parc_borders(...
    yeo7Struct.RH.labs,surfStruct.RH.nbrs,0) ;

%% struct yeo17

currName = ['schaefer' num2str(200) '-yeo17']
yeo17Struct = load_annotStruct([pwd '/data/'],'fsaverage',currName) ;

yeo17Struct.combo_table = new_combo_17 ;
yeo17Struct.roi_ids = new_combo_17(:,5) ;
yeo17Struct.combo_names = names17(1:7) ;

% replace labs
yeo17Struct.LH.labs = LH_newLabs_17 ;
yeo17Struct.RH.labs = RH_newLabs_17 ;

yeo17Struct.LH.border = get_parc_borders(...
    yeo17Struct.LH.labs,surfStruct.LH.nbrs,0) ;
yeo17Struct.RH.border = get_parc_borders(...
    yeo17Struct.RH.labs,surfStruct.RH.nbrs,0) ;


%% newMap 

yeoNets = containers.Map ;

yeoNets('7') = yeo7Struct ;
yeoNets('17') = yeo17Struct ; 

%% now plot

cmap = yeoNets('7').combo_table(:,1:3) ./ 255 ;


% function [h] = parc_plot(surfStruct,annotMap,annotName,dataVec,cMap,viewStr)
parc_plot(surfStruct,yeoNets,'7',1:(size(cmap,1)),...
    'cMap',cmap, 'border',1)

