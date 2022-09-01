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

function relevant_data(arr, upper_bound)
    return [entry for entry in arr if entry <= upper_bound]
end


function range_finder(lst, a, b)
   i = 1 
   while lst[i] < a
       i = i+1 
   end
   j = i 
   while lst[j] < b
        if j == length(lst)
           break 
        end
        j = j+1
    end
    if j == length(lst) return (i, j) else return (i, j-1) end 
end

function first_p_divisible(a, p)
   i = 1
   while ((a + (i-1)) % p) != 0
        i += 1
   end 
   return i   
end

function location_dict(n, block_size = 10000)  
    X = Dict() 
    for step in primes
        block_index = Int64(floor((step-1)/block_size))
        X[step] = first_p_divisible(1 + (block_size*block_index), step)
        
        sq_step = step^2
        if sq_step <= n
            sq_block_index = Int64(floor((sq_step-1)/block_size))
            X[sq_step] = first_p_divisible(1 + (block_size*sq_block_index), sq_step)
        end
    end
    return X
end

function array_reset(arr)
    return [if entry == 1 1 else 1 end for entry in arr]
end

function wintner_block_function(starting_pt::Int64, cancel_ps, arr, block_size = 10000)
    range = range_finder(cancel_ps, 2, starting_pt + block_size - 1);
    primes_effecting_block = cancel_ps[1:range[2]]
    sq_primes = [p^2 for p in primes if p^2 <= starting_pt + block_size - 1]  
    for p in primes_effecting_block
        first_p = prime_locations[p]
        for pos = first_p:p:block_size
            arr[pos] *= Int8(-1)    
        end
    end 
    for sq_p in sq_primes
        first_sq = prime_locations[sq_p]
        for pos = first_sq:sq_p:block_size
            arr[pos] = 0
        end
    end 
    return arr 
end

function wintner_block_by_num(block_num::Int64, relevant_primes, arr)
    
end

function random_mertens_block(n, block_size = 10000, multithreading = false) 
    if multithreading == false
        total_sum = 0
        cancel_prime_data = cancellation_primes(n)
        for i = 0:Int64(floor(n/block_size) - 1)
            block_data = wintner_block_function(1 + block_size*i, cancel_prime_data[2], block_size)
            total_sum += sum(block_data)     
        end
        return total_sum
    end

    if multithreading == true
        thread_number = Threads.nthreads();
        total_sum_threads = fill(Atomic{Int64}(0), thread_number);
        Threads.@threads for i=0:Int64(floor(n/10000) - 1)
            block_data = wintner_block_function(1 + 10000*i, cancel_prime_data[2])
            mertens_sum = sum(block_data)
            Atomic_add!(total_sum_threads[Threads.threadid()], mertens_sum)
            println(i," ",  mertens_sum, " " , Threads.threadid())
        end
    return total_sum_threads
    end   
end
