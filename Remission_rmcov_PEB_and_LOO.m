%% This script will reproduce the DCM results comparing remitters and 
%% non-remitters using the model without demographic and treatment arm 
%% covariates reported in the Online Supplement of the Kung et al., 
%% manuscript

% Please ensure that your SPM12 folder (r7771) is listed in your MATLAB set
% path. These results were obtained using Matlab R2021b. Values may
% slightly differ from the manuscript depending on your OS and version of
% Matlab.

%% -----------------------------------------------------------------------

% The script runs a PEB model containing parameters to quantify
% the effects of MDD remission, which are saved in M_Remission_rmcov.mat, 
% on each of the DCM intrinsic {'A'} % and modulatory {'B'} pathways, 
% to generate the results detailed in Table S16 in the online supplement.

% Load GCM & M.mat files and mean-center covariates
clear
load('MDD_GCM.mat');
load('M_Remission_rmcov.mat'); % This design matrix contains data on 
                               % participant treatment response (remission)

X = dm.X;
K = width(X);
X(:,2:K)=X(:,2:K)-mean(X(:,2:K));
X_labels = dm.labels;

M = struct();
M.Q = 'fields';
M.X = X;
M.Xnames = X_labels;

[PEB, RCM] = spm_dcm_peb(DCM, M, {'A', 'B'});
BMA_Remission_rmcov = spm_dcm_peb_bmc(PEB);

spm_dcm_peb_review (BMA_Remission_rmcov, DCM);

% Review shared effects
    % second-level effect - Mean 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise

% Review between-group effects (Table S16)
    % second-level effect - Remission_12 
    % threshold - strong evidence (Pp>.95)
    % display as matrix(B), input Reappraise
