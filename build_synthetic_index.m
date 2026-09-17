% Questa funzione crea l'indice sintetico equal-weight da un panel di ETF.
% Ad ogni mese t, calcola il rendimento medio (equal-weight) di tutti gli
% ETF eleggibili, e lo compone in un indice che parte da 100. 
% Il set di componenti puo' cambiare ogni mese in base all'eleggibilita'.

function idxLevel = build_synthetic_index(prices_monthly, eligibleMask)

[T, ~] = size(prices_monthly);
idxLevel = nan(T,1);
idxLevel(1) = 100;

for t = 2:T

    validNow = eligibleMask(t,:)   & ~isnan(prices_monthly(t,:));
    validPrev = eligibleMask(t-1,:) & ~isnan(prices_monthly(t-1,:));
    usable = validNow & validPrev;

    if any(usable)
        r = prices_monthly(t,usable) ./ prices_monthly(t-1,usable) - 1;
        r_bucket = mean(r); 
    else
        r_bucket = 0;
    end

    idxLevel(t) = idxLevel(t-1) * (1 + r_bucket);

end

end