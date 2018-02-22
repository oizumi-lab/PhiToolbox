function [min_Energy, State_min_Energy, Energy_history, State_history, Exchange_history, T_history, wasConverged, NumCalls] = ... 
    REMCMC_partition( calc_E, N, options )
% Replica Exchange MCMC for K-state system with the constraint that each
% state has at least one element, i.e., K-partition is assumed.
%
% min_Energy: the minimum of Energy at each temperature
% State_min_Energy: subset with highest phi at each temperature
% Energy_history: history of energy 
% State_history: history of State
% Exchange_history: history of exchange
% T_history: history of T
% wasConverged: {1, 0}
%      1:Converged, 0:Not converged
% NumCalls: Number of function calls

addpath(genpath('minFunc_2012'))

if nargin < 3
    options = [];
end

[partition_order, nT, ar_minT, ar_maxT, ...
    nMCS, nMCS_btw_Exchanges, nExchanges_btw_OptimTemp, nMCS_OptimTempEnd, ...
    threshold_GRB, nExchanges_threshold_consecutive, display, showFig] = ...
    REMCMC_processInputOptions(options);

nSteps = N * nMCS;
nSteps_btw_Exchanges = N * nMCS_btw_Exchanges;
nSteps_btw_OptimTemp = N * nMCS_btw_Exchanges * nExchanges_btw_OptimTemp;
nSteps_OptimTempEnd = N * nMCS_OptimTempEnd;
nExchanges = round(nMCS/nMCS_btw_Exchanges);

if showFig, f_progress = figure; end

%% Set initial states and values.
State = set_initial_state(N, partition_order, nT);
State_min_Energy = State;

Energy_prev = zeros(nT,1);
for i_T = 1:nT
    Energy_prev(i_T) = calc_E(State(:,i_T));
end
min_Energy = Energy_prev;

NumCalls = nT;

%% set initial temperature
subE_init = zeros(nT,1);
for i_T = 1:nT
    NumCalls_init = 0;
    while subE_init(i_T) == 0 && NumCalls_init < 10
        State_temp = make_candidate(State(:,i_T), N, partition_order);
        
        if ~check_Forbidden(State_temp, partition_order)
            Energy_init_temp = calc_E(State_temp);
            NumCalls = NumCalls + 1;
            NumCalls_init = NumCalls_init + 1;
            
            if Energy_init_temp < min_Energy
                min_Energy(i_T) = Energy_init_temp;
                State_min_Energy(:,i_T) = State_temp;
            end
            subE_init(i_T) = Energy_init_temp - Energy_prev(i_T);
        end
    end
end

if all(subE_init==0)
    subE_init = 1e-5;
else
    subE_init = abs(subE_init);
    subE_init(subE_init==0) = mean(subE_init(subE_init~=0));
end

T_min = set_temperature(1, subE_init, ar_minT, 1e-3); % Set the lowest Temperature
T_max = set_temperature(1, subE_init, ar_maxT, 1e-3); % Set the highest Temperature

Tratio = (T_max/T_min)^(1/(nT-1));
T = T_min*Tratio.^(0:(nT-1))';


%% Allocation
subE_history_minT = zeros(nSteps, nT);
subE_history_maxT = zeros(nSteps, nT);

Energy_history = zeros(nSteps, nT);
State_history = zeros(nSteps, N, nT);
Energy_history_btw_OptimTemp = zeros(nSteps_btw_OptimTemp, nT);
subE_history_btw_Exchanges = zeros(nSteps_btw_Exchanges, nT);
Energy_history_btw_Exchanges = zeros(nSteps_btw_Exchanges, nT);
min_Energy_timecourse = [NumCalls, min(min_Energy)];
R_c = [];

Exchange_history = zeros(nExchanges+1, nT);
Exchange_history(1,:) = 1:nT;
countExchange = 1;

T_history = zeros(nExchanges+1, nT);
T_history(1,:) = T;

Rec_meanE_bet_T_optim = zeros(nExchanges+1, nT);
Rec_varE_bet_T_optim = zeros(nExchanges+1, nT);

wasConverged = 0;
count_below_threshold = 0;

i_TemperatureOptim = 1;
for iExchanges = 1:nExchanges
    parfor i_T = 1:nT
        State_eachT = State(:, i_T);
        for i_bet_exchange = 1:nSteps_btw_Exchanges
            
            % Make a candidate
            State_temp = make_candidate(State_eachT, N, partition_order);
            
            % Determine whether or not moving.
            if check_Forbidden(State_temp, partition_order)
                subE = Inf;
            else
                Energy_temp = calc_E(State_temp);%%%
                NumCalls = NumCalls + 1;
                subE = Energy_temp - Energy_prev(i_T);
            end
            accept = Metropolis_step( 1./T(i_T), subE );
            
            % If accept==1, update State.
            if accept == 1
                State_eachT = State_temp;
                Energy_prev(i_T) = Energy_temp;
            end
            
            % Compare current Energy with the temporary minimum of Energy
            if subE<0 && Energy_temp<min_Energy(i_T)
                min_Energy(i_T) = Energy_temp;
                State_min_Energy(:,i_T) = State_temp;
            end
            
            subE_history_btw_Exchanges(i_bet_exchange,i_T) = subE; % Record subE for Tmin/Tmax optimization
            Energy_history_btw_Exchanges(i_bet_exchange, i_T) = Energy_prev(i_T); % Record Energy
            State_history_bet_exchange(i_bet_exchange, :, i_T) = State_eachT;
            Energy_history_btw_OptimTemp(i_bet_exchange, i_T) = Energy_prev(i_T);
        end
        State(:,i_T) = State_eachT;
    end
    
    i_steps = nSteps_btw_Exchanges*iExchanges;
    
    
    %% plot and display min_Energy
    if showFig
        subplot(2,2,1)
        min_Energy_timecourse = [min_Energy_timecourse; NumCalls, min(min_Energy)];
        plot(min_Energy_timecourse(:,1), min_Energy_timecourse(:,2));
        title(['Current minimum: ', num2str(min(min_Energy))])
        drawnow
    end
    
    if display
        disp([num2str(iExchanges*nMCS_btw_Exchanges), 'MCSs/', num2str(nMCS), 'MCSs'])
        disp(['Current minimum: ', num2str(min(min_Energy)) ])
    end
    
    steps_temp = (i_steps-nSteps_btw_Exchanges+1):i_steps;% N_steps_bet_exchange*(i_exchanges-1)+(1:N_steps_bet_exchange);
    subE_history_minT(steps_temp,1) = subE_history_btw_Exchanges(:,1);
    subE_history_maxT(steps_temp,1) = subE_history_btw_Exchanges(:,nT);
    for i_T = 1:nT
        Energy_history(steps_temp,i_T) = Energy_history_btw_Exchanges(:,i_T);
        State_history(steps_temp, :, i_T) = State_history_bet_exchange(:, :, i_T);
    end
    
    %% exchange
    if mod(iExchanges, 2) == 1
        i_Ts = 1:2:(size(T,1)-1);
    else
        i_Ts = 2:2:(size(T,1)-1);
    end
    Exchange_history(countExchange+1,:) = Exchange_history(countExchange,:);
    for i_T = i_Ts
        subE = Energy_prev(i_T+1) - Energy_prev(i_T);
        accept = Metropolis_step( -(1./T(i_T+1)-1./T(i_T)), subE );
        if accept == 1
            Exchange_history(countExchange+1, Exchange_history(countExchange,:)==i_T) = ...
                Exchange_history(countExchange,Exchange_history(countExchange,:)==(i_T+1));
            Exchange_history(countExchange+1,Exchange_history(countExchange,:)==(i_T+1)) = ...
                Exchange_history(countExchange,Exchange_history(countExchange,:)==i_T);
            
            State_temp = State(:,i_T);
            State(:,i_T) = State(:,i_T+1);
            State(:,i_T+1) = State_temp;
            
            Energy_prev_temp = Energy_prev(i_T);
            Energy_prev(i_T) = Energy_prev(i_T+1);
            Energy_prev(i_T+1) = Energy_prev_temp;
        end
    end
    countExchange = countExchange + 1;
    
    % plot the history of exchanges
    if showFig
        subplot(2,2,2)
        plot(Exchange_history(1:countExchange,:))
        title('Exchange')
        ylim([0.5 nT+0.5])
        drawnow
    end
    
    %% Optim temperature spacing
    if mod(i_steps, nSteps_btw_OptimTemp) == 0 && i_steps < nSteps_OptimTempEnd
        
        
        T_min = set_temperature(T(1), subE_history_minT(1:i_steps), ar_minT, 1e-3); % Set the lowest T
        T_max = set_temperature(T(end), subE_history_maxT(1:i_steps), ar_maxT, 1e-3); % Set the highest T
        
        if isinf(abs(T_min))||isnan(T_min)
            disp('T_min_new is Inf/NaN!!!!')
            T_min = T(1);
        end
        if isinf(abs(T_max))||isnan(T_max)
            disp('T_max_new is Inf/NaN!!!!')
            T_max = T(end);
        end
        if T_min >= T_max
            T_min = T(1);
            T_max = T(end);
        end

        Rec_meanE_bet_T_optim(i_TemperatureOptim,:) = mean(Energy_history_btw_OptimTemp);
        Rec_varE_bet_T_optim(i_TemperatureOptim,:) = var(Energy_history_btw_OptimTemp);
        
        vec_Rec_meanE_bet_T_optim = reshape(Rec_meanE_bet_T_optim(1:i_TemperatureOptim,:), i_TemperatureOptim*nT, 1);
        vec_Rec_varE_bet_T_optim = reshape(Rec_varE_bet_T_optim(1:i_TemperatureOptim,:), i_TemperatureOptim*nT, 1);
        
        vec_Rec_T = reshape(T_history(1:i_TemperatureOptim,:), i_TemperatureOptim*nT, 1);
        
        meanE_anchor = lsq_lut_piecewise( vec_Rec_T, vec_Rec_meanE_bet_T_optim, T );
        varE_anchor = lsq_lut_piecewise( vec_Rec_T, vec_Rec_varE_bet_T_optim, T );
        
        meanE_anchor = sort(meanE_anchor);
        varE_anchor(varE_anchor<0) = min(vec_Rec_varE_bet_T_optim);
        
%        % plot T vs. meanE
%         subplot(n_subplot,1,3)
%         scatter( vec_Rec_T, vec_Rec_meanE_bet_T_optim )
%         hold on
%         plot( T, meanE_anchor, 'r' )
%         drawnow
%         hold off
        
        [~, T, ~, ~] = ...
            optim_temperature_spacing_2( meanE_anchor, varE_anchor, T, T_min, T_max, nT );
        if any(isinf(abs(T))) || any(isnan(T))
            disp('Optimized T includes Inf/NaN!!!')
        end
        i_TemperatureOptim = i_TemperatureOptim + 1;
        T_history(i_TemperatureOptim,:) = T;
        
        % plot the chage in temperatures
        if showFig
            subplot(2,2,4)
            plot(T_history(1:i_TemperatureOptim,:))
            title('Temperature')
            drawnow
        end
        
    end
    

    %% Gelman-Rubin-Brooks diagnosis
    R_c_temp = zeros(1,nT);
    if i_steps>nSteps_OptimTempEnd+100*N
        length_ind = floor((i_steps-nSteps_OptimTempEnd)/2);
        ind_former = (i_steps-2*length_ind+1):N:(i_steps-length_ind);
        ind_latter = (i_steps-length_ind+1):N:i_steps;
        for i_T = 1:nT
            former = Energy_history(ind_former, i_T);
            latter = Energy_history(ind_latter, i_T);
            [ R_c_temp(1, i_T), ~ ] = BrooksGelman( [former, latter], 0.05 );
        end
        R_c = [R_c; R_c_temp];
        
        % plot and display
        if showFig
            subplot(2,2,3)
            plot(R_c)
            title('Gelman-Rubin-Brooks plot')
            ylabel('R_c')
            drawnow
        end
        if display, disp(['Rc: ', num2str(R_c_temp)]), end
        
        if all(R_c_temp(1:end)<threshold_GRB)
            count_below_threshold = count_below_threshold + 1;
        else
            count_below_threshold = 0;
        end
        if count_below_threshold >= nExchanges_threshold_consecutive
            wasConverged = 1;
            break
        end
    end
    
end

Exchange_history = Exchange_history(1:countExchange,:);

end


function State = set_initial_state(N, K, num_T)

State = zeros(N, num_T);
for i_T = 1:num_T
    while size(unique(State(:, i_T)))<K
        State(:,i_T) = randi(K, N, 1);
    end
end

end

function State_temp = make_candidate(State, N, K)

State_temp = State;
i_site = randi(N);
state_i_site = State_temp(i_site);
while state_i_site == State_temp(i_site)
    state_i_site = randi(K);
end
State_temp(i_site) = state_i_site;

end

function isForbidden = check_Forbidden(State, K)

if size(unique(State), 1) < K
    isForbidden = true;
else
    isForbidden = false;
end

end