function ms_equal( prob,line )
    global max_sym;
    global sample_type;
    
    symbol2 = max_sym;
    
    ID = fopen('maxlkno','w');
        fprintf(ID,int2str(symbol2));
    fclose(ID);
    
    ID1 = fopen('file-2','w');
        
    for i = 1:line
        
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
        str = strcat('perl ms.pl "',out{i},'"');
        [~,query] = system(str);
        fprintf(ID2,num2str(2^str2num(query)));        
        fprintf(ID2,'\n');
    end
    
    fclose(ID2);

end

