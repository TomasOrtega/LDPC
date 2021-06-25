function res = girth_of_H_at(H, v)
    %girth_of_H_at gives the girth of the longest cycle passing through v
    %   where v is a check node
    v = size(H, 2) + v;
    G = graph(H2adjacency(H));
    neig = neighbors(G, v);
    res = inf;

    for i = 1:length(neig)
        nv = neig(i);
        Gp = rmedge(G, v, nv);
        pathl = length(shortestpath(Gp, v, nv));

        if pathl > 0
            res = min(res, pathl);
        end

    end

end
