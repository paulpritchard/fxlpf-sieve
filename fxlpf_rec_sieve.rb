##
# Method primes_up_to(limit,primes) is a prime-number sieve:
#   primes_up_to(N,p) stores all primes <= N, in order, in the given empty array p
# The running-time is linear in N.
#
# It is one of several algorithms presented in:
#   Paul Pritchard,
#   Linear Prime-Number Sieves: A Family Tree".
#   Sci. Comput. Program. 9(1): 17-35 (1987)
#
# The algorithm computes least-prime-factor(n) for each non-prime n, 2 <= n <= N.
# It does so with a pair of nested loops, the outer one over the cofactors f,
# and the inner one over the primes p, where n = p*f and p = least-prime-factor(n).
#
# NB This is a recursive version to highlight the simplicity of the algorithm.
#    The implementation is written for maximum clarity, not speed.
#    So, for example, the even composites are not ignored.
#
def primes_up_to (limit, primes)
  primes_up_to(Math.sqrt(limit),primes) unless limit < 2
  lpf = []
  for f in 2..(limit/2) # co-factor
    primes.take_while{ |p| p*f <= limit && p <= (lpf[f] || f) }.each{ |p| lpf[p*f] = p }
  end
  for n in (primes[-1]||1)+1..limit # if primes is not empty, start after the max value, else at 2
    primes << n if !lpf[n]
  end
end
