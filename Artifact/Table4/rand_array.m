function [ out ] = rand_array( rand_num, alpha )
    
    
    out = [];
    while (rand_num > 0)
        out = [out,mod(rand_num,alpha)+1];
        rand_num = floor(rand_num./alpha);
    end


end

