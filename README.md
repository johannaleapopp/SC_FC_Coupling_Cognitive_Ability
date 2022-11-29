# SC_FC_Coupling_Cognitive_Ability

 ## 1.	Scope

This repository contains scripts that were used to conduct the analyses in **“Structural-Functional Brain Network Coupling Predicts Human Cognitive Ability”** coauthored by Johanna L. Popp, Jonas A. Thiele, Joshua Faskowitz, Caio Seguin, Olaf Sporns and Kirsten Hilger (doi: will be updated after publication). In brief, we investigated the relationship between general cognitive ability and structural-functional brain network coupling as operationalized with similarity measures and network communication measures. The scripts found in this repository can be used to replicate all analyses or more generally, to study the association between structural-functional brain network coupling and individual differences (e.g., in general cognitive ability). In case you have questions or trouble with running the scripts, feel free to reach out under johanna.popp@uni-wuerzburg.de.
 
## 2.	Data 
For the main sample analysis, data from the S1200 sample of the Human Connectome Project funded by the National Institute of Health Project were used (HCP; Van Essen et al., 2013). For the replication of results, we used data from the ID1000 sample collected as a part of the Amsterdam Open MRI Collection (AOMIC; Snoek et al., 2021). All data analyzed in the current study can be accessed online: 

HCP: https://www.humanconnectome.org/study/hcp-young-adult/data-releases/

AOMIC: https://openneuro.org/datasets/ds003097


## 3.	Preprocessing 
For the Main Analysis, we used the minimally preprocessed HCP fMRI data (Glasser et al., 2013) and implemented an additional nuisance regression strategy as explained here (Parkes et al., 2018) with 24 head motion parameters, 8 mean signals from white matter and cerebrospinal fluid and 4 global signals (strategy no. 6). FMRI preprocessing steps were conducted externally, and code can be found here: [faskowit/app-fmri-2-mat: fmriprep outputs to connectivity matrices (github.com)](https://github.com/faskowit/app-fmri-2-mat). To assess individual structural connectivity, we use minimally preprocessed DWI provided by the HCP and ran the MRtrix pipeline for DWI processing (Civier et al., 2019; Tournier et al., 2012; [HCP-dMRI-connectome/subject_preprocess.sh at master · civier/HCP-dMRI-connectome (github.com)](https://github.com/civier/HCP-dMRI-connectome/blob/master/subject_preprocess.sh)). Probabilistic streamline tractography was carried out to render streamlines through the white matter and terminating in grey matter (Smith et al., 2012). For the Replication Analyses, data from the AOMIC was downloaded in minimally preprocessed form and preprocessed similarly to the approaches described above. Brain networks were constructed using a multimodal parcellation dividing the brain into 360 nodes (Glasser et al., 2016). 

## 4.	Computation of latent g-factor 

To estimate general cognitive ability in the subjects from the HCP, a latent g-factor was computed using simplified bi-factor analysis of 12 cognitive scores that were derived as a part of the HCP Protocol (see Dubois et al., 2018; Thiele et al., 2022). Specifics about this procedure and code for the computation of a latent g-factor is provided here: [https://github.com/jonasAthiele/BrainReconfiguration_Intelligence](https://github.com/jonasAthiele/BrainReconfiguration_Intelligence).

## 5.	Structure and Script Description 

### 5.1.	 Main Analysis 
For the analysis done in the paper, the scripts should be run in the following order: 
1.	`HCP_import_data`: Imports structural connectivity matrices and fMRI time courses from folder structure 

2. `HCP_import_motion_data`: Imports motion data from folder structure

3.	`HCP_prepare_SC_data`: This script prepares the structural connectivity matrices. It imports subjects IDs and connectivity matrices into a cell that can be used for further analyses and reorders nodes so that they match up with the FC connectivity matrices. 

4.	`HCP_motion_correction_with_FD`: This script is used for motion correction using data from fractional displacement (FD). It defines resting-state scans that need to be excluded and computes meanFD values across the remaining scans that are used for confound regression in later analyses. 

5.	`HCP_prepare_FC_data_with_FD`: This script prepares the functional connectivity matrices. It a) imports subject IDs and fMRI time courses (of all 4 runs conducted) into a cell b) matches up the node order with the node order in SC Matrices c) computes FC connectivity matrices d) excludes scans based on motion criteria e) averages the FC connectivity matrices across the 4 runs per individual and f) Fisher-z transforms the mean FC connectivity matrix. 

6.	`HCP_match_behavioral_data`: This script imports all behavioral data and merges them together for the subjects that have complete data. 

5.	`HCP_find_subjects_that_have_all_data`: This script creates tables and cells for further analyses only containing the subjects with complete data. 

6.	`HCP_compute_coupling_measures`: This script is based on a script published by Esfahlani et al. (2021) and was adjusted accordingly to fit our analysis. Original code can be found here: [local_scfc/README.md at main · brain-networks/local_scfc · GitHub](https://github.com/brain-networks/local_scfc/blob/main/README.md). This script a) computes individual communication and similarity matrices and b) correlates regional connectivity profiles with respective connectivity profiles of the functional connectivity matrix. 

7.	`HCP_whole_brain_coupling` : This script a) computes whole-brain coupling average for each individual across the 8 coupling measures and b) correlates whole-brain coupling with cognitive ability scores 

8.	`HCP_maximum_variance_explained_all_measures`: This script computes the maximum variance in FC (node-specific) explained by any of the 8 coupling measures for each individual and averages node-specific values across all individuals. This script also plots the respective Figure in the paper. 

9.	`HCP_NMAs_whole_sample`: This script builds a positive and negative Node-Measure Assignment (NMA) for the complete sample, plots the NMAs, the grouped NMAs and the mean coupling for the NMAs. 

10.	`HCP_internal_cross_validation_complete`: This script conducts an internal cross validation of the multiple linear regression model based on the mean coupling values of the NMAs. It contains 3 parts: **Part 1** partitions the sample into 5 different folds (taking into account family relations and intelligence distribution) and creates the positive and negative Node-Measure Assignments for each training fold and test fold based on the correlation with general cognitive ability. **Part 2** uses the Node-Measure Assignments that were created in part 1 to build multiple linear regression models that are then tested for their ability to predict general cognitive ability in the test samples. **Part 3** tests the prediction of the internal cross-validated linear regression model by permutation testing.

11.	`HCP_external_replication_in_AOMIC`: This script consists of two parts and conducts the external replication of the linear regression model built in the HCP that is then tested in the AOMIC. It creates the Linear Regression Model in the HCP and tests for its prediction of Intelligence in the AOMIC sample.

12.	`HCP_post_hoc_analyses`: This script carries out all post hoc analyses using the Margulies gradient and the 7 Yeo networks. 

### 5.2.	Replication Analysis 

For the replication analysis done in the paper, scripts are named similarly and should be run in the same order as described in the Main Analysis above. 

### 5.3.	Functions 
Functions used in the scripts can be found in the functions folder. Some of the functions can be found elsewhere e.g., as part of the brain connectivity toolbox (Rubinov & Sporns, 2010, [Brain Connectivity Toolbox (google.com)](https://sites.google.com/site/bctnet/)). Comments on the authorship and licenses of these functions are provided within the folder. 

## 6.	Software requirements 
-	Matlab version 2021a
-	R version 4.0.2 (For the computation of the latent g-factor) 

## References 
*Civier, O., Smith, R. E., Yeh, C. H., Connelly, A., & Calamante, F. (2019). Is removal of weak connections necessary for graph-theoretical analysis of dense weighted structural connectomes from diffusion MRI?. NeuroImage, 194, 68-81.*

*Dubois, J., Galdi, P., Paul, L. K., & Adolphs, R. (2018). A distributed brain network predicts general intelligence from resting-state human neuroimaging data. Philosophical Transactions of the Royal Society B: Biological Sciences, 373(1756), 20170284.*

*Zamani Esfahlani, Farnaz, et al. "Local structure-function relationships in human brain networks across the lifespan." Nature communications 13.1 (2022): 1-16.Glasser, Matthew F., et al. "A multi-modal parcellation of human cerebral cortex." Nature 536.7615 (2016): 171-178.*

*Glasser, M. F., Coalson, T. S., Robinson, E. C., Hacker, C. D., Harwell, J., Yacoub, E., ... & Van Essen, D. C. (2016). A multi-modal parcellation of human cerebral cortex. Nature, 536(7615), 171-178.*

*Parkes, L., Fulcher, B., Yücel, M., & Fornito, A. (2018). An evaluation of the efficacy, reliability, and sensitivity of motion correction strategies for resting-state functional MRI. Neuroimage, 171, 415-436.*

*Rubinov, M., & Sporns, O. (2010). Complex network measures of brain connectivity: uses and interpretations. Neuroimage, 52(3), 1059-1069.*

*Snoek, L., van der Miesen, M. M., Beemsterboer, T., van der Leij, A., Eigenhuis, A., & Steven Scholte, H. (2021). The Amsterdam Open MRI Collection, a set of multimodal MRI datasets for individual difference analyses. Scientific Data, 8(1), 1-23.*

*Smith, R. E., Tournier, J. D., Calamante, F., & Connelly, A. (2012). Anatomically-constrained tractography: improved diffusion MRI streamlines tractography through effective use of anatomical information. Neuroimage, 62(3), 1924-1938.*

*Thiele, J. A., Faskowitz, J., Sporns, O., & Hilger, K. (2022). Multitask brain network reconfiguration is inversely associated with human intelligence. Cerebral Cortex, 32(19), 4172-4182.* 

*Tournier, J. D., Calamante, F., & Connelly, A. (2012). MRtrix: diffusion tractography in crossing fiber regions. International journal of imaging systems and technology, 22(1), 53-66.*

*Van Essen, David C., et al. "The WU-Minn human connectome project: an overview." Neuroimage 80 (2013): 62-79.*

## Copyright 
Copyright (cc) by Johanna L. Popp 

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />Files of SC_FC_Coupling_Intelligence by Johanna L. Popp are licensed under <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

Note that external functions have other licenses that are provided in the `Functions` folder. 
