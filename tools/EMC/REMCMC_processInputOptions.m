function [partition_order, nT, ar_minT, ar_maxT, ...
    nMCS, nMCS_btw_Exchanges, nExchanges_btw_OptimTemp, nMCS_OptimTempEnd, ...
    threshold_GRB, nExchanges_threshold_consecutive, display, showFig] = ...
    REMCMC_processInputOptions(o)

o = toUpper(o);

%type_of_state = getOpt(o, 'type_of_state', 'binary');

%Order of Partition
partition_order = getOpt(o, 'PARTITION_ORDER', 2);

% Temperature Settings
nT = getOpt(o, 'NT', 10); % number of temperatures
ar_minT = getOpt(o, 'AR_MINT', 0.01); % target acceptance ratio at minT
ar_maxT = getOpt(o, 'AR_MAXT', 0.5); % target acceptance ratio at maxT

% Monte Carlo Steps
nMCS = getOpt(o, 'NMCS', 5000); % total number of Monte Carlo Steps
nMCS_btw_Exchanges = getOpt(o, 'NMCS_BTW_EXCHANGES', 5); %  number of Monte Carlo steps between exchanges
nExchanges_btw_OptimTemp = getOpt(o, 'NEXCHANGES_BTW_OPTIMTEMP', 4); % number of exhanges between temperature optimization
nMCS_OptimTempEnd = getOpt(o, 'NMCS_OPTIMTEMPEND', 500); % number of MCSs at which 

% Gelman-Rubin-Brooks diagnosis
threshold_GRB = getOpt(o, 'THRESHOLD_GRB', 1.01); % threshold of GRB diagnosis
nExchanges_threshold_consecutive = getOpt(o, 'NEXCHANGES_THRESHOLD_CONSECUTIVE', 100);
% Sampling will be stopped if GRB measure is below threshold for 
% "nExchanges_threshold_consecutive" times consecutively.

% 
display = getOpt(o, 'DISPLAY', 1); % whether display progress on the command window. 
showFig = getOpt(o, 'SHOWFIG', 1); % whether plot figures

end

function [v] = getOpt(options,opt,default)
if isfield(options,opt)
    if ~isempty(getfield(options,opt))
        v = getfield(options,opt);
    else
        v = default;
    end
else
    v = default;
end
end

function [o] = toUpper(o)
if ~isempty(o)
    fn = fieldnames(o);
    for i = 1:length(fn)
        o = setfield(o,upper(fn{i}),getfield(o,fn{i}));
    end
end
end