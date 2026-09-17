% Questa funzione calcola Markowitz min-variance dentro una
% singola asset class (es. solo ETF Equity, solo ETF Bond...).
% Si avvale della funzione markowitz_min_variance_weights.

function w = compute_markowitz_subclass_weights_t(dayIdx_end, assetClassWeight, DailyReturns_class, eligMask_class_daily, tradingDaysWindow)

N = size(DailyReturns_class,2);
w = zeros(1,N);

endRow = dayIdx_end - 1;
startRow = endRow - tradingDaysWindow + 1;

if startRow < 1
    return
end

eligibleCols = eligMask_class_daily(dayIdx_end, :);
nElig = sum(eligibleCols);

if nElig == 0
    return
elseif nElig == 1
    w(eligibleCols) = assetClassWeight; % un solo eleggibile: nessuna covarianza da stimare
    return
end

returns_window = DailyReturns_class(startRow:endRow, eligibleCols);

w_reduced = markowitz_min_variance_weights(returns_window, [], []);

if any(isnan(w_reduced))
    return
end

w(eligibleCols) = assetClassWeight * w_reduced;

end