function [ avg_acc ] = test_HMM2( seq_2, seq_5, N, Ainit )
% sequences is the concatenation of cells for words 2 and 5. (audio, visual, or audio-visual)
    % 10 for each word)
% seq_type is the identifier of the word for each matrix in sequences.  The
    % first 10 correspond to '2', and the last 10 correspond to '5'

success_cnt = 0;
[P02,A2,mu2,sigma2] = ghmm_learn(seq_2,N,Ainit);
[P05,A5,mu5,sigma5] = ghmm_learn(seq_5,N,Ainit);

for tst_seq = 1:length(seq_2)
        
    trn_seq_2 = seq_2;
    trn_seq_2(tst_seq) = [];

    [P0,A,mu,sigma] = ghmm_learn(trn_seq_2,N,Ainit);
    [~,scale2] = ghmm_fwd(seq_2{tst_seq},A,P0,mu,sigma);
    pr_2 = scale2(end);
            
    [~,scale5] = ghmm_fwd(seq_2{tst_seq},A5,P05,mu5,sigma5);
    pr_5 = scale5(end);
            
    if (pr_2 > pr_5)
        success_cnt = success_cnt + 1;
    end

end

for tst_seq = 1:length(seq_5)

    trn_seq_5 = seq_5;
    trn_seq_5(tst_seq) = [];

    [P0,A,mu,sigma] = ghmm_learn(trn_seq_5,N,Ainit);
    [~,scale5] = ghmm_fwd(seq_5{tst_seq},A,P0,mu,sigma);
    pr_5 = scale5(end);
            
    [~,scale2] = ghmm_fwd(seq_5{tst_seq},A2,P02,mu2,sigma2);
    pr_2 = scale2(end);
            
    if (pr_2 < pr_5)
        success_cnt = success_cnt + 1;
    end

end

avg_acc = success_cnt/(length(seq_2) + length(seq_5));

end