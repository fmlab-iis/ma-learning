function os_equal( prob,line )
    global max_sym;
    
    symbol2 = max_sym;
    
    ID = fopen('maxlkno','w');
        fprintf(ID,int2str(symbol2));
    fclose(ID);
    
    ID1 = fopen('file-2','w');
        
    for i = 1:line
        
        hold = floor(rand(1)*symbol2)+1;        
        str = cat(2,'h',int2str(hold));
        
        while(prob < 100*rand(1))
            hold = floor(rand(1)*symbol2)+1; 
            str = cat(2,str,'h',int2str(hold));
        end
        
        fprintf(ID1,str);
        fprintf(ID1,'\n');             
               
    end
    fclose(ID1);
    
    ID2 = fopen('bout-2','w');
    
    out = textread('file-2','%s');
    
    
    for i = 1:line        
        fprintf(ID2,char(OS(out{i})));
        fprintf(ID2,'\n');
    end
    
    fclose(ID2);

end

