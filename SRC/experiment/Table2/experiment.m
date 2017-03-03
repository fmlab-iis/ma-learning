clc;
clear;

times = 20;

%================Order Calculator Result=======================

timeout_or = zeros(1,times);
time_each_or = zeros(1,times);
state_or = zeros(1,times);
counter_mem_or = zeros(1,times);
mem_or = zeros(1,times);
eq_mem_or = zeros(1,times);

average_or = zeros(1,times);
max_value_or = zeros(1,times);

%================Unorder Calculator Result======================

timeout_un = zeros(1,times);
time_each_un = zeros(1,times);
state_un = zeros(1,times);
counter_mem_un = zeros(1,times);
mem_un = zeros(1,times);
eq_mem_un = zeros(1,times);

average_un = zeros(1,times);
max_value_un = zeros(1,times);

%================Main Function==================================

global result_count;
global od;

for i = 1:20
    result_count = i;
    fprintf('Test number = %d\n',i);
    %================Order Calculator==========================
    fprintf('\nOrdered Result\n');
    od = 1;
    [timeout_or(i), time_each_or(i), state_or(i), counter_mem_or(i), mem_or(i),eq_mem_or(i)] = order_comp( 1, 0, 10 );

    not_timeout = i - sum(timeout_or);
    fprintf('# Timeout = %.0f\n',sum(timeout_or));
    fprintf('Average Time = %.2f\n',sum(~timeout_or.*time_each_or)/not_timeout);
    fprintf('Average # States = %.0f\n',sum(~timeout_or.*state_or)/not_timeout);
    fprintf('Average # counter_mem_or = %.0f\n',sum(~timeout_or.*counter_mem_or)/not_timeout);
    fprintf('Average # mem_or = %.0f\n',sum(~timeout_or.*mem_or)/not_timeout);
    fprintf('Average # eq_mem_or = %.0f\n',sum(~timeout_or.*eq_mem_or)/not_timeout);
    
    if(timeout_or(i) == 0)
        [average_or(i),max_value_or(i)] = test(5,1);
        fprintf('Average of Five = %.2f\n',sum(~timeout_or.*average_or)/not_timeout);
        fprintf('Max of Five = %.2f\n\n',sum(~timeout_or.*max_value_or)/not_timeout);
    end    
    %================Unorder Calculator======================== 
    od = 0;
    fprintf('\nUnrdered Result\n');
    [timeout_un(i), time_each_un(i), state_un(i), counter_mem_un(i), mem_un(i),eq_mem_un(i)] = order_comp( 0, 0, 10 );
    not_timeout = i - sum(timeout_un);
    fprintf('# Timeout = %.0f\n',sum(timeout_un));
    fprintf('Average Time = %.2f\n',sum(~timeout_un.*time_each_un)/not_timeout);
    fprintf('Average # States = %.0f\n',sum(~timeout_un.*state_un)/not_timeout);
    fprintf('Average # counter_mem_un = %.0f\n',sum(~timeout_un.*counter_mem_un)/not_timeout);
    fprintf('Average # mem_un = %.0f\n',sum(~timeout_un.*mem_un)/not_timeout);
    fprintf('Average # equal_mem_un = %.0f\n',sum(~timeout_un.*eq_mem_un)/not_timeout);
    
    if(timeout_un(i) == 0)
        [average_un(i),max_value_un(i)] = test(5,0);
        fprintf('Average of Five = %.2f\n',sum(~timeout_un.*average_un)/not_timeout);
        fprintf('Max of Five = %.2f\n\n',sum(~timeout_un.*max_value_un)/not_timeout);
    end    
    fprintf('====================================================\n');
        
end
