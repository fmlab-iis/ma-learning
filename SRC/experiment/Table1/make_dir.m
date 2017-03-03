function make_dir(number)

cmd = strcat('mkdir test',num2str(number));
system(cmd);
cmd2 = strcat('test',num2str(number));
cd(cmd2);

fileID = fopen('123','w');
fprintf(fileID,num2str(number));
fprintf(fileID,'\n');
fclose(fileID);

cd('..');

end

