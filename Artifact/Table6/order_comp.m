function [timeout, time_each, state, counter_mem, mem,eq_mem] = order_comp( order, distri, probability )

timeout = 0;
time_each = 0;
state = 1;
counter_mem = 0;
mem = 0;
eq_mem = 0;

%===================================
%          Time Out time          
%===================================
time_out_range = 900;
time_out_rank = 50;

%===================================

global reorder;
reorder = ~order;

global augment;
global fun;
global debug;
global mb_count;
global eq_count;
global total_count;
global cache_count;
global map;

global time_mb;
global time_eq;
global time_matrix;
global time_counter;
global time_total;

global read_flag;
global sample_type;

global counter_count;
counter_count = 0;

t_total = tic;

read_flag = 0;
augment = 1;
debug = 0;

refine = 0;

d = 0;
%==================Some Variables==========

fun = 3;
%0 -> local; 1 -> web; 2 -> calculator; 3 -> missionary; 4 -> bdd; 5 -> OS

sample_type = distri;
%0 -> monkey; 1 -> normal; else -> fix;

prob = probability;

power = 0.1;
highest = 1;

rate = 0.1;

epsilon = rate;
delta = rate;
mb_count = 0;
eq_count = 0;

total_count = 0;
cache_count = 0;

time_mb = 0;
time_eq = 0;
time_matrix = 0;
time_counter = 0;

key =   {'Jan'};
value = [327.2];
map = containers.Map(key,value);
%==================Some Table===================

global mb_table;
global eq_table;
global matrix_table;
global counter_table;
global total_table;

global mb_table_ac;
global eq_table_ac;
global matrix_table_ac;
global counter_table_ac;
global total_table_ac;

global mb_count_table;
global eq_count_table;
global mb_count_table_ac;
global eq_count_table_ac;

global perm_len;
perm_len = 10;

mb_table = [0];
eq_table = [0];
matrix_table = [0];
counter_table = [0];
total_table = [0];

mb_table_ac = [0];
eq_table_ac = [0];
matrix_table_ac = [0];
counter_table_ac = [0];
total_table_ac = [0];

mb_count_table = [0];
eq_count_table = [0];

mb_count_table_ac = [0];
eq_count_table_ac = [0];

%==================STEP1===================
% Initialization

alphabet = sym_number();

ID = fopen('maxlkno','w');
    fprintf(ID,'%d',alphabet);
fclose(ID);

symbolX = {[]};
symbolY = {[]};
rank = 1;

%fill the symbol table

temp_time_mb = tic; 

fileID = fopen('MLoutput','w');
for i = 0:alphabet
    fprintf(fileID,strcat('h',num2str(i)));
    fprintf(fileID,'\n');
    mb_count = mb_count + 1;
end
fclose(fileID);

mq();

out = textread('bout-1','%s');

hankel = sym(zeros(alphabet+1,1));
for i = 1:alphabet+1
    hankel(i,1) = sym(out{i});
end

temp_time_mb_elapsed = toc(temp_time_mb);
time_mb = time_mb + temp_time_mb_elapsed;

%==================STEP2===================
% main algorithm


while 1   
%Define hypothesis h
%(1)find lamda and r
    
    
    time_total = toc(t_total);
    
    if(state >= time_out_rank)
        timeout = 1;
        break;
    end    

    temp_time_total = tic;

    fprintf('Iteration number : ');
    fprintf('%d\n',rank);    
    test_num = ceil((1/epsilon)*(log(1/delta)+ rank*log(2)));    
    num_run = 1;
    
%     fprintf('Cache count is : ');
%     fprintf('%d\n',cache_count);
%     fprintf('Total count is : ');
%     fprintf('%d\n',total_count);
%     fprintf('Cache rate is : %.2f\n\n',cache_count/total_count); 
%==================Sampling=============================
    
    while(num_run <= test_num)
        
        temp_time_eq = tic;
        
        sample(prob,1);
            
        
        temp_time_eq_elapsed = toc(temp_time_eq);
        time_eq = time_eq + temp_time_eq_elapsed;
        
        eq_count = eq_count + 1;

%==================Augmenting Process=================== 

        temp_alphabet = textread('maxlkno','%d');

%change alphabet size if augment
%==================Augmenting Process===================
        ag = 0;
        if(temp_alphabet > alphabet)
            
            temp_time_mb = tic; 
            
            ag = 1;
            fileID = fopen('MLoutput','w');                
            for i = 1:rank
                for j = 1:size(symbolY,2)
                    for k = (alphabet+1):temp_alphabet
                        str = minus0(cat(2,symbolX{i},[k]),symbolY{j});
                        fprintf(fileID,str);
                        fprintf(fileID,'\n');
                    
                        mb_count = mb_count + 1;
                    end
                end 
            end
            fclose(fileID);
        
            mq();
        
            hankel_temp = sym(zeros(rank * (1+temp_alphabet),rank));
               
            for i = 1:rank
                hankel_temp(((i-1)*(temp_alphabet+1)+1):((i-1)*(temp_alphabet+1)+1+alphabet),:) = hankel(((i-1)*(alphabet+1)+1):((i-1)*(alphabet+1)+1+alphabet),:);
            end

            out = textread('bout-1','%s');
        
            for i = 1:rank
                for j = 1:size(symbolY,2)
                    for k = (alphabet+1):temp_alphabet
                        hankel_temp((i-1)*(temp_alphabet+1)+k+1,j) = out{(i-1)*size(symbolY,2)*(temp_alphabet-alphabet) + (j-1)*(temp_alphabet-alphabet) + k-alphabet,1};
                    end
                end 
            end
        
            hankel = hankel_temp;
            alphabet = temp_alphabet;
            
            temp_time_mb_elapsed = toc(temp_time_mb);
            time_mb = time_mb + temp_time_mb_elapsed;
        
        end

%======================construct u==================================    
        if(ag == 1 || num_run == 1)
            
            temp_time_matrix = tic; 
            
            matrix = sym(zeros(rank,rank));
            for i = 0:(rank-1)
                matrix(i+1,:) = hankel(i*(alphabet+1)+1,:);
            end
            r = matrix(:,1);
    
            u = sym(zeros(rank,rank,alphabet));
    
            matrix2 = inv(matrix);
    
            for a = 1:alphabet

                temp2 = sym(zeros(rank,rank));
        
                for j = 1:rank
                    temp2(j,:) =  hankel((j-1)*(alphabet+1)+(a+1),:);
                end
                
                u(:,:,a) = temp2*matrix2;
            end
            
            temp_time_matrix_elapsed = toc(temp_time_matrix);
            time_matrix = time_matrix + temp_time_matrix_elapsed;
            
        end
               
%======================check equivalence=====================    

        temp_time_eq = tic;

        [isEqual,str] = equal_query(u,r,1);
        temp_time_eq_elapsed = toc(temp_time_eq);
        time_eq = time_eq + temp_time_eq_elapsed;     
                
        if(isEqual ~= 1)
            break;
        end    
        num_run = num_run + 1;
        
        if(num_run > test_num)
            
            if((refine == 1) && (isEqual == 1))
                [isEqual,str] = rf(3,u,r);
            end
                
            if(isEqual == 1);  
                result_out(epsilon,delta,prob,alphabet,rank,u,r,mb_count,eq_count);
                if (epsilon > 0.1)
                    epsilon = epsilon - power;
                else
                    epsilon = epsilon - 0.1*power;
                end
                
                delta = epsilon;                
                test_num = ceil((1/epsilon)*(log(1/delta)+ rank*log(2)));
                
                if(epsilon <= rate - 0.01)
                    state = size(u,1);
                    time_each = toc(t_total);
                    
                    mem = mb_count;
                    counter_mem = counter_count;
                    eq_mem = eq_count;
                    
                    break;
                end  
            end    
        end
    end

    
%     fprintf('MQ time is : ');
%     fprintf('%f\n',time_mb);
%     fprintf('EQ time is : ');
%     fprintf('%f\n',time_eq);
%     fprintf('Matrix time is : ');
%     fprintf('%f\n',time_matrix);    
%     fprintf('Counter time is : ');
%     fprintf('%f\n\n',time_counter);    
    
    
    if(isEqual == 1);        
        break;
    end

%============%Find counter example Aw o sigma o y============   
    
    
    temp_time_counter = tic;
    s1 = strsplit(str(2:end),'h');
    s = zeros(1,size(s1,2));
    for i = 1:size(s1,2)
        s(i) = str2num(s1{i});
    end
    
    for i = 1:(size(s,2)-1)
        w = s(1,1:i);
        a = s(1,i+1);

        [result,y] = check_counter( symbolY, matrix,u, w,a);
        if(result == 1)
            x_new = w;
            y_new = cat(2,a,y);
            break;
        end
            
    end
    
    temp_time_counter_elapsed = toc(temp_time_counter);
    time_counter = time_counter + temp_time_counter_elapsed;  
 
%============================================================
%xl+1 = w, yl+1 = sigma o w, X = X and {xl+1}, Y = Y and {yl+1}, l = l+1 
    
    rank = rank + 1;
    symbolY{1,size(symbolY,2)+1} = y_new(y_new~=0);
    symbolX{1,size(symbolX,2)+1} = x_new(x_new~=0);
    
    
    temp_time_mb = tic;

    hc = 0;
    fileID = fopen('MLoutput','w');
    for i = 1:(size(hankel,1)/(1+alphabet))
        for j = 0:alphabet
            str = minus0(cat(2,symbolX{1,i},[j]),symbolY{1,rank});
            fprintf(fileID,str);
            fprintf(fileID,'\n');
            mb_count = mb_count + 1;
            hc = hc+1;
        end
    end


    for i = 0:alphabet
        for j = 1:size(symbolY,2)
            str = minus0(cat(2,symbolX{1,rank},[i]),symbolY{1,j});
            fprintf(fileID,str);
            fprintf(fileID,'\n');
            
            mb_count = mb_count + 1;
            
        end
    end    
    fclose(fileID);

    mq();

    out = textread('bout-1','%s');
    for i = 1:(size(hankel,1)/(1+alphabet))
        for j = 0:alphabet
            hankel((alphabet+1)*(i-1)+j+1,rank) = sym(out{(j+1)+(i-1)*(alphabet+1)});
        end
    end

    for i = 0:alphabet
        for j = 1:size(symbolY,2)
            hankel((alphabet+1)*(rank-1)+i+1,j) = sym(out{hc + j+(i)*(size(symbolY,2))});
        end
    end
    
    temp_time_mb_elapsed = toc(temp_time_mb);
    time_mb = time_mb + temp_time_mb_elapsed;    

temp_time_total_elapsed = toc(temp_time_total);
time_total = time_total + temp_time_total_elapsed;
end

end

