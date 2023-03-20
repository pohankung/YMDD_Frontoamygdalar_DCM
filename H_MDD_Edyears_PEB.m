%% This script will reproduce the DCM results comparing MDD patients to 
%% healthy controls (including education attainment as covariate) reported 
%% in the Kung et al., manuscript

% Please ensure that your SPM12 folder (r7771) is listed in your MATLAB set
% path. These results were obtained using Matlab R2021b. Values may
% slightly differ from the manuscript depending on your OS and version of
% Matlab.

%% -----------------------------------------------------------------------

% The first section runs a PEB model containing parameters to quantify
% the effects of MDD diagnosis, education attainment (years of education), 
% which are saved in M_H_MDD_Edyears.mat, 
% on each of the DCM intrinsic {'A'} and modulatory {'B'} pathways, to 
% generate the follow-up analysis results reported in the manuscript.

% Load GCM & M.mat files and mean-center covariates
clear
load('H_MDD_GCM.mat');
load('M_H_MDD_Edyears.mat'); % This design matrix contains data on participant 
                             % diagnostic group, education attainment

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

% Review edducation attainment effects
    % second-level effect - Ed_year 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise