function out = random_shuffle(v)
    %RANDOM_SHUFFLE Does a random shuffle of a vector
    p = randperm(length(v));
    out = v(p);
end
