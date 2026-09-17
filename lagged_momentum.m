% Questa funzione calcola il lagged momentum su un livello di indice o prezzi.
% Il rendimento va da t-lookback a t-1, poichè esclude l'ultimo mese per evitare l'effetto short-term reversal. 
% Funziona sia su un livello di indice sintetico sia direttamente sui prezzi di un singolo ETF.

function mom = lagged_momentum(idxLevel, lookback)

T = length(idxLevel);
mom = nan(T,1);

for t = (lookback+1):T
    p_start = idxLevel(t-lookback);
    p_end   = idxLevel(t-1);
    if ~isnan(p_start) && ~isnan(p_end) && p_start > 0
        mom(t) = p_end / p_start - 1;
    end
end

end