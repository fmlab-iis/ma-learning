function get_ref(prob,line)

    global augment;

    % 0 -> monkey, 1 -> normal, 2 -> fix;    
    global sample_type;

    [test_size,symbol] = textread('max.txt','%d %d',1);
    
    if(augment == 1)
        symbol2 = floor(rand(1)*symbol)+1;
        if (symbol2 == 1)
            symbol2 = symbol2 + 1;
        end    
    else
        symbol2 = symbol;
    end    
        
    ID = fopen('maxlkno','w');
        fprintf(ID,int2str(symbol2));
    fclose(ID);
    
    ID1 = fopen('file-2','w');
    
    [test,r] = read_test();
        
    for i = 1:line
        
        init = sym(zeros(1,test_size));
        init(1,1) = 1;
        
        hold = floor(rand(1)*symbol2)+1;        
        str = cat(2,'h',int2str(hold));
        
        switch sample_type
            case 0
                while(prob < 100*rand(1))
                    hold = floor(rand(1)*symbol2)+1; 
                    str = cat(2,str,'h',int2str(hold));
                end
                
            case 1
                
                rand_r = rand_array( randi([1,symbol2^prob]), symbol2 );
                
                for k = 1:size(rand_r,2)
                    str = cat(2,str,'h',int2str(rand_r(1,k)));
                end                                
                
            case 2
                for k = 1:prob
                    hold = floor(rand(1)*symbol2)+1; 
                    str = cat(2,str,'h',int2str(hold));
                end
        end
        fprintf(ID1,str);
        fprintf(ID1,'\n');    
               
    end
    fclose(ID1);
    
    
    ID2 = fopen('bout-2','w');
    
    out = textread('file-2','%s');
    
    for i = 1:line
        fprintf(ID2,char(str2mq(out{i},test,r)));
        fprintf(ID2,'\n');
    end
    
    fclose(ID2);
    
end

