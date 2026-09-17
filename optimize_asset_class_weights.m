% Questa funzione calcola i pesi ottimi di asset class via programmazione lineare.
% Risolve: max_w  sum(w_i * momentum_i)
%           s.t.   lb_i <= w_i <= ub_i   (range MiFID per asset class)
%                  sum(w_i) = 1
% NB: se lb e ub sono incompatibili con sum(w)=1 (es. sum(lb) > 1, o
% sum(ub) < 1), linprog restituisce w vuoto e segnala infeasibility.

function w = optimize_asset_class_weights(momentum, lb, ub)

momentum = momentum(:);
lb = lb(:);
ub = ub(:);
N = length(momentum);

if any(isnan(momentum))
    warning('optimize_asset_class_weights:nanMomentum', ...
        'Momentum non disponibile per almeno una asset class (probabilmente storico insufficiente per questo mese): pesi non calcolati.');
    w = nan(N,1);
    return
end

f = -momentum; % linprog minimizza di default: neghiamo per massimizzare

Aeq = ones(1,N);
beq = 1;

options = optimoptions('linprog','Display','off');

[w, ~, exitflag] = linprog(f, [], [], Aeq, beq, lb, ub, options);

if exitflag ~= 1
    warning('optimize_asset_class_weights:infeasible', ...
        'Problema non risolvibile con i range forniti (verifica che sum(lb)<=1<=sum(ub)).');
    w = nan(N,1);
end

end