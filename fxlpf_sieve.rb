##
# Method primes_up_to is a prime-number sieve:
#   primes_up_to(N) returns an array of all primes <= N, in order
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
# NB The implementation is written for maximum clarity, not speed.
#    So, for example, the even composites are not ignored.
#    For a more transparent presentation of the algorithm, see the recursive version.
#
def primes_up_to (limit)
# array of primes <= limit, in increasing order
  lpf = []
  p = [nil]

  def prime(p,i,lpf)
  # i'th prime: prime(1)=2, prime(2)=3,..., using p as memo
    return p[i] if p[i]
    return p[i] = 2 if i == 1
    n = p[i-1]
    while lpf[n += 1]; end
    p[i] = n
  end

  for f in 2..(limit/2) # co-factor
    i = 1
    loop do
       n = prime(p,i,lpf)*f
       break if n > limit
       lpf[n] = p[i]
       break if p[i] == (lpf[f] || f)
       i += 1
    end
  end

  p = []
  for n in 2..limit
    p << n if !lpf[n]
  end
  p
end
