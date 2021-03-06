function pred = nnrpred(Xtest,X,y,K,dist_type,pret_type)

% prediction of new samples with knn regression model
%
% pred = nnrpred(Xtest,X,y,K,dist_type,pret_type)
%
% ------------ INPUT ---------------------------------------------------
% Xtest:        dataset to be predicted [n_test x p] n objects, p variables
% X:            training data matrix (n x p)
% y:            training y vector (n x 1)
% K:            number of neighbors
% dist_type:    'euclidean' Euclidean distance
%               'mahalanobis' Mahalanobis distance
%               'cityblock' City Block metric
%               'minkowski' Minkowski metric
% pret_type:    'cent' cenering
%               'scal' variance scaling
%               'auto' for autoscaling (centering + variance scaling)
%               'rang' range scaling (0-1)
%               'fp'   fingerprints
%
% ------------ OUTPUT --------------------------------------------------
% pred is a structure conyaining
% y_pred            predicted y vector [n_test x 1]
% y_pred_weighted   predicted wighted y vector [n_test x 1]
% neighbors         list of k neighbors for each predicted sample [n_test x k]
% 
% version 2.0 - may 2012
% Davide Ballabio
% Milano Chemometrics and QSAR Research Group
% www.disat.unimib.it/chm

[n,p] = size(Xtest);
[X_scal_train,param] = data_pretreatment(X,pret_type);
X_scal = test_pretreatment(Xtest,param);
Xd = [X_scal;X_scal_train];
D = nnr_calc_dist(X_scal_train,X_scal,dist_type,pret_type);
neighbors = zeros(n,K);
yc=zeros(1,n);
yc_weighted=zeros(1,n);
w=zeros(n,K);
for i=1:n
    D_in = D(i,:);
    [d_tmp,n_tmp] = sort(D_in);
    neighbors(i,:) = n_tmp(1:K);
    d_neighbors = d_tmp(1:K);
    [yc(i),yc_weighted(i),w(i,:)] = nnrcalcy(y(neighbors(i,:)),d_neighbors,K);
    dc(i,:)=d_neighbors;
end

pred.neighbors  = neighbors;
pred.y_pred = yc';
pred.y_pred_weighted = yc_weighted';
pred.D=D;
pred.dc=dc;
pred.w=w;