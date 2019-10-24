function [P0,A,mu,sigma] = ghmm_learn(Yseq,N,Ainit)
%
% USAGE : [P0,A,mu,sigma] = ghmm_learn(data,N,Ainit);
% P0 initial state probability matrix
% A - Tranistion Probability matrix
% mu - mean matrix
% sigma - covariance matrix
% 
% N = number of states
% Ainit  - This is the initial A matrix that you can input to force the model
%          to leanr a left to right model
% data = this is a cell. Each entry of the cell is the data matrix. The format of each
%        entry is T*M. That is T is the length of the sequence and M is the dimension
%        of the observation vector.
%
% Read the code to see if something is not clear.
% By Ashutosh Garg


M=size(Yseq{1},2);
P0=ones(N,1)/N;


if (nargin<3)
   A=rand(N)+2*eye(N);
   for l=1:N
      A(l,:) = A(l,:)/sum(A(l,:));
   end
end
if (nargin==3)
   A = Ainit;
end


Nseq = length(Yseq);


datatmp = Yseq{1};
for seq=2:Nseq
   datatmp = [datatmp; Yseq{seq}];
end

M=size(datatmp,2);
T=size(datatmp,1);
T1 = floor(T/N);
for i=1:N
   mu(i,1:M) = mean(datatmp(1+(i-1)*T1:i*T1,:));
   sigma(i,1:M,1:M) = cov(datatmp);
end

for itr = 1:25
   [mu, sigma] = ghmm_em_obs(Yseq,N,A,P0,mu,sigma);
   [A] = ghmm_em_trans(Yseq,N,A,P0,mu,sigma);
end
