%% Alexander Hamidi, adhamid2
%  ECE 417 Spring 2016
%  Mark Hasegawa Johnson
%  Mary Pietrowicz

% plot final performance metric
figure;
plot([1,2,3],[8,18,19], '-*',[1,2,3],[16,18,18],'-*',[1,2,3],[14,19,20],'-*',[1,2,3],[10,17,18],'-*',[1,2,3],[8,9,9],'-*');
legend('Tiger','Horse','Sunset','Boat','Building')
ylabel('Precision');
xlabel('Query Round')
title('Retrieval Performance');