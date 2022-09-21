using Distributions
coin = Bernoulli(0.5)

function wintner_data_generator(position_of_z = prime_position,
                                  sample_coin = coin, 
                                  set_of_primes = primes, 
                                  set_of_small_primes = list_of_small_primes)
    hold_S = [[p for p in set_of_small_primes if rand(sample_coin)]]
    append!(hold_S, [[p for p in view(set_of_primes, position_of_z+1:length(set_of_primes)) if rand(sample_coin) ]])
    return hold_S
end

function naive_wintner_sum(subset_of_primes::Vector{Int64}, arr = main_arr)
    wintner_function_z!(subset_of_primes, arr)
    return sum(arr)
end

#Main function
#Input: a set of primes that the realization of the Rademacher function
#       evaluates to -1, i.e. f(p) = -1.
#Output: The sum of each f(n) up to some predetermined term upperbound X.
#        Typically, X is some power of 10 i.e. 10^7 - 10^10.

function sieve_computation(split_subset_of_primes, 
                           arr = sieve_array, 
                           list_of_sieve_primes = list_of_small_primes,
                           conditioned_numbers = conditional_on_small_primes)

    #Compute M_1(x) values based on the values of small primes that we are sieving
    #by.
    M1_values = computing_M1_values(split_subset_of_primes[1])  
    non_zero_M1_values = indices_for_nonzero_entries_in_array(M1_values)

    #Computes the relevant values for rest of array 
    #(in the intervals where M1(x_k) are non-zero)
    wintner_function_z!(split_subset_of_primes[2])

    #Computes the relevant partial sums and then computers the Mertens's value 
    #up to X using Halasz identity
    nonzero_partial_sums = list_of_star_sums(non_zero_M1_values)
    return final_sum_test(M1_values, non_zero_M1_values, nonzero_partial_sums) 
end

#-----------------------------------------------------------------
# Setting up the M_1 terms and finding non-zero terms
#-----------------------------------------------------------------

function computing_M1_values(subset_of_primes,
                             largest_possible_value = conditional_on_small_primes[end],
                             list_of_sieve_primes = list_of_small_primes,
                             conditioned_numbers = conditional_on_small_primes)
    S = fill(Int8(1), largest_possible_value)                     
    for p in list_of_sieve_primes
        if !contained_in_ordered_list(subset_of_primes, p) continue end
        for i in p:p:largest_possible_value
            S[i] *= Int8(-1)
        end
    end
    return values_for_M1(S)
end

function contained_in_ordered_list(ordered_arr, numm)
    i = 1
    while i <= length(ordered_arr)
        if ordered_arr[i] > numm return false end
        if ordered_arr[i] == numm return true end
        i += 1
    end
    return false
end

function values_for_M1(arr, conditioned_numbers = conditional_on_small_primes)
    M1 = 0
    for i in conditioned_numbers
       M1 += arr[i] 
    end
    values = [M1]
    for j in 0:length(conditioned_numbers) - 2
        append!(values, [values[length(values)] - arr[conditioned_numbers[length(conditioned_numbers) - j]]])
    end
    return values
end

function indices_for_nonzero_entries_in_array(arr)
    i = Int8(1)
    while arr[i] == 0
        i += 1 
        if i > length(arr) break end
    end
    if i > length(arr) return [i for i in 1:length(arr)] end
    index_arr = Int8[i]
    if i == length(arr) return index_arr end
    for j in i+1:length(arr)
        if arr[j] != 0 append!(index_arr, [j]) end 
    end
    return index_arr
end

#-----------------------------------------------------------------
# Sets up the rest of the relevant values in the array (M_1 value is non-zero)
#-----------------------------------------------------------------

function wintner_function_z!(subset_of_primes::Vector{Int64}, 
                             arr = sieve_array, 
                             n = X)
    abs!(arr);
    for p in subset_of_primes
        for position = p:p:n
            arr[position] *= (Int8(-1))
        end      
    end  
end

function abs!(arr)
    for i in 1:length(arr)
        arr[i] = abs(arr[i])
    end
end

#-----------------------------------------------------------------
# Properly sums the values in the arr to get answer
#-----------------------------------------------------------------

function list_of_star_sums(nonzero_indices, 
                           set_of_endpoints = end_points, 
                           arr = sieve_array)
    return [sum_of_values_in_interval(arr, set_of_endpoints[index], set_of_endpoints[index+1]) for index in nonzero_indices]
end

function sum_of_values_in_interval(arr, starting_pt, ending_pt)
    return sum(view(arr, starting_pt:ending_pt))
end

function final_sum_test(arr_of_scalars, nonzero_indices, partial_sums)
    total_sum = arr_of_scalars[1]
    for i in 1:length(nonzero_indices)
        total_sum += arr_of_scalars[nonzero_indices[i]]*partial_sums[i]
    end
    return total_sum
end


