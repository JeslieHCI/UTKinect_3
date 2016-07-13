clear
clc

% pairs = [ 8 10; 1 8; 1 3; 2 3; 2 9; 9 11];

% pairs = [14 16; 5 14; 5 7; 6 7; 6 15; 15 17];

pairs = [1 3; 2 3; 3 20; 3 4; 4 7; 5 7; 6 7];

len = length(pairs); 
%body_pairs = zeros(len*(len - 1), 4);
body_pair = [];
for n = 1:len
    for m = 1:len
        if n~=m
            body_pair = [body_pair; pairs(n,:), pairs(m,:)];
        end
    end
end