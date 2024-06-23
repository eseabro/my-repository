function d = A1solve_k(K, P, bcs)
    k = K(bcs,bcs);
    p = P(bcs);
    d = k\p;
end