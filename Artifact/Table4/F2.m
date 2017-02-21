function out = F2( input )

    global lagpoly2;
    global final_state;
    global int_SymbolNum;

    
    lagpoly = lagpoly2;
    r = final_state;

    ra = size(r,1);
    init = zeros(1,ra);
    init(1,1) = 1;

    for i = 1:size(input,2)
        if(input(1,i) >= int_SymbolNum)
            poly_new = lagpoly(:,:,int_SymbolNum);
        else if	(input(1,i) <= 1)
                 poly_new = lagpoly(:,:,1);
             else if(ceil(input(1,i)) == floor(input(1,i)))
                     poly_new = lagpoly(:,:,input(1,i));
                  else    
                     c = lagpoly(:,:,ceil(input(1,i)));
                     f = lagpoly(:,:,floor(input(1,i)));
                     poly_new = f + (c-f)*(input(1,i) - floor(input(1,i)));
                  end    

             end
        end
        init = init*poly_new;        
    end
    
    
    out = -1*double(init*r);

end

