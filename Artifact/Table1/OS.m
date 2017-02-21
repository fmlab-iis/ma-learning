function out = OS( str )
    SJF = 0;
    RR = 1;



if (strcmp(str,'h0') == 1)
    out = sym(1);
else    
    str = strsplit(str(2:end),'h');
    work = zeros(size(str));
    for i = 1:size(str,2)
       work(i) = str2double(str{i}); 
    end
%==========================================================================



    work_counter = 1;
    line = [0];
    line = line(line~=0);
    s_work = size(work,2);

    total_wait = 0;
    num_work = size(work(work(:) ~= 0),2);
    
    s_line = 0;
    
    while ((work_counter <= s_work) || (s_line == 0))
        
        if(s_line > 1)
            total_wait = total_wait + (s_line-1);
        end
        
        if(work_counter <= s_work)
            if (work(work_counter) ~= 0)
                line = [line,work(work_counter)];
            end                        
        end
        
        work_counter = work_counter +1;
        
        if(line(1,1) > 0)
            line(1,1) = line(1,1)-1;
        end
        disp(line);
        if(size(line,2) > 1)
            line = [line(2:end),line(1)];
        end
        
        
        line = line(line(:) ~= 0);
        s_line = size(line,2);
    end
    

    
    out = sym(total_wait/num_work);
    

end
%==========================================================================    

end