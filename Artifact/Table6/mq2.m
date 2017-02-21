function init = mq2(input)

	[test_size,symbol] = textread('max.txt','%d %d',1);
    
	test = zeros(test_size,test_size,symbol);
	r = zeros(test_size,1);
	temp = textread('test.txt');
    
	for s = 1:symbol
    	test(:,:,s) = temp(((s-1)*test_size + 1):(s*test_size),1:test_size);
    end 
        
	r = temp((symbol*test_size+1):(symbol+1)*test_size)';    
    
    init = str2mq(input,test,r);

end

