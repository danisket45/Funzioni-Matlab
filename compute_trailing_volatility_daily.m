% Questa funzione calcola la volatilita' trailing da dati giornalieri.
% tradingDaysWindow indica quanti giorni di trading usare per la stima (es. 126)

function trailingVolAtMonthEnds = compute_trailing_volatility_daily(dailyPrices, monthEndsIdx, tradingDaysWindow)

dailyReturns = dailyPrices(2:end,:) ./ dailyPrices(1:end-1,:) - 1; % D-1 x N

M = length(monthEndsIdx);
N = size(dailyPrices,2);
trailingVolAtMonthEnds = nan(M,N);

for m = 1:M

    dayIdx_end = monthEndsIdx(m);
    endRow = dayIdx_end - 1; 
    startRow = endRow - tradingDaysWindow + 1;

    if startRow < 1
        continue 
    end

    trailingVolAtMonthEnds(m,:) = std(dailyReturns(startRow:endRow,:), 0, 1, 'omitnan') * sqrt(252);

end

end