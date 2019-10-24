function [ X_proj, Ra_proj ] = PCA( M,E,X )

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

% Create subspace of eigenvectors, form a projector matrix
V_sub = [];
for i=1:N 
    vk = Xc*V(:,ind(i))/sqrt(D(ind(i),ind(i)));
    V_sub = cat(2,V_sub,vk);
end

% project
X_proj = V_sub'*Xc;

end

