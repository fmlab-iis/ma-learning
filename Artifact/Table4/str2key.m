function str2key( str )
    global total_count;
    global cache_count;
    global map;
    
    st = strsplit(str(2:end),'h');
    total_count = total_count + size(st,2);
        
    str = strcat(str,'h');
    counter = size(str,2);
    while (counter > 1)
        
        if (strcmp(str(counter),'h'))
            str2 = str(1:counter-1);
            if(isKey(map,str2) == 0)
                str3 = strsplit(str2(2:end),'h');
                cache_count = cache_count + size(str3,2);
                map(str2) = 100;
                break;
            end    
        end
        
        counter = counter -1;
    end
    
    


end

