function [result,y] = check_counter(symbolY, matrix,u, w,a)
    global counter_count;

    y = 0;
%(a)Fw = linear combination Fxi

    Fw = sym(zeros(1,size(symbolY,2)));

    hc = 0;
    fileID = fopen('MLoutput','w');
    for i = 1:size(symbolY,2)
        str = minus0(w,symbolY{i});
        fprintf(fileID,str);
        fprintf(fileID,'\n');
        hc = hc+1;
    end

%(b)
    Fwa = sym(zeros(1,size(symbolY,2)));

    for i = 1:size(symbolY,2)
        str = minus0(cat(2,w,a),symbolY{i});
        fprintf(fileID,str);
        fprintf(fileID,'\n');
        counter_count = counter_count + 1;
    end

    fclose(fileID);

    mq();

    out = textread('bout-1','%s');

    for i = 1:size(symbolY,2)
        Fw(1,i) = sym(out{i});
    end

    for i = 1:size(symbolY,2)
        Fwa(1,i) = sym(out{hc + i});
    end
    
    if (Fw ~= str2query(w, u)*matrix)
        result = 0;
        return;
    end

    F_temp = str2query(cat(2,w,a), u)*matrix;

    for i = 1:size(Fwa,2)
        if(Fwa(1,i) ~= F_temp(1,i))
            
%             fprintf('=====vvvvv=====\n');
%             disp(Fwa(1,i));
%             disp(F_temp(1,i));
%             fprintf('=====^^^^^=====\n');
            
            y =  symbolY{i};
            result = 1;
            return;
        end
    end

    result = -1;

end


