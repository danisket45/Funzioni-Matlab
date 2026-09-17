% Questa funzione calcola il turnover mensile da una matrice di pesi T x N.
% Turnover al mese t = 0.5 * sum(|w_t - w_drift{t-1}|), dove
% w_drift sono i pesi effettivi del portafoglio immediatamente 
% prima del ribilanciamento (aggiustati per il rendimento realizzato)

function turnover = compute_turnover(WeightsHistory, MonthlyReturns_ETF)
    T = size(WeightsHistory,1);
    turnover = nan(T,1);
    for t = 2:T
        w_prev = WeightsHistory(t-1,:);
        r_prev = MonthlyReturns_ETF(t-1,:); 

        grossVal = w_prev .* (1 + r_prev);
        grossVal(isnan(grossVal)) = 0;
        denom = sum(grossVal, 'omitnan');

        if denom > 0
            w_drift = grossVal / denom;
        else
            w_drift = w_prev;
        end

        turnover(t) = 0.5 * sum(abs(WeightsHistory(t,:) - w_drift), 'omitnan');
    end
end

