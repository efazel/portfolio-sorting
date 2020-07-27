%%%% portfosort Function %%%%
% Author: Ehsan Fazel (Concordia University)
% This version: November 2019

% I used the package "portsort" in R as a reference:
% https://cran.r-project.org/web/packages/portsort/index.html


function [prtf,rtns,tkrs] = portfosort(exrtn,factors,w,fnum)
% portfosort function summary: 
%   

% input 1 (exrtn): a panel of N excess common stock return (T by N).
% input 2 (factors): a panel of 2 factors (T by 2).
% input 3 (w): window length.
% input 4 (fnum): select the column of factors to sort on. either 1 or 2.

% Output 1 (prtf): tercile portfolio sorted on the factor beta.                                                     
% Output 2 (rtns): stored returns in each portfolio.           
% Output 3 (tkrs): stored tickers (indeces) in each portfolio.


both_factors = [factors(:,1), factors(:,1)]; %both factors in level
lag_exrtn = exrtn(1:end-1,:); %lag return consists of all the observations
frw_exrtn = exrtn(2:end,:); % forward return starts with one lag and go one 
%observation ahead of the dimension of factors


f1 = both_factors(:,1);
f2 = both_factors(:,2);
k = 0 ; 
s1 = size(lag_exrtn,1);
s2 = size(lag_exrtn,2);
factor1_beta = NaN(s1,s2);
factor2_beta = NaN(s1,s2);

%estimation of betas
for i=1:size(lag_exrtn,2)
    l_r = lag_exrtn(:,i); %first asset in lag
    for j=w+1:size(lag_exrtn,1)
    e_l_r = l_r((j-w):(j-1-k),1)%excess lag return
    f1_L = f1((j-w):(j-1-k),1); %select subset the first factor for regression
    f2_L = f2((j-w):(j-1-k),1); %select subset the second factor for regression
    inpt = ones(size(f1_L,1),1); %declaring intercept
    X = [inpt, f1_L, f2_L];
    y = e_l_r;
    [b,bint] = regress(y,X);
    factor1_beta(j,i) = b(2,1);
    factor2_beta(j,i) =  b(3,1);
        
    end
end

%remove the portfolio formation period
factor1_beta(any(isnan(factor1_beta),2),:)=[];
factor2_beta(any(isnan(factor2_beta),2),:)=[];

all_factors_beta{1} = factor1_beta;
all_factors_beta{2} = factor2_beta;

%resubset ForwardReturn:
frw_exrtn = frw_exrtn(w+1:size(frw_exrtn,1),:);


%which factor to sort on:
Fac = all_factors_beta{fnum};

%specify the tercile dimensions
sz = size(frw_exrtn,2); %number of assets
s1 = round(sz/3); %size of first and last terciles
s3 = s1;
s2 = sz - s1 - s3;
q = 3;

prtf = NaN(size(frw_exrtn,1),q); %store portfolios
rtns = cell(size(frw_exrtn,1),q); %store returns
tkrs = cell(size(frw_exrtn,1),q); %store tickers (indeces)
preformBeta = cell(size(frw_exrtn,1),q); %store the 
%preformation betas

for i=1:size(frw_exrtn,1)
    fac = Fac(i,:);
    [B,I] = sort(fac);
    sorted = I;
    sorted_beta = B;
    
    tkrs{i,1} = sort(sorted(1,1:s1));
    preformBeta{i,1} = sort(sorted_beta(1,1:s1)); %sort and store the preformation betas
    sorted(:,1:s1) = [];
    sorted_beta(:,1:s1) = [];
    
    tkrs{i,2} = sort(sorted(1,1:s2));
    preformBeta{i,2} = sort(sorted_beta(1,1:s2));
    sorted(:,1:s2) = [];
    sorted_beta(:,1:s2) = [];
    
    tkrs{i,3} = sort(sorted(1,1:s3));
    preformBeta{i,3} = sort(sorted_beta(1,1:s3));
    sorted(:,1:s3) = [];
    sorted_beta(:,1:s3) = [];
     
end

% filling out
for i=1:size(frw_exrtn,1)
    for j=1:q
        tick = tkrs{i,j};
        rt = frw_exrtn(i,tick);
        prtf(i,j) = mean(rt);
        rtns{i,j} = rt;
    end
end
end

