% Questa funzione è molto simile a compute_candidate_weights_t, ma
% i K candidati selezionati vengono pesati per inverse-volatility usando
% la volatilità dell'ETF candidato. 
% Viene usata nella versione IV sia per l'asset class Equity che per Fixed Income.

function w = compute_candidate_weights_invvol_t(t, assetClassWeight, K, etfBucketLabels, mom_ETF, trailingVol_ETF)

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

candidateGlobalIdx = candidateETF_globalIdx(topCandidates);


candidateVols = trailingVol_ETF(t, candidateGlobalIdx);
candidateWeights = inverse_vol_weights(candidateVols);

for i = 1:K_actual
    w(candidateGlobalIdx(i)) = assetClassWeight * candidateWeights(i);
end

end