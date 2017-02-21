function out = bdd( str )

global perm_len;


alphabet = 10;
len = perm_len;

if (strcmp(str,'h0') == 1)
    out = sym(1);
else    
    str = strsplit(str(2:end),'h');
    
    job = 0;
    for i = 1:size(str,2)
       job = job*alphabet + str2double(str{i}); 
    end
    
    if (job >= factorial(len)-1)
        out = 0;
    else
        order = perm(len,job);
        order = order + ones(size(order));
        str_order = '';
        for i = 1:size(order,2)
            blank = ' .';
            str_order = strcat(str_order,blank,num2str(order(1,i)));
        end
        str_order = str_order(str_order(:) ~= '.');
        bg = './a.out';
        ed = ' | sed ''s/^.*: //g''| sed ''s/nodes.*$//g''';
        out_str = strcat(bg,str_order,ed);
        [~,out] = system(out_str);    
    end    
            
end    

end

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

function k = inv_perm(perm_in)

        k=0;
        m=1;
        n = size(perm_in,2);
        pos = zeros(1,n);
        elems = zeros(1,n);
               
        elems(:)=0:n-1;    
        pos(:)=0:n-1;
    
        for i=1:n
                k = k + m*pos(perm_in(i) + 1);
                m = m*(n-i+1);
                pos(elems(n-i+1) + 1)=pos(perm_in(i) + 1);
                elems(pos(perm_in(i)+1)+1)=elems(n-i+1);
        end
        
end
