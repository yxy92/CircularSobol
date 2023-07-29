% Parallel Sobol indices calculation on ARC adapted from Jing's code
function j = SarahSobol_submit2cluster_pool(c, fname_bounds_cost, WorkDir, NumSets, max_num_jobs, NumSetsPerJob)

if ~exist('max_num_jobs','var') || isempty(max_num_jobs) || max_num_jobs > 250
    max_num_jobs = 250; % Tinkercliffs allows a total maximum of 250
end


% Calculate number of jobs
NumSets = numel(setIDs);
runs_per_job = ceil(NumSets/max_num_jobs);
num_jobs = ceil(NumSets/runs_per_job);

% % Debugging code
% for i = 1:num_jobs-1
%     j{i} = setIDs((i-1)*runs_per_job+1:i*runs_per_job);
% end
% j{num_jobs} = setIDs(i*runs_per_job+1:NumSets);

% Submit jobs to cluster
for i = 1:num_jobs-1
    j(i) = batch(c, @optimize_batch, 0, {fname_bounds_cost, initial_guesses, setIDs((i-1)*runs_per_job+1:i*runs_per_job), WorkDir, ModelName}, 'pool', NumSetsPerJob);
end
j(num_jobs) = batch(c, @optimize_batch, 0, {fname_bounds_cost, initial_guesses, setIDs(i*runs_per_job+1:NumSets), WorkDir, ModelName}, 'pool', NumSetsPerJob);


function optimize_batch(fname_bounds_cost, initial_guesses, setIDs, WorkDir, ModelName)

parfor i = 1:length(setIDs)
    try
        out = optimize_single(fname_bounds_cost, initial_guesses(setIDs(i),:), 0);
    catch ME
        disp(ME);
        out = [];
    end    

    if ~isempty(out)
        m = matfile([WorkDir filesep ModelName '_fit_' num2str(setIDs(i)) '.mat'],'Writable',true)
        m.out = out;
    end
end