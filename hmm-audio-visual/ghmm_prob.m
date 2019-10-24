function [Pxy, Pxxy] = ghmm_prob(alpha,beta,scale,A,mu,sigma,Y)
%
%  Usage: [Pxy, Pxxy] = gmihmm_prob(alpha,beta,scale,A,mu,sigma,Y)
%
% Input:
%   Y		observation vector sequence [ dim x time ]
%   A		state transition probabilities [ to x from ]
%   P0		initial state probabilities [ state x 1 ]
%   mu		observation mean [ dim x mixture x state ]
%   sigma		observation variance: diagonal [ dim x mixture x state ]
%		                      full [ dim x dim x mixture x state ]
% Output:
%  Pxy = P(x_t|Y)
%  Pxxy = P(x_t,x_{t+1}|Y)

scale = exp(scale);

N = size(A,1);
i = ones(1,N);
T = size(Y,1);
M = size(Y,2);

% Forward
for j=1:N
   sigmai(1:M,1:M) = reshape(sigma(j,:,:),[M,M]);
   for t=1:T
      Pys(j,t) = sqrt(1/(((2*pi)^M)*det(sigmai)))*exp(-0.5*(Y(t,:)-mu(j,:))*inv(sigmai)*(Y(t,:)-mu(j,:))');
   end
end

Pxy = zeros(T,N);
for t=1:T
   Pxy0 = alpha(:,t).*exp(beta(:,t))*scale(t);
   Pxy(t,:)=(Pxy0./sum(Pxy0))';
end

for t=1:T-1
   Pxxy0 = (alpha(:,t)*(exp(beta(:,t+1)).*Pys(:,t+1))').*A;
   Pxxy(t,:,:)=Pxxy0./sum(sum(Pxxy0));
end