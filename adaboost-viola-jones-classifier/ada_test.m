function  ada_test( T, num_samp, num_tst, IntImgs_tst, tst_rects_pos, tst_rects_neg )

T_classifiers = load('t_classifiers.txt','-ascii');
bta = T_classifiers(:,9);
alpha = -log(bta);

feat_tst = zeros(num_tst,8,T);
classifier_out = zeros(num_tst,8,T);
classifier_strong = zeros(num_tst,8,T);

for t = 1:T
    frac_rect = T_classifiers(t,1:4)/num_samp;
    vert = T_classifiers(t,5);
    order = T_classifiers(t,6);
    theta = T_classifiers(t,7);
    pol = T_classifiers(t,8);
    beta = T_classifiers(t,9);
    feat_tst(:,:,t) = rectfeature(IntImgs_tst,[tst_rects_pos,tst_rects_neg],frac_rect,order,vert);
    classifier_out(:,:,t) = pol*sign(theta - feat_tst(:,:,t));
end    
    
% construct the strong classifier
classifier_strong = cumsum(classifier_out.*repmat(reshape(alpha,[1,1,T]),[num_tst,8]),3);
% signed binary label
lbls_correct = [ones(num_tst,4), -ones(num_tst,4)];


for t = 1:T
    err_tot(t) = mean(mean(sign(classifier_strong(:,:,t)) ~= lbls_correct));
    err_single(t) = mean(mean(sign(classifier_out(:,:,t)) ~= lbls_correct));
end
    
figure();
plot(1:T,err_tot,'*',1:T,err_single,1:T,bta,'o',1:T,alpha,'^');
legend('Total Error','Single Error','betas','alphas')
xlabel('Classifier Step');
ylabel('Error Metrics');

%imshow('testing-performance.png')


end

