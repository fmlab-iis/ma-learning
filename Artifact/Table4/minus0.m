function str = minus0(x,y)
    w = cat(2,x,y);
    w = w(w ~= 0);

    str = '';

    if isempty(w)
        str = 'h0';
    else
        for i = 1:size(w,2)
            str = strcat(str,'h',num2str(w(i)));
        end
    end

end

