function out = OS( str )
    SJF = 0;



if (strcmp(str,'h0') == 1)
    out = sym(1);
else if(SJF <= 1)    
    str = strsplit(str(2:end),'h');
    work = zeros(size(str));
    for i = 1:size(str,2)
       work(i) = str2double(str{i}); 
    end
    
    work_counter = 1;
    line = [0];
    line_data = [0];
    process = 0;
    total_wait = 0;
    num_work = size(work(work(:) ~= 0),2);
    s_work = size(work,2);
    
    while ((process > 0) || (work_counter <= s_work) || (size(line,2) > 1))
        total_wait = total_wait + line_data;
        if(work_counter <= s_work)
            line = [line,work(work_counter)];
            if(SJF == 1)
                line = sort(line);
            end    
            if(work(work_counter) ~= 0)
                line_data = line_data + 1;
            end    
        end
        work_counter = work_counter +1;
        
        if((process <= 0) && (size(line,2) >= 2))                
            process = line(2);
            if(process ~= 0)
                line_data = line_data -1;
            end    
            line(2) = [];               
        end
        process = process -1;  
        
    end
    out = sym(total_wait/num_work);
    
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
    
    while ((work_counter <= s_work) || (s_line > 0))
        
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
        if(size(line,2) > 1)
            line = [line(2:end),line(1)];
        end
        
        
        line = line(line(:) ~= 0);
        s_line = size(line,2);
    end
    

    
    out = sym(total_wait/num_work);    
    
    end
end


end