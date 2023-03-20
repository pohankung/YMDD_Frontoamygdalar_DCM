%% This script will reproduce the DCM results comparing MDD patients to 
%% healthy controls reported in the Kung et al., manuscript

% Please ensure that your SPM12 folder (r7771) is listed in your MATLAB set
% path. These results were obtained using Matlab R2021b. Values may
% slightly differ from the manuscript depending on your OS and version of
% Matlab.

%% -----------------------------------------------------------------------

% The first section runs a PEB model containing parameters to quantify
% the effects of MDD diagnosis, age, and sex, which are saved in M_H_MDD.mat, 
% on each of the DCM intrinsic {'A'} and modulatory {'B'} pathways, to 
% generate the results displayed in Figure 3A (also detailed in Table S11, 
% Table S13, and Figure S2 in the online supplement).

% Load GCM & M.mat files and mean-center covariates
clear
load('H_MDD_GCM.mat');
load('M_H_MDD.mat'); % This design matrix contains data on participant 
                     % diagnostic group, age & sex

X = dm.X;
K = width(X);
X(:,2:K)=X(:,2:K)-mean(X(:,2:K));
X_labels = dm.labels;

M = struct();
M.Q = 'fields';
M.X = X;
M.Xnames = X_labels;

[PEB, RCM] = spm_dcm_peb(DCM, M, {'A', 'B'});
BMA_HMDD = spm_dcm_peb_bmc(PEB);

spm_dcm_peb_review (BMA_HMDD, DCM);

% Review shared effects (Figure 3A, Table S11)
    % second-level effect - Mean 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise

% Review between-group effects (Figure 3A, Table S13)
    % second-level effect - Group 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise

%% -----------------------------------------------------------------------

% The second section tested the vlPFC-to-amygdala modulatory effects using 
% leave-one-out cross validation to generate the results reported in the 
% manuscript (Figure S2).

[qE,qC,Q] = spm_dcm_loo(DCM,M,{'B(1,3,2)'});
