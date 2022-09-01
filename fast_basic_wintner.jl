using Distributions

coin = Bernoulli(0.5)

function sieve(n)
    S = fill(true,n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p+p:p:n S[m]=false end
        end
    end
    return findall(S)
end

function cancel_primes(sample_coin = coin)
    return [p for p in primes if rand(coin)]
end

function array_maker(n::Int64)
    S = fill(Int8(1),n);
    sq_primes = [p^2 for p in primes if p^2 <= n]
    for sq_p in sq_primes
        for sq_pos = sq_p:sq_p:n
            S[sq_pos] = 0
        end
    end
    return S 
end

function wintner_function(bad_primes, arr, n)
    for p in bad_primes
        for position = p:p:n
            arr[position] *= (Int8(-1))
        end      
    end
    return arr    
end

function mertens_values(arr, n::Int64)
    arr = abs.(arr)
    return sum(wintner_function(cancel_primes(), abs.(arr), n))
end