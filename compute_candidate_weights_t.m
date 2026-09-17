% Questa funzione si compone di 2 step: 
% step 1: ogni bucket candida il suo ETF migliore
% step 2: tra tutti i candidati, tiene i K con momentum piu' alto
% Viene usata nella versione EW sia per l'asset class Equity che per Fixed Income.

function w = compute_candidate_weights_t(t, assetClassWeight, K, etfBucketLabels, mom_ETF, bucketData)

N = size(mom_ETF,2);
w = zeros(1,N);

bucketNamesRaw = unique(etfBucketLabels);
numBuckets = length(bucketNamesRaw);

candidateETF_globalIdx = nan(numBuckets,1);
candidateETF_momentum  = nan(numBuckets,1);


for i = 1:numBuckets

    bucketMask = etfBucketLabels == bucketNamesRaw(i);
    momInBucket = mom_ETF(t, bucketMask);

    if all(isnan(momInBucket))
        continue 
    end

    [bestMom, bestLocal] = max(momInBucket, [], 'omitnan');
    idxInFull = find(bucketMask);

    candidateETF_globalIdx(i) = idxInFull(bestLocal);
    candidateETF_momentum(i)  = bestMom;

end


validCandidates = find(~isnan(candidateETF_momentum));

if isempty(validCandidates)
    return
end

[~, order] = sort(candidateETF_momentum(validCandidates), 'descend');
topCandidates = validCandidates(order(1:min(K,length(order))));

K_actual = length(topCandidates);

for i = 1:K_actual
    globalIdx = candidateETF_globalIdx(topCandidates(i));
    w(globalIdx) = assetClassWeight / K_actual; % equal-weight tra i candidati selezionati
end

end