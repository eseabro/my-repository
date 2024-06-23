function [inCollision, edge] = CheckCollision2(ptA, ptB, obstEdges)
    % Bounding box of the line segment
    min_x = min(ptA(1), ptB(1));
    max_x = max(ptA(1), ptB(1));
    min_y = min(ptA(2), ptB(2));
    max_y = max(ptA(2), ptB(2));

    % Indices of edges that potentially intersect with the bounding box
    candidate_edges = find(~((max_x < min(obstEdges(:, 1), obstEdges(:, 3))) | ...
        (min_x > max(obstEdges(:, 1), obstEdges(:, 3))) | ...
        (max_y < min(obstEdges(:, 2), obstEdges(:, 4))) | ...
        (min_y > max(obstEdges(:, 2), obstEdges(:, 4)))));

    % Detailed collision check for candidate edges
    for k = candidate_edges'
        if EdgeCollision([ptA, ptB], obstEdges(k, :))
            % Eliminate end-to-end contacts from collisions list
            if any(ptA ~= obstEdges(k, 1:2),2) && ...
                any(ptB ~= obstEdges(k, 1:2),2) && ...
                any(ptA ~= obstEdges(k, 3:4),2) && ...
                any(ptB ~= obstEdges(k, 3:4),2)
                
                edge = k;
                inCollision = 1; % In Collision
                return
            end
        end
    end

    % No collision found
    inCollision = 0;
    edge = [];
end
