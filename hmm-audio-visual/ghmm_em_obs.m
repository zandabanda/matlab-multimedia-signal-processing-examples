function [mu, sigma] = ghmm_em_obs(Yseq,N,A,P0,mu,sigma)
%
%
% USAGE [mu, sigma] = gmihmm_em_obs(y,n,alpha,A,P0,mu,sigma)
% This function learns the parameters of the gaussian
%

N_seq = length(Yseq);
eps  = 1e-5;
M = size(Yseq{1},2);
museq_unnorm = zeros(N,M);
museq_norm = zeros(N,M);
sigmaseq_unnorm = zeros(N,M,M);
sigmaseq_norm = zeros(N);


%%%% compute the probabilities
for seq = 1:N_seq
   Y=Yseq{seq};
   M = size(Y,2);
   T =size(Y,1);
   %%%% compute the probabilities
   [alpha,scale] = ghmm_fwd(Y,A,P0,mu,sigma);
   beta = ghmm_bwd(Y,A,P0,mu,sigma,scale);
   [Pxy, Pxxy] = ghmm_prob(alpha,beta,scale,A,mu,sigma,Y);
   Pxyseq{seq}=Pxy;
   Pxxyseq{seq}=Pxxy;
   llseq{seq} = exp(sum(scale));
   
   
   for i=1:N
      Pxy0 = Pxy(:,i);
      Pxy0 = sum(Pxy0(:,ones(M,1)).*Y)+eps;
      museq_unnorm(i,:)=museq_unnorm(i,:)+Pxy0;
      museq_norm(i,:)=museq_norm(i,:)+(sum(Pxy(:,i))+eps);
   end
end
mu = museq_unnorm./museq_norm;
sigmaseq_unnorm = zeros(N,M,M);
sigmaseq_norm = zeros(N);

for seq = 1:N_seq
   Y=Yseq{seq};
   M = size(Y,2);
   T =size(Y,1);
   %%%% compute the probabilities
   [alpha,scale] = ghmm_fwd(Y,A,P0,mu,sigma);
   beta = ghmm_bwd(Y,A,P0,mu,sigma,scale);
   [Pxy, Pxxy] = ghmm_prob(alpha,beta,scale,A,mu,sigma,Y);
   Pxyseq{seq}=Pxy;
   Pxxyseq{seq}=Pxxy;
   llseq{seq} = exp(sum(scale));
   
   
   for i=1:N
      Pxy0 = Pxy(:,i); 
      sigmatmp =zeros(M,M);
      for t=1:T
         sigmatmp = sigmatmp + (Y(t,:)-mu(i,:))'*(Y(t,:)-mu(i,:)).*Pxy0(t);
         sigmaseq_norm(i)=sigmaseq_norm(i) + Pxy0(t);
      end
      sigmaseq_unnorm(i,1:M,1:M) = sigmaseq_unnorm(i,1:M,1:M)+reshape(sigmatmp,[1,M,M]);
   end
end
for i=1:N
   sigma(i,1:M,1:M) = sigmaseq_unnorm(i,1:M,1:M)./sigmaseq_norm(i);
end
