% Questa funzione applica il filtro di momentum assoluto: per ogni ETF con peso > 0, 
% se il suo momentum assoluto è negativo il peso viene azzerato e reindirizzato 
% verso il safe asset invece di restare investito in quell'ETF.

function [w_filtered, redirected] = apply_dual_momentum_filter(w, momentum_t)

w_filtered = w;

negOrMissing = (w > 0) & (isnan(momentum_t) | momentum_t < 0);

redirected = sum(w(negOrMissing));
w_filtered(negOrMissing) = 0;

end