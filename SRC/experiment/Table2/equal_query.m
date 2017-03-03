function [isEqual,str] = equal_query(u,r,test_num)
    
    isEqual = 1;
    rank = size(r,1);
    init = zeros(1,rank);
    init(1,1) = 1;
    str = '';

    
%     fprintf('Number of Query : ');
%     fprintf('%d\n\n',test_num);


    out = textread('bout-2','%s');
    counter = textread('file-2','%s');
    
    for i = 1:test_num
        if(sym(out{i}) ~= str2mq(counter{i},u,r))
        %if( (sym(out(i)) - str2mq(counter{i},u,r)) > 10 )
        
%             disp(counter{i});
%             disp(sym(out{i}));
%             disp(str2mq(counter{i},u,r)); 
            
            isEqual = 0;
            str = counter{i,1};
            break;
        end    
    end
    
    
    
end





