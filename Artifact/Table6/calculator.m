function out = calculator( str )

% str2key( str )

global reorder;

if (strcmp(str,'h0') == 1)
    out = num2str(1);
else    
    str = strsplit(str(2:end),'h');
    
    for i = 1:size(str,2)
        if (~strcmp(str{i},'*'))
            if op(str{i})
                str = delete_repeat(str,i);
            end
        end    
    end
    
    
    
    str_out = '';    

if (reorder == 1)    
    for i = 1:size(str,2)        
        switch str{i}
            case '#'
            case '1'
                str_out = strcat(str_out,'4');
            case '2'
                str_out = strcat(str_out,'7');
            case '3'
                str_out = strcat(str_out,'0');                 
            case '4'
                str_out = strcat(str_out,'2');
            case '5'
                str_out = strcat(str_out,'6');
            case '6'
                str_out = strcat(str_out,'9');                
            case '7'
                str_out = strcat(str_out,'3');
            case '8'
                str_out = strcat(str_out,'-');
            case '9'
                str_out = strcat(str_out,'5');                
            case '10'
                str_out = strcat(str_out,'+');
            case '11'
                str_out = strcat(str_out,'8');
            case '12'
                str_out = strcat(str_out,'1');                
            otherwise
                str_out = strcat(str_out,str{i});
        end        
    end
else    

    for i = 1:size(str,2)        
        switch str{i}
            case '#'
            case '11'
                str_out = strcat(str_out,'+');
            case '12'
                str_out = strcat(str_out,'-');               
            otherwise
                str_out = strcat(str_out,num2str(str2num(str{i})-1));
        end        
    end    
    
end
    while 1
        if (size(str_out,2) == 0)
            break;
        end    
        if (str_out(1) =='+' || str_out(1) =='-')
            str_out(1) = [];
        else    
            break;
       end    
    end
    
    while 1
        if (size(str_out,2) == 0)
            break;
        end   
        if (str_out(end) =='+' || str_out(end) =='-')
            str_out(end) = [];
        else    
            break;
        end    
    end 
    if(size(str_out,2) == 0)
        out = sym(1);
    else    
        out = sym(str2num(str_out));
    end
end    
end

function str = delete_repeat(str,i)
    if ((i <= (size(str,2)-1)) && (op(str{i})&&op(str{i+1})))
        str{i} = '#';
        str = delete_repeat(str,i+1);
    end   
end

function out = op(a)
out = (str2double(a) >= 10 && str2double(a) <= 13);
end
