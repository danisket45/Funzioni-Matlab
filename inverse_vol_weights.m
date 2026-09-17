% Questa funzione viene usata all'interno delle funzioni
% compute_candidate_weights_invvol_t e compute_topk_invvol_weight_t.
% Calcola i pesi proporzionali a 1/volatilita', normalizzati a somma 1.
% Se nessuna volatilita' e' disponibile, ripiega su equal-weight tra tutti gli asset passati.

function w = inverse_vol_weights(vols)

invVol = 1 ./ vols;
invVol(isnan(vols) | vols <= 0) = 0;

if sum(invVol) == 0
    w = ones(size(vols)) / numel(vols); 
else
    w = invVol / sum(invVol);
end

end