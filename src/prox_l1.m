function x = prox_l1(u,c)
% x = prox_{c\| \|}(u)
x = sign(u) .* max(abs(u) - c, 0);
end
