function alphabet = sym_number()

    global augment;
    global fun;
    global max_sym;
    global website;
    
    
    
    switch fun
        case 1
            [~,alphabet] = system(char(strcat('perl  lcnt.pl',{' '},website)));
            alphabet = str2num(alphabet);
        case 2
            max_sym = 12;
            alphabet = max_sym;
        case 3
            max_sym = 9;
            alphabet = max_sym;
        case 4
            max_sym = 10;
            alphabet = max_sym;
        case 5
            max_sym = 10;
            alphabet = max_sym;              
        otherwise
            [~,symbol] = textread('max.txt','%d %d',1);
    
            if(augment == 1)
                alphabet = floor(rand(1)*symbol)+1;
            else
                alphabet = symbol;
            end
    end
end

