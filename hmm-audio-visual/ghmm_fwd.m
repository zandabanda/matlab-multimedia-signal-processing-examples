function [alpha,scale] = ghmm_fwd(Y,A,P0,mu,sigma)
%
%  Usage: [alpha,scale] = ghmm_fwd(y,Pss,Ps0,Q,C,R,wS,wY)
%
% Input:
%   y		observation vector sequence [ dim x time ]
%   A		state transition probabilities [ to x from ]
%   P0		initial state probabilities [ state x 1 ]
%   mu		observation mean [ dim x mixture x state ]
%   sigma		observation variance: diagonal [ dim x mixture x state ]
%		                      full [ dim x dim x mixture x state ]
% Output:
%   alpha		E[ s_t | Y_t ] = Pr( s_t | observation sequence up to time 't')
%   scale	log Pr( s_0, ..., s_t | observation sequence up to time 't')

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

alpha0 = P0.*Pys(:,1);
scale(1) = sum(alpha0);
alpha(:,1) = alpha0 / scale(1);

for t=2:T,
  alpha0 = ( ( A' ) * alpha(:,t-1)).*Pys(:,t);
  scale(t) = sum(alpha0);
  alpha(:,t) = alpha0 / scale(t);
end

scale = log(scale);
