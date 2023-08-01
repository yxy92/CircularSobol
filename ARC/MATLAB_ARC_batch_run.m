% MATLAB_ARC_batch_run.m

% addpath

addpath /home/jacky92/CircularSobol

% configure cluster
configCluster;
c = parcluster;
c.AdditionalProperties.AccountName = 'polya';
c.AdditionalProperties.WallTime='48:00:00';


% configure I/O directory
currentFolder = pwd;

% batch description
num_job = 1;


% job description
ModelName = "SarahSobol_ARC";
fh = str2func(ModelName);



% set up job submission
for i=1:num_job
    % for unix environment
    fname = currentFolder + "/" + ModelName + "_batch_" + num2str(i) + ".mat";
    j(i) = batch(c,fh,2,{fname},'Pool',20); 
end

