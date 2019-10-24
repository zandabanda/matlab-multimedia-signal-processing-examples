function adaboost( T, WHOLE, num_trn, num_samp, IntImgs_trn,trn_rects_pos,trn_rects_neg )

%T = 40; % combine T weak classifiers
% create weight vector or matrix 126*8 rectangles, initialize as uniform
wght = ones(num_trn, 8);
lbls = [ones(num_trn,4), zeros(num_trn, 4)]; % assign 0 or 1 to each rectangle SUPERVISED LEARNING (we know correct in advance)

bta = [];
classifiers_weak = zeros(0,9);
% Choose how subrectangles we will search for each image, 6 is a good
% compromise between computational complexity and classifier quality
%num_samp = 6;

%WHOLE = 1; % controls whether we perform 1 or T training iterations

% Exhaustive search for best T classifiers
for t = 1:(T^WHOLE)
    
    wght=wght/sum(sum(wght)); % renormalize
    bst_wght_err = .51; % Binary classification error can't go above 50%
    
    for xm = 0:(WHOLE*(num_samp-1))
        for ym = 0:(WHOLE*(num_samp-1))
            %disp(sprintf('%d: [%d, %d]',t,xmin,ymin));
            for width = 1:((num_samp-xm)^WHOLE)
                for height = 1:((num_samp-ym)^WHOLE)
                    frac_rect = [xm,ym,width,height]/num_samp;
                    for vert = 0:WHOLE
                        for order = (1+vert):((4-vert)^WHOLE)
                            
                            feat_trn = rectfeature(IntImgs_trn,[trn_rects_pos,trn_rects_neg],frac_rect,order,vert);
                            [theta,pol,err] = bestthreshold(feat_trn,lbls,wght);
                            
                            if err < bst_wght_err
                                bst_classifier = [xm,ym,width,height,vert,order,theta,pol];
                                bst_wght_err = err;
                                %disp(sprintf('%d: [%d, %d, %d, %d], %d, %d: %g < %g with %g, %d',...
                                    %t,xm,ym,width,height,vert,order,err,bst_wght_err,theta,pol));
                            end
                            
                        end
                    end
                end
            end   
        end
    end
    
bta(t) = bst_wght_err/(1-bst_wght_err);
classifiers_weak(t,:) = [bst_classifier, bta(t)];

% recompute features
frac_rect = bst_classifier(1:4)/num_samp;
vert = bst_classifier(5);
order = bst_classifier(6);
theta = bst_classifier(7);
pol = bst_classifier(8);
feat_trn = rectfeature(IntImgs_trn,[trn_rects_pos,trn_rects_neg],frac_rect,order,vert);
        
classifier = (pol*feat_trn < pol*theta); % 0 or 1
% if the classifier is correct, alter the weights; reduce the weights
% corresponding to correctly classified weights.
wght(classifier == lbls) = wght(classifier == lbls)*bta(t);
  
end


if WHOLE
    save('t_classifiers.txt','classifiers','-ascii');
end


end

