%# sample dataset


%# fit GMM using EM
K = 4;
obj = gmdistribution.fit(Set, K,'Regularize',0.1);

%# assign points to mixtures: argmax_k P(M(k)|data)
P = posterior(obj, Set);
[~,mIDX] = max(P,[],2);

