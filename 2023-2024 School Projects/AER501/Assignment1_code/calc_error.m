function err = calc_error(a, b)
    % Calculate L^2 norm of the error
    err = sqrt(sum((b'-a').^2));
end