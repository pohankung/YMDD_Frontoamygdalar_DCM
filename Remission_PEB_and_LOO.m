%% This script will reproduce the DCM results comparing remitters to 
%% non-remitters reported in the Kung et al., manuscript

% Please ensure that your SPM12 folder (r7771) is listed in your MATLAB set
% path. These results were obtained using Matlab R2021b. Values may
% slightly differ from the manuscript depending on your OS and version of
% Matlab.

%% -----------------------------------------------------------------------

% The first section runs a PEB model containing parameters to quantify
% the effects of MDD remission, treatment group, 
% treatment group x remission interaction, age, and sex, which are saved 
% in M_H_MDD.mat, on each of the DCM intrinsic {'A'} and modulatory {'B'} 
% pathways, to generate the results displayed in Figure 4A (also detailed 
% in Table S12, Table S13, and Figure S4 in the online supplement).

% Load GCM & M.mat files and mean-center covariates
clear
load('MDD_GCM.mat');
load('M_Remission.mat'); % This design matrix contains data on participant 
                         % treatment response (remission), treatment group, 
                         % treatment group x remission interaction, age & sex

X = dm.X;
K = width(X);
X(:,2:K)=X(:,2:K)-mean(X(:,2:K));
X_labels = dm.labels;

M = struct();
M.Q = 'fields';
M.X = X;
M.Xnames = X_labels;

[PEB, RCM] = spm_dcm_peb(DCM, M, {'A', 'B'});
BMA_Remission = spm_dcm_peb_bmc(PEB);

spm_dcm_peb_review (BMA_Remission, DCM);

% Review shared effects (Figure 4A, Table S12)
    % second-level effect - Mean 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise

% Review between-group effects (Figure 4A, Table S13)
    % second-level effect - Remission_12 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise

%% -----------------------------------------------------------------------

% The second section tested the vmPFC-to-amygdala modulatory effects using 
% leave-one-out cross validation to generate the results reported in the 
% manuscript (Figure S4).

[qE,qC,Q] = spm_dcm_loo(DCM,M,{'B(1,5,2)'});
