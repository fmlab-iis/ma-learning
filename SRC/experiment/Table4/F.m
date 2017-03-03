function out = F( input )

    global transition;
    global final;
    
    out = -1*mult(input,transition,final);

end

function out = mult(input,lagpoly,r)

    ra = size(r,1);
    init = zeros(1,ra);
    init(1,1) = 1;

    for i = 1:size(input,2)
        
        if(input(1,i) >= size(lagpoly,3))
            input(1,i) = size(lagpoly,3);
        else
            if(input(1,i) <= 1)
                input(1,i) = 1;
            end
        end
        
        if(ceil(input(1,i)) == floor(input(1,i)))
            poly_new = lagpoly(:,:,(input(1,i)));
        else    
            c = lagpoly(:,:,(ceil(input(1,i))));
            f = lagpoly(:,:,(floor(input(1,i))));
            poly_new = f + (c-f)*(input(1,i) - floor(input(1,i)));
        end    
        init = init*poly_new;
    end
    out = double(init*r);

end

