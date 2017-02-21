function [u,r]= read_result()
    
        [test_size,symbol] = textread('result_max.txt','%d %d',1);
        temp2 = fileread('result.txt');
        temp3 = strsplit(temp2,'\n');
        
        u = sym(zeros(test_size,test_size,symbol));
        
        for k = 1:symbol
            for i = 1:test_size
                temp4 = strsplit(temp3{test_size*(k-1)+i},' ');
                for j = 1:test_size
                    u(i,j,k) = sym(temp4{j}); 
                end
            end    
        end
        
        r = sym(zeros(test_size,1));
        for i = 1:test_size
            r(i,1) = temp3(i+test_size*symbol);
        end
 
end

