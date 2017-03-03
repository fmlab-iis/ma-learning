clc;
clear;

[rank,alphabet] = textread('result_max.txt','%d %d',1);
prob = textread('probability.txt','%d',1);
[u,r]= read_result();

max_out = 0;
ave_out = 0;
counter = 0;

length = 3;

for i = 1:length^alphabet
   
end    