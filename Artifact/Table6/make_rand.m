function length = make_rand( alpha, prob )

    length = 1;
    
    table = zeros(1,prob);
    table_ac = zeros(1,prob);
    
    for i = 1:prob
        table(1,i) = alpha^i;
        table_ac(1,i) = sum(table(1,1:i));
    end
    
    r = randi([1,table_ac(1,end)]);

    for i = 1:prob
        if(table_ac(1,i) >= r)
            length = i;
            break;
        end    
    end
    
    
    
    


end

