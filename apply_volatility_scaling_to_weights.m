% Questa funzione applica lo scalare del volatility scaling direttamente 
% al vettore dei pesi, invece che al solo rendimento, producendo una storia 
% dei pesi scalata, riusabile per il calcolo del turnover.

function WeightsScaled = apply_volatility_scaling_to_weights(WeightsHistory, scalarSeries, safeAssetCols)

[T, N] = size(WeightsHistory);
WeightsScaled = nan(T,N);

for t = 1:T

    s = scalarSeries(t);

    if isnan(s)
        continue
    end

    WeightsScaled(t,:) = s * WeightsHistory(t,:);
    WeightsScaled(t,safeAssetCols) = WeightsScaled(t,safeAssetCols) + (1-s)/length(safeAssetCols);

end

end