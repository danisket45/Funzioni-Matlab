% Questa funzione scala ad ogni mese l'esposizione alla strategia in base al rapporto
% target_vol / vol_realizzata_trailing (come nel paper B-SC). 
% La quota di esposizione "liberata" quando la strategia è scalata sotto 1 va al safe asset; 
% siccome leverageCap = 1, è la versione deleveraging only.

function [scaledReturns, scalarSeries] = apply_volatility_scaling_v2(rawReturns, safeAssetReturns, targetVol, realizedVolSeries, leverageCap)

T = length(rawReturns);
scaledReturns = nan(T,1);
scalarSeries = nan(T,1);

for t = 1:T

    if isnan(realizedVolSeries(t)) || isnan(rawReturns(t)) || isnan(safeAssetReturns(t))
        continue
    end

    scalar_t = targetVol / realizedVolSeries(t);
    scalar_t = min(scalar_t, leverageCap);
    scalar_t = max(scalar_t, 0);

    scalarSeries(t) = scalar_t;
    scaledReturns(t) = scalar_t * rawReturns(t) + (1 - scalar_t) * safeAssetReturns(t);

end

end