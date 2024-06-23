function [d] = MinDist2Edges_vec(points,edges)
% Returns the minimum distance to edges for a set of points

n = length(points(:,1));
for ii=1:n
    P = points(ii,:);
    l2 = sum((edges(:, 3:4) - edges(:, 1:2)).^2, 2);

    t = dot((P-edges(:,1:2))', (edges(:,3:4)-edges(:,1:2))')./l2';

    m1 = t<0.0;
    m2 = t>1.0;
    m3 = ~(m1 | m2);

    dist(ii, m1) = vecnorm(P - edges(m1, 1:2), 2, 2);
    dist(ii, m2) = vecnorm(P - edges(m2, 3:4), 2, 2);
    if any(m3)
        dist(ii, m3) = abs((P(1) - edges(m3, 1)) .* (edges(m3, 4) - edges(m3, 2)) ...
            - (P(2) - edges(m3, 2)) .* (edges(m3, 3) - edges(m3, 1))) ./ sqrt(l2(m3));
    end
end
d = min(dist, [], 2)';
end