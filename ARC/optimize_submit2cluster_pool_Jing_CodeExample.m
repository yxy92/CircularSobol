function j = optimize_submit2cluster_pool(c, new_or_continue, fname_bounds_cost, WorkDir, NumSets, max_num_jobs, NumSetsPerJob)

if ~exist('max_num_jobs','var') || isempty(max_num_jobs) || max_num_jobs > 250
    max_num_jobs = 250; % Tinkercliffs allows a total maximum of 250
end

switch new_or_continue
    
    case 'new'
        
        % Get ModelName from fname_bounds_cost
        temp = regexp(fname_bounds_cost, '.*(?=_bounds_cost)', 'match');
        ModelName = temp{1};

        WorkDir = getUnusedFileName([ModelName '_Results']);
        mkdir(WorkDir);
        
        % Generate initial guesses
        fh_bounds_cost = str2func(fname_bounds_cost);
        bounds = fh_bounds_cost('bounds');
        lb = bounds(1,:);
        ub = bounds(2,:);

        rng('shuffle');
        X = lhsdesign(NumSets, length(lb));
        
        initial_guesses = zeros(size(X));
        for i = 1:NumSets
            initial_guesses(i,:) = (ub-lb).*X(i,:) + lb;
        end
        setIDs = 1:NumSets;
        
        % Save initial guesses
        save([WorkDir filesep ModelName '_initial_guesses.mat'], 'initial_guesses');
        
        % Save *_bounds_cost function
        copyfile([fname_bounds_cost '.m'], WorkDir);
        
    case 'continue'
        
        % Get ModelName from WorkDir        
        temp = regexp(WorkDir, '.*(?=_Results)', 'match');
        ModelName = temp{1};       
        
        load([WorkDir filesep ModelName '_initial_guesses.mat'], 'initial_guesses');
        
        % get IDs of finished jobs
        files = dir([WorkDir filesep ModelName '_fit_*.mat']);
        for i = 1:length(files)
            str = regexp(files(i).name, '(?<=fit_)\w*(?=.mat)','match');
            setIDs_done(i) = str2double(str{1});
        end
        % get IDs of jobs to be run
        setIDs = setdiff(1:size(initial_guesses,1), setIDs_done);
        
        % continue with cost function in existing folder
        files_temp = dir([WorkDir filesep '*_bounds_cost_*.m']);
        fname_bounds_cost = files_temp(1).name(1:end-2);
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