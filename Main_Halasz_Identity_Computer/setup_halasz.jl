include("precomputation_functions_halasz.jl")
include("halasz_identity.jl")

#Computes a list of primes up to 10^input as well as intializes the
#main array used in the computations.
println("Please enter to which power of 10 you want to compute up to:")
power = readline()
X = 10^parse(Int64, power);
sieve(10);
primes = sieve(X);
main_arr = array_maker(X, primes);

#Computes several other lists that need to be precomputed.
#In particular, this is where we set how many small primes
#we sieve out by.

println("Please enter the number of primes that you want to sieve by:")
zed = readline();
prime_position = parse(Int64, zed);
z = primes[prime_position];
list_of_small_primes = primes_less_than_z(z);
sieve_array = array_for_sieve_method(X, primes, list_of_small_primes);
conditional_on_small_primes = all_combination_products_less_than_z(z);
end_points = end_points_for_intervals(conditional_on_small_primes, z, X);
#prime_locations_dictionary = dictionary_of_information_for_primes()