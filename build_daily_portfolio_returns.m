% Questa funzione calcola il rendimento di portafoglio giornaliero,
% tenendo fissi i pesi decisi ad ogni fine mese e rivalutandoli 
% quotidianamente sui prezzi; serve per stimare la
% volatilità della strategia su base giornaliera.

function dailyPortRet = build_daily_portfolio_returns(WeightsHistory, AllPrices_daily, monthEnds)

D = size(AllPrices_daily,1);
dailyReturns = AllPrices_daily(2:end,:) ./ AllPrices_daily(1:end-1,:) - 1; % (D-1) x N

dailyPortRet = nan(D-1,1);

M = length(monthEnds);

for m = 1:(M-1)

    w = WeightsHistory(m+1,:);

    if any(isnan(w))
        continue
    end

    startRow = monthEnds(m); % primo rendimento giornaliero del periodo di detenzione
    endRow   = monthEnds(m+1) - 1; % ultimo rendimento giornaliero prima del ribilanciamento successivo

    if startRow < 1 || endRow > size(dailyReturns,1) || startRow > endRow
        continue
    end

    for d = startRow:endRow
        dailyPortRet(d) = sum(w .* dailyReturns(d,:), 'omitnan');
    end

end

end