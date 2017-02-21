function out = str2mq(str,u,r)

    str = strsplit(str(2:end),'h');  
    
    init = sym(zeros(1,size(u,2)));
    init(1,1) = 1;
    
    
    for i = 1:size(str,2)
        if(str2num(str{i}) > size(u,3))
            init = init*zeros(size(u(:,:,1)));
        else    
            init = init*u(:,:,str2num(str{i}));
        end    
    end
    
    out = init*r;

end

