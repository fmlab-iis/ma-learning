function [equal,str] = rf(cat_num,u,r)
    
    global transition;
    global final;
    
    transition = u;
    final = r;
    
    alphabet = size(u,3);

    min = 0;

    for q = 1:(100*cat_num)
        x1 = round((alphabet-1)*rand(1,cat_num))+1;
        hold = F(x1);
        if(hold < min);
            min = hold;
            x0 = x1;
        end    
    end

    A = [eye(cat_num );-eye(cat_num )];
    B = [alphabet*ones(cat_num,1);(-1)*ones(cat_num,1)];

    x = fmincon(@F,x0,A,B);

    for j = 1:size(x,2)
        x_f = x;
        x_c = x;
        x_f(1,j) = floor(x(1,j));
        x_c(1,j) = ceil(x(1,j));
        if(F(x_f) <= F(x_c))
            x = x_f;
        else
            x = x_c;
        end    
    end
    
    disp(x);
    
    
    fileID = fopen('MLoutput','w');
    
    st = strcat('h',num2str(x(1,1)));
    for i = 2:cat_num
        st = strcat(st,'h',num2str(x(1,i)));
    end
    
    fprintf(fileID,st);
    fprintf(fileID,'\n');
    fclose(fileID);

    mq();

    out = textread('bout-1','%s');
    oracle = sym(out);
    
    str = st;
    
    if (abs((oracle + F(x))/oracle) <= 0.001)
        equal = 1;        
    else
        equal = 0;
    end   
    
end

