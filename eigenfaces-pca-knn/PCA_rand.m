function [ Ra_proj ] = PCA_rand( M,E,X )

% M is the total # of images
% Call for each image set

% average over all images (each column)
T = mean(X,2);

% subtract the mean from each column
Xc = bsxfun(@minus,X,T); 

% compute the scattter matrices
S = Xc'*Xc;

% compute eigenvalues/eigenvectors of scatter matrices
[V,D] = eig(S); % eigenvectors stored in columns of V

% sort eigenvalues in descending order, keeping track of original index
% into the corresponding eigenvector,
[eg_srtd, ind] = sort(diag(D),'descend'); 

% find N principal components
eg_tot = sum(eg_srtd);
count = 0;
N = 0;
for eg=1:M % eg is index into the sorted eigenvalues, whereas ind is the index into the corresponding eigenvectors
    count = count + eg_srtd(eg);
    if (count/eg_tot >= E)
        N = eg;
        break
    end
end

sz_X = size(X);

% Project onto random subspace
Ra_sub = randn(sz_X(1),N);
Ra_proj = Ra_sub'*Xc;

end
