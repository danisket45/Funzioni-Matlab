% Questa funzione seleziona i K ETF con momentum piu' alto tra 
% gli eleggibili e distribuisce il peso per inverse-volatility.
% Viene usata per l'asset class Commodity nella versione IV.

function w = compute_topk_invvol_weight_t(t, assetClassWeight, K, eligMask, mom_ETF, trailingVol_ETF)

N = size(mom_ETF,2);
w = zeros(1,N);

eligNow = eligMask(t,:);
momNow = mom_ETF(t,:);
momNow(~eligNow) = NaN;

validIdx = find(~isnan(momNow));

if isempty(validIdx)
    return
end

[~, order] = sort(momNow(validIdx), 'descend');
K_actual = min(K, length(order));
topIdx = validIdx(order(1:K_actual));

topVols = trailingVol_ETF(t, topIdx);
topWeights = inverse_vol_weights(topVols);

w(topIdx) = assetClassWeight * topWeights;

end