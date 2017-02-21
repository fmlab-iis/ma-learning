function result_out(epsilon,delta,prob,alphabet,rank,u,r,mb_count,eq_count)
global total_count;
global cache_count;
global result_count;
global od;

    cmd = strcat('mkdir result_',num2str(result_count),'_',num2str(od));
    system(cmd);
    cmd2 = strcat('result_',num2str(result_count),'_',num2str(od));
    cd(cmd2);
        
    fileID = fopen('result.txt','w');
    for s = 1:alphabet
        for i = 1:size(r,1)
            for j = 1:size(r,1)
                fprintf(fileID,'%.1f ',double(u(i,j,s)));
            end
            fprintf(fileID,'\n');
        end
        fprintf(fileID,'\n');
    end
    
    for i = 1:size(r,1)
        fprintf(fileID,'%.1f\n',double(r(i,1)));
    end
    
    fclose(fileID);        
        
    rq = fopen('result data.txt','w');
    fprintf(rq,'# iterations is : ');
    fprintf(rq,'%d\n',rank); 
    fprintf(rq,'# alphabets is : ');
    fprintf(rq,'%d\n',alphabet);     
    fprintf(rq,'Probability is : ');
    fprintf(rq,'%d\n',prob);
    fprintf(rq,'Cache count is : ');
    fprintf(rq,'%d\n',cache_count);
    fprintf(rq,'Total count is : ');
    fprintf(rq,'%d\n',total_count);
    fprintf(rq,'Cache rate is : %.2f\n',cache_count/total_count);    
    fprintf(rq,'Total number of membership query is : ');
    fprintf(rq,'%d\n',mb_count);
    fprintf(rq,'Total number of equivalence query is : ');
    fprintf(rq,'%d\n',eq_count);
    fclose(rq);
    
    save('result');  
    
    cd('..');
            
end

