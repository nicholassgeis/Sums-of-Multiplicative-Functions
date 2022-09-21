using Combinatorics

#Creates a list of primes up to an integer n.
function sieve(n::Int64)
    S = fill(true,n); S[1] = false
    for p = 2:n
        if S[p]
            for m = p+p:p:n S[m]=false end
        end
    end
    return findall(S)
end

#Creates an array that stores the data of square-free numbers of
#a Wintner function.
function array_maker(n, list_of_primes)
    S = fill(Int8(1),n);
    sq_primes = [p^2 for p in list_of_primes if p^2 <= n]
    for sq_p in sq_primes
        for sq_pos in sq_p:sq_p:n
            S[sq_pos] = 0
        end
    end
    return S 
end

#Creates an array that stores the data of square-free numbers without prime
#factors smaller than a set parameter z.
function array_for_sieve_method(n, list_of_primes, small_primes)
    S = fill(Int8(1),n);
    sq_primes = [p^2 for p in list_of_primes if p^2 <= n]
    for sq_p in sq_primes
        for sq_pos in sq_p:sq_p:n
            S[sq_pos] = 0
        end
    end
    for p in small_primes
        for pos in p:p:n
            S[pos] = 0
        end
    end
    return S
end

#Finds all primes less than a fixed integer z.
function primes_less_than_z(z)
    i = 1
    while primes[i] <= z
        i += 1 
    end
    return primes[1:i-1]
end

#Computes the list of all possible squarefree products of primes
#less than an integer z.
function all_combination_products_less_than_z(z)
    return sort(append!([1], [prod(entry) for entry in combinations(primes_less_than_z(z)) if prod(entry) <= X]))
end

function end_points_for_intervals(arr_of_nums, z, n)
    return sort(append!([z], [Int64(floor(n/entry)) for entry in arr_of_nums]))
end

#=
function first_p_in_range(a, b, p)
    if p > b return 0 end
    modulus = a % p
    if modulus == 0 && (a + p <= b)
        return a + p
    end
    position = (p - modulus)
    if a + position > b
        return 0
    else
        return a + position
    end
end

#Creates a dictionary of locations of the first number divisible by a prime in the interval
#(a, b] for every prime. If a multiple of the prime is not in the interval, no data added to dictionary.
function locations_of_primes_in_intervals(starting_pt,
                                          ending_pt,
                                          set_of_primes = primes)
    X = Dict{Integer, Integer}();
    for p in set_of_primes
        hold_value = first_p_in_range(starting_pt, ending_pt, p)
        if hold_value != 0 
            X[p] = hold_value 
        end
    end
    return X
end

function list_of_dictionaries_with_location_information(set_of_endpoints)
    list_of_data = [locations_of_primes_in_intervals(set_of_endpoints[1], set_of_endpoints[2])]
    for i in 2:length(set_of_endpoints)-1
        append!(list_of_data, [locations_of_primes_in_intervals(set_of_endpoints[i], set_of_endpoints[i+1])])
    end
    return list_of_data
end


function dictionary_of_information_for_primes(set_of_primes = primes, 
                                              set_of_endpoints = end_points)
    X = Dict{Int64, Vector{Tuple{Int8, Int64}}}();
    for p in set_of_primes
        X[p] = Tuple{Int8, Int64}[]
        for index in 1:length(set_of_endpoints)-1
            hold_value = first_p_in_range(set_of_endpoints[index], set_of_endpoints[index+1], p);
            if hold_value == 0 continue end
            append!(X[p], [(index, hold_value)])
        end
    end
    return X
end
=#