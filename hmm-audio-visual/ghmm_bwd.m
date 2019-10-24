function beta = ghmm_bwd(Y,A,P0,mu,sigma,scale)
%
% gmihmm_bwd -- Gaussian mixture HMM backward state estimation 
%            (backward probability propagation)
%
% Usage: beta = gmihmm_bwd(Y,A,P0,mu,sigma,scale)
%
% Input:
%   Y		observation vector sequence [ dim x time ]
%   A		state transition probabilities [ to x from ]
%   P0		initial state probabilities [ state x 1 ]
%   mu		observation mean [ dim x mixture x state ]
%   sigma		observation variance: diagonal [ dim x mixture x state ]
%		                      full [ dim x dim x mixture x state ]
%   scale	see 'ghmm_fwd'
% Output:
%   beta	Pr( s_t, observation sequence from time 't+1')
%

scale = exp(scale);

N = size(A,1);
T = size(Y,1);
M = size(Y,2);

% Forward
for j=1:N
   sigmai(1:M,1:M) = reshape(sigma(j,:,:),[M,M]);
   for t=1:T
      Pys(j,t) = sqrt(1/(((2*pi)^M)*det(sigmai)))*exp(-0.5*(Y(t,:)-mu(j,:))*inv(sigmai)*(Y(t,:)-mu(j,:))');
   end
end


% Backward
beta(:,T) = ones(N,1)/scale(T);
for t=T-1:-1:1,
  beta(:,t) = A*(beta(:,t+1).*Pys(:,t+1))/scale(t);
end
beta = log(beta+1.0e-10);