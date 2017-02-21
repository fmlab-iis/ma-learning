function make_ref(test_size, symbol)

    test = sym(round(10^3*rand(test_size,test_size,symbol)));
    r = sym(round(10^3*rand(test_size,1)));


    fileID = fopen('test.txt','w');
        for s = 1:symbol
            for i = 1:test_size
                for j = 1:test_size
                    fprintf(fileID,char(test(i,j,s)));
                    fprintf(fileID,' ');
                end
                fprintf(fileID,'\n');
            end
            fprintf(fileID,'\n');
        end
    
        for i = 1:test_size
            fprintf(fileID,char(r(i,1)));
            fprintf(fileID,'\n');
        end
    
    fclose(fileID);

    ID = fopen('max.txt','w');
    fprintf(ID,'%d %d\n',test_size, symbol);
    fclose(ID);

end

