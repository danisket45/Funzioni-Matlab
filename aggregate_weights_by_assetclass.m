% Questa funzione somma la storia dei pesi per singolo ETF nei 5 totali di asset class.
% Serve per disegnare la mappa dei pesi.

function AssetClassWeightsOverTime = aggregate_weights_by_assetclass(WeightsHistory, N_equity, N_bond, N_commodity, N_realestate, N_safeasset)

idx_equity     = 1:N_equity;
idx_bond       = N_equity + (1:N_bond);
idx_commodity  = N_equity + N_bond + (1:N_commodity);
idx_realestate = N_equity + N_bond + N_commodity + (1:N_realestate);
idx_safeasset  = N_equity + N_bond + N_commodity + N_realestate + (1:N_safeasset);

AssetClassWeightsOverTime = [ ...
    sum(WeightsHistory(:,idx_equity), 2, 'omitnan'), ...
    sum(WeightsHistory(:,idx_bond), 2, 'omitnan'), ...
    sum(WeightsHistory(:,idx_commodity), 2, 'omitnan'), ...
    sum(WeightsHistory(:,idx_realestate), 2, 'omitnan'), ...
    sum(WeightsHistory(:,idx_safeasset), 2, 'omitnan') ];

end