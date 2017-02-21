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

for i = 1:1
    result_count = i;
    fprintf('Test number = %d\n',i);
    %================Order Calculator==========================
    fprintf('\nOrdered Result\n');
    od = 1;
    [timeout_or(i), time_each_or(i), state_or(i), counter_mem_or(i), mem_or(i),eq_mem_or(i)] = order_comp( 1, 0, 20 );

%     not_timeout = i - sum(timeout_or);
%     fprintf('Average Time = %.2f\n',sum(~timeout_or.*time_each_or)/not_timeout);
%     fprintf('Average # States = %.0f\n',sum(~timeout_or.*state_or)/not_timeout);

    cmd2 = strcat('result_',num2str(result_count),'_',num2str(od));
    cd(cmd2);
    load('result');
    cd('..');    
    
    u_temp = zeros(size(u,1));
    for j = 1:10
        u_temp = u_temp + u(:,:,j);
    end
    
    u_temp = u_temp/10;
    init = zeros(1,size(r,1));
    init(1,1) = 1;
    
    for k = 5:5:30
        fprintf('The result of length = %d, is : %.2f\n',k,init*(u_temp^k)*r);
        %fprintf('The oracle of length = %d, is : %.2f\n',k,4.5*10^k);
        fprintf('The error rate is : %.2f%%\n',(abs(init*(u_temp^k)*r - 4.5*10^(k-1))/(4.5*10^(k-1)))*100);
    fprintf('====================================================\n');
    end    

    
        
end
