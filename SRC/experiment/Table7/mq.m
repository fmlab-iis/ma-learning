function mq()
    global fun;
    global website;

    switch fun
        case 1
            system(char(strcat('perl  mbsq.pl',{' '},website,'>>0')));
        case 2
            ID = fopen('bout-1','w');
            input = textread('MLoutput','%s');

            for j = 1:size(input,1)
                fprintf(ID,char(calculator(input{j,1})));
                fprintf(ID,'\n');
            end   
            fclose(ID);   
        case 3
            ID = fopen('bout-1','w');
            input = textread('MLoutput','%s');
            for j = 1:size(input,1)
                if strcmp(input{j,1},'h0')
                    fprintf(ID,'1');
                else    
                    str = strcat('perl ms.pl "',input{j,1},'"');
                    [~,query] = system(str);
                    fprintf(ID,num2str(2^str2num(query)));
                end    
                fprintf(ID,'\n');    
            end
            fclose(ID);
        case 4
            ID = fopen('bout-1','w');
            input = textread('MLoutput','%s');

            for j = 1:size(input,1)
                fprintf(ID,char(bdd(input{j,1})));
                fprintf(ID,'\n');
            end    
            fclose(ID);
        case 5
            ID = fopen('bout-1','w');
            input = textread('MLoutput','%s');

            for j = 1:size(input,1)
%                 fprintf(char(OS(input{j,1})));
%                 fprintf('\n');
                fprintf(ID,char(OS(input{j,1})));
                fprintf(ID,'\n');
            end
    
            fclose(ID);    
        otherwise       
            [test_size,symbol] = textread('max.txt','%d %d',1);
    
            [test,r] = read_test();  

            ID = fopen('bout-1','w');
            input = textread('MLoutput','%s');

            for j = 1:size(input,1)

                init = zeros(1,test_size);
                init(1,1) = 1;
                str = strsplit(input{j,1},'h');

                for i = 2:size(str,2)
                    if(str2num(str{1,i})~=0)
                        init = init * test(:,:,str2num(str{1,i}));
                    end
                end

                fprintf(ID,char(init*r));
                fprintf(ID,'\n');
            end
    
            fclose(ID);
    end


end

