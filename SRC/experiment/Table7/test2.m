function [value,num] = test2(length)

    alphabet = 16;
    num = alphabet^length;
    value = 0;

    fprintf('Length = %d\n',length);;
    
    
    max_ms = 0;

    
     for i = 0:num-1
         
          clc;
          fprintf('Complete : %f\n',((i+1)/(num))*100);
          fprintf('The time of iteration is %d/%d\n',i,num-1);          
          fprintf('Average Oracle of length %d is %f\n',length, double(value/(i+1)));
          fprintf('Average Max of length %d is %f\n',length, double(max_ms));
	  
          input = rand_str( i, alphabet,length );
          fileID = fopen('MLoutput','w');
          fprintf(fileID,input);
          fprintf(fileID,'\n');
          fclose(fileID);
          
          system('perl  mbsq.pl  http://www.iis.sinica.edu.tw/pages/scm/');
           
          query = sym((textread('bout-1','%s')));
          
          disp(query)
          
          if(query > max_ms)
              
              max_ms = query;
              disp(input)
          end
          value = value + query;

     end

end


function str = rand_str( rand_num, alpha ,length )
        
    out1 = [];
    if(rand_num == 0)
        out1 = 0;
    else    
        while (rand_num > 0)
            out1 = [out1,mod(rand_num,alpha)];
            rand_num = floor(rand_num./alpha);
        end
    end
    
    
    out = zeros(1,length);
    out(1,1:size(out1,2)) = out1;
    out = out + ones(size(out));
    
    str = '';
    for i = 1:length
        str = strcat(str,'h',num2str(out(1,i)));
    end    
end


