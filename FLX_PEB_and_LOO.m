%% This script will reproduce the DCM results comparing remitters to 
%% non-remitters in the CBT + fluoxetine group reported in the Kung et al., 
%% manuscript

% Please ensure that your SPM12 folder (r7771) is listed in your MATLAB set
% path. These results were obtained using Matlab R2021b. Values may
% slightly differ from the manuscript depending on your OS and version of
% Matlab.

%% -----------------------------------------------------------------------

% The first section runs a PEB model containing parameters to quantify
% the effects of MDD remission, age, and sex, which are saved in 
% M_FLX_Remission.mat, on each of the DCM intrinsic {'A'} and modulatory 
% {'B'} pathways, to generate the exploratory analysis results reported in 
% the manuscript.

% Load GCM & M.mat files and mean-center covariates
clear
load('FLX_GCM.mat');
load('M_FLX_Remission.mat'); % This design matrix contains data on 
                             % participant treatment outcome (remission), 
                             % age & sex

X = dm.X;
K = width(X);
X(:,2:K)=X(:,2:K)-mean(X(:,2:K));
X_labels = dm.labels;

M = struct();
M.Q = 'fields';
M.X = X;
M.Xnames = X_labels;

[PEB, RCM] = spm_dcm_peb(DCM, M, {'A', 'B'});
BMA_FLX = spm_dcm_peb_bmc(PEB);

spm_dcm_peb_review (BMA_FLX, DCM);

% Review shared effects
    % second-level effect - Mean 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise

% Review between-group effects
    % second-level effect - Remission_12 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise

%% -----------------------------------------------------------------------

% The second section tested the vmPFC-to-amygdala modulatory effects using 
% leave-one-out cross validation to generate the results reported in the 
% manuscript.

[qE,qC,Q] = spm_dcm_loo(DCM,M,{'B(1,5,2)'});
