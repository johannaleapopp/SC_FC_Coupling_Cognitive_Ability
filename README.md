# SC_FC_Coupling_Cognitive_Ability

 ## 1.	Scope

This repository contains scripts that were used to conduct the analyses in **“Structural-Functional Brain Network Coupling Predicts Human Cognitive Ability”** coauthored by Johanna L. Popp, Jonas A. Thiele, Joshua Faskowitz, Caio Seguin, Olaf Sporns and Kirsten Hilger (doi: will be updated after publication). In brief, we investigated the relationship between general cognitive ability and structural-functional brain network coupling (SC-FC coupling) as operationalized with similarity measures and network communication measures. The scripts found in this repository can be used to replicate all analyses or more generally, to study the association between SC-FC coupling and individual differences (e.g., in general cognitive ability). In case you have questions or trouble with running the scripts, feel free to reach out under johanna.popp@uni-wuerzburg.de.
 
## 2.	Data 
For the main sample analysis, data from the S1200 sample of the Human Connectome Project funded by the National Institute of Health were used (HCP; Van Essen et al., 2013). For the replication of results, we used data from the ID1000 sample collected as a part of the Amsterdam Open MRI Collection (AOMIC; Snoek et al., 2021). All data analyzed in the current study can be accessed online: 

HCP: https://www.humanconnectome.org/study/hcp-young-adult/data-releases/

AOMIC: https://openneuro.org/datasets/ds003097


## 3.	Preprocessing 
For the main analysis, the minimally preprocessed resting-state fMRI data from the HCP (Glasser et al., 2013) were used. As additional denoising strategy, nuisance regression as explained in Parkes et al. (2018; strategy no.6) with 24 head motion parameters, eight mean signals from white matter and cerebrospinal fluid and four global signals was applied. Resting-state fMRI preprocessing steps were conducted externally, and code can be found here: https://github.com/faskowit/app-fmri-2-mat. To assess individual structural connectivity, the minimally preprocessed DWI data provided by the HCP were used and we ran the MRtrix pipeline for DWI processing (Civier et al., 2019; Tournier et al., 2019; https://github.com/civier/HCP-dMRI-connectome). Probabilistic streamline tractography was carried out to render streamlines through white matter that are terminating in grey matter (Smith et al., 2012). For the replication analysis, data from the AOMIC was downloaded in minimally preprocessed form and further processed similarly as in the main sample. Brain networks were constructed using a multimodal parcellation dividing the brain into 360 nodes (Glasser et al., 2016). 

## 4.	Computation of latent *g*-factor 

General cognitive ability was operationalized as latent *g*-factor from 12 cognitive measures (Thiele et al., 2022). This *g*-factor was calculated using simplified bi-factor analysis as outlined in Dubois et al. (2018). Code for the computation of a latent *g*-factor is provided here: https://github.com/jonasAthiele/BrainReconfiguration_Intelligence.

## 5.	Structure and script description 

### 5.1.	 Main analysis 
For the analysis done in the paper, the scripts should be run in the following order (Script 1-8 are found in the subfolder `HCP Data Prep`):  
1. `HCP_import_data`: Import of structural connectivity matrices and fMRI time courses from folder structure.  

2. `HCP_import_motion_data`: Import of motion data from folder structure.

3. `HCP_join_motion_and_behavioral`: Merge motion data with other behavioral data.

4. `HCP_prepare_SC_data`: Preparation of the structural connectivity matrices: Import of subject’s IDs and connectivity matrices into a cell that can be used for further analyses and reordering of nodes so that they match up with the FC data.  

5. `HCP_motion_correction_with_FD`: Motion correction using data from fractional displacement (FD). Determination of resting-state scans that need to be excluded and computation of mean FD values across the remaining scans used for confound regression in later analyses.

6. `HCP_prepare_FC_data_with_FD`: Preparation of the functional connectivity matrices. Included steps are a) import of subject IDs and fMRI time courses (of all 4 runs conducted) into a cell b) matching up node order with the node order in SC data c) computation of FC matrices d) exclusion of scans based on motion criteria e) averaging the FC matrices across the 4 runs per individual and f) Fisher-z transformation of the individual mean FC matrix. 

7. `HCP_match_behavioral_data`: Import of all behavioral data. 

8. `HCP_find_subjects_that_have_all_data`: Construction of tables and cells for further analyses only containing the subjects with complete data.  

9. `HCP_compute_coupling_measures`: This script is based on a script published by Zamani Esfahlani et al. (2022) and was adjusted accordingly to fit our analysis. Original code can be found here: https://github.com/brain-networks/local_scfc. Included steps are a) computation of individual similarity matrices and communication matrices and b) correlation of regional connectivity profiles in communication/similarity matrices with respective connectivity profiles of the functional connectivity matrix. 

10. `HCP_maximum_variance_explained_all_measures`: Creation of the SC-FC coupling pattern by indentifying the coupling measure able to explain the largest variance in FC across all participants and averaging respective region-specific individual coupling values across all participants. Plotting of a group map visualizing the overall SC-FC coupling pattern. 
	
11. `HCP_whole_brain_coupling`: Included steps are a) computation of individual brain-average coupling values for all eight coupling measures and b) partial correlations of brain-average coupling values with cognitive ability scores controlling for age, gender, handedness and in-scanner head motion.   

12. `HCP_NMAs_whole_sample`: Computation of a positive and negative node-measure assignment (NMA) mask for the complete sample based on the magnitude of association between coupling measures with general cognitive ability scores per brain region across all subjects, plotting of a) positive and negative NMAs b) positive and negative NMAs with measures grouped based on conceptual similarity, and c) mean coupling strength for the positive and negative NMAs.  

13. `HCP_internal_cross_validation_complete`: Conduction of the internal cross-validation of the multiple linear regression model that is built using two input predictor variables. The predictor variables are are derived from individual’s coupling values and extracted by using group-based positive and group-based negative NMA masks. This script contains three parts: **Part 1** partitions the sample into 5 different folds (considering family relations and intelligence distribution) and creates the positive and negative NMAs for each training fold and test fold. **Part 2** uses the NMAs created in part 1 to build multiple linear regression models that are then tested for their ability to predict general cognitive ability in the test samples. **Part 3** assesses the significance of the prediction with a permutation test. 

14. `HCP_external_replication_in_AOMIC`: Construction of the multiple linear regression model in the HCP and testing for its ability to predict cognitive ability scores in the AOMIC.

15. `HCP_external_replication_in_AOMIC_permutation_test`: Assessment of the statistical significance of the external replication with a permutation test.

16. `HCP_post_hoc_analyses`: Conduction of post-hoc analyses using the Margulies gradient (Margulies et al., 2016) and assignment of coupling measures to the 7 functional Yeo networks (Yeo et al., 2011) 

17. `HCP_AOMIC_distribution_of_general_cognitive_ability_scores`: Plotting the distribution of general cognitive ability scores in both samples. 

### 5.2.	Replication Analysis 

For the replication analysis done in the paper, scripts are named similarly and should be run in the same order as described in the main analysis above. 

### 5.3.	Functions 
Functions used in the scripts can be found in the functions folder. Some of the functions can be found elsewhere e.g., as part of the brain connectivity toolbox (Rubinov & Sporns, 2010, https://sites.google.com/site/bctnet/). Comments on the authorship and licenses of these functions are provided within the folder. 

## 6.	Software requirements 
-	Matlab version 2021a
-	R version 4.0.2 (For the computation of the latent *g*-factor) 

## References 

Civier, O., Smith, R. E., Yeh, C.-H., Connelly, A., & Calamante, F. (2019). Is removal of weak connections necessary for graph-theoretical analysis of dense weighted structural connectomes from diffusion MRI? *NeuroImage, 194*, 68–81. https://doi.org/10.1016/j.neuroimage.2019.02.039

Dubois, J., Galdi, P., Paul, L. K., & Adolphs, R. (2018). A distributed brain network predicts general intelligence from resting-state human neuroimaging data. *Philosophical Transactions of the Royal Society B: Biological Sciences, 373*(1756), 20170284. https://doi.org/10.1098/rstb.2017.0284

Glasser, M. F., Coalson, T. S., Robinson, E. C., Hacker, C. D., Harwell, J., Yacoub, E., Ugurbil, K., Andersson, J., Beckmann, C. F., Jenkinson, M., Smith, S. M., & Van Essen, D. C. (2016). A multi-modal parcellation of human cerebral cortex. *Nature, 536*(7615), 171–178. https://doi.org/10.1038/nature18933

Glasser, M. F., Sotiropoulos, S. N., Wilson, J. A., Coalson, T. S., Fischl, B., Andersson, J. L., Xu, J., Jbabdi, S., Webster, M., Polimeni, J. R., Van Essen, D. C., & Jenkinson, M. (2013). The minimal preprocessing pipelines for the Human Connectome Project. *NeuroImage, 80*, 105–124. https://doi.org/10.1016/j.neuroimage.2013.04.127

Margulies, D. S., Ghosh, S. S., Goulas, A., Falkiewicz, M., Huntenburg, J. M., Langs, G., Bezgin, G., Eickhoff, S. B., Castellanos, F. X., Petrides, M., Jefferies, E., & Smallwood, J. (2016). Situating the default-mode network along a principal gradient of macroscale cortical organization. *Proceedings of the National Academy of Sciences, 113*(44), 12574–12579. https://doi.org/10.1073/pnas.1608282113

Parkes, L., Fulcher, B., Yücel, M., & Fornito, A. (2018). An evaluation of the efficacy, reliability, and sensitivity of motion correction strategies for resting-state functional MRI. *NeuroImage, 171*, 415–436. https://doi.org/10.1016/j.neuroimage.2017.12.073

Rubinov, M., & Sporns, O. (2010). Complex network measures of brain connectivity: Uses and interpretations. NeuroImage, 52(3), 1059–1069. https://doi.org/10.1016/j.neuroimage.2009.10.003

Smith, R. E., Tournier, J.-D., Calamante, F., & Connelly, A. (2012). Anatomically-constrained tractography: Improved diffusion MRI streamlines tractography through effective use of anatomical information. *NeuroImage, 62*(3), 1924–1938. https://doi.org/10.1016/j.neuroimage.2012.06.005

Snoek, L., van der Miesen, M. M., Beemsterboer, T., van der Leij, A., Eigenhuis, A., & Steven Scholte, H. (2021). The Amsterdam Open MRI Collection, a set of multimodal MRI datasets for individual difference analyses. *Scientific Data, 8*, 85. https://doi.org/10.1038/s41597-021-00870-6

Thiele, J. A., Faskowitz, J., Sporns, O., & Hilger, K. (2022). Multitask Brain Network Reconfiguration Is Inversely Associated with Human Intelligence. *Cerebral Cortex*, bhab473. https://doi.org/10.1093/cercor/bhab473

Tournier, J.-D., Smith, R., Raffelt, D., Tabbara, R., Dhollander, T., Pietsch, M., Christiaens, D., Jeurissen, B., Yeh, C.-H., & Connelly, A. (2019). MRtrix3: A fast, flexible and open software framework for medical image processing and visualisation. *NeuroImage, 202*, 116137. https://doi.org/10.1016/j.neuroimage.2019.116137

Van Essen, D. C., Smith, S. M., Barch, D. M., Behrens, T. E. J., Yacoub, E., & Ugurbil, K. (2013). The WU-Minn Human Connectome Project: An Overview. *NeuroImage, 80*, 62–79. https://doi.org/10.1016/j.neuroimage.2013.05.041

Yeo, T., Krienen, F., Sepulcre, J., Sabuncu, M., Lashkari, D., Hollinshead, M., Roffman, J., Smoller, J., Zöllei, L., Polimeni, J., Fischl, B., Liu, H., & Buckner, R. (2011). The organization of the human cerebral cortex estimated by intrinsic functional connectivity. *J Neurophysiol, 106*(3). https://doi.org/10.1152/jn.00338.2011

Zamani Esfahlani, F., Faskowitz, J., Slack, J., Mišić, B., & Betzel, R. F. (2022). Local structure-function relationships in human brain networks across the lifespan. *Nature Communications, 13*(1), 2053. https://doi.org/10.1038/s41467-022-29770-y


## Copyright 
Copyright (cc) by Johanna L. Popp 

<a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc/4.0/88x31.png" /></a><br />

Files of SC_FC_Coupling_Cognitive_Ability by Johanna L. Popp are licensed under <a rel="license" href="http://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attribution-NonCommercial 4.0 International License</a>.

Note that external functions have other licenses that are provided in the `Functions` folder. 
