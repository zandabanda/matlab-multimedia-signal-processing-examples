function run(rects_path,jpg_path)

T = 40;
WHOLE = 0;
num_samp = 6;

[num_trn, num_tst, trn_rects_pos, trn_rects_neg, tst_rects_pos, tst_rects_neg, IntImgs_trn, IntImgs_tst] = load_dat(jpg_path, rects_path);
adaboost(T, WHOLE, num_trn, num_samp, IntImgs_trn, trn_rects_pos, trn_rects_neg);
ada_test(T, num_samp, num_tst, IntImgs_tst, tst_rects_pos, tst_rects_neg);

end



