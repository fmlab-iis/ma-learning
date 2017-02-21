function permuted = perm(n, k)

        m=k;
        permuted = zeros(1,n);
        elems = zeros(1,n);
        elems(:)=0:n-1;
               
        for i = 1:n
            ind = mod(m,n+1-i)+1;
            m = floor(m/(n+1-i));
            permuted(i)=elems(ind);
            elems(ind)=elems(n-i+1);
        end
               
end

