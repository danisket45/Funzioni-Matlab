% Questa funzione seleziona i K ETF con momentum piu' alto tra gli
% eleggibili e gli assegna peso equal-weight.
% Viene usata per l'asset class Commodity nella versione EW.

function w = compute_topk_weight_t(t, assetClassWeight, K, eligMask, mom_ETF)

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

w(topIdx) = assetClassWeight / K_actual;

end