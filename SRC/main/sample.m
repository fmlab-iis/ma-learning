function sample(prob,test_num)
    global fun;
    
    % 0 -> monkey, 1 -> normal, 2 -> fix;

    switch fun
        case 1
            system(char(strcat('perl  eqvq.pl  http://www.richpuppy.net/AutomtTest/index.html',{' '},num2str(prob),{' '},num2str(test_num))));
        case 2
            cal_equal(prob,test_num);
        case 3
            ms_equal(prob,test_num); 
        case 4
            bdd_equal(prob,test_num);     
        case 5
            os_equal(prob,test_num);
        otherwise
            get_ref(prob,test_num);
    end
    
    
end

