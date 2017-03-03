clc;
clear;

times = 20;

%================Unorder Calculator Result======================
%================Monkey Distribution========================
timeout_un_mo = zeros(1,times);

average_un_mo_3 = zeros(1,times);
max_value_un_mo_3 = zeros(1,times);
average_un_mo_5 = zeros(1,times);
max_value_un_mo_5 = zeros(1,times);
average_un_mo_7 = zeros(1,times);
max_value_un_mo_7 = zeros(1,times);

%================Uniform Distribution========================

timeout_un_uni = zeros(1,times);

average_un_uni_3 = zeros(1,times);
max_value_un_uni_3 = zeros(1,times);
average_un_uni_5 = zeros(1,times);
max_value_un_uni_5 = zeros(1,times);
average_un_uni_7 = zeros(1,times);
max_value_un_uni_7 = zeros(1,times);

%================Exact Distribution======================== 

timeout_un_ex = zeros(1,times);

average_un_ex_3 = zeros(1,times);
max_value_un_ex_3 = zeros(1,times);
average_un_ex_5 = zeros(1,times);
max_value_un_ex_5 = zeros(1,times);
average_un_ex_7 = zeros(1,times);
max_value_un_ex_7 = zeros(1,times);


%================Main Function==================================

global result_count;
global od;
global dis;

for i = 1:20
    result_count = i;
    fprintf('Test number = %d\n',i);
    %================Monkey Distribution======================== 
    od = 0;
    dis = 0;
    fprintf('\nMonkey Distribution\n');
    [timeout_un_mo(i), ~, ~,~, ~,~] = order_comp( 0, 0, 20 );
    not_timeout = i - sum(timeout_un_mo);
    
    if(timeout_un_mo(i) == 0)
        
        [average_un_mo_3(i),max_value_un_mo_3(i)] = test(3,0);
        fprintf('Average of 3 = %.2f\n',sum(~timeout_un_mo.*average_un_mo_3)/not_timeout);
        fprintf('Max of 3 = %.2f\n',sum(~timeout_un_mo.*max_value_un_mo_3)/not_timeout);
        
        [average_un_mo_5(i),max_value_un_mo_5(i)] = test(5,0);
        fprintf('Average of 5 = %.2f\n',sum(~timeout_un_mo.*average_un_mo_5)/not_timeout);
        fprintf('Max of 5 = %.2f\n',sum(~timeout_un_mo.*max_value_un_mo_5)/not_timeout);
        
        [average_un_mo_7(i),max_value_un_mo_7(i)] = test(7,0);
        fprintf('Average of 7 = %.2f\n',sum(~timeout_un_mo.*average_un_mo_7)/not_timeout);
        fprintf('Max of 7 = %.2f\n\n',sum(~timeout_un_mo.*max_value_un_mo_7)/not_timeout);
    else
        fprintf('Time Out!!!\n\n');        
    end
    %================Uniform Distribution======================== 
    dis = 1;
    fprintf('\nUniform Distribution\n');
    [timeout_un_uni(i), ~, ~,~, ~,~] = order_comp( 0, 1, 5 );
    not_timeout = i - sum(timeout_un_uni);
    
    if(timeout_un_uni(i) == 0)
        
        [average_un_uni_3(i),max_value_un_uni_3(i)] = test(3,0);
        fprintf('Average of 3 = %.2f\n',sum(~timeout_un_uni.*average_un_uni_3)/not_timeout);
        fprintf('Max of 3 = %.2f\n',sum(~timeout_un_uni.*max_value_un_uni_3)/not_timeout);
        
        [average_un_uni_5(i),max_value_un_uni_5(i)] = test(5,0);
        fprintf('Average of 5 = %.2f\n',sum(~timeout_un_uni.*average_un_uni_5)/not_timeout);
        fprintf('Max of 5 = %.2f\n',sum(~timeout_un_uni.*max_value_un_uni_5)/not_timeout);
        
        [average_un_uni_7(i),max_value_un_uni_7(i)] = test(7,0);
        fprintf('Average of 7 = %.2f\n',sum(~timeout_un_uni.*average_un_uni_7)/not_timeout);
        fprintf('Max of 7 = %.2f\n\n',sum(~timeout_un_uni.*max_value_un_uni_7)/not_timeout);
    else
        fprintf('Time Out!!!\n\n');                
    end
    %================Exact Distribution======================== 
    dis = 2;
    fprintf('\nExact Distribution\n');
    [timeout_un_ex(i), ~, ~,~, ~,~] = order_comp( 0, 2, 5 );
    not_timeout = i - sum(timeout_un_ex);
    
    if(timeout_un_ex(i) == 0)
        
        [average_un_ex_3(i),max_value_un_ex_3(i)] = test(3,0);
        fprintf('Average of 3 = %.2f\n',sum(~timeout_un_ex.*average_un_ex_3)/not_timeout);
        fprintf('Max of 3 = %.2f\n',sum(~timeout_un_ex.*max_value_un_ex_3)/not_timeout);
        
        [average_un_ex_5(i),max_value_un_ex_5(i)] = test(5,0);
        fprintf('Average of 5 = %.2f\n',sum(~timeout_un_ex.*average_un_ex_5)/not_timeout);
        fprintf('Max of 5 = %.2f\n',sum(~timeout_un_ex.*max_value_un_ex_5)/not_timeout);
        
        [average_un_ex_7(i),max_value_un_ex_7(i)] = test(7,0);
        fprintf('Average of 7 = %.2f\n',sum(~timeout_un_ex.*average_un_ex_7)/not_timeout);
        fprintf('Max of 7 = %.2f\n\n',sum(~timeout_un_ex.*max_value_un_ex_7)/not_timeout);
    else
        fprintf('Time Out!!!\n\n');        
    end
    
    fprintf('====================================================\n');
        
end
