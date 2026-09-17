% Questa funzione decide per ogni mese quali ETF verranno inclusi
% nell'analisi; un ETF è eleggibile al mese t se ha almeno "minHistory" 
% mesi di storico consecutivo di prezzi non mancanti immediatamente precedenti.
% Gestisce automaticamente sia gli ETF che partono in ritardo sia quelli "morti"/delistati 

function eligibleMask = build_eligibility_mask(prices_monthly, minHistory)

[T, N] = size(prices_monthly);
hasPrice = ~isnan(prices_monthly);
eligibleMask = false(T, N);

for j = 1:N
    consecCount = 0;
    for t = 1:T
        if hasPrice(t,j)
            consecCount = consecCount + 1;
        else
            consecCount = 0;
        end
        eligibleMask(t,j) = consecCount >= minHistory;
    end
end

end