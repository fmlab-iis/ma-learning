function [average,max_value] = test(cat_num,order)

    global int_SymbolNum % Sample points of each variable
    global int_Rank % iteration number
    global reorder;
    global result_count;
    global od;
	global dis;

    reorder = ~order;

    cmd2 = strcat('result_',num2str(result_count),'_',num2str(dis));
    cd(cmd2);
    load('result');
    cd('..');

    int_SymbolNum = alphabet;      %alphabet
    int_Rank = size(r,1);           %rank

    init = zeros(1,int_Rank);
    init(1,1) = 1;

    lag_matrix = zeros(size(u(:,:,1)));

    for mi = 1:size(u,3)
        lag_matrix = lag_matrix + u(:,:,mi);
    end


    for j = 1:cat_num
        init = init*lag_matrix;
        result = init*r;
    end

    result = result/((int_SymbolNum)^cat_num);
    average = double(result);

% % %==========================================

    global lagpoly2;
    global final_state;

    lagpoly2 = u;
    final_state = r;

    for i = cat_num:cat_num
        min = 0;

        for q = 1:(100*i)
            x1 = round((alphabet-1)*rand(1,cat_num))+1;
            hold = F2(x1);
            if(hold < min);
                min = hold;
                x0 = x1;
            end    
        end

        A = [eye(cat_num );-eye(cat_num )];
        B = [alphabet*ones(cat_num,1);(-1)*ones(cat_num,1)];

        x = fmincon(@F2,x0,A,B);

        for j = 1:size(x,2)
            
            if(x(1,j) >= int_SymbolNum)
                x(1,j) = int_SymbolNum;
            else if(x(1,j) <= 1)
                    x(1,j) = 1;
                else        
                    x_f = x;
                    x_c = x;
                    x_f(1,j) = floor(x(1,j));
                    x_c(1,j) = ceil(x(1,j));
            
                    if(F2(x_f) <= F2(x_c))
                        x = x_f;
                    else
                        x = x_c;
                    end
                end
            end    
        end
        

            
        s = '';
        for k = 1:size(x,2)
            s = strcat(s,'h',num2str(x(k)));
        end
        
        fprintf('-F2(x0) = %.2f, -F2(x) = %.2f\n',-F2(x0),-F2(x))
        max_value = -F2(x);
            
    end


end

