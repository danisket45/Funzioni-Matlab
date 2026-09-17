% Funzione simile a compute_trailing_volatility_daily,
% ma l'input è una serie di rendimenti giornalieri.

function trailingVolAtMonthEnds = compute_trailing_volatility_from_daily_returns(dailyReturns, monthEndsIdx, tradingDaysWindow)

M = length(monthEndsIdx);
trailingVolAtMonthEnds = nan(M,1);

for m = 1:M

    dayIdx_end = monthEndsIdx(m);
    endRow = dayIdx_end - 1;
    startRow = endRow - tradingDaysWindow + 1;

    if startRow < 1 || endRow > length(dailyReturns)
        continue
    end

    window = dailyReturns(startRow:endRow);

    if any(isnan(window))
        continue
    end

    trailingVolAtMonthEnds(m) = std(window, 'omitnan') * sqrt(252);

end

end