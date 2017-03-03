function query = str2query(w, u)

    query = sym(eye(1,size(u,2)));
    for  i = 1:size(w,2)
        if(w(i) > size(u,3))
            query = zeros(size(u(:,:,1)));
        else    
            query = query*u(:,:,w(i));
        end    
    end
    
end


