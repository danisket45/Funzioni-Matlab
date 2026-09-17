% Questa funzione calcola il momentum "secco" (non lagged) 
% su un livello di indice o prezzi.

function mom = momentum(idxLevel, lookback)
T = length(idxLevel);
mom = nan(T,1);
for t = (lookback+1):T
    p_start = idxLevel(t-lookback);
    p_end   = idxLevel(t);
    if ~isnan(p_start) && ~isnan(p_end) && p_start > 0
        mom(t) = p_end / p_start - 1;
    end
end
end